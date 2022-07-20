#include <stdio.h> 

extern __int64 suma_siedmiu_liczb(__int64  v1, __int64  v2, __int64 v3, __int64  v4, __int64  v5, __int64  v6, __int64  v7);

int main() {
    __int64 v1 = 2;
    __int64 v2 = 3;
    __int64 v3 = 4;
    __int64 v4 = 5;
    __int64 v5 = 6;
    __int64 v6 = 7;
    __int64 v7 = 8;
    __int64 sum;

    sum = suma_siedmiu_liczb(v1, v2, v3, v4, v5, v6, v7);
    printf("\nSuma wynosi: %I64d\n", sum);

    return 0;
}