library(Rlibstree)
words = c("stemming", "boing", "springs")
tree = SuffixTree(words)

getLongestSubstring(tree)

getLongestSubstring(tree, repeated = FALSE)
