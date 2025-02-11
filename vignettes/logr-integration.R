## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  #' @title Read an RDS file
#  #' @param file_path The path to the file.
#  #' @return The RDS file contents as an R object.
#  #' @import logr
#  #' @export
#  read_file <- function(file_path) {
#  
#    ret <-  readRDS(file_path)
#  
#    log_hook(paste0("Read RDS file from '", file_path, "'"))
#  
#    return(ret)
#  }

