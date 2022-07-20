#include <stdio.h>
float sredniaHarm(float* tablica, unsigned int n);
int main() {
	unsigned int n = 6;
	float tablica[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0};
	float wynik = sredniaHarm(tablica, n);
	printf("\n wynik to %f\n", wynik);
	return 0;
}