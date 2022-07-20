.686
.model flat

extern _ExitProcess@4 : PROC
EXTERN __write : PROC


.data

text db 'Hello', 10
textEnd db 0


.code
_main PROC	

	mov eax, (offset textEnd) - (offset text)
	push eax
	push offset text
	push 1
	call __write
	add esp, 12




	push 0
	call _ExitProcess@4

_main ENDP
END	