;
; 6-BotaoIncrementarDecrementar.asm
;
; Created: 11/6/2025 12:13:44 AM
; Author : pedro
; Código 6


; Esse código será para misturar os conceitos aprendidos até aqui. O objetivo é implementar o código de um circuito que adiciona 1 em um contador 
;quando botão1 é ativado e diminui 1 quando o botão2 é decrementado.

; Apesar de não gostar de usar label, recomendo que usem a diretiva .equ para substituir o nome dos pinos por labels, isso pode ajudar a entender o código.
; Não usarei essa diretiva, mas fica de exercício adicional deixar esse código mais legível usando as labels ("variáveis").

INICIO:

	LDI R16, 0xFF 
	OUT DDRB, R16 ; A porta B inteira está setada para ser output.
	OUT PORTD, R16; Liga o Pull-up de PIND (Pesquise mais sobre).

	LDI R16, 0x00
	OUT DDRD, R16 ; A porta D inteira está setada para ser input.
	OUT PORTB, R16 ; Aqui inicializa R16 com zero para marcar o inicio da contagem.


PRINCIPAL:
	
	ISBOTAO1_SOLTO: ; Esse bloco verifica se o botão1 foi pressionado, se não foi, então vai checar se o outro botão foi pressionado.
		SBIS PIND, PD0
		RJMP ISBOTAO1_PRESSIONADO
	
	ISBOTAO2_SOLTO:	; Esse bloco verifica se o botão2 foi pressionado, se não foi, então vai voltar para o começo do loop.
		SBIS PIND, PD1
		RJMP ISBOTAO2_PRESSIONADO
		RJMP PRINCIPAL

	ISBOTAO1_PRESSIONADO: ; Esse bloco verifica se o botão1 foi solto, se foi, ativa a rotina de incrementar, caso contrário repete até o botão ser solto.
		SBIS PIND, PD0
		RJMP ISBOTAO1_PRESSIONADO
		RJMP INCREMENTAR

	ISBOTAO2_PRESSIONADO:; Esse bloco verifica se o botão2 foi solto, se foi, ativa a rotina de decrementar, caso contrário repete até o botão ser solto.
		SBIS PIND, PD1
		RJMP ISBOTAO2_PRESSIONADO
		RJMP DECREMENTAR

; Exercício: No simulide, implementar outro botão em PD2 da mesma forma que o botão implementado em PD0 e PD2.
; Além disso, modifique o código para que o botão consiga somar de 2 em 2.
INCREMENTAR:
	INC R16
	OUT PORTB, R16
	RJMP PRINCIPAL

DECREMENTAR:
	DEC R16
	OUT PORTB, R16
	RJMP PRINCIPAL
	






		


	