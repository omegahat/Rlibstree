\name{StringSet}
\alias{StringSet}
\title{Create a StringSet object.}
\description{
 This is a concstructor for the internal C-level 
 String Set data structure.
 This can be thought of as an unordered character vector
 with a length and facilities for indexing.  

 Since a string set is a set,
 the order of the elements is not meaningful. However the indexing facilities can be
 useful, for example, when sampling where the order is not important, but consistent
 across calls. 
}
\usage{
StringSet(..., class = "StringSet", .els = as.character(unlist(list(...))))
}
\arguments{
  \item{\dots}{one or more character vectors. These are are combined into one large character vector
    to be used to construct the set.  This allows one to make calls like
     \code{StringSet(x, y)}.  Of course, this is just a convenience for 
     \code{StringSet(c(x, y))} - 3 more characters.}
  \item{class}{the name of the class of which we want an instance.  Being able to specify this 
      allows the caller to use this function as a constructor for derived classes.}
  \item{.els}{a character vector giving the elements for the set. This is a more convenient form 
      than \dots if the values are already in a vector.}
}
\details{
  This creates an object in C from the libstree  library and returns a reference to it.
}
\value{
  An object of class \code{\link{StringSet-class}}.
}

\references{
 \url{http://www.cl.cam.ac.uk/~cpk25/libstree/}{libstree}
 \url{http://www.omegahat.org/Rlibstree}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{ 
 \code{\link{SuffixTree-methods}}
 \code{\link{StringSet-class}}
 \code{\link{getLongestSubstring}}
}
\examples{
words = c("stemming", "boing", "springs")
set = StringSet(words)

length(set)

set[sample(1:3, 1)]


 # Appending values to the set 
 # Note that we don't have to re-assign the value.
append(set, c("a", "b", "c"))

length(set)


lapply(set, function(x) x)
sapply(set, function(x) x)

sapply(set, getNativeSymbolInfo("R_LST_elementAsRString"))

}
\keyword{IO}

