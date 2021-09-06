#include<stdio.h>

int main(void){
    int a[100], b[100], i, size, atemp[100], btemp[100], n=0;
    setbuf(stdout,NULL);
    printf("enter size: ");
    scanf("%d", &size);
    printf("enter array1:\n");
    for ( i = 0; i < size; i++)
    {
        scanf("%d",&a[i]);
    }
       printf("enter array2:\n");
    for ( i = 0; i < size; i++)
    {
        scanf("%d", &b[i]);
    }

    for ( i = size-1; i >= 0; i--)
    {
        atemp[n] = a[i];
        btemp[n] = b[i];

        n++;
    }
    printf("Array 1: ");
    for ( i = 0; i < size; i++)
    {
       a[i] = btemp[i];

       printf("%d  ", a[i]);
    }

    printf("Array 2: ");
    for ( i = 0; i < size; i++)
    {
       b[i] = atemp[i];

       printf("%d  ", b[i]);
    }
}