\name{lapply-methods}
\docType{methods}
\alias{lapply}
\alias{sapply}
\alias{lapply-methods}
\alias{lapply,ANY,ANY-method}
\alias{lapply,StringSet,NativeSymbolInfo-method}
\alias{lapply,StringSet,ANY-method}
\alias{sapply,StringSet-method}
\title{Evaluate function on each element of a StringSet}
\description{
This function loops over the elements of a StringSet and 
evaluates the specified function on each value.
Since the \code{\link{StringSet-class}} is an 
opaque, internal data structure of the libstree
library, this method takes care of handling 
the details of the iteration.
}
\section{Methods}{
\describe{

  \item{X = "StringSet", FUN = "function"}{ 
the first argument is the \code{\link{StringSet-class}}
whose elements are to be processed sequentially.
The second argument is a function which is called for
each element. The argument to this function
is the string from that element of the string set.
 }
}}

\keyword{methods}
