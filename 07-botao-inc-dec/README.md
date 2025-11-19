# Contador decimal de 7 segmentos com botão de incremento e decremento

## Obejetivo

Contar de 0 à 9 em um display de 7 segmentos incrementado com um botão

## Circuito

![Circuito contador com dois botões](https://github.com/user-attachments/assets/cfc358b2-7470-4b2a-9703-5183806dc7ac)

## Estratégia

Primeiramente, configuraremos DDRB para input e DDRD para output e ativaremos a função de pullup em PD0 e PD1, após isso, definimos R16 para 0, já que esse será nosso contador e chamamos a rotina de decodificação, para inicializarmos o display como o número 0.

```asm
INICIO:
    LDI R16, 0b11111111
    OUT DDRB, R16
    LDI R16, 0b00000000
    OUT DDRD, R16
    LDI R16, 0b00000011
    OUT PORTD, R16

    LDI R16, 0
    CALL DECODIFICAR
    OUT PORTB, R0
```

Para a rotina principal com dois botões, implementamos quatro subrotinas: INC_SOLTO e INC_PRESSIONADO para o botão de incremento (PD0), e DEC_SOLTO e DEC_PRESSIONADO para o botão de decremento (PD1). A lógica segue o mesmo princípio utilizado anteriormente: nas subrotinas “SOLTO”, utilizamos SBIC para verificar quando o pino correspondente estiver em nível alto, mantendo o programa em espera até que o botão seja pressionado. Nas subrotinas “PRESSIONADO”, aplicamos SBIS para detectar quando o pino retornar ao nível alto, indicando que o botão foi solto. Quando isso ocorre, executamos a rotina apropriada — INCREMENTAR ou DECREMENTAR — seguido da decodificação e envio do valor para PORTB. Como agora há dois botões independentes, é necessário alternar a lógica de detecção entre eles: sempre que um botão é solto, a execução retorna à sua rotina de “solto”, mas também verifica se o outro botão foi pressionado, garantindo que a navegação entre os dois fluxos (incremento e decremento) seja contínua e responsiva ao estado atual de cada entrada.

```asm
PRINCIPAL:
    INC_SOLTO:
        SBIC PIND, PD0
        RJMP DEC_SOLTO
        RJMP INC_PRESSIONADO
    INC_PRESSIONADO:
        SBIS PIND, PD0
        RJMP INC_PRESSIONADO
        CALL INCREMENTAR
        CALL DECODIFICAR
        OUT PORTB, R0
        RJMP INC_SOLTO

    DEC_SOLTO:
        SBIC PIND, PD1
        RJMP INC_SOLTO
        RJMP DEC_PRESSIONADO
    DEC_PRESSIONADO:
        SBIS PIND, PD1
        RJMP DEC_PRESSIONADO
        CALL DECREMENTAR
        CALL DECODIFICAR
        OUT PORTB, R0
        RJMP DEC_SOLTO
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

Para implementar a rotina de incrementar R16, iremos primeiramente verificar se ele já está em seu valor limite, se sim, a rotina de zerar R16 será utilizada, se não, R16 será incrementado em 1.

```asm
INCREMENTAR:
    CPI R16, 9
    BREQ ZERAR
        INC R16
        RET
    ZERAR:
        LDI R16, 0
        RET
```

Para implementar a rotina de incrementar R16, iremos primeiramente verificar se ele já está em seu valor limite, se sim, a rotina de maximizar R16 será utilizada, se não, R16 será decrementado em 1.

```asm
DECREMENTAR:
    CPI R16, 0
    BREQ FILLAR
        DEC R16
        RET
    MAXIMIZAR:
        LDI R16, 9
        RET
```
