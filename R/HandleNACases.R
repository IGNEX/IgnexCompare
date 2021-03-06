#' Prepare input sequences.
#'
#' This function takes a pollen sequence as reference (sequence.A), and a target pollen sequence (sequence.B), checks the integrity of the reference sequence, and tries to adapt the target sequence to the characteristics of the reference sequence: matching column names and number of columns, and no missing data. Missing data can be handled in two ways: 1) deleting rows with NA or empty cases; 2) replacing NA data with zeros.
#'
#' @param sequence A dataframe containing pollen data. This sequence will be compared with and adapted to the structure of sequence.A
#' @param sequence.name A character string with the name of the sequence.
#' @param if.empty.cases A character argument with two possible values "omit", or "zero". The default value is "omit", but it removes every row with at least one empty record. The option "zero" replaces NA data with zeros.
#' @return The function returns the reformatted target sequence as a data frame.
#' @author Blas Benito <blasbenito@gmail.com>
#' @examples
#' data(InputDataExample)
#' @export
#'
HandleNACases=function(sequence=NULL, sequence.name=NULL, if.empty.cases=NULL, silent=NULL){

  #SILENT?
  if (is.null(silent)){silent=FALSE}

  #default value for if.empty.cases
  if (is.null(if.empty.cases)){
    if.empty.cases="omit"
    }

  if (is.null(sequence)){
    stop("Input sequence not provided")
  }

  if (is.null(sequence.name)){
    message("Sequence name not provided.")
    sequence.name=""
  }



  #message
  if (silent == FALSE){cat(paste("Handling empty and NA cases of the sequence '", sequence.name,"'.", sep=" "), sep="\n")}

  #identifying empty cases
  empty.cases=is.na(sequence=="")

  #replacing by NA if there are empty cases
  if (sum(empty.cases, na.rm=TRUE)>0){
    sequence[empty.cases]=NA
  }

  #identifying NA cases
  na.cases=is.na(sequence)

  #sum empty and NA cases
  sum.na.cases=sum(na.cases)

  #message
  if (silent == FALSE){cat(paste(sum.na.cases, "NA or empty cases were found in", sequence.name, sep=" "), sep="\n")}


  #STOP IF NO NA CASES
  if (sum.na.cases==0){
    #message
    if (silent == FALSE){cat("Nothing to do here, returning original input sequence.", sep="\n")}
    return(sequence)
  }


  #HANDLING EMPTY CASES
  if (sum.na.cases>0){

    #IF if.empty.cases="omit"
    if (if.empty.cases=="omit"){

      if (silent == FALSE){cat(paste("Removing", sum(!complete.cases(sequence)), "rows with NA cases.", sep=" "), sep="\n")}

      #remove rows with NA
      sequence=sequence[complete.cases(sequence), ]

      return(sequence)

    }#end of IF if.empty.cases="omit"


    #IF if.empty.cases="zero"
    if (if.empty.cases=="zero"){

      if (silent == FALSE){cat(paste("Replacing NAs with zero.", sep=" "), sep="\n")}

      #remove rows with NA
      sequence[is.na(sequence)]=0

      return(sequence)

    }#end of IF if.empty.cases="omit"


  }#end of HANDLING EMPTY CASES

}
