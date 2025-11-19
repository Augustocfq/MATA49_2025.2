# Contador decimal de 7 segmentos com botão

## Obejetivo

Contar de 0 à 9 em um display de 7 segmentos incrementado com um botão

## Circuito

![Circuito contador com botão](https://github.com/user-attachments/assets/8383d766-9604-49ab-aa2b-8669d49f1c4f)

## Estratégia

Primeiramente, configuraremos DDRB para input e DDRD para output, ativando a função de pullup em PD0, após isso, definimos R16 para 0, já que esse será nosso contador e chamamos a rotina de decodificação, para inicializarmos o display como o número 0.

```asm
INICIO:
    LDI R16, 0b11111111
    OUT DDRB, R16
    LDI R16, 0b00000000
    OUT DDRD, R16
    LDI R16, 0b00000001
    OUT PORTD, R16

    LDI R16, 0
    CALL DECODIFICAR
    OUT PORTB, R0
```

Para a rotina principal, implementaremos duas subrotinas: SOLTO e PRESSIONADO. Na primeira, utilizamos a instrução SBIC (Skip if Bit in I/O is Clear). Assim, enquanto o pino PD0 de PIND estiver em nível alto — ou seja, o botão estiver solto — permanecemos em loop dentro dessa subrotina; quando o botão for pressionado (nível baixo), avançamos para a segunda subrotina. Na subrotina PRESSIONADO, aplicamos a lógica inversa usando SBIS (Skip if Bit in I/O is Set): enquanto o pino PD0 estiver em nível baixo — botão pressionado — ficamos em loop; quando o botão for solto, executamos as rotinas de incrementação e decodificação, enviamos o resultado armazenado em R0 para PORTB, e então retornamos para a subrotina correspondente ao estado de botão solto.

```asm
PRINCIPAL:
    SOLTO:
        SBIC PIND, PD0
        RJMP SOLTO
        RJMP PRESSIONADO

    PRESSIONADO:
        SBIS PIND, PD0
        RJMP PRESSIONADO
        CALL INCREMENTAR
        CALL DECODIFICAR
        OUT PORTB, R0
        RJMP SOLTO
```

Para a rotina de decodificação é utilizada uma jump table de dados com os códigos BCD armazenados em binário

```asm
DECODIFICAR:
    LDI ZH, HIGH(TABELA << 1)
    LDI ZL, LOW(TABELA << 1)
    ADD ZL, R16
    BRCC LEITURA
    INC ZH
    LEITURA:
        LPM R0, Z
    RET

TABELA: 
    .db 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111
```

Para implementar a rotina de incrementar R16, iremos primeiramente verificar se ele já está em seu valor limite, se sim, a rotina de zerar R16 será utilizada, se não, R16 será incrementado m 1.

```asm
INCREMENTAR:
    CPI R16, 15
    BREQ ZERAR
        INC R16
        RET
    ZERAR:
        LDI R16, 0
        RET
```
