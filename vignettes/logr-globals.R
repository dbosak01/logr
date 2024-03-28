## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Turn logger off
#  options("logr.on" = FALSE)
#  
#  # Turn logger on and show notes
#  options("logr.on" = TRUE, "logr.notes" = TRUE)
#  
#  # Turn off notes
#  options("logr.notes" = FALSE)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Turn autolog on
#  options("logr.autolog" = TRUE)
#  
#  # Turn autolog off
#  options("logr.autolog" = FALSE)
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Turn on compact option
#  options("logr.compact" = TRUE)
#  
#  # Turn off compact option
#  options("logr.compact" = FALSE)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Turn on traceback messaging
#  options("logr.traceback" = TRUE)
#  
#  # Turn off traceback messaging
#  options("logr.traceback" = FALSE)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Get warnings from function
#  w1 <- get_warnings()
#  
#  # Get warnings from global variable
#  w2 <- getOption("logr.warnings")

