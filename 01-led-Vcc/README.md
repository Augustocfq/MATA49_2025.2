# Ligar LED utilizando a saída Vcc

## Obejetivo

Acender um LED com o anodo ligado à uma porta do µC e o cátodo ligado à GND.

## Circuito

![Circuito led Vcc](https://github.com/user-attachments/assets/038ef8e8-4454-46ff-bb3d-4f021d912191)

## Estratégia

Primeiramente, há de ser criado um snippet de inicialização do µC, responsavel por configurar-lo para que ele possa realizar o objetivo desejado. Para isso, iremos definir o DDRD (Data Direction Register D) para 0b11111111, para que todos os pinos de PORTD estejam na direção de output.

```asm
INICIO:
    LDI R16, 0b11111111
    OUT DDRD, R16 
```

Por fim, basta passar o valor de 0b00000001 para PORTD, definindo que o pino D0 será o único a receber a corrente de 5Vcc, enquanto os outros permanecerão desligados.

```asm
LDI R16, 0b00000001
OUT PORTD, R16 
```
