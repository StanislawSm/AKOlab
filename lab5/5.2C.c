#include <stdio.h>
float nowyExp(float x);
int main() {
	float x;
	printf("podaj x\n");
	scanf_s("%f", &x);
	float wynik = nowyExp(x);
	printf("wynik to %f\n", wynik);
	return 0;
}