public  sum 
.code 
 
sum PROC 
	push  rbp   ; zapisanie zawarto�ci EBP na stosie 
	mov   rbp,rsp ; kopiowanie zawarto�ci ESP do EBP 
	push  rbx   ; przechowanie zawarto�ci rejestru EBX 
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
	pop   rbx   ; odtworzenie zawarto�ci rejestr�w 
	pop   rbp 
	ret     ; powr�t do programu g��wnego 
sum  ENDP 
 END 