; Program gwiazdki.asm
; Wyświetlanie znaków * w takt przerwań zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakończenie programu po naciśnięciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obsługi przerwania zegarowego
obsluga_zegara PROC
; przechowanie używanych rejestrów
push ax
push bx
push es
push dx
push cx

; wpisanie adresu pamięci ekranu do rejestru ES - pamięć
; ekranu dla trybu tekstowego zaczyna się od adresu B8000H,
; jednak do rejestru ES wpisujemy wartość B800H,
; bo w trakcie obliczenia adresu procesor każdorazowo mnoży
; zawartość rejestru ES przez 16
mov ax, 0B800h ;adres pamięci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bieżący w pamięci ekranu
mov bx, cs:licznik
mov cl, 0

mov al, cs:kierunek

cmp al, 0
jne other1
mov cl, 5Eh
jmp other

other1:
cmp al, 1
jne other2
mov cl, 3Eh
jmp other

other2:
cmp al, 2
jne other3
mov cl, 76h
jmp other

other3:
cmp al, 3
jne other
mov cl, 3Ch

other:

; przesłanie do pamięci ekranu kodu ASCII wyświetlanego znaku
; i kodu koloru: biały na czarnym tle (do następnego bajtu)
mov byte PTR es:[bx], cl ; kod ASCII
mov byte PTR es:[bx+1], 00011110B ; kolor

mov al, cs:kierunek

cmp al, 0
jne next1
sub bx,160
jmp next

next1:
cmp al, 1
jne next2
add bx,2
jmp next

next2:
cmp al, 2
jne next3
add bx,160
jmp next

next3:
cmp al, 3
jne next
sub bx,2

next:

; zwiększenie o 2 adresu bieżącego w pamięci ekranu

; sprawdzenie czy adres bieżący osiągnął koniec pamięci ekranu
cmp bx,4000
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bieżącego, gdy cały ekran zapisany
mov bx, 0
;zapisanie adresu bieżącego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
; odtworzenie rejestrów
wait1:
pop cx
pop dx
pop es
pop bx
pop ax
; skok do oryginalnej procedury obsługi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze względu na specyfikę obsługi przerwań
; umieszczone są w segmencie kodu
licznik dw 320 ; wyświetlanie począwszy od 2. wiersza
wektor8 dd ?
kierunek db 1
obsluga_zegara ENDP




obsluga_klawiatury PROC
; przechowanie używanych rejestrów
push ax
push bx
push es
push dx
push cx

mov ax, 0B800h ;adres pamięci ekranu
mov es, ax
mov bx, 0

mov ax, 0
in al, 60H
cmp al, 72
jne notUp
mov cs:kierunek, 0
notUp:
cmp al, 77
jne notRight
mov cs:kierunek, 1
notRight:
cmp al, 80
jne notDown
mov cs:kierunek, 2
notDown:
cmp al, 75
jne notLeft
mov cs:kierunek, 3
notLeft:

; odtworzenie rejestrów
pop cx
pop dx
pop es
pop bx
pop ax
; skok do oryginalnej procedury obsługi przerwania zegarowego
jmp dword PTR cs:wektor9
; dane programu ze względu na specyfikę obsługi przerwań
; umieszczone są w segmencie kodu
wektor9 dd ?
obsluga_klawiatury ENDP





;============================================================
; program główny - instalacja i deinstalacja procedury
; obsługi przerwań
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartości wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamięci 4 bajty
; począwszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax
; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
mov ax, SEG obsluga_zegara ; część segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
cli ; zablokowanie przerwań
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
sti ;odblokowanie przerwań


mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartości wektora nr 8 i zapisanie go
; w zmiennej 'wektor9' (wektor nr 8 zajmuje w pamięci 4 bajty
; począwszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[36] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor9, eax
; wpisanie do wektora nr 8 adresu procedury 'obsluga_klawiatury'
mov ax, SEG obsluga_klawiatury ; część segmentowa adresu
mov bx, OFFSET obsluga_klawiatury ; offset adresu
cli ; zablokowanie przerwań
; zapisanie adresu procedury do wektora nr 8
mov ds:[36], bx ; OFFSET
mov ds:[38], ax ; cz. segmentowa
sti ;odblokowanie przerwań




; oczekiwanie na naciśnięcie klawisza 'x'
aktywne_oczekiwanie:
mov ah,1
int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeśli
; naciśnięto jakiś klawisz
jz aktywne_oczekiwanie
; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0)
; do rejestru AL
mov ah, 0
int 16H
cmp al, 'x' ; porównanie z kodem litery 'x'
jne aktywne_oczekiwanie ; skok, gdy inny znak
; deinstalacja procedury obsługi przerwania zegarowego
; odtworzenie oryginalnej zawartości wektora nr 8

mov eax, cs:wektor8
cli
mov ds:[32], eax ; przesłanie wartości oryginalnej
; do wektora 8 w tablicy wektorów
; przerwań
sti

mov eax, cs:wektor9
cli
mov ds:[36], eax ; przesłanie wartości oryginalnej
; do wektora 8 w tablicy wektorów
; przerwań
sti
; zakończenie programu


; zakończenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij