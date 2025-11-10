;
; BotaoLed.asm
;
; Created: 11/5/2025 11:38:12 PM
; Author : pedro
; Código 5


;Este código é o primeiro nessa sequência que vai implementar input. No caso, vamos trabalhar com um botão em lógica negativa (quando pressionado, bit=0).

INICIO:
	LDI R16, 0b11111100
	OUT DDRD, R16

	LDI R16, 0x00000011
	OUT PORTD, R16

PRINCIPAL:
;vamos implementar um looping responsável por ler o estado do botão, lembrando que botão pressionado =0 e botao solto = 1.

	ISBOTAOSOLTO:
		SBIC PIND, PD0 ; PINx é um registrador responsável por receber dados do pino configurado como entrada, nesse caso PD0. 
;Essa linha verifica se o PD0 tem valor 0, se tiver, significa que o botão foi pressionado, pulando para o proximo loop.
		RJMP ISBOTAOSOLTO
		RJMP ISBOTAOPRESSIONADO

	ISBOTAOPRESSIONADO:
		SBIS PIND, PD0 ; Similar à linha de cima, essa verifica se o botão foi solto, ou seja, se seu bit é 1. se for ele vai ligar ou desligar o LED.
		
		RJMP ISBOTAOPRESSIONADO

		SBIS PORTD, PD7 ; Verifica se o pino PD7 (configurado como saída) está ligado, se tiver ele será desligado, caso contrário, ele será ligado.
		RJMP LIGAR
		RJMP DESLIGAR

; Exercício: Estudar sobre as funções SBIS, SBIC, SBI e SBC, e modificar o código de modo que o botão que ligue ou desligue o LED seja o botão
; associado ao pino PD3 no circuito do simulide. 

LIGAR:
	SBI PORTD, PD7
	RJMP PRINCIPAL
DESLIGAR:
	CBI PORTD, PD7
	RJMP PRINCIPAL


	