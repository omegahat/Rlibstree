\name{SuffixTree-methods}
\docType{methods}
\alias{SuffixTree-methods}
\alias{SuffixTree}
\alias{SuffixTree,StringSet-method}
\alias{SuffixTree,character-method}
\title{Constructor methods for an internal SuffixTree object.}
\description{
 These methods create an internal suffix tree in C code and 
 associated data structures. These  return an object of class
 \code{\link{SuffixTree-class}} which is a reference to the internal
 C data.
}
\section{Methods}{
\describe{
There are two methods at present. One works
from a previously created \code{\link{StringSet-class}},
and the other takes a collection of strings and 
constructs the \code{\link{StringSet-class}}
and then constructs the \code{\link{SuffixTree-class}}.

\item{x = "character"}{if given a character vector, this constructs
 a \code{StringSet} from its string elements and then creates a 
 \code{SuffixTree} from this \code{StringSet}.}
\item{x = "StringSet"}{creates a \code{SuffixTree} directly from this 
 \code{StringSet} by constructing the relevant nodes and edges in C.}
}}
\keyword{methods}

