#' @title Creates log files
#'
#' @description The \strong{logr} package contains functions to 
#' easily create log files.
#'
#' @details 
#' The \strong{logr} package helps create log files for R scripts.  The package 
#' provides easy logging, without the complexity of other logging systems.  
#' It is 
#' designed for analysts who simply want a written log of the their program 
#' execution.  The package is designed as a wrapper to 
#' the base R \code{sink()} function.
#' 
#' @section How to use:
#' There are only three \strong{logr} functions:
#' \itemize{
#'   \item \code{\link{log_open}}
#'   \item \code{\link{log_print}}
#'   \item \code{\link{log_close}}
#' }
#' The \code{log_open()} function initiates the log.  The 
#' \code{log_print()} function prints an object to the log.  The 
#' \code{log_close()} function closes the log.  In normal situations, 
#' a user would place the call to 
#' \code{log_open} at the top of the program, call \code{log_print()} 
#' as needed in the 
#' program body, and call \code{log_close()} once at the end of the program.  
#' 
#' Logging may be controlled globally using the options "logr.on" and 
#' "logr.notes".  Both options accept TRUE or FALSE values, and control
#' log printing or log notes, respectively. 
#'
#' See function documentation for additional details.
#' @docType package
#' @name logr
NULL

# Globals -----------------------------------------------------------------

# Set up environment
e <- new.env(parent = emptyenv())
e$log_status <- "closed"

# Log Separator
separator <- 
  "========================================================================="


# Public Functions --------------------------------------------------------

#' @title
#' Open a log
#' 
#' @description 
#' A function to initialize the log file.
#' 
#' @details
#' The \code{log_open} function initializes and opens the log file.  
#' This function must be called first, before any logging can occur.  
#' The function determines the log path, attaches event handlers, 
#' clears existing log files, and initiates a new log.
#'
#' The \code{file_name} parameter may be a full path, a relative path, or 
#' a file name.  An relative path or file name will be assumed to be relative
#' to the current working directory.  If the \code{file_name} does 
#' not have a '.log' extension, the \code{log_open} function will add it.
#' 
#' If requested in the \code{logdir} parameter, the \code{log_open}
#' function will write to a 'log' subdirectory of the path specified in the 
#' \code{file_name}.  If the 'log' subdirectory does not exist, 
#' the function will create it.
#' 
#' The log file will be initialized with a header that shows the log file name,
#' the current working directory, the current user, and a timestamp of
#' when the \code{log_open} function was called.
#' 
#' All errors, the last warning, and any \code{log_print} output will be 
#' written to the log.  The log file will exist in the location specified in the 
#' file_name parameter, and will normally have a '.log' extension.
#' 
#' If errors or warnings are generated, a second file will
#' be written that contains only error and warning messages.  This second file
#' will have a '.msg' extension and will exist in the specified log directory.
#' If the log is clean, the msg file will not be created.  
#' The purpose of the msg file is to give the user a visual indicator from 
#' the file system that an error or warning occurred.  This indicator
#' msg file is useful when running programs in batch.
#' 
#' To use \strong{logr}, call \code{log_open}, and then make calls to 
#' \code{log_print} as needed to print variables or data frames to the log.  
#' The \code{log_print} function can be used in place of a standard 
#' \code{print} function.  Anything printed with \code{log_print} will 
#' be printed to the log, and to the console if working interactively.  
#' 
#' This package provides the functionality of \code{sink}, but in much more 
#' user-friendly way.  Recommended usage is to call \code{log_open} at the top 
#' of the script, call \code{log_print} as needed to log interim state, 
#' and call \code{log_close} at the bottom of the script. 
#' 
#' Logging may be controlled globally using the "logr.on" option.  This option
#' accepts a TRUE or FALSE value. If the option is set to FALSE, \strong{logr}
#' will print to the console, but not to the log. 
#' Example: \code{options("logr.on" = TRUE)}
#' 
#' Notes may be controlled globally using the "logr.notes" option.  This option
#' also accepts a TRUE or FALSE value, and determines whether or not to print
#' notes in the log.  The global option will override the \code{show_notes}
#' parameter on the \code{log_open} function. 
#' Example: \code{options("logr.notes" = FALSE)}
#' 
#' @param file_name The name of the log file.  If no path is specified, the 
#' working directory will be used.
#' @param logdir Send the log to a log directory named "log".  If the log 
#' directory does not exist, the function will create it.  Valid values are 
#' TRUE and FALSE. The default is TRUE.
#' @param show_notes If true, will write notes to the log.  Valid values are 
#' TRUE and FALSE. Default is TRUE.
#' @return The path of the log.
#' @seealso \code{\link{log_print}} for printing to the log (and console), 
#' and \code{\link{log_close}} to close the log.
#' @export
#' @examples 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send message to log
#' log_print("High Mileage Cars Subset")
#' 
#' # Perform operations
#' hmc <- subset(mtcars, mtcars$mpg > 20)
#' 
#' # Print data to log
#' log_print(hmc)
#' 
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
log_open <- function(file_name = "", logdir = TRUE, show_notes = TRUE) {
  
  if (is.null(options()[["logr.on"]]) == FALSE) {
    
   opt <- options("logr.on")
   
   if (all(opt[[1]] == FALSE)) 
     e$log_status = "off"
   else 
     e$log_status = "on"
    
  } else e$log_status = "on"
  
  
  lpath <- ""
  
  # If no filename is specified, make up something.
  # If R had a good way of getting the name of the currently
  # executing script, I would do that instead.  But it doesn't.
  if (file_name == "")
    file_name = "script.log"
  
  if (file_name != "") {
    
    # If there is no log extension, give it one
    if (grepl(".log", file_name, fixed=TRUE) == TRUE)
      lpath <- file_name
    else
      lpath <- paste0(file_name, ".log")
    
    # Create log directory if needed
    d <- dirname(lpath)
    if (logdir == TRUE & substr(d, length(d) - 3, length(d)) != "log") {
      tryCatch({
        ldir <- file.path(d, "log")
        if (!dir.exists(ldir))
          dir.create(ldir)
        lpath <- file.path(ldir, basename(lpath))
      },
      error = function(cond) {
        # do nothing
        # will create in current directory
      })
    }
  }
  
  if (e$log_status == "off") {
    
    message("Log is off.")
    
  } else {
  
    # Create path for message file
    mpath <- sub(".log", ".msg", lpath, fixed = TRUE)
    e$msg_path <- mpath
  
      
    # Kill any existing log file
    if (file.exists(lpath)) {
      file.remove(lpath)
    }
    
    # Kill any existing msg file  
    if (file.exists(mpath)) {
      file.remove(mpath)
    }
    
    # At one point considered creating a dump file
    # automatically.  Still under consideration.
    # if (file.exists(dump_path)) {
    #   file.remove(dump_path)
    # }
  
    # Set global variable
    e$log_path <- lpath
    e$log_status = "open"
    
    # Attach error event handler
    options(error = error_handler)
    
    # Clear any warnings
    has_warnings <- FALSE
    if(exists("last.warning")) {
      lw <- get("last.warning")
      has_warnings <- length(lw) > 0
      if(has_warnings) {
        log_print(warnings(), console = FALSE)
        log_print(warnings(), console = FALSE, msg = TRUE)
        assign("last.warning", NULL, envir = baseenv())
      }
    }
    
    # Doesn't seem to work. At least on Windows. Bummer.
    #options(warn = 1, warning = warning_handler)
    
    # Create the log header
    print_log_header(lpath)
    
    # Record timestamp for later use by log_print
    ts <- Sys.time()
    e$log_time = ts
    e$log_start_time = ts
  
    
    if (is.null(options()[["logr.notes"]]) == FALSE) {
      
      optn <- options("logr.notes")
      
      e$log_show_notes = optn[[1]] 
      
    } else {
      
      # Capture show_notes parameter
      e$log_show_notes = show_notes
    }

  
  }
  
  return(lpath)
  
}

#' @title
#' Print an object to the log
#' 
#' @description 
#' The \code{log_print} function prints an object to the currently opened log.
#' @usage log_print(x, ..., console = TRUE, blank_after = TRUE, msg = FALSE)
#' @usage put(x, ..., console = TRUE, blank_after = TRUE, msg = FALSE)
#' @usage sep(x, console = TRUE)
#' @details 
#' The log is initialized with \code{log_open}.  Once the log is open, objects
#' like variables and data frames can be printed to the log to monitor execution
#' of your script.  If working interactively, the function will print both to
#' the log and to the console.  The \code{log_print} function is useful when
#' writing and debugging batch scripts, and in situations where some record
#' of a scripts' execution is required.
#' 
#' If requested in the \code{log_open} function, \code{log_print}  
#' will print a note after each call.  The note will contain a date-time stamp
#' and elapsed time since the last call to \code{log_print}.  When printing
#' a data frame, the \code{log_print} function will also print the number
#' and rows and column in the data frame.  These counts may also be useful 
#' in debugging.   
#' 
#' Notes may be turned off either by setting the \code{show_notes} parameter
#' on \code{log_open} to FALSE, or by setting the global option "logr.notes"
#' to FALSE.
#'
#' The \code{put} function is a shorthand alias for \code{log_print}. You can
#' use \code{put} anywhere you would use \code{log_print}.  The functionality
#' is identical.
#' 
#' The \code{sep} function is also a shorthand alias for \code{log_print}, 
#' except it will print a separator before and after the printed text
#' or object.  You can use the \code{sep} function to help organize your 
#' log.  In addition, the \code{sep} function has a limited number of 
#' optional arguments.
#' 
#' @param x The object to print.  
#' @param ... Any parameters to pass to the print function.
#' @param console Whether or not to print to the console.  Valid values are
#' TRUE and FALSE.  Default is TRUE.
#' @param blank_after Whether or not to print a blank line following the 
#' printed object.  The blank line helps readability of the log.  Valid values
#' are TRUE and FALSE. Default is TRUE.
#' @param msg Whether to print the object to the msg log.  This parameter is
#' intended to be used internally.  Value values are TRUE and FALSE.  The 
#' default value is FALSE.
#' @return The object, invisibly
#' @aliases put 
#' @aliases sep
#' @seealso \code{\link{log_open}} to open the log, 
#' and \code{\link{log_close}} to close the log.
#' @export
#' @examples 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send message to log
#' log_print("High Mileage Cars Subset")
#' 
#' # Perform operations
#' hmc <- subset(mtcars, mtcars$mpg > 20)
#' 
#' # Print data to log
#' log_print(hmc)
#' 
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
log_print <- function(x, ..., 
                      console = TRUE, 
                      blank_after = TRUE, 
                      msg = FALSE) {
  
  
  if (e$log_status == "open") {
  
    # Print to console, if requested
    if (console == TRUE)
      print(x, ...)
    
    # Print to msg_path, if requested
    file_path <- e$log_path
    if (msg == TRUE)
      file_path <- e$msg_path
    
    # Print to log or msg file
    tryCatch( {
      
        # Use sink() function so print() will work as desired
        sink(file_path, append = TRUE)
        if (all(class(x) == "character")) {
          if (length(x) == 1 && nchar(x) < 100) {
          
            # Print the string
            cat(x, "\n")
            
            # Add blank after if requested
            if (blank_after == TRUE)
              cat("\n")
          } else {
            
            # Print the object
            print(x, ...)
            
            if (blank_after == TRUE)
              cat("\n")
            
          }
          
          
        } else {
          
          # Print the object
          print(x, ...)
          
          if (blank_after == TRUE)
            cat("\n")
        }
      },
      error = function(cond) {
        
          print("Error: Object cannot be printed to log\n")
        },
      finally = {
        
        # Print time stamps on normal log_print
        if (blank_after == TRUE & console == TRUE) {
          tc <- Sys.time()
          
          if (e$log_show_notes == TRUE) {
            
            # Print data frame row and column counts
            if (any(class(x) == "data.frame")) {
              cat(paste("NOTE: Data frame has", nrow(x), "rows and", ncol(x), 
                        "columns."), "\n")
              cat("\n")
            }
            
            # Print log timestamps
            cat(paste("NOTE: Log Print Time: ", tc), "\n")
            cat(paste("NOTE: Elapsed Time in seconds:", get_time_diff(tc)), "\n")
            cat("\n")
          }
        }
        
        # Release sink no matter what
        sink()
      }
    )
  } else if (e$log_status == "off") {
    print(x, ...) 
  }  else {
    print(x, ...)
    message("Log is not open.")

  }
  
  invisible(x)
}

#' @aliases log_print
#' @export
put <- function(x, ..., 
                console = TRUE, 
                blank_after = TRUE, 
                msg = FALSE) {
  
  # Pass everything to log_print()
  ret <- log_print(x, ..., console = console, blank_after = blank_after,
                   msg = msg)
  
  invisible(ret)
}

#' @aliases log_print
#' @export
sep <- function(x, console = TRUE) {
  
  # Pass everything to log_print()
  log_print(separator, blank_after = FALSE)
  ret <- log_print(x, blank_after = FALSE)
  log_print(separator)
  
  invisible(ret)
}

#' @title
#' Close the log
#'
#' @description 
#' The \code{log_close} function closes the log file. 
#' 
#' @details 
#' The \code{log_close} function terminates logging.  As part of the termination
#' process, the function prints any outstanding warnings to the log.  Errors are
#' printed at the point at which they occur. But warnings can be captured only 
#' at the end of the logging session. Therefore, any warning messages will only
#' be printed at the bottom of the log.  
#' 
#' The function also prints the log footer.  The log footer contains a 
#' date-time stamp of when the log was closed.  
#' @return None
#' @seealso \code{\link{log_open}} to open the log, and \code{\link{log_print}} 
#' for printing to the log.
#' @export
#' @examples 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send message to log
#' log_print("High Mileage Cars Subset")
#' 
#' # Perform operations
#' hmc <- subset(mtcars, mtcars$mpg > 20)
#' 
#' # Print data to log
#' log_print(hmc)
#' 
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
log_close <- function() {
  
  if (e$log_status == "open") {
    has_warnings <- FALSE
    if(exists("last.warning")) {
      lw <- get("last.warning")
      has_warnings <- length(lw) > 0
      if(has_warnings) {
        log_print(warnings(), console = FALSE)
        log_print(warnings(), console = FALSE, msg = TRUE)
        assign("last.warning", NULL, envir = baseenv())
      }
    }
    
    # Detach error handler
    options(error = NULL)
    
    # Print out footer
    print_log_footer(has_warnings)
    
    # Clean up environment variables
    e$log_path <- NULL
    e$msg_path <- NULL
    e$log_show_notes <- NULL
    e$log_time <- NULL
    e$log_start_time <- NULL
    e$log_status <- "closed"
  } else if (e$log_status == "off") {
  
    message("Log is off.")
    
  } else {
    message("Log is not open.")

  }
  
}


# Event Handlers ----------------------------------------------------------

#' Event handler for errors.  This works.
#' Is attached using options function in log_open.
#' @noRd
error_handler <- function() {
  
  log_print(geterrmessage())
  log_print(geterrmessage(), console = FALSE, msg = TRUE)
  
}

# Currently Not Used
# Was not able to get warning event to trigger properly.
# Will revisit at some point.
# In the meantime, warnings will be printed at 
# the end of the log, above the footer.
#' @noRd
warning_handler <- function() {
  
  #print("Warning Handler")
  log_print(warnings())
  log_print(warnings(), console = FALSE, msg = TRUE)
  
}


# Utilities ---------------------------------------------------------------

#' Function to print the log header
#' @noRd
print_log_header <- function(log_path) {
  
  log_print(paste(separator), console = FALSE, blank_after = FALSE)
  log_print(paste("Log Path:", log_path), console = FALSE, blank_after = FALSE)
  log_print(paste("Working Directory:", getwd()), console = FALSE, 
            blank_after = FALSE)
  
  inf <- Sys.info()
  log_print(paste("User Name:", inf["user"]), console = FALSE, 
            blank_after = FALSE)
  
  vr <- sub("R version ", "", R.Version()["version.string"])
  log_print(paste("R Version:", vr), console = FALSE, 
            blank_after = FALSE)
  log_print(paste("Machine:", inf["nodename"], inf["machine"]), 
            console = FALSE, 
            blank_after = FALSE)

  log_print(paste("Operating System:", inf["sysname"], inf["release"], 
                  inf["version"]), 
            console = FALSE, 
            blank_after = FALSE)
  
  log_print(paste("Log Start Time:", Sys.time()), console = FALSE, 
            blank_after = FALSE)
  log_print(paste(separator), console = FALSE)
}

#' Function to print the log footer
#' @noRd
print_log_footer <- function(has_warnings = FALSE) {
  
  tc <- Sys.time()
  
  if (e$log_show_notes == "TRUE" & has_warnings) {
    
    # Force notes after warning print, before the footer
    log_print(paste("NOTE: Log Print Time:", Sys.time()), 
              console = FALSE, blank_after = FALSE)
    log_print(paste("NOTE: Log Elapsed Time:", get_time_diff(tc)), 
              console = FALSE, blank_after = TRUE)
  }
  
  # Calculate total elapsed execution time
  ts <- e$log_start_time
  #tn <- as.POSIXct(as.double(ts), origin = "1970-01-01")
  lt <-  tc - ts

  # Print the log footer
  log_print(paste(separator), console = FALSE, blank_after = FALSE)
  log_print(paste("Log End Time:", tc), console = FALSE, 
            blank_after = FALSE)

  log_print(paste("Log Elapsed Time:", dhms(as.numeric(lt))), console = FALSE, 
            blank_after = FALSE)

  log_print(paste(separator), console = FALSE, blank_after = FALSE)
}

#' Get time difference between last log_print call and current call
#' @noRd
get_time_diff <- function(x) {
  
  # Pull timestamp out of environment variable
  ts <- e$log_time
  
  # Convert string to time
  #tn <- as.POSIXct(as.double(ts), origin = "1970-01-01")
  
  # Get difference
  ret <- x - ts
  
  # Set new timestamp
  e$log_time = x
  
  return(ret)
}

#' Little function to format time in seconds into 
#' days, hours, minutes, and seconds.  Stolen from StackOverflow.
#' Did not want to create a dependency on external package to do it.
#' @noRd
dhms <- function(t){
  paste(t %/% (60*60*24) 
        ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
               ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
               ,formatC(t %% 60, width = 2, format = "d", flag = "0")
               ,sep = ":"
        )
  )
}

# Test Case ---------------------------------------------------------------
# 
# library(logr)
# 
# 
# options("logr.on" = NULL)
# options("logr.notes" = NULL)
# 
# library(tibble)
# 
# file.remove(lf)
# tmp <- file.path(tempdir(), "test.log")
# 
# lf <- log_open(tmp)
# 
# sep("High Mileage Cars Subset")
# 
# hmc <- tibble(subset(mtcars, mtcars$mpg > 20))
# log_print(hmc)
# 
# log_print("Here is a character vector")
# v1 <- c("1", "2", "3")
# log_print(v1)
# 
# sep("Here is a numeric \nvector")
# v2 <- c(1, 2, 3)
# log_print(v2)
# 
# log_print("Here is a factor")
# f1 <- factor(c("A", "B", "B", "A"), levels = c("A", "B"))
# log_print(f1)
# 
# log_print("Here is a list")
# l1 <- list("A", 1, Sys.Date())
# log_print(l1)
# 
# #
# # # generror
# # # warning("Test warning")
# #
# #
# log_close()
# 
# writeLines(readLines(lf))
# 
# 
# 





