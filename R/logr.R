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
#' There are three main \strong{logr} functions:
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
#' @name logr
#' @aliases logr-package
#' @keywords internal
"_PACKAGE"

# Globals -----------------------------------------------------------------

# Set up environment
e <- new.env(parent = emptyenv())
e$log_status <- "closed"
e$os <- Sys.info()[["sysname"]]
e$log_blank_after <- TRUE
e$log_warnings <- c()
e$error_count <- 0
e$log_stdout <- FALSE
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
#' If an error is encountered, a traceback of the error message is printed
#' to the log and message files by default. This traceback helps in finding
#' the source of the error, particularly in situations where you have deeply
#' nested functions. If you wish to turn the traceback off, set 
#' the \code{traceback} parameter of the \code{log_open} function to FALSE.
#' You may also use the global option \code{logr.traceback} to control printing
#' of this information.
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
#' @param traceback By default, if there is an error in the program
#' being logged, \strong{logr} will print a traceback of the error. You may
#' turn this feature off by setting the \code{traceback} parameter to FALSE.
#' @param header Whether or not to print the log header.  Value values
#' are TRUE and FALSE.  Default is TRUE.
#' @param stdout If TRUE, the log will print to stdout instead of a file.
#' Default is FALSE, which means the log will normally print to a file.
#' This behavior can also be set with the global option 
#' \code{globals("logr.stdout" = TRUE)}.
#' @return The path of the log.
#' @seealso \code{\link{log_print}} for printing to the log (and console), 
#' and \code{\link{log_close}} to close the log.
#' @export
#' @examples 
#' library(logr)
#' 
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
                     autolog = NULL, compact = FALSE, traceback = TRUE, 
                     header = TRUE, stdout = FALSE) {
  
  # Deal with stdout option 
  if (is.null(options()[["logr.stdout"]]) == FALSE) {
    
    optc <- options("logr.stdout")
    
    e$log_stdout = optc[[1]] 
    
  } else {
    
    # Capture compact parameter
    e$log_stdout = stdout
  }
  
  # Deal with compact log
  if (is.null(options()[["logr.compact"]]) == FALSE) {
    
    optc <- options("logr.compact")
    
    e$log_blank_after = !optc[[1]] 
    
  } else {
    
    # Capture compact parameter
    e$log_blank_after = !compact
  }

  # Deal with traceback option
  if (is.null(options()[["logr.traceback"]]) == FALSE) {
    
    optc <- options("logr.traceback")
    
    e$log_traceback = optc[[1]] 
    
  } else {
    
    # Capture traceback parameter
    e$log_traceback = traceback
  }
  
  if (is.null(options()[["logr.on"]]) == FALSE) {
    
   opt <- options("logr.on")
   
   if (all(opt[[1]] == FALSE)) 
     e$log_status = "off"
   else 
     e$log_status = "on"
    
  } else {
    
    e$log_status = "on"
    
  }
  
  
  if (!is.null(autolog)) 
    e$autolog <- autolog
  else if (!is.null(options()[["logr.autolog"]])) {
    
    autolog <- options("logr.autolog")
    
    if (all(autolog[[1]] == FALSE)) 
      e$autolog <- FALSE
    else 
      e$autolog <- TRUE
    
  } else e$autolog <- FALSE
  

  
  lpath <- ""
  
  # If no filename is specified, use current program path.
  if (trimws(file_name) == "") {
    
    ppth <- NULL
    tryCatch({
      ppth <- common::Sys.path()
      # print("ppth0: " %p% ppth)
      # print("ppth1: " %p% is.null(ppth))
      # print("ppth2: " %p% length(ppth))
      # print("ppth3: " %p% nchar(ppth))
      if (length(ppth) == 1) {
        if (nchar(ppth) == 0) { 
          ppth <- NULL 
        } 
      }
      
    }, error = function(e) { ppth <- NULL})
    
    if (is.null(ppth))
      file_name <-  "script.log"
    else 
      file_name <- sub(pattern = "(.*)\\..*$", replacement = "\\1", ppth)
    
  }
  
#print("File name #1: " %p% file_name)
  
  if (trimws(file_name) != "") {
    
    # If there is no log extension, give it one
    if (grepl(".log", basename(file_name), fixed=TRUE) == TRUE)
      lpath <- file_name
    else
      lpath <- paste0(file_name, ".log")
    
    # Create log directory if needed
    d <- dirname(lpath)
    if (logdir == TRUE & basename(d) != "log") {
      tryCatch({
        ldir <- file.path(d, "log")
        if (!dir.exists(ldir))
          dir.create(ldir, recursive = TRUE)
        lpath <- file.path(ldir, basename(lpath))
      },
      warning = function(cond) {
        lpath <- file.path(getwd(), basename(lpath))
      },
      error = function(cond) {
        # do nothing
        # will create in current directory
        lpath <- file.path(getwd(), basename(lpath))
      })
    }
  }
  
  # Give error if path is not valid,
  # before any handlers are established
  if (path_valid(lpath) == FALSE) {
    stop(paste("Log path is invalid: ", lpath))
  }
    
  #print("File name #2: " %p% file_name)
  
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
  
  if (e$log_status == "off") {
    
    message("Log is off.")
    
  } else {
  
    # Create path for message file
    fmpath <- sub(".log", ".msg", basename(lpath), fixed = TRUE)
    mpath <- file.path(dirname(lpath), fmpath)
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
    e$log_status <- "open"
    e$error_count <- 0
    
    # Attach error event handler
    options(error = log_error)
    
    # Clear any warnings
    has_warnings <- FALSE
    if(exists("last.warning")) {
      lw <- get("last.warning")
      has_warnings <- length(lw) > 0
      if(has_warnings) {
        # Would like to do this, but CRAN does not allow it.
        #unlockBinding("last.warning", baseenv()) # Necessary for some OSes
        tryCatch({assign("last.warning", NULL, envir = baseenv())},
                 error = function(cond){},
                 warning = function(cond){},
                 finally = {})
        
      }
    }
    
    # Clear local warnings
    e$log_warnings <- c()
    
    # Publish warnings 
    options("logr.warnings" = c())
    
    # Attach warning event handler
    options(warning.expression = quote({log_warning()}))
    
    
    #print("File name #3: " %p% lpath)
    
    
    # Create the log header
    if (header) {
      print_log_header(lpath)
    }
    
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
#' library(logr)
#' 
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
    if (console == TRUE || e$log_stdout) {
      if (all("character" == class(x)) && length(x) == 1) {
        cat(strwrap(x, width = 80), "\n")
      } else {
        print(x, ...)
      }
    }
    
    # Print to msg_path, if requested
    file_path <- e$log_path
    if (msg == TRUE)
      file_path <- e$msg_path
    
    if (e$log_stdout == FALSE) {
      if (e$os == "Windows") {
        
        print_windows(x, file_path, blank_after, hide_notes, ...)
        
      } else {
        
        print_other(x, file_path, blank_after, hide_notes, ...)
      }
    }
    
    
  } else if (e$log_status == "off") {
    print(x, ...) 
  } else if (e$log_status == "suspended") {
    print(x, ...)    
  } else {
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
  log_print(separator, blank_after = FALSE, hide_notes = TRUE, console = console)
  
  str <- paste(strwrap(x, nchar(separator)), collapse = "\n")
  ret <- log_print(str, blank_after = FALSE, hide_notes = TRUE, console = console)
  log_print(separator, hide_notes = TRUE, blank_after = e$log_blank_after, console = console)
  
  invisible(ret)
}

#' @title
#' Close the log
#'
#' @description 
#' The \code{log_close} function closes the log file. 
#' 
#' @details 
#' The \code{log_close} function terminates logging. The function also prints 
#' the log footer.  The log footer contains a 
#' date-time stamp of when the log was closed.  
#' @param footer Whether or not to print the log footer.  
#' Valid values are TRUE and FALSE.  Default is TRUE.
#' @return None
#' @seealso \code{\link{log_open}} to open the log, and \code{\link{log_print}} 
#' for printing to the log.
#' @export
#' @examples 
#' library(logr)
#' 
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
log_close <- function(footer = TRUE) {
  
  update_status()
  
  # print(paste0("Warnings: ", names(warnings())))
  # print(paste0("Exists: ", exists("last.warning")))
  # print(paste0("Get: ", unclass(get("last.warning"))))
  
  disconnect_handlers()
  
  if (e$log_status == "open") {
    
    # Print out footer
    if (footer) {
      print_log_footer()
    }
    
    # Clean up color codes
    # Commented out because crayon is fixed. 11/8/2023
    # clear_codes()
    
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


#' @title
#' Suspends the log
#'
#' @description 
#' The \code{log_suspend} function function suspends printing to the log, but
#' does not close it. The function will 
#' not print the log footer. To reopen the log, call \code{\link{log_resume}}. 
#' @return None
#' @seealso \code{\link{log_resume}} to continue logging.
#' @export
#' @examples 
#' library(logr)
#' 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send message to log
#' log_print("Before suspend")
#' 
#' # Suspend log
#' log_suspend()
#' 
#' # View suspended log
#' writeLines(readLines(lf))
#' 
#' # Resume log
#' log_resume(lf)
#' 
#' # Print data to log
#' log_print("After suspend")
#' 
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
log_suspend <- function() {
  
  update_status()

  if (e$log_status %in% c("open")) {
    
    log_quiet(paste(separator), blank_after = FALSE)
    log_quiet("Log suspended", blank_after = FALSE)
    log_quiet(paste(separator), blank_after = TRUE)
    
    log_quiet(paste0("Autolog: ", e$autolog), blank_after = FALSE)
    log_quiet(paste0("Log Path: ", e$log_path), blank_after = FALSE)
    log_quiet(paste0("Msg Path: ", e$msg_path), blank_after = FALSE)
    log_quiet(paste0("Show Notes: ", e$log_show_notes), blank_after = FALSE)
    log_quiet(paste0("Blank After: ", e$log_blank_after), blank_after = FALSE)
    log_quiet(paste0("Traceback: ", e$log_traceback), blank_after = FALSE)
    log_quiet(paste0("Status: ", e$log_status), blank_after = FALSE)
    log_quiet(paste0("Tidylog: ", e$tidylog_loaded), blank_after = FALSE)
    log_quiet(paste0("Log Time: ", e$log_time), blank_after = FALSE)
    log_quiet(paste0("Start Time: ", e$log_start_time), blank_after = FALSE)
    st <- Sys.time()
    log_quiet(paste0("Suspend Time: ", st ), blank_after = FALSE)
    log_quiet(paste0("Elapsed Time: ", get_time_diff(st))) 
              
    e$log_status <- "suspended"
    message("Log suspended")
    
  } else if (e$log_status == "off") {
    
    message("Log is off.")
    
  } else {
    message("Log is not open.")
    
  }
}


#' @title
#' Resume writing to a log
#' 
#' @description 
#' A function to reopen and resume writing to a log file that has been suspended. 
#' @param file_name The name of the log file to resume. 
#' If the \code{file_name} parameter is not supplied, the function will look
#' in the current session for the original name and path of the log.  If that
#' name and path is not found, an error will be generated.
#' @return The path of the log.
#' @seealso \code{\link{log_suspend}} for suspending the log, 
#' and \code{\link{log_close}} to close the log.
#' @export
#' @examples 
#' library(logr)
#' 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send message to log
#' log_print("Before suspend")
#' 
#' # Suspend log
#' log_suspend()
#' 
#' # View suspended log
#' writeLines(readLines(lf))
#' 
#' # Resume log
#' log_resume(lf)
#' 
#' # Print data to log
#' log_print("After suspend")
#' 
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
log_resume <- function(file_name = NULL) {
  
  
  # If no filename is specified, use current program path.
  if (is.null(file_name)) {

    if (!is.null(e$log_path))
      file_name <- e$log_path
    else
      stop("Log file name to resume is required.")
  }

  if (!file.exists(file_name)) {
    
    stop("Log resume file not found: " %p% file_name)
  }
  
  lpath <- file_name
  
  rparms <- read_suspended_log(lpath)
  
  # Deal with compact log
  if (is.null(options()[["logr.compact"]]) == FALSE) {
    
    optc <- options("logr.compact")
    
    e$log_blank_after = !optc[[1]] 
    
  } else {
    
    e$log_blank_after <- TRUE
      
    # Capture compact parameter
    if (!is.null(rparms[["Blank After"]])) {
      
      e$log_blank_after = as.logical(rparms[["Blank After"]])
    }

  }
  
  # Deal with traceback option
  if (is.null(options()[["logr.traceback"]]) == FALSE) {
    
    optc <- options("logr.traceback")
    
    e$log_traceback = optc[[1]] 
    
  } else {
    
    e$log_traceback <- TRUE
    
    # Capture traceback parameter
    if (!is.null(rparms[["Traceback"]])) {
      e$log_traceback <- as.logical(rparms[["Traceback"]])
    }
  }
  
  if (is.null(options()[["logr.on"]]) == FALSE) {
    
    opt <- options("logr.on")
    
    if (all(opt[[1]] == FALSE)) 
      e$log_status = "off"
    else 
      e$log_status = "on"
    
  } else {
    
    e$log_status = "on"
    
    if (!is.null(rparms[["Status"]])) {
      e$log_status <-rparms[["Status"]]
    }
    
  }
  
  if (!is.null(options()[["logr.autolog"]])) {
    
    autolog <- options("logr.autolog")
    
    if (all(autolog[[1]] == FALSE)) 
      e$autolog <- FALSE
    else 
      e$autolog <- TRUE
    
  } else {
    
    e$autolog <- FALSE
    
    if (!is.null(rparms[["Autolog"]])) {
      
      e$autolog <- as.logical(rparms[["Autolog"]])
    }
    
  }
  
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
  
    
  # Create path for message file
  mpath <- sub(".log", ".msg", lpath, fixed = TRUE)
  e$msg_path <- mpath

  # Set global variable
  e$log_path <- lpath
  
  # Attach error event handler
  options(error = log_error)

  
  # Attach warning event handler
  options(warning.expression = quote({log_warning()}))
  
  # Create the log header
  print_resume_header(lpath, rparms[["StartPos"]], rparms[["Suspend Time"]])
  
  # Record timestamp for later use by log_print
  e$log_time <- Sys.time()

  if (is.null(options()[["logr.notes"]]) == FALSE) {
    
    optn <- options("logr.notes")
    
    e$log_show_notes = optn[[1]] 
    
  } else {
    
    e$log_show_notes = TRUE
    
    # Capture show_notes parameter
    if (!is.null(rparms[["Show Notes"]])) {
      e$log_show_notes = rparms[["Show Notes"]]
    }
  }
  
  
  return(lpath)
  
}




# Event Handlers ----------------------------------------------------------

# Event handler for errors.  This works.
# Is attached using options function in log_open.
#' @title Logs an error
#' @description Writes an error message to the log. Error will be written
#' both to the log and the message file.  For the log, the error will be written 
#' at the point the function is called.  This function is used internally.
#' @param msg The message to log.
#' @seealso \code{\link{log_warning}} to write a warning message to the log. 
#' @examples
#' library(logr)
#' 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send error message to log
#' log_error("Here is a error")
#'
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
#' 
#' @export
log_error <- function(msg = NULL) {
  

  update_status()
  # print(e$log_status)
  
  
   if (e$log_status == "open" || TRUE) {
     tb <- NULL
     
    if (!is.null(msg)) {
      er <- paste0("Error: ", msg)
      message(er)
    } else {
     
      er <- geterrmessage()
    
      if (e$log_traceback) {
        tb <- capture.output(traceback(5, max.lines = 1000))
      } else {
        
        if (all(grepl("Error", er, fixed = TRUE) == FALSE)) {
          er <- paste0("Error: ", er) 
        }
      }
    }
    
    log_print(er, hide_notes = TRUE, blank_after = FALSE)
    if (e$log_traceback) {
      if (!is.null(tb)) {
        log_print("Traceback:", hide_notes = TRUE, blank_after = FALSE)
        log_print(tb)
      }
    }
    log_quiet(er, msg = TRUE, blank_after = FALSE)
    if (e$log_traceback) {
      if (!is.null(tb)) {
        log_quiet("Traceback:", msg = TRUE, blank_after = FALSE)
        log_quiet(tb, msg = TRUE)
      }
    }
  
    # User requested to close log if there is an error issue #38.
    # Hopefully this will not cause trouble.
    log_close()
    
  } else {

    disconnect_handlers()
  }
}

# Finally got this working
#' @title Logs a warning
#' @description Writes a warning message to the log. Warning will be written
#' both to the log at the point the function is called, and also written to the 
#' message file.  This function is used internally.
#' @param msg The message to log.
#' @seealso \code{\link{log_error}} to write an error message to the log.
#' @export
#' @examples
#' library(logr)
#' 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send warning message to log
#' log_warning("Here is a warning")
#'
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
#' 
log_warning <- function(msg = NULL) {
  
  
  update_status()


  if (e$log_status == "open") {


    # print("Warning Handler")
    if (!is.null(msg)) {
      msg1 <- paste("Warning:", msg)
      log_print(msg1, console = FALSE)
      log_quiet(msg1, msg = TRUE)
      message(msg1)
    } else {
      msg1 <- NULL
      for (n in seq.int(to = 1, by = -1, length.out = sys.nframe() - 1)) {
        e1 <- sys.frame(n)
        # print(paste("frame: ", n))
        lse <- ls(e1)
        #print(lse)
        
        if ("call" %in% lse && "msg" %in% lse) {
          # call1 <- capture.output(print(get("call", envir = e1)))
          # print(msg) 
          msg1 <- paste("Warning:", get("msg", envir = e1))
          log_print(msg1, console = FALSE)
          log_quiet(msg1, msg = TRUE)
          message(msg1)
        }
      }
    }
    
    # Capture warnings locally
    # This is necessary because now the warnings() function in Base R
    # Doesn't work for logr.  So this allows a local version of the
    # warnings() function called get_warnings().  
    if (!is.null(msg1)) {
      wrn <- e$log_warnings
      wrn[length(wrn) + 1] <- paste0(msg1, collapse = "\n")
      e$log_warnings <- wrn
      
      # Publish warnings 
      options("logr.warnings" = wrn)
    
    }
    
  } else {
    
    disconnect_handlers()

  }
}



# Finally got this working
#' @title Gets warnings from most recent log 
#' @description Returns a vector of warning messages from the most recent
#' logging session.  The function takes no parameters.  The warning
#' list will be cleared the next time \code{\link{log_open}} is called.
#' @seealso \code{\link{log_warning}} to write a warning message to the log.
#' @export
#' @examples
#' library(logr)
#' 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send warning message to log
#' log_warning("Here is a warning")
#'
#' # Close log
#' log_close()
#' 
#' # Retrieve warnings
#' res <- get_warnings()
#' 
#' # View results
#' res
#' # [1] "Warning: Here is a warning"
get_warnings <- function() {
  
  
  ret <- e$log_warnings
  
  return(ret)

}


#' @title Logs an informational message
#' @description Writes an informational message to the log. Message will be written
#' to the log at the point the function is called.  
#' @param msg The message to log.  The message must be a character string.
#' @param console Whether or not to print to the console.  Valid values are
#' TRUE and FALSE.  Default is TRUE.
#' @param blank_after Whether or not to print a blank line following the 
#' printed message.  The blank line helps readability of the log.  Valid values
#' are TRUE and FALSE. Default is TRUE.
#' @param hide_notes If notes are on, this parameter gives you the option 
#' of not printing notes for a particular log entry.  Default is FALSE, 
#' meaning notes will be displayed.  Used internally.
#' @return The object, invisibly
#' @seealso \code{\link{log_warning}} to write a warning message to the log.
#' @export
#' @examples
#' library(logr)
#' 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Send info to log
#' log_info("Here is an info message")
#'
#' # Close log
#' log_close()
#' 
#' # View results
#' writeLines(readLines(lf))
#' 
log_info <- function(msg,
                     console = TRUE, 
                     blank_after = NULL, 
                     hide_notes = FALSE) {
  
  if (is.null(blank_after)) {
    
    blank_after <- e$log_blank_after
  }
  
  if (all("character" %in% class(msg))) {
  
    nmsg <- paste0("Info: ", msg)
    
    # Pass everything to log_print()
    ret <- log_print(nmsg, console = console, blank_after = blank_after,
                     msg = FALSE, hide_notes = hide_notes)
  
  } else {
    
    message("Info message must be a character string.")
  }
  
  invisible(ret)
}

