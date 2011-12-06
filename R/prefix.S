getCommonPrefix =
function(words, asCharacter = TRUE, na.rm = TRUE)
{
  words = as.character(words)

  if(length(words) < 2)
     return(if(asCharacter) words else 0L)

  nas = is.na(words)
  if(any(nas)) {
    if(na.rm)
      words = words[!nas]
    else
      stop("cannot find common prefix with NA values")
  }
  
  n = .C("R_getLongestPrefix", words, length(words), n = as.integer(0), DUP = TRUE)$n

  if(!asCharacter)
    return(n)
  
  if(n == 0)
     character()
  else
     substring(words[1], 1, n)
}

