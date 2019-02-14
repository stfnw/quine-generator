void print_src(void);

/***************************************************************************
 * main code -- content can be (almost) arbitrary                          *
 **************************************************************************/

#include <string.h>
#include <stdio.h>

/**
 * computes the sum of all even fibonacci numbers with a value smaller than n
 * uses the recursion: E(n) = n-th even fibonacci number
 *      E(n) = 4 * E(n-1) + E(n-2)
 */
unsigned long long int sum_even_fib(unsigned long long int n) {
  unsigned long long int even_1 = 2;
  unsigned long long int even_2 = 8;

  unsigned long long int sum = 0, temp;
  while (even_1 < n) {
    sum += even_1;

    temp = even_1;
    even_1 = even_2;
    even_2 = 4*even_1 + temp;
  }

  return sum;
}

void project_euler_nr_2(void) {
  unsigned long long int n = 4000000;
  printf("The sum of all even fibonacci numbers with a value smaller than %llu is:\n"
      "    %llu\n", n, sum_even_fib(n));
}


int main(int argc, char *argv[]) {
  if ( argc == 2 && strcmp(argv[1], "--sum-fibonacci") == 0 )
    project_euler_nr_2();
  else
    print_src();
}


/***************************************************************************
 * routine for printing the data as both code and data                     *
 **************************************************************************/
void print_src(void) {

  // print the data as data
  printf( "char data[] = {\n" );
  for ( size_t i = 0; i < sizeof(data); i++ ) {
    printf( "%3d,", data[i] );
    if ( (i+1)%20 == 0 ) {
      printf( "\n" );
    }
  }
  printf( "\n};\n" );

  // print the data as code
  fwrite( data, sizeof(data), 1, stdout );
  /* equivalent is the following code:
   * for ( size_t i = 0; i < sizeof(data); i++ )
   *   printf( "%c", data[i] ); */

}
