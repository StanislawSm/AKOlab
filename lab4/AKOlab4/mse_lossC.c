#include <stdio.h>
#include <stdlib.h>
int mse_loss(int tab1[], int tab2[], int n);
int main() {
	
	int n;
	
	printf("Type n\n");
	scanf_s("%d", &n);
	int* tab1 = malloc(sizeof *tab1 * n);
	int* tab2 = malloc(sizeof *tab2 * n);
	printf("Enter tab1 \n");
	for (int i = 0; i < n; i++) {
		scanf_s("%d", &tab1[i]);
	}
	printf("Enter tab2 \n");
	for (int i = 0; i < n; i++) {
		scanf_s("%d", &tab2[i]);
	}

	int result = mse_loss(tab1, tab2, n);
	printf("\nResult: %d", result);
	return 0;
}