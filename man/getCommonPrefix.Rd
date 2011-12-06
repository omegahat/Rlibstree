\name{getCommonPrefix}
\alias{getCommonPrefix}
\title{Compute the longest common prefix of the given strings}
\description{
  This function finds the longest common prefix shared by the
  input strings.
  This is different from finding the longest common substring
  as here we are insisting that this occur at the beginning of each
  of the strings.
  This uses a straightforward search, terminating whenever it
  finds a mismatch in any of the strings.
}
\usage{
getCommonPrefix(words, asCharacter = TRUE, na.rm = TRUE)
}
\arguments{
  \item{words}{ a character vector containing the strings of interest}
  \item{asCharacter}{a logical value which if \code{TRUE} means that the
   actual prefix is returned. Otherwise, the number of characters in the
   prefix is returned and this can be used to compute the substring or
   for some other purpose.
 }
 \item{na.rm}{a logical value indicating whether to remove \code{NA}s.
   If this is \code{FALSE} and there are \code{NA} elements in
   \code{words}, an error is raised.}
}
\value{
  If \code{asCharacter} is \code{TRUE}, a character vector giving the
  actual prefix. If there is no common prefix, this is the empty
  character vector.

  If \code{words} is empty, this returns the empty character vector
  if \code{asCharacter} is \code{TRUE} and 0 otherwise.

  If \code{asCharacter} is \code{FALSE}, this returns a
  scalar integer giving the position  of the end character
  of the common prefix string.
}

\references{
\url{http://www.omegahat.org/Rlibstree}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
  \code{\link{getLongestCommonSubstring}}
}
\examples{

   # The names of enumerated constants in Microsoft Word's
   # scripting interface.  We want to find the common prefix.
enumNames = c('wdSummaryModeHighlight',
              'wdSummaryModeHideAllButSummary',
              'wdSummaryModeInsert',
              'wdSummaryModeCreateNew')

 getCommonPrefix(enumNames)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{IO}
