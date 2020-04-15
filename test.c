 #include <stdio.h>
 
 
 
char decideCell (int old, int nn); 
int main (void)
{
        char i = decideCell(1,2);
        printf("%d\n", i);
        return 0;
}

char decideCell (int old, int nn)
{
	char ret;
	if (old == 1) {
		if (nn < 2)
			ret = 0;
		else if (nn == 2 || nn == 3)
			ret = 1;
		else
			ret = 0;
	} else if (nn == 3) {
		ret = 1;
	} else {
		ret = 0;
	}

	return ret;
}
