#include <stdio.h>
#include <xmmintrin.h>
float dylatacja_czasu(unsigned int delta_t_zero, float predkosc);
__m128 szybki_max(short int t1[], short int t2[]);
int main() {
	unsigned int delta = 10;
	float predkosc = 10000.0f;
	float wynik = dylatacja_czasu(delta, predkosc);
	printf("wynik to %f\n", wynik);

	delta = 10;
	predkosc = 200000000.0f;
	wynik = dylatacja_czasu(delta, predkosc);
	printf("wynik to %f\n", wynik);

	delta = 60;
	predkosc = 270000000.0f;
	wynik = dylatacja_czasu(delta, predkosc);
	printf("wynik to %f\n", wynik);
	
	
	short int val1[8] = { 1, -1, 2, -2, 3, -3, 4, -4 };
	short int val2[8] = { -4, -3, -2, -1, 0, 1, 2, 3 };
	__m128 t1 = szybki_max(val1, val2);

	for (int i = 0; i < 8; i++) {
		printf("%d,", t1.m128_i16[i]);
	}
	
	return 0;
}