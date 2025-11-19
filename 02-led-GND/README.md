# Ligar LED utilizando a saída GND

## Obejetivo

Acender um LED com o cátodo ligado à uma porta do µC e o anodo ligado à uma fonte de 5Vcc.

## Circuito

![Circuito led GND](https://github.com/user-attachments/assets/2c5a73da-cfa0-4153-91f8-5332ff67b3fd)

## Estratégia

Primeiramente, há de ser criado um snippet de inicialização do µC, responsavel por configurar-lo para que ele possa realizar o objetivo desejado. Para isso, iremos definir o DDRD (Data Direction Register D) para 0b11111111, para que todos os pinos de PORTD estejam na direção de output.

```asm
INICIO:
    LDI R16, 0b11111111
    OUT DDRD, R16 
```

Por fim, basta passar o valor de 0b11111110 para PORTD, definindo que o pino D0 será o único a não receber corrente atuando como GND enquanto os outros permanecerão ligados.

```asm
LDI R16, 0b11111110
OUT PORTD, R16 
```
