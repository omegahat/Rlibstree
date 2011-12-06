
library(Rlibstree)
txt = scan("~/Projects/R/R-devel/doc/manual/R-intro.texi", what = "")
# Take just the first 1000 words.  Large collections  can be slow
# in creating the StringSet.
txt = txt[1:10000]

sset = StringSet(txt)

lens = unlist(lapply(sset, nchar))
all(sapply(txt, nchar) == lens)

txt1 = unlist(lapply(sset, function(x) x))

txt2 = as(sset, "character")

tree = SuffixTree(sset)

getLongestSubstring(tree, range = c(2, 6))

getLongestSubstring(tree, range = c(2, 0))

getLongestSubstring(tree, range = c(1, 0), FALSE)






