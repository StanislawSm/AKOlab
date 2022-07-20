
;By�o jedno zadanie - na inpucie 2 liczby w systemie dwunastkowym (<= BB) i wy�wietli� ich iloraz w dziesi�tnym z dok�adno�ci� do 3 miejsc po przecinku


.686 
.model flat 
extern __write : PROC 
extern __read : PROC
extern _ExitProcess@4 : PROC 
public _main 


.data 

;wyswietl_EAX
znaki   db 12 dup (?)

;wczytaj_do_EAX
obszar db 12 dup (?) 
osiem   dd 8 ; mno�nik 

;main
num1 dd 0
num2 dd 0
result dd 0
sign db '-', 0


.code 

wczytaj_do_EAX_oct PROC

	push ebx
	push ecx

	
	; wczytywanie liczby dziesi�tnej z klawiatury � po 
	; wprowadzeniu cyfr nale�y nacisn�� klawisz Enter 
 
	; liczba po konwersji na posta� binarn� zostaje wpisana 
	; do rejestru EAX 
	; max ilo�� znak�w wczytywanej liczby 
	push  dword PTR 12 
  
	push  dword PTR OFFSET obszar  ; adres obszaru pami�ci 
	push  dword PTR 0; numer urz�dzenia (0 dla klawiatury) 
	call  __read ; odczytywanie znak�w z klawiatury 
		; (dwa znaki podkre�lenia przed read) 
	add   esp, 12 ; usuni�cie parametr�w ze stosu 
 
 
	; bie��ca warto�� przekszta�canej liczby przechowywana jest 
	; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow� 
	mov ebp, 0
	mov   eax, 0   
	mov   ebx, OFFSET obszar  ; adres obszaru ze znakami 
 
pobieraj_znaki: 
	mov   cl, [ebx] ; pobranie kolejnej cyfry
	inc   ebx   ; zwi�kszenie indeksu 
	cmp   cl,10 ; sprawdzenie czy naci�ni�to Enter 
	je  byl_enter ; skok, gdy naci�ni�to Enter 
	cmp cl, '-'
	je minus
	jmp wasDigit
minus:
	mov ebp, 1 ;edx jest flag� ze znakiem
	jmp pobieraj_znaki

wasDigit:
	sub   cl, 30H ; zamiana kodu ASCII na warto�� cyfry 
save:
	movzx ecx, cl ; przechowanie warto�ci cyfry w 
	; rejestrze ECX 
 
	 ; mno�enie wcze�niej obliczonej warto�ci razy 10 
	mul   dword PTR osiem         
	add   eax, ecx  ; dodanie ostatnio odczytanej cyfry 
	jmp   pobieraj_znaki ; skok na pocz�tek p�tli 
 
byl_enter:
	cmp ebp, 1
	jne koniec
	neg eax 

koniec:
	; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX 

	pop ecx
	pop ebx

	ret
wczytaj_do_EAX_oct ENDP
 
wyswietl_EAX PROC 
	pusha
 
	bt	eax, 31
	jnc dalej
	neg eax
	
	pusha
	push  1 ; liczba wy�wietlanych znak�w 
	push  dword PTR OFFSET sign ; adres wy�w. obszaru 
	push  dword PTR 1; numer urz�dzenia (ekran ma numer 1) 
	call  __write  ; wy�wietlenie liczby na ekranie
	add esp, 12
	popa



	
dalej:	
	mov   esi, 10  ; indeks w tablicy 'znaki' 
	mov   ebx, 10  ; dzielnik r�wny 10 
 
konwersja: 
	mov   edx, 0 ; zerowanie starszej cz�ci dzielnej 
	div   ebx   ; dzielenie przez 10, reszta w EDX, iloraz w EAX 
	add   dl, 30H ; zamiana reszty z dzielenia na kod ASCII 
	mov   znaki [esi], dl; zapisanie cyfry w kodzie ASCII 
	dec   esi    ; zmniejszenie indeksu 
	cmp   eax, 0  ; sprawdzenie czy iloraz = 0 
	jne   konwersja  ; skok, gdy iloraz niezerowy 
 
; wype�nienie pozosta�ych bajt�w spacjami i wpisanie 
; znak�w nowego wiersza 
wypeln: 
	or  esi, esi 
	jz  wyswietl   ; skok, gdy ESI = 0 
	mov   byte PTR znaki [esi], 0 ; kod spacji 
	dec   esi    ; zmniejszenie indeksu 
	jmp   wypeln 
  
wyswietl: 
	mov   byte PTR znaki [0], 0 ; kod nowego wiersza 
	mov   byte PTR znaki [11], 0 ; kod nowego wiersza 
 
	; wy�wietlenie cyfr na ekranie 
	push  dword PTR 12 ; liczba wy�wietlanych znak�w 
	push  dword PTR OFFSET znaki ; adres wy�w. obszaru 
	push  dword PTR 1; numer urz�dzenia (ekran ma numer 1) 
	call  __write  ; wy�wietlenie liczby na ekranie 
	add   esp, 12  ; usuni�cie parametr�w ze stosu
	popa
	ret 
wyswietl_EAX ENDP 

 
_main PROC 
;czytanie
	call wczytaj_do_EAX_oct
	mov num1, eax
	call wczytaj_do_EAX_oct
	mov num2, eax
	
	mov eax, num1
	mov ebx, num2
	add eax, ebx

	call wyswietl_EAX	

    push 0 
    call _ExitProcess@4 
_main ENDP 
END