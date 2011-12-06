\name{getLongestSubstring}
\alias{getLongestSubstring}
\alias{getLongestSubstring,character-method}
\alias{getLongestSubstring,StringSet-method}
\alias{getLongestSubstring,SuffixTree-method}
\alias{getLongestCommonSubstring}
\alias{getLongestRepeatedSubstring}
\title{Compute longest repeated or common substring in a SuffixTree}
\description{
  This function works with a suffix tree, either passed to it directly
  or by building one from a character vector or a StringSet.
  The function can be used to find the longest common substring
  shared by two or more words,
  or alernatively to find the longest substring that is repeated,
   i.e. occurs at least twice, within a word or across two or more words.

   When finding the common substring, the string must be present in
   each of the words. When finding the repeated substring,
   the substring can be found across two
   
  
  If one is going to do multiple operations on the same collection
  of strings, it is sensible to first build the SuffixTree
  (using \code{\link{SuffixTree}}) and then pass this object in each
  of the calls.

  
  This function is a relatively straightforward interface to the libstree routines
  \code{lst_alg_longest_repeated_substring}  and
  \code{lst_alg_longest_common_substring}.
  Therefore, more information can be found from their documentation.
}
\usage{
getLongestRepeatedSubstring(words, range = c(1, 0), asCharacter = TRUE)
getLongestCommonSubstring(words, range = c(1, 0), asCharacter = TRUE)
getLongestSubstring(stree, repeated = TRUE, range = c(1, 0), asCharacter = TRUE)

}

\arguments{
  \item{stree, words}{the collection of strings which are to be searched
    for the longest substring.
    This can be a character vector, a \code{StringSet} or a \code{SuffixTree}.
  }
  \item{repeated}{a logical value.  If this is \code{TRUE}, then we look for repeated substrings.
   If it is \code{FALSE}, then we look for common substrings.  See the document for 
  libstree, \url{}}
  \item{range}{a pair of integers giving the minimum and maximum length of the substrings
  over which to search.  If the second value is 0, this means substrings of all possible
  length, i.e. the maximum of the longest string in the set.
  If the caller supplies just a single integer, the trailing 0 is assumed.
  }
  \item{asCharacter}{a logical value indicating whether the result should be 
   converted to a character vector in R or, alternatively (FALSE), left as a
  \code{\link{StringSet-class}}.}
}
\details{
 This uses the libstree routines
 \code{lst_alg_longest_repeated_substring}
  and  \code{lst_alg_longest_common_substring}.
}
\note{The libstree distribution has some bugs. If possible,
  test any anomalies with the executables in libstree's
  \code{test} directory to determine if they are due to
   the code in this package or libstree itself.
 }
\value{
 If \code{asCharacter} is \code{TRUE}, the default,
 the result  is a character vector.
 Otherwise, it is an object of class \code{\link{StringSet-class}}.
}
\references{
 \url{http://www.cl.cam.ac.uk/~cpk25/libstree/}{libstree}
 \url{http://www.omegahat.org/Rlibstree}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}



\seealso{
 \code{\link{SuffixTree}}
 \code{\link{StringSet}}
 \code{\link{getCommonPrefix}}
}
\examples{

 els = c("aaabbbaaabbb", "aaa", "aabb")
  # "aaabbb"
 getLongestRepeatedSubstring(els)

  # "aa" 
 getLongestCommonSubstring(els)
  # Same call but with the geneal getLongestSubstring() function.
 getLongestSubstring(els, repeated = FALSE)

 
  words = c("stemming", "boing", "springs")
  tree = SuffixTree(words)

    # The longest common or repeated substring for these is the same - "ing"
    # Longest repeated substring
 getLongestRepeatedSubstring(tree)

    # Longest common substring.
 getLongestCommonSubstring(tree)


 # Find the repeated substring. 
 # Note it finds aaaa twice in the second string aaaax and xaaaa
 # where x is an arbitrary character, admittedly also a.
getLongestRepeatedSubstring(c("aaa sdsd", "aaaaa", "xyz"))



  # This returns "aa" which is repeated as subsequences 1:2 and 2:3,
  # i.e. repeating the use of the middle "a"
getLongestRepeatedSubstring("aaa")


 # Get the return value as a StringSet
set = getLongestSubstring(tree, asCharacter = FALSE)
length(set)


 # The word mississipi and the same word backword and we can find the
 # longest palindrome.  Taken from the Perl module Tree::Suffix by Gray

 # First, a function to reverse the order of the characters in each word
 reverseWord = function(word)
                  sapply(strsplit(word, ""), function(x) paste(rev(x), collapse = ""))

 # Just check it does it correctly, round trip the word
"mississippi" == reverseWord(reverseWord("mississippi"))


  # We get "ississi 
 getLongestSubstring(c("mississippi", reverseWord("mississippi")), TRUE, c(0, 0))



 # just of the word itself.
 #   "issi"
getLongestSubstring("mississippi", TRUE, c(0, 0))

# Longest repeated substring is esday
getLongestSubstring(c("Monday", "Tuesday", "Wednesday"), TRUE)

# Longest common substring is day
getLongestSubstring(c("Monday", "Tuesday", "Wednesday"), FALSE)


  # We get the common prefix as the longest substring
  # [1] "ABCDEF_"
 getLongestSubstring(paste("ABCDEF_", c("Monday", "Tuesday", "Wednesday"), sep = ""), TRUE, c(0, 0))



 # The names of enumerated constants in Microsoft Word's
 # scripting interface.  We want to find the common prefix.

enumNames = c('wdSummaryModeHighlight',
              'wdSummaryModeHideAllButSummary',
              'wdSummaryModeInsert',
              'wdSummaryModeCreateNew')

 # common substring
x = getLongestCommonSubstring(enumNames)

x == "wdSummaryMode"

 # longest repeated substring
 # This is "wdSummaryModeHi" shared by the first two elements.

x = getLongestSubstring(enumNames)

x == "wdSummaryModeHi"

# A series of examples of repeated substrings within a single string

 # "first a"
getLongestSubstring("first and first again and again")


 # [1] "first " " again"
getLongestSubstring("first then first again and again")

 # [1] "first " " again"
getLongestSubstring(c("first then first again and again", "first"))


 # This finds " again and again" 
getLongestSubstring(c("first then first again and again", "Or again and again"))



  # We take this very long place name in New Zealand and find the
  # repeated substrings.
  # "ata" "aka" "ang" "mat" "tan" "nga" 
  nzPlaceName = "Taumatawhakatangihangakoauauotamateaturipukakapikimaungahoronukupokaiwhenuakitanatahu"
  getLongestRepeatedSubstring(nzPlaceName)

}
\keyword{IO}

