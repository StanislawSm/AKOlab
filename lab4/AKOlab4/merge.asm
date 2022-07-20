.686 
.model flat 
public  _merge_reversed

.data

result dd 8 dup (0)

.code 
 
_merge_reversed PROC 
	push ebp ; prolog    
	mov ebp,esp ; prolog

; prepare arguments
	mov ecx, [ebp + 16] ; n
	cmp ecx, 0 ; empty arrays
	je finish
	cmp ecx, 4 ; given n is to big
	ja nullptr

; prepare loop1
	mov esi, 0
	mov ebx, [ebp + 8] ; tab1

lp1:
	mov eax, [ebx + 4*esi] ; load tab1[esi]
	mov result[4*esi], eax ; save tab[esi]
	inc esi
	loop lp1

; prepare loop2
	mov ecx, [ebp + 16] ; n
	mov eax, [ebp + 16] ; n
	mov edx, 4
	mul edx ; eax: n*4
	mov edi, eax ; edi: n*4
	mov edx, [ebp + 12] ; tab2
	mov esi, 0

lp2:
	mov eax, [edx + 4*ecx - 4]
	mov result[edi +  4*esi], eax
	inc esi
	loop lp2

	mov eax, offset result
	jmp finish

nullptr:
	mov eax, 0
finish:
	pop ebp 
	ret
_merge_reversed  ENDP 
 END 