#!/usr/bin/env python3
"""
pyquesta - Lança o Questa GUI com compilação automática,
adiciona sinais à janela de onda e executa "run -all".
Enquanto a simulação roda, exibe o transcript em tempo real
no terminal, omitindo as linhas de copyright/versão.
"""

import argparse
import sys
import os
import glob
import tempfile
import subprocess
import pathlib
import time

def find_top_level():
    """Encontra o primeiro *_tb.v ou *_tb.sv no diretório atual."""
    patterns = ['*_tb.v', '*_tb.sv']
    files = []
    for pat in patterns:
        files.extend(glob.glob(pat))
    files.sort()
    return files[0] if files else None

def tail_transcript_in_real_time(transcript_file='transcript'):
    """
    Segue o arquivo transcript, imprimindo novas linhas no terminal
    após pular o cabeçalho de copyright/versão.
    """
    if not os.path.isfile(transcript_file):
        print("[pyquesta] Aguardando criação do transcript...")
        # Aguarda até o arquivo aparecer (com timeout)
        for _ in range(100):
            if os.path.isfile(transcript_file):
                break
            time.sleep(0.1)
        else:
            print("[pyquesta] Transcript não foi criado.")
            return

    # Lê o arquivo a partir do início para pular o cabeçalho
    with open(transcript_file, 'r', encoding='utf-8', errors='ignore') as f:
        # Avança até a primeira linha útil (linha que começa com '# vsim' ou não é comentário de copyright)
        while True:
            pos = f.tell()
            line = f.readline()
            if not line:
                # Fim do arquivo (ainda não há conteúdo útil), recua e tenta de novo
                f.seek(pos)
                break
            # Linhas de cabeçalho: começam com '# ' e contêm marcadores típicos
            if line.startswith('#') and (
                '//' in line or
                'Reading pref.tcl' in line or
                'Unpublished' in line or
                'Copyright' in line or
                'Version' in line or
                'Questa' in line
            ):
                continue
            else:
                # Primeira linha útil encontrada: imprime-a e sai do loop
                print(line.rstrip('\n'))
                break

        # Agora segue as novas linhas em tempo real
        while True:
            line = f.readline()
            if line:
                print(line.rstrip('\n'))
            else:
                # Se o processo do vsim já terminou e não há mais linhas, sai
                if proc.poll() is not None:
                    # Lê qualquer resto que tenha sobrado
                    remaining = f.read()
                    if remaining:
                        print(remaining.rstrip('\n'))
                    break
                time.sleep(0.2)  # Pequena pausa para não consumir CPU

def main():
    global proc  # Para ser acessível na função tail
    parser = argparse.ArgumentParser(
        description='Simula com Questa abrindo GUI e formas de onda automaticamente.'
    )
    parser.add_argument('-i', '--input',
                        help='Arquivo top-level .v ou .sv (padrão: primeiro *_tb.v/sv)')
    parser.add_argument('-s', '--signals',
                        help='Sinais separados por vírgula, ex.: dut.clk,dut.a')
    args = parser.parse_args()

    # Determina o arquivo top-level
    top_file = args.input
    if top_file is None:
        top_file = find_top_level()
        if top_file is None:
            print("Erro: nenhum top-level encontrado. Use -i.", file=sys.stderr)
            sys.exit(1)
        print(f"Top-level automático: {top_file}")
    else:
        if not os.path.isfile(top_file):
            print(f"Erro: arquivo '{top_file}' não encontrado.", file=sys.stderr)
            sys.exit(1)
        print(f"Top-level: {top_file}")

    # Nome do módulo = nome do arquivo sem extensão
    top_module = pathlib.Path(top_file).stem
    print(f"Módulo top: {top_module}")

    # Comando para adicionar formas de onda
    if args.signals:
        sig_list = [s.strip() for s in args.signals.split(',') if s.strip()]
        if not sig_list:
            print("Aviso: -s vazio, usando '*'.", file=sys.stderr)
            add_wave_cmd = "add wave *"
        else:
            add_wave_cmd = "add wave " + " ".join(sig_list)
    else:
        # Default: tenta dut/*, depois uut/*, senão *
        add_wave_cmd = (
            "if {[catch {add wave dut/*}]} {\n"
            "    if {[catch {add wave uut/*}]} {\n"
            "        add wave *\n"
            "    }\n"
            "}"
        )

    # Conteúdo do script Tcl que o vsim executará
    do_content = f"""\
# Gerado automaticamente por pyquesta
view wave
{add_wave_cmd}
run -all
wave zoom full
"""

    # Cria arquivo .do temporário
    with tempfile.NamedTemporaryFile(mode='w', suffix='.do',
                                     delete=False, encoding='utf-8') as tmp:
        tmp.write(do_content)
        do_file = tmp.name

    try:
        # Compilação: separar .v e .sv para usar -sv apenas em .sv
        v_files = glob.glob('*.v')
        sv_files = glob.glob('*.sv')

        if v_files:
            print(f"Compilando {len(v_files)} arquivo(s) Verilog...")
            subprocess.run(['vlog'] + v_files, check=True)
        if sv_files:
            print(f"Compilando {len(sv_files)} arquivo(s) SystemVerilog...")
            subprocess.run(['vlog', '-sv'] + sv_files, check=True)
        if not v_files and not sv_files:
            print("Aviso: nenhum arquivo .v/.sv encontrado no diretório.",
                  file=sys.stderr)

        # Lança o vsim com GUI, preservando todos os sinais para debug
        vsim_cmd = ['vsim', '-voptargs=+acc', '-gui', '-do', do_file, top_module]
        print(f"Iniciando simulação com Questa para '{top_module}'...")
        print("Transcript em tempo real:")
        proc = subprocess.Popen(vsim_cmd)   # Processo em background

        # Exibe o transcript em tempo real até a GUI fechar
        tail_transcript_in_real_time()

    finally:
        # Remove o arquivo temporário
        try:
            os.unlink(do_file)
        except OSError:
            pass


if __name__ == "__main__":
    main()