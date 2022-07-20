.686 
.model flat 
public  _mse_loss
.code 
 
_mse_loss PROC 
	push ebp ; prolog
	mov ebp, esp  
 

	mov esi,[ebp + 8] ; tab1
	mov edi,[ebp + 12] ; tab2
	mov ecx, [ebp+16] ; n
	mov eax, 0
    cmp ecx, 0
	je ready ; n = 0
	mov ebx, 0
	mov ebp, 0
ptl: 
	mov eax, [esi + 4 * ebp] ; tab1[ebp]
	mov edx, [edi + 4 * ebp] ; tab2[ebp]
	sub eax, edx ; x1 - y1
	mov edx, eax
	mul edx ; pow 2
	add ebx, eax ; result container
	inc ebp
	loop ptl

	mov eax, ebx
	mov ecx, [esp + 16]
	mov edx, 0
	div ecx ; result in eax
ready:
	pop ebp 
	ret  
_mse_loss  ENDP 
 END 