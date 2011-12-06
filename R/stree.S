setClass("StringSet", representation(ref = "externalptr"))
setClass("SuffixTree", representation(ref = "externalptr"))

StringSet =
function(..., class = "StringSet", .els = as.character(unlist(list(...))))
{
  r = .Call("R_newStringSet", as.character(.els))
  new("StringSet", ref = r)
}  


setGeneric("SuffixTree", 
                   function(x, ...)
                     standardGeneric("SuffixTree"))


setMethod("SuffixTree", "StringSet",
              function(x, ...) {
                 r = .Call("R_newSuffixTree", x@ref)
                 new("SuffixTree", ref = r)
              })


setMethod("SuffixTree", "character",
              function(x, ...) {
                 x = StringSet(x)
                 SuffixTree(x)
              })
  
setMethod("lapply", c("StringSet"),
              function(X, FUN, ...)
                 .Call("R_lapplyStringSet", X@ref, FUN, list(...))
         )


setOldClass("NativeSymbolInfo")

setMethod("lapply", c("StringSet", "NativeSymbolInfo"),
              function(X, FUN, ...)
                 .Call("R_lapplyStringSet", X@ref, FUN$address, list(...))
         )


setMethod("sapply", c("StringSet"),
function (X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE) 
{
    # FUN <- match.fun(FUN)

# We have to copy this entire function as the version in base
# explicitly casts the X to a list and does not leave the 
# class with X for dispatching to X.
# We'll deal with that later.
    answer <- lapply(X, FUN, ...)

# Remove the test for is.character() as we know it is not but we can 
# coerce it to easily.
    if (USE.NAMES && is.null(names(answer))) 
        names(answer) <- as(X, "character")
    if (simplify && length(answer) && length(common.len <- unique(unlist(lapply(answer, 
        length)))) == 1) {
        if (common.len == 1) 
            unlist(answer, recursive = FALSE)
        else if (common.len > 1) 
            array(unlist(answer, recursive = FALSE), dim = c(common.len, 
                length(X)), dimnames = if (!(is.null(n1 <- names(answer[[1]])) & 
                is.null(n2 <- names(answer)))) 
                list(n1, n2))
        else answer
    }
    else answer
}
)


setMethod("length", "StringSet",
              function(x) {
                 .Call("R_stringGetLength", x@ref)
              })


#setMethod("c", c("StringSet", "character"),
#           function(..., recursive = FALSE) {
#             stringSetAppend(x, .Call("R_stringSetAdd", x@ref, 
#           })

setMethod("append", c("StringSet", "character"),
             function(x, values, after = length(x)) {
               .Call("R_stringSetAdd", x@ref, values) 
               x
             })

# The order is not meaningful - it is a set -
# but it is convenient to index assuming the set
# is fixed.  Sampling is one example.
setMethod("[", c("StringSet", "numeric"),
             function(x, i, j, drop = TRUE) {
               ctr = 1
               ans = character(length(i))

               iterator = function(el) {
                 idx = ctr == i
                 if(length(idx)) 
                   ans[idx] <<- el
                 
                 ctr <<- ctr + 1
                NULL 
               }

               lapply(x, iterator)
               ans
             })


setAs("StringSet", "character",
       function(from) {
         unlist(lapply(from, function(x) x))
       })



setGeneric("getLongestSubstring",
                function(stree, repeated = TRUE, range = c(1, 0), asCharacter = TRUE)
                         standardGeneric("getLongestSubstring"))

setMethod("getLongestSubstring", "character",
           function(stree, repeated = TRUE, range = c(1, 0), asCharacter = TRUE)
           {
                  stree = StringSet(.els = stree)
                  getLongestSubstring(stree, repeated, range, asCharacter)
           })

setMethod("getLongestSubstring", "StringSet",
           function(stree, repeated = TRUE, range = c(1, 0), asCharacter = TRUE)
           {
               stree <- SuffixTree(stree)
               getLongestSubstring(stree, repeated, range, asCharacter)
           })
  
setMethod("getLongestSubstring", "SuffixTree",
           function(stree, repeated = TRUE, range = c(1, 0), asCharacter = TRUE)
           {

             range = as.integer(range)
             if(length(range) == 1)
                range = c(range, 0)

             ref = .Call("R_streeLongestSubstring", stree@ref, as.integer(range), as.logical(repeated))

             set = new("StringSet", ref = ref)
             if(asCharacter)
               as(set, "character")
             else
               set
          })





getLongestCommonSubstring =
function(words, range = c(1, 0), asCharacter = TRUE)
{
  getLongestSubstring(words, FALSE, range, asCharacter)
}


getLongestRepeatedSubstring =
function(words, range = c(1, 0), asCharacter = TRUE)
{
  getLongestSubstring(words, TRUE, range, asCharacter)
}

