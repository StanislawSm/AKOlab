public  sum 
.code 
 
sum PROC 
	push  rbp   ; zapisanie zawartoœci EBP na stosie 
	mov   rbp,rsp ; kopiowanie zawartoœci ESP do EBP 
	push  rbx   ; przechowanie zawartoœci rejestru EBX 
	push  rsi
 
	mov   rax, 0 
	
	cmp   rcx, 0
	je    ready
	
	cmp rcx, 1
	jne are2
	mov rax, rdx
	jmp ready

are2:
	cmp rcx, 2
	jne are3
	mov rax, rdx
	add rax, r8
	jmp ready

are3:
	cmp rcx, 3
	jne more
	mov rax, rdx
	add rax, r8
	add rax, r9
	jmp ready

more:
	mov rax, rdx
	add rax, r8
	add rax, r9

	; in rcx is amount of arguments
	sub rcx, 3
	mov rsi, 0

ptl: 
	add rax, [rbp + 8 * rsi + 48]  
	inc esi
	loop ptl

ready:
	pop rsi
	pop   rbx   ; odtworzenie zawartoœci rejestrów 
	pop   rbp 
	ret     ; powrót do programu g³ównego 
sum  ENDP 
 END 