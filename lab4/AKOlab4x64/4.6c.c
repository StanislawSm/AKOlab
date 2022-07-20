#include <stdio.h>
extern __int32 sum(unsigned __int64 n, ...);
int main() {

	printf("\n%I32d", sum(5, 1, 2, 3, 4, 5));
	printf("\n%I32d", sum(0));
	printf("\n%I32d", sum(1, -3));
	printf("\n%I32d", sum(3, -3, -2, -1));
	return 0;
}