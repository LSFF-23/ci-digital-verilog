### pyquesta - Instalação
- No linux: ```chmod +x pyquesta```
- No windows: Colocar pyquesta.bat e pyquesta.py na mesma pasta e no PATH
- vlog e vsim devem estar no PATH
- *_tb.v/sv são os testbenches padrões que este script procura

#### Simulação mais simples - detecta automaticamente o testbench e os sinais:
```pyquesta```

#### Especificar o testbench e alguns sinais:
```pyquesta -i top_tb.sv -s dut.clk,dut.reset,dut.dout```

#### Testbench padrão, mas sinais específicos:
```pyquesta -s dut.a,dut.b,dut.sum```

#### Testbench específico, sinais padrão:
```pyquesta -i outro_tb.sv```
