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
e$os <- Sys.info()[["sysname"]]
e$log_blank_after <- TRUE
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
#' As of v1.2.7, if the \code{file_name} parameter is not supplied,
#' the function will use the program/script name as the default
#' log file name, and the program/script path as the default path.
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
#' Version v1.2.0 of the \strong{logr} package introduced \strong{autolog}.
#' The autolog feature provides automatic logging for \strong{dplyr},
#' \strong{tidyr}, and the \strong{sassy} family of packages.  To use autolog,
#' set the \code{autolog} parameter to TRUE, or set the global option
#' \code{logr.autolog} to TRUE.  To maintain backward compatibility with 
#' prior versions, autolog is disabled by default. 
#' 
#' The "compact" parameter will remove all the blank lines between log
#' entries.  The downside of a compact log is that it makes the log 
#' harder to read.  The benefit is 
#' that it will take up less space.  The global option "logr.compact" will
#' achieve the same result.
#' 
#' @param file_name The name of the log file.  If no path is specified, the 
#' working directory will be used.  As of v1.2.7, the name and path of the 
#' program or script will be used as a default if the \code{file_name} parameter
#' is not supplied.
#' @param logdir Send the log to a log directory named "log".  If the log 
#' directory does not exist, the function will create it.  Valid values are 
#' TRUE and FALSE. The default is TRUE.
#' @param show_notes If true, will write notes to the log.  Valid values are 
#' TRUE and FALSE. Default is TRUE.
#' @param autolog Whether to turn on autolog functionality.  Autolog
#' automatically logs functions from the dplyr, tidyr, and sassy family of
#' packages. To enable autolog, either set this parameter to TRUE or 
#' set the "logr.autolog" option to TRUE. A FALSE value on this parameter
#' will override the global option.  The global option
#' will override a NULL on this parameter. Default is that autolog is
#' disabled.
#' @param compact When the compact option is TRUE, \strong{logr} will 
#' minimize the number of blank spaces in the log.  This option generates
#' the same logging information, but in less space. The "logr.compact" global
#' option does the same thing.
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
log_open <- function(file_name = "", logdir = TRUE, show_notes = TRUE,
                     autolog = NULL, compact = FALSE) {
  
  # Deal with compact log
  if (is.null(options()[["logr.compact"]]) == FALSE) {
    
    optc <- options("logr.compact")
    
    e$log_blank_after = !optc[[1]] 
    
  } else {
    
    # Capture show_notes parameter
    e$log_blank_after = !compact
  }

  
  if (is.null(options()[["logr.on"]]) == FALSE) {
    
   opt <- options("logr.on")
   
   if (all(opt[[1]] == FALSE)) 
     e$log_status = "off"
   else 
     e$log_status = "on"
    
  } else e$log_status = "on"
  
  
  if (!is.null(autolog)) 
    e$autolog <- autolog
  else if (!is.null(options()[["logr.autolog"]])) {
    
    autolog <- options("logr.autolog")
    
    if (all(autolog[[1]] == FALSE)) 
      e$autolog <- FALSE
    else 
      e$autolog <- TRUE
    
  } else e$autolog <- FALSE
  
  if (e$autolog) {
    
    if (length(find.package('tidylog', quiet=TRUE)) == 0) {
      utils::install.packages("tidylog", verbose = FALSE, quiet = TRUE)
      #print("tidylog installed")
    }

    if ("tidylog" %in% .packages()) {
      do.call("library", list(package = "tidylog", warn.conflicts = FALSE))
      e$tidylog_loaded <- TRUE
      #print("tidylog was loaded")
      
    } else {
      do.call("library", list(package = "tidylog", warn.conflicts = FALSE))
      e$tidylog_loaded <- FALSE
      #print("tidylog was not loaded")
    }
   
    options("tidylog.display" = list(log_print)) 
    #print("tidylog attached")
  }
  
  lpath <- ""
  
  # If no filename is specified, make up something.
  # If R had a good way of getting the name of the currently
  # executing script, I would do that instead.  But it doesn't.
  if (file_name == "") {
    
    ppth <- NULL
    tryCatch({
      ppth <- this.path::this.path()
    }, error = function(e) { ppth <- NULL})
    
    if (is.null(ppth))
      file_name <-  "script.log"
    else 
      file_name <- sub(pattern = "(.*)\\..*$", replacement = "\\1", ppth)
    
  }
  
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
#' @usage log_print(x, ..., console = TRUE, blank_after = NULL, msg = FALSE, hide_notes = FALSE)
#' @usage put(x, ..., console = TRUE, blank_after = NULL, msg = FALSE, hide_notes = FALSE)
#' @usage sep(x, console = TRUE)
#' @usage log_hook(x)
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
#' except it will print a separator before and after the printed text.  This 
#' function is intended for documentation purposes, and you can use it
#' to help organize your log into sections.
#' 
#' The \code{log_hook} function is for other packages that wish to
#' integrate with \strong{logr}.  The function prints to the log only if 
#' \code{autolog} is enabled. It will not print to the console.
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
#' @param hide_notes If notes are on, this parameter gives you the option 
#' of not printing notes for a particular log entry.  Default is FALSE, 
#' meaning notes will be displayed.  Used internally.
#' @return The object, invisibly
#' @aliases put 
#' @aliases sep
#' @aliases log_hook
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
                      blank_after = NULL, 
                      msg = FALSE, 
                      hide_notes = FALSE) {
  
  update_status()
  
  if (is.null(blank_after)) {
    
    blank_after <- e$log_blank_after
  }
  
  if (e$log_status == "open") {
  
    # Print to console, if requested
    if (console == TRUE)
      print(x, ...)
    
    # Print to msg_path, if requested
    file_path <- e$log_path
    if (msg == TRUE)
      file_path <- e$msg_path
    
    if (e$os == "Windows") {
      
      print_windows(x, file_path, blank_after, hide_notes, ...)
      
      
    } else {
      
      print_other(x, file_path, blank_after, hide_notes, ...)
    }
    
    
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
                blank_after = NULL, 
                msg = FALSE,
                hide_notes = FALSE) {
  
  if (is.null(blank_after)) {
    
    blank_after <- e$log_blank_after
  }
  
  # Pass everything to log_print()
  ret <- log_print(x, ..., console = console, blank_after = blank_after,
                   msg = msg, hide_notes = hide_notes)
  
  invisible(ret)
}

#' @aliases log_print
#' @export
log_hook <- function(x) {
  
  
  update_status()
  if (!is.null(e$log_status) & !is.null(e$autolog)) {
    if (e$log_status == "open" & e$autolog == TRUE) {
      
      # Pass everything to log_print()
      log_print(x, console = FALSE, blank_after = e$log_blank_after, 
                msg = FALSE, hide_notes = FALSE)
    
    }
  }
  
  invisible(x)
}

#' @description Used internally to write header, footer, etc.
#' @noRd
log_quiet <- function(x, blank_after = NULL, msg = FALSE) {
  
 if (is.null(blank_after)) {
   blank_after <- e$log_blank_after 
 }
  
 ret <- log_print(x, console = FALSE, 
                  blank_after = blank_after, 
                  hide_notes = TRUE, 
                  msg = msg)  
 
 return(ret)
                  
}

#' @aliases log_print
#' @export
sep <- function(x, console = TRUE) {
  
  # Pass everything to log_print()
  log_print(separator, blank_after = FALSE, hide_notes = TRUE)
  
  str <- paste(strwrap(x, nchar(separator)), collapse = "\n")
  ret <- log_print(str, blank_after = FALSE, hide_notes = TRUE)
  log_print(separator, hide_notes = TRUE, blank_after = e$log_blank_after)
  
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
  
  update_status()
  
  if (e$log_status == "open") {
    has_warnings <- FALSE
    if(exists("last.warning")) {
      lw <- get("last.warning")
      has_warnings <- length(lw) > 0
      if(has_warnings) {
        log_quiet(warnings())
        log_quiet(warnings(),  msg = TRUE)
        assign("last.warning", NULL, envir = baseenv())
      }
    }
    
    # Detach error handler
    options(error = NULL)
    
    if (e$autolog) {
      
     options("tidylog.display" = NULL) 
      
     # Detach tidylog if not attached by user
     if (e$tidylog_loaded == FALSE) {
       do.call("detach", list(name = "package:tidylog", unload = TRUE))
     }
    }
    
    # Print out footer
    print_log_footer(has_warnings)
    
    # Clean up color codes
    clear_codes()
    
    # Clean up environment variables
    e$log_path <- NULL
    e$msg_path <- NULL
    e$log_show_notes <- NULL
    e$log_time <- NULL
    e$log_start_time <- NULL
    e$log_status <- "closed"
    e$tidylog_loaded <- NULL
    
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
  
  er <- geterrmessage()

  
  tb <- capture.output(traceback(5, max.lines = 1000))
  
  log_print(er, hide_notes = TRUE, blank_after = FALSE)
  log_print("Traceback:", hide_notes = TRUE, blank_after = FALSE)
  log_print(tb)
  log_quiet(er, msg = TRUE, blank_after = FALSE)
  log_quiet("Traceback:", msg = TRUE, blank_after = FALSE)
  log_quiet(tb, msg = TRUE)

  
}

# Currently Not Used
# Was not able to get warning event to trigger properly.
# Will revisit at some point.
# In the meantime, warnings will be printed at 
# the end of the log, above the footer.
# @noRd
# warning_handler <- function() {
#   
#   #print("Warning Handler")
#   log_print(warnings())
#   log_quiet(warnings(), msg = TRUE)
#   
# }
