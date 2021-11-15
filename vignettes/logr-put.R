## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(logr)
#  library(magrittr)
#  
#  # Create temp file location
#  tmp <- file.path(tempdir(), "test.log")
#  
#  # Open log
#  lf <- log_open(tmp)
#  
#  # Create log section
#  sep("Illustration of put() and sep()")
#  
#  # Send message to log
#  put("High Mileage Cars Subset")
#  
#  # Perform operations
#  hmc <- subset(mtcars, mtcars$mpg > 20) %>%
#    put() # prints pipeline result to log
#  
#  # Close log
#  log_close()
#  
#  # View results
#  writeLines(readLines(lf))
#  

