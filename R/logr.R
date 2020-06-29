
# Globals -----------------------------------------------------------------


# Log Separator
separator <- 
  "========================================================================="


# Public Functions --------------------------------------------------------



#' @title
#' Initialize the log
#' 
#' @description 
#' A function to initialize the log file.
#' 
#' @details
#' This function initializes and opens the log file.  This function must be 
#' called first, before any logging can occur.  The function determines the 
#' log path, attaches event handlers, clears existing log files, 
#' and initiates a new log.
#'
#' The \code{file_name} parameter may be a full path, a relative path, or 
#' a file name.  An relative path or file name will be assumed to be relative
#' to the current working directory.  
#' 
#' If requested in the \code{subfolder} parameter, the \code{log_open}
#' function will write to a 'log' subfolder of the path specified in the 
#' \code{file_name}.  If the 'log' subfolder does not exist, 
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
#' the file system that an error or warning has been generated.  This indicator
#' msg file is useful when running programs in batch.
#' 
#' To use logr, call \code{log_open}, and then make calls to \code{log_print} 
#' as needed to print variables or data frames to the log.  The \code{log_print}
#' function can be used in place of a standard \code{print} function.  Anything
#' printed with \code{log_print} will be printed to the log, and to the console
#' if working interactively.  
#' 
#' This package provides the functionality of \code{sink}, but in much more 
#' user-friendly way.  Recommended usage is to call \code{log_open} at the top 
#' of the script, call \code{log_print} as needed to log interim state, 
#' and call \code{log_close} at the bottom of the script. 
#' 
#' @param file_name The name of the log file.  If no path is specified, the 
#' working directory will be used.
#' @param logfolder Send the log to a logfolder named "log".  If the logfolder
#' does not exist, the function will create it.
#' @return The path of the log.
#' @seealso \code{\link{log_print}} for printing to the log (and console), 
#' and \code{\link{log_close}} to close the log.
#' @export
#' @examples
#' # Open the log
#' log_open("test.log", logfolder = TRUE)
#' 
#' # Print test messages
#' log_print("Test message")
#' log_print(mtcars)
#' 
#' # Close the log
#' log_close()
log_open <- function(file_name = "", logfolder = FALSE) {
  

  lpath <- ""
  
  # Get log file name
  if (file_name == "")
    file_name = "script.log"
  
  if (file_name != "") {
    
    if (grepl(".log", file_name, fixed=TRUE) == TRUE)
      lpath <- file_name
    else
      lpath <- paste0(file_name, ".log")
    
    d <- dirname(lpath)
    if (logfolder == TRUE & substr(d, length(d) - 3, length(d)) != "log") {
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
  
  mpath <- sub(".log", ".msg", lpath, fixed = TRUE)
  Sys.setenv(msg_path = mpath)

    
  # Kill any existing log file
  if (file.exists(lpath)) {
    file.remove(lpath)
  }
  
  # Kill any existing msg file  
  if (file.exists(mpath)) {
    file.remove(mpath)
  }
  
  # if (file.exists(dump_path)) {
  #   file.remove(dump_path)
  # }

  # Set global variable
  Sys.setenv(log_path = lpath)
  
  # Attach error event handler
  options(error = error_handler)
  
  # Doesn't seem to work
  #options(warn = 1, warning = warning_handler)
  
  print_log_header(lpath)
  
  return(lpath)
  
}

#' @title
#' Print an object to the log
#' 
#' @description 
#' The \code{log_print} function prints an object to the currently opened log.
#' 
#' @details 
#' The log is initialized with \code{log_open}.  Once the log is open, objects
#' like variables and data frames can be printed to the log to monitor execution
#' of your script.  If working interactively, the function will print both to
#' the log and to the console.  The \code{log_print} function is useful when
#' writing and debugging batch scripts, and in situations where some record
#' of a scripts' execution is required.
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
#'
#' @return None
#' @export
#' @examples
#' # Open the log
#' log_open("test.log", logfolder = TRUE)
#' 
#' # Print test messages
#' log_print("Test message")
#' log_print(mtcars)
#' 
#' # Close the log
#' log_close()
log_print <- function(x, ..., 
                      console = TRUE, 
                      blank_after = TRUE, 
                      msg = FALSE) {
  
  # Print to console, if requested
  if (console == TRUE)
    print(x, ...)
  
  # Print to msg_path, if requested
  file_path <- Sys.getenv("log_path")
  if (msg == TRUE)
    file_path <- Sys.getenv("msg_path")
  
  # Print to log or msg file
  tryCatch( {
    
      # Use sink() function so print() will work as desired
      sink(file_path, append = TRUE)
      if (class(x) == "character") {
        
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
    },
    error = function(cond) {
      
        print("Error: Object cannot be printed to log\n")
      },
    finally = {
      
      # Release sink no matter what
      sink()
    }
  )
  
  invisible(x)
}



#' @title
#' Close the log
#'
#' @description 
#' Print any warnings, print the log footer and close the log file. 
#' 
#' @details 
#' The \code{log_close} function terminates logging.  As part of the termination
#' process, the function prints any outstanding warnings to the log.  Errors are
#' printed at the point at which they occur. But warnings can be captured only 
#' at the end of the logging session. Therefore, any warning messages will only
#' be printed at the bottom of the log.  
#' 
#' The function also prints the log footer.  The log footer contains a 
#' date/timestamp of when the log was closed.  
#' @return None
#' @export
#' @examples
#' # Open the log
#' log_open("test.log", logfolder = TRUE)
#' 
#' # Print test messages
#' log_print("Test message")
#' log_print(mtcars)
#' 
#' # Close the log
#' log_close()
log_close <- function() {
  
  if(exists("last.warning")) {
    lw <- get("last.warning")
    if(length(lw) > 0) {
      log_print(warnings(), console = FALSE)
      log_print(warnings(), console = FALSE, msg = TRUE)
      assign("last.warning", NULL, envir = baseenv())
    }
  }
  

  
  options(error = NULL)
  
  print_log_footer()
  
  Sys.unsetenv("log_path")
  Sys.unsetenv("msg_path")
  
}


# Event Handlers ----------------------------------------------------------


#' @noRd
error_handler <- function() {
  
  log_print(geterrmessage())
  log_print(geterrmessage(), console = FALSE, msg = TRUE)
  
}

# Currently Not Used
#' @noRd
warning_handler <- function() {
  
  #print("Warning Handler")
  log_print(warnings())
  log_print(warnings(), console = FALSE, msg = TRUE)
  
}


# Utilities ---------------------------------------------------------------

#' @noRd
print_log_header <- function(log_path) {
  
  log_print(paste(separator), console = FALSE, blank_after = FALSE)
  log_print(paste("Log Path:", log_path), console = FALSE, blank_after = FALSE)
  log_print(paste("Working Directory:", getwd()), console = FALSE, 
            blank_after = FALSE)
  log_print(paste("System User:", Sys.getenv("USERNAME")), console = FALSE, 
            blank_after = FALSE)
  log_print(paste("Log Start Time:", Sys.time()), console = FALSE, 
            blank_after = FALSE)
  log_print(paste(separator), console = FALSE)
}

#' @noRd
print_log_footer <- function() {
  log_print(paste(separator), console = FALSE, blank_after = FALSE)
  log_print(paste("Log End Time:", Sys.time()), console = FALSE, 
            blank_after = FALSE)
  log_print(paste(separator), console = FALSE, blank_after = FALSE)
}



# Test Case ---------------------------------------------------------------
# 
# lf <- log_open("test.log", logfolder = TRUE)
# 
# log_print("Here is the first log message")
# log_print(mtcars)
# generror
# warning("Test warning")
# log_print("Here is a second log message")
# log_close()
# 
# # clean up
# if (file.exists(lf)) {
#   file.remove(lf)
# }
# if (file.exists(msg_path)) {
#   file.remove(msg_path)
# }
