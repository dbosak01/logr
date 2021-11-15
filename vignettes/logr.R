## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(logr)
#  
#  # Create temp file location
#  tmp <- file.path(tempdir(), "test.log")
#  
#  # Open log
#  lf <- log_open(tmp)
#  
#  # Send message to log
#  log_print("High Mileage Cars Subset")
#  
#  # Perform operations
#  hmc <- subset(mtcars, mtcars$mpg > 20)
#  
#  # Print data to log
#  log_print(hmc)
#  
#  # Close log
#  log_close()
#  
#  # View results
#  writeLines(readLines(lf))
#  

