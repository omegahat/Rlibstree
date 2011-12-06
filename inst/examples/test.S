library(Rlibstree)
txt = scan("~/Projects/R/R-devel/doc/manual/R-intro.texi", what = "")
# Take just the first 1000 words.  Large collections  can be slow
# in creating the StringSet.
txt = txt[1:1000]
tree = SuffixTree(txt)

gctorture(TRUE)

for(i in 1:20) {
  r = getLongestSubstring(tree, asCharacter = FALSE)
  rm(r)
}

for(i in 1:20) {
  print(i)
  r = getLongestSubstring(tree)
  print(r)
}

