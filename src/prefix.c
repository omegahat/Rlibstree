#include <Rdefines.h>

void
R_getLongestPrefix(const char **words, int *num, int *ans)
{
    int i = 0, j;
    const char *p = words[0];
    
    while(p) {
        for(j = 1; j < *num; j++) {
	    if(words[j][i] != *p) {
	       *ans = i;
	       return;
	    }
	}
	p++; i++;
    }
 
    *ans = i;
}

