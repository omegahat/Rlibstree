/*
 This is for exploring the effect of calling lst_stringset_free()
 on the string set used to construct an LST_STree.
  
 */

#include <stree/lst_structs.h>
#include <stree/lst_stree.h>
#include <stree/lst_string.h>
#include <stree/lst_algorithms.h>

#include <stdio.h>


static void 
countStringSet(LST_String *str, void *ctr)
{
   int *c = (int *) ctr;
   const char *p = lst_string_print(str);
   fprintf(stderr, "%d) %s\n", *c, p);
   (*c)++;

}

int
lst_stringset_length(LST_StringSet *set)
{
    int ctr = 0;
    lst_stringset_foreach(set, countStringSet, &ctr);  
    return(ctr);
}


const char const *strings[] =  {
#if 0
    "springs",
    "boing",
    "running",
    "ingo"
#else
    "aaabbbbccccddddxxxx",
    "bcd",
    "cdab"
#endif
};


int
main(int argc, char *argv[])
{
    int i = 0;

    LST_STree *tree;
    LST_StringSet *set;

    char *els[10];

    set = lst_stringset_new();
    for(i = 0; i < sizeof(strings)/sizeof(strings[0]) ; i++) {
	lst_stringset_add(set, lst_string_new(strings[i], sizeof(char), strlen(strings[i])));
    }

    tree = lst_stree_new(set);
/* This is the problem. We can't release this using lst_stringset_free. */
//    lst_stringset_free(set);
//    free(set);
    i = 0;
    while( i < 40) {
	LST_StringSet *results = lst_alg_longest_common_substring(tree, 1, 0);
	int len = lst_stringset_length(results);
	fprintf(stderr, "Length %d\n", len);
	lst_stringset_free(results);
	i++;
    }
    lst_stree_free(tree);
    /* If we don't call lst_stringset_free(set) but simply free(set),
       valgrind doesn't complain.
       If we call lst_stringset_free(set) and not free(set), we get segmentation faults
       from an attempt to do a double free.
     */
#if 0
    free(set); 
#else
    lst_stringset_free(set);
#endif
    return(0);
}

