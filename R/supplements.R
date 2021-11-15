

#' @title Get the path of the current log
#' @description The \code{log_path} function gets the path to the currently
#' opened log.  This function may be useful when you want to manipulate 
#' the log in some way, and need the path.  The function takes no parameters.
#' @return The full path to the currently opened log, or NULL if no log is open.
#' @examples 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' log_open(tmp)
#' 
#' # Get path
#' lf <- log_path()
#' 
#' # Close log
#' log_close()
#' 
#' lf
#' @export
log_path <- function() {
  
  ret <- e$log_path
  
  return(ret)
  
}

#' @title Get the status of the log
#' @description The \code{log_status} function gets the status of the 
#' log.  Possible status values are 'on', 'off', 'open', or 'closed'.  
#' The function takes no parameters.
#' @return The status of the log as a character string.
#' @examples 
#' # Check status before the log is opened
#' log_status()
#' # [1] "closed"
#' 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Check status after log is opened
#' log_status()
#' # [1] "open"
#' 
#' # Close log
#' log_close()
#' @export
log_status <- function() {
  
  update_status()
  
  ret <- e$log_status
  
  return(ret)
  
}

#' @title Log the current program code
#' @description A function to send the program/script code to the 
#' currently opened log.  The log must be opened first with 
#' \code{\link{log_open}}.  Code will be prefixed with a right arrow (">")
#' to differentiate it from standard logging lines.  The \code{log_code}
#' function may be called from anywhere within the program.  Code will
#' be inserted into the log at the point where it is called.  The 
#' \code{log_code} function will log the code as it is saved on disk.  It 
#' will not capture any unsaved changes in the editor.  If the current
#' program file cannot be found, the function will return FALSE and no
#' code will be written.
#' @return A TRUE or FALSE value to indicate success or failure of the 
#' function.
#' @seealso \code{\link{log_open}} to open the log, 
#' and \code{\link{log_close}} to close the log.
#' @import this.path
#' @export
#' @examples 
#' # Create temp file location
#' tmp <- file.path(tempdir(), "test.log")
#' 
#' # Open log
#' lf <- log_open(tmp)
#' 
#' # Write code to the log
#' log_code()
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
log_code <- function() {
  
 pth <- NULL
 tryCatch({
   pth <- this.path::this.path()
 }, error = function(e) { pth <- NULL})
 
 
 ret <- FALSE
 
 if (!is.null(pth)) {
   if (file.exists(pth)) {
     
     update_status()
     
     if (e$log_status == "open") {
    
        lns <- readLines(pth, encoding = "UTF-8")
        
        f <- file(e$log_path, "a", encoding = "native.enc")
        
        lns <- paste(">", lns)
        
        writeLines(lns, con = f, useBytes = TRUE)
        writeLines("", con = f, useBytes = TRUE)
        
        close(f)
        
        ret <- TRUE
     }
     
   }
 }
 
 return(ret)
}




