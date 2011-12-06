\name{StringSet-class}
\docType{class}
\alias{StringSet-class}
\alias{[,StringSet,numeric-method}
%\alias{append,StringSet,character-method}
%\alias{lapply,StringSet,function-method}
%\alias{SuffixTree,StringSet-method}
\alias{coerce,StringSet,character-method}
\alias{length,StringSet-method}

\title{The Opaque StringSet reference class}
\description{
This is a class that represents a reference to a set of strings
in the libstree library.  The underlying data structure can be thought
of as a character vector in which the order is not meaningful.
The set is a collection of strings.  In R, we can 
compute its length and index its elements via the
\code{[} operator.  This is convenient, for example,
when sampling from the set.  However because the order is 
not respected when constructing the set from a character
vector, one cannot treat this as a regular character vector in 
R.
}
\section{Objects from the Class}{
The preferred way to create a \code{StringSet}
is via the generic \code{\link{StringSet}}
function.
}
\section{Slots}{
  \describe{
    \item{\code{ref}:}{Object of class \code{"externalptr"}.  This is a reference
  to the internal C-level object that represents the string set in libstree.
  This external pointer has a tag value \code{StringSet}.}
  }
}
\section{Methods}{
  \describe{
    \item{SuffixTree}{\code{signature(x = "StringSet")}: ... }
    \item{[}{\code{signature(x = "StringSet", i = "numeric")}: ... }
    \item{append}{\code{signature(x = "StringSet", values = "character")}: ... }
    \item{coerce}{\code{signature(from = "StringSet", to = "character")}: ... }
    \item{lapply}{\code{signature(X = "StringSet", FUN = "function")}: ... }
    \item{length}{\code{signature(x = "StringSet")}: ... }
  }
}
\references{
 \url{http://www.cl.cam.ac.uk/~cpk25/libstree/}{libstree}
 \url{http://www.omegahat.org/Rlibstree}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}



\seealso{
\code{\link{StringSet}}
}
\examples{

words = c("stemming", "boing", "springs")
set = StringSet(words)

lapply(set, function(x) nchar)

 # Check that we can accept additional arguments
lapply(set, substring, 1, 2)


}
\keyword{classes}
