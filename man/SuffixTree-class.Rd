\name{SuffixTree-class}
\docType{class}
\alias{SuffixTree-class}

\title{An opaque reference to a suffix tree for string matching}
\description{
 This class is used to represent a reference to a C-level
 data structure that is a suffix tree.  Suffix trees are  
 used to represent strings in ways that make performing
 substring comparisons efficient. 
}
\section{Objects from the Class}{
  The preferred way to construct objects of this class is
via the \code{\link{SuffixTree-methods}} which 
accept either a \code{\link{StringSet-class}} or
a character vector giving the collection  of strings.
The latter is merely a convenience function for the former.
}
\section{Slots}{
  \describe{
    \item{\code{ref}:}{Object of class \code{"externalptr"}. This is a reference
     to the opaque C-level data structure from the libstree library.}
  }
}
\section{Methods}{
No methods defined with class "SuffixTree" in the signature.
}

\references{
 \url{http://www.cl.cam.ac.uk/~cpk25/libstree/}{libstree}
 \url{http://www.omegahat.org/Rlibstree}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
 \code{\link{SuffixTree-methods}}
}
\examples{
words = c("stemming", "boing", "springs")
tree = SuffixTree(words)

getLongestSubstring(tree, c(1, 0))
}
\keyword{classes}
