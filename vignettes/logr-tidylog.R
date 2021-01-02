## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(logr)
#  library(dplyr)
#  library(magrittr)
#  
#  # Create temp file location
#  tmp <- file.path(tempdir(), "test.log")
#  
#  # Open log
#  lf <- log_open(tmp, autolog = TRUE, show_notes = FALSE)
#  
#  # Print log header
#  sep("Example of autolog feature")
#  
#  # Send message to log
#  put("High Mileage Cars Subset")
#  
#  # Perform dplyr operations
#  hmc <- mtcars %>%
#    select(mpg, cyl, disp) %>%
#    filter(mpg > 20) %>%
#    arrange(mpg) %>%
#    put() # sends pipeline result to log
#  
#  # Close log
#  log_close()
#  
#  # View results
#  writeLines(readLines(lf))
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(logr)
#  library(dplyr)
#  library(magrittr)
#  library(tidylog, warn.conflicts = FALSE)
#  
#  # Connect tidylog to logr
#  options("tidylog.display" = list(log_print),
#          "logr.notes" = FALSE)
#  
#  # Create temp file location
#  tmp <- file.path(tempdir(), "test.log")
#  
#  # Open log
#  lf <- log_open(tmp)
#  
#  # Print log header
#  sep("Example of tidylog integration")
#  
#  # Send message to log
#  put("High Mileage Cars Subset")
#  
#  # Perform dplyr operations
#  hmc <- mtcars %>%
#    select(mpg, cyl, disp) %>%
#    filter(mpg > 20) %>%
#    arrange(mpg) %>%
#    put() # sends pipeline result to log
#  
#  # Close log
#  log_close()
#  
#  # View results
#  writeLines(readLines(lf))
#  

