#include <stdio.h>
#include <stdlib.h>
int* merge_reversed(int tab1[], int tab2[], int n);
int main() {

	int n;
	printf("Type n\n");
	scanf_s("%d", &n);
	
	int* tab1 = malloc(sizeof * tab1 * n);
	int* tab2 = malloc(sizeof * tab2 * n);
	int* result;
	
	printf("Enter tab1 \n");
	for (int i = 0; i < n; i++) {
		scanf_s("%d", &tab1[i]);
	}
	printf("Enter tab2 \n");
	for (int i = 0; i < n; i++) {
		scanf_s("%d", &tab2[i]);
	}

	result = merge_reversed(tab1, tab2, n);

	if (result == 0 && n != 0) {
		printf("Given n is to big\n");
	} else {
		printf("Merged arrays: \n");
		for (int i = 0; i < 2 * n; i++) {
			printf("%d ", result[i]);
		}
	}

	return 0;
}