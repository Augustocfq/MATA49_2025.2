;
; 1-LigarLed.asm
;
; Created: 11/5/2025 9:31:30 PM
; Author : pedro
; Código 1

; Recomendo que o estudo do código seja realizado acompanhado pelo Instruction Set Summary, presente no Atmega328P Datasheet (primeiro link no google).
; Focarei a explicação na lógica do código e funcionamento do atmega328p.

INICIO:
	
	LDI R16, 0xFF ; Lembrando, 0xFF (hexadecimal) = 0b11111111 (binário) = 255(decimal)
	OUT DDRD, R16 
; DDRx: A função de DDRx é indicar para o microcontrolador como vai funcionar o pino ao longo do código.
; No caso, DDRx possui 8 bits de tamanho, cada um representa um pino. Bit 1 indica que aquele pino é de saída, bit 0 indica que o pino é de entrada.
; Lembrando que são 3 portas: B, C e D. Então existe DDRB, DDRC e DDRD, DDRx é apenas uma notação para indicar algum desses.
; No caso do DDRC, ele apenas possui 7 bits.
; Nesse exemplo, todas os bits do DDRD são 1, ou seja, a porta inteira está configurada como saída.


	LDI R16, 0b00000001
	OUT PORTD, R16 ; PORTx: De maneira geral, a função do PORTx é indicar a voltagem que será passada em cada pino.
; "Bit 1 indica voltagem 5V, bit 0 indica voltagem 0V" (pesquisar melhor isso).
; Note que apenas o PD0 está ativo. Logo, apenas o LED desse pino estará aceso. Tente ligar o LED em outro pino.

; Exercício: No simulide, conecte novos LEDs nos pinos PD7, PD4 e PD1, e altere o código de modo a ligar esses novos LEDs.
; NAO ESQUEÇA DE COMPILAR O NOVO CÓDIGO.
