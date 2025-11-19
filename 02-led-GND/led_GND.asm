.nolist
.include "m328Pdef.inc"
.list

INICIO:
	LDI R16, 0xFF
	OUT DDRD, R16

LDI R16, 0b11111110 
OUT PORTD, R16
