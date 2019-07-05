/*Test for Comparison expression and if-then-else */
void main()
{
   int a;
   int b;
   float c;
   float d;
   a = 20 ;
   b = 7 ;
   if( a != b ){
   		b=5; /*execute this*/
   }
   else{
   		b=9;
   }
   printf("---The result of test3.c---\n");
   printf("The result of b is %d\n",b);
   c = 6.8 ;
   d = 9.1 ;
   if( c < 5.2 ){
   		d=5.0;
   }
   else {
   		d=8.9; /*Execute this*/
   }
   printf("The result of d is %f\n",d);
   printf("------------END------------\n");
}
