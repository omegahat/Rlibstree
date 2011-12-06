#ifdef FROM_LIBSTREE_SRC
#include <lst_structs.h>
#include <lst_stree.h>
#include <lst_string.h>
#include <lst_algorithms.h>
#else
#include <stree/lst_structs.h>
#include <stree/lst_stree.h>
#include <stree/lst_string.h>
#include <stree/lst_algorithms.h>
#endif

#include <Rdefines.h>

static LST_StringSet * getStringSetRef(SEXP sset);
static void * getRef(SEXP sset, SEXP sym);
static LST_STree *getSuffixTreeRef(SEXP sset);

void
finalizeStringSet(SEXP s)
{
    LST_StringSet *set = getStringSetRef(s);
    if(set) {
#if defined(RLIBSTREE_DEBUG) && RLIBSTREE_DEBUG
	fprintf(stderr, "Freeing StringSet %p\n", (void *)set);fflush(stderr);
#endif
/*  Freeing the individual strings seems to cause problems.
    	lst_stringset_free(set);  
    It could be that we have done something wrong in our code. Looking at the code for
    lst_stree.c and lst_node_get_string(), it seems that we do get a copy of the string.
    However, if we run lrstext in the tests/ directory (e.g. ./lrstext  2 3  `ls *.[co]`), 
    we do end up with some odd symbols in the strings, e.g. ^Q in the dre.
    Just free()ing the  set doesn't seem to cause problems.
    See the experiments in try/stringset.c
*/
#if 0
	lst_stringset_free(set);
#else
	free((void *) set); 
#endif
    }
    R_ClearExternalPtr(s);
}

void
finalizeSuffixTree(SEXP s)
{
    LST_STree *tree = getSuffixTreeRef(s);
    if(tree) {
#if defined(RLIBSTREE_DEBUG) && RLIBSTREE_DEBUG
	fprintf(stderr, "Freeing STree %p\n", (void*) tree);fflush(stderr);
#endif
	lst_stree_free(tree);
    }
    R_ClearExternalPtr(s);
}


SEXP
makeStringSetRef(LST_StringSet *set)
{
    SEXP ans;
    PROTECT(ans = R_MakeExternalPtr(set, Rf_install("StringSet"), R_NilValue));
    R_RegisterCFinalizer(ans, finalizeStringSet);
    UNPROTECT(1);

    return(ans);
}



SEXP
R_newSuffixTree(SEXP sset)
{
    LST_STree *ptr;
    SEXP ans;
    LST_StringSet *set;

    set = getStringSetRef(sset);
    ptr = lst_stree_new(set);
    PROTECT(ans = R_MakeExternalPtr(ptr, Rf_install("SuffixTree"), R_NilValue));
    R_RegisterCFinalizer(ans, finalizeSuffixTree);
    UNPROTECT(1);
    return(ans);
}


SEXP
R_newStringSet(SEXP els)
{
    LST_StringSet *set;
    int i, n;
    const char *str;

    set = lst_stringset_new();

    n = GET_LENGTH(els);
    for(i = 0; i < n; i++) {
	str = CHAR(STRING_ELT(els, i));
	lst_stringset_add(set, lst_string_new(str, 1, strlen(str)));
    }

    return(makeStringSetRef(set));

}



LST_StringSet *
getStringSetRef(SEXP sset)
{
    return((LST_StringSet *) getRef(sset, Rf_install("StringSet")));
}

LST_STree *
getSuffixTreeRef(SEXP sset)
{
    return((LST_STree *) getRef(sset, Rf_install("SuffixTree")));
}


void *
getRef(SEXP sset, SEXP sym)
{
    LST_StringSet *set;

    if(TYPEOF(sset) != EXTPTRSXP) {
	PROBLEM "a %s reference must be an external pointer object in R",
	    CHAR(PRINTNAME(sym))
        ERROR;
    }

    if(R_ExternalPtrTag(sset) != sym) {
	PROBLEM "the %s reference has the wrong internal type/tag",
	    CHAR(PRINTNAME(sym))
        ERROR;
    }


    set = R_ExternalPtrAddr(sset);

    return(set);
}


SEXP
R_streeLongestSubstring(SEXP stree, SEXP lens, SEXP repeated)
{
   LST_StringSet *resultSet;
   LST_STree *tree;
   LST_StringSet *(*f)(LST_STree *, u_int , u_int);

   f = LOGICAL(repeated)[0] ? lst_alg_longest_repeated_substring : lst_alg_longest_common_substring;
   tree = getSuffixTreeRef(stree);

   resultSet = f(tree, INTEGER(lens)[0], INTEGER(lens)[1]);

   return(makeStringSetRef(resultSet));
}


typedef SEXP (*R_LST_NativeIterator)(LST_String *str, SEXP data);

typedef struct {

    int i; /* Current location */
    SEXP els; /* the answer list into which we put the individual elements */
    SEXP call; /* for calling the R function */
    R_LST_NativeIterator op; /* If we are dealing with a native routine rather than an R function. */
    Rboolean  isRFunction; /* Indicates whether we have an R function or native routine. */

} ForEachData ;


void
forEachCallback(LST_String *str, void *cbdata)
{
    ForEachData *data = (ForEachData *) cbdata;
    SEXP val;

    if(data->isRFunction) {
        const char *tmp = lst_string_print(str);
	SETCAR(CDR(data->call), mkString(tmp ? tmp : ""));
	val = Rf_eval(data->call, R_GlobalEnv);
    } else {
	val = data->op(str, data->call);
    }

    if(data->i >= GET_LENGTH(data->els)) {
#if defined(RLIBSTREE_DEBUG) && RLIBSTREE_DEBUG
	    fprintf(stderr, "Walking past length %d. Skipping result.\n", GET_LENGTH(data->els));
#endif
	    return;
    }
      
    SET_VECTOR_ELT(data->els, data->i, val);
    data->i++;
}


SEXP
R_LST_elementAsRString(LST_String *str, SEXP data)
{
    return(mkString(lst_string_print(str)));
}

static void 
countStringSet(LST_String *str, void *ctr)
{
   int *c = (int *) ctr;
   (*c)++;
}

int
lst_stringset_length(LST_StringSet *set)
{
    int ctr = 0;
    lst_stringset_foreach(set, countStringSet, &ctr);  
    return(ctr);
}



SEXP
R_stringGetLength(SEXP sset)
{
    LST_StringSet *set;
    int n;

    set = getStringSetRef(sset);
    n = lst_stringset_length(set);

    return(ScalarInteger(n));
}

#if 0
/* Rather than building our own function here, pass a C routine to 
  R_lapplyStringSet and let it do the work with the ForEachData. */
R_stringSetAsElements(SEXP sset)
{
    LST_StringSet *set;
    int i, n;
    ForEachData d
    set = getStringSetRef(sset);

    n = lst_stringset_length(set);

    for(i = 0; i < n ; i++) {
	SET_STRING_ELT(ans, i, lst_string_print(str))
    }
}
#endif


SEXP
R_lapplyStringSet(SEXP sset, SEXP fun, SEXP args)
{
    SEXP tmp;
    int i, n, nargs;

    LST_StringSet *set;
    ForEachData data;

    set = getStringSetRef(sset);

    n = lst_stringset_length(set);

    data.i = 0;
    PROTECT(data.els = NEW_LIST(n));

    if(TYPEOF(fun) == CLOSXP) {

	data.isRFunction = TRUE;
	nargs = GET_LENGTH(args);
	PROTECT(data.call = allocVector(LANGSXP, 2 + nargs));
	SETCAR(data.call, fun);
	SETCAR(CDR(data.call), R_NilValue); /* Fill in empty value. */
        if(nargs > 0) {
    	    tmp = CDR(CDR(data.call));
	    for(i = 0; i < nargs; i++) {
       	        SETCAR(tmp, VECTOR_ELT(args, i));
		tmp = CDR(tmp);
	    }
	}

    } else if(TYPEOF(fun) == EXTPTRSXP) {
	data.isRFunction = FALSE;
	data.op = (R_LST_NativeIterator) R_ExternalPtrAddr(fun);
	if(GET_LENGTH(args))
	    args = VECTOR_ELT(args, 0);
	data.call = args;
    } else {
	PROBLEM "Unrecognized operator in the lapply. Need an R function or a routine"
        ERROR;
    }

    lst_stringset_foreach(set, forEachCallback, &data);

    UNPROTECT(data.isRFunction ? 2 : 1);

    return(data.els);
}


SEXP
R_stringSetAdd(SEXP sset, SEXP values)
{
    LST_StringSet *set;
    int i, n;

    set = getStringSetRef(sset);
    n = GET_LENGTH(values);

    for(i = 0; i < n; i++) {
	const char *str = CHAR(STRING_ELT(values, i));
	lst_stringset_add(set, lst_string_new(str, 1, strlen(str)));
    }

    return(ScalarInteger(lst_stringset_length(set)));
}
