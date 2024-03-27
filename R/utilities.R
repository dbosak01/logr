
# Utilities ---------------------------------------------------------------

#' @noRd
update_status <- function() {
  
  if (!is.null(options("logr.on")[[1]])) {
    
    if(options("logr.on")[[1]] == FALSE)
      e$log_status <- "off"
    else if (options("logr.on")[[1]] == TRUE & e$log_status == "off")
      e$log_status <- "on"
    
  }
  
  if (!is.null(options("logr.autolog")[[1]])) {
    
    if(options("logr.autolog")[[1]] == FALSE)
      e$autolog <- FALSE
    else if (options("logr.autolog")[[1]] == TRUE)
      e$autolog <- TRUE
  }
  
  if (!is.null(options("logr.notes")[[1]])) {
    
    if(options("logr.notes")[[1]] == FALSE)
      e$log_show_notes <- FALSE
    else if (options("logr.notes")[[1]] == TRUE)
      e$log_show_notes <- TRUE
  }
  
  if (!is.null(options("logr.compact")[[1]])) {
    
    if(options("logr.compact")[[1]] == FALSE)
      e$log_blank_after <- TRUE
    else if (options("logr.compact")[[1]] == TRUE)
      e$log_blank_after <- FALSE
  }
  
  
  
}


#' Function to print the log header
#' @import common
#' @noRd
print_log_header <- function(log_path) {
  
  log_quiet(paste(separator), blank_after = FALSE)
  log_quiet(paste("Log Path:", log_path), blank_after = FALSE)
  
  ppth <- NULL
  tryCatch({
    ppth <- common::Sys.path()
  }, error = function(e) { ppth <- NULL})
  
  if (!is.null(ppth)) {
    if (file.exists(ppth))
      log_quiet(paste("Program Path:", ppth), blank_after = FALSE)
  }
  
  
  log_quiet(paste("Working Directory:", getwd()), blank_after = FALSE)
  
  inf <- Sys.info()
  log_quiet(paste("User Name:", inf["user"]), blank_after = FALSE)
  
  vr <- sub("R version ", "", R.Version()["version.string"])
  log_quiet(paste("R Version:", vr), blank_after = FALSE)
  log_quiet(paste("Machine:", inf["nodename"], inf["machine"]), 
            blank_after = FALSE)
  
  log_quiet(paste("Operating System:", inf["sysname"], inf["release"], 
                  inf["version"]), 
            blank_after = FALSE)
  
  log_quiet(get_base_package_versions(), blank_after = FALSE)
  log_quiet(get_other_package_versions(), blank_after = FALSE)
  
  log_quiet(paste("Log Start Time:", Sys.time()), blank_after = FALSE)
  log_quiet(paste(separator), blank_after = e$log_blank_after)
}

#' Function to print the log footer
#' @noRd
print_log_footer <- function(has_warnings = FALSE) {
  
  tc <- Sys.time()
  
  if (e$log_show_notes == "TRUE" & has_warnings) {
    
    # Force notes after warning print, before the footer
    log_quiet(paste("NOTE: Log Print Time:", Sys.time()), blank_after = FALSE)
    log_quiet(paste("NOTE: Log Elapsed Time:", get_time_diff(tc)), 
              blank_after = e$log_blank_after)
  }
  
  # Calculate total elapsed execution time
  ts <- e$log_start_time
  #tn <- as.POSIXct(as.double(ts), origin = "1970-01-01")
  lt <-  difftime(tc, ts, units = "secs") 
  
  # Print the log footer
  log_quiet(paste(separator), blank_after = FALSE)
  log_quiet(paste("Log End Time:", tc),  blank_after = FALSE)
  log_quiet(paste("Log Elapsed Time:", dhms(as.numeric(lt))), blank_after = FALSE)
  log_quiet(paste(separator), blank_after = FALSE)
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

#' @description Should not be this complicated.  Unfortunately, tidylog
#' decided to use a Unicode ellipsis character in their log entries. 
#' This character causes gsub to crash. grep just gives a warning.
#' So we suppressWarnings, find the lines with strings to replace, 
#' then loop through each and tryCatch to suppress the error.  Horrible pain.
#' 
#' This whole thing is necessary because crayon codes are still being printed
#' to the log.  So the purpose of the function is to remove the crayon
#' color codes.  Generally, should not have to do this.
#' @noRd
clear_codes <- function(path = NULL) {
  
  if (is.null(path))
    pth <- e$log_path
  else 
    pth <- path
  
  
  if (file.exists(pth)) {
    
    lns <- readLines(pth, encoding = "UTF-8")
    
    f <- file(pth, open = "w", encoding = "native.enc")
    #f <- file(pth, open = "w", encoding = "UTF-8")
    
    # lns <- gsub("[90m", "", lns, fixed = TRUE)
    res90 <- suppressWarnings(grep("\033[90m", lns, fixed = TRUE))
    res39 <- suppressWarnings(grep("\033[39m", lns, fixed = TRUE))
    #lns <- gsub("\033[39m", "", lns, fixed = TRUE, useBytes = TRUE)
    
    if (length(res90) > 0 | length(res39) > 0) {
      # print(res90)
      #  print(res39)
      
      if (length(res90) > 0) {
        for (ln in res90) {
          tryCatch({ 
            lns[ln] <- gsub("\033[90m", "", lns[ln], fixed = TRUE)
          })
        }
      }
      
      if (length(res39) > 0) {
        for (ln in res39) {
          tryCatch({ 
            lns[ln] <- gsub("\033[39m", "", lns[ln], fixed = TRUE)
          })
        }
      }
    }
    
    
    # Print the string
    writeLines(lns, con = f, useBytes = TRUE)
    
    # Close file
    close(f) 
    
    
  }
  
}

#' @import utils
#' @noRd
get_base_package_versions <- function() {
  
  
  si <- sessionInfo()
  
  bp <- si$basePkgs
  bpstr <- ""
  cntr <- 0
  
  for (nm in bp) {
    
    cntr <- cntr + 1
    if (cntr > 6) {

      cntr <- 0
      if (nm != bp[[length(bp)]]) {
        bpstr <- paste0(bpstr, nm, "\n", "               ") 
        
      } else {
        
        bpstr <- paste0(bpstr, nm) 
      }
      
    } else {
      
      bpstr <- paste0(bpstr, nm, " ") 
    }
      
    
  }
  
  ret <- paste0("Base Packages: ", bpstr, "\n")

  
  return(ret)
  
}


#' @import utils
#' @noRd
get_other_package_versions <- function() {
  
  
  si <- sessionInfo()
  
  oth <- si$otherPkgs
  othstr <- ""
  cntr <- 0
  ret <- c()
  
  for (nm in names(oth)) {
    cntr <- cntr + 1
    
    if (cntr > 4) {
      
      
      cntr <- 0
      
      if (nm != names(oth)[[length(oth)]]) {
        othstr <- paste0(othstr, nm, "_", oth[[nm]]$Version, "\n", 
                         "                ")
        
      } else {
        
        othstr <- paste0(othstr, nm, "_", oth[[nm]]$Version)
      }
    } else {
      
      othstr <- paste0(othstr, nm, "_", oth[[nm]]$Version, " ") 
    }
    
  }
  
  if (othstr != "") {
    
    ret <- paste0("Other Packages: ", othstr) 
    
  }
  
  
  return(ret)
  
}


read_suspended_log <- function(file_name) {
  
  
  lns <- readLines(file_name, encoding = "UTF-8")
  
  ret <- list()
  
  hlen <- 17
  
  if (length(lns) > hlen) {
    
    slns <- lns[seq(length(lns) - hlen, length(lns))]
    
    spos <- grep("Log suspended", slns, fixed = TRUE)
    
    ret[["StartPos"]] <- length(lns) - hlen + spos - 3
    
    seqparms <- seq(spos + 3, length(slns))
    
    parmlns <- strsplit(slns[seqparms], ":", fixed = TRUE) 
    
    for (i in seq_len(length(parmlns))) {
      
      ln <- parmlns[[i]]
      
      nm <- ln[1]
      
      if (!is.na(nm)) {
        if (nm != "" && length(ln) > 1) {
          tval <- ln[seq(2, length(ln))]
          ret[[nm]] <- trimws(paste0(tval, collapse = ":"))
          
        }
      }
    }
    
  }
  
  return(ret)

}


print_resume_header <- function(file_name, startpos, suspendtime) {
  
  lns <- readLines(file_name, encoding = "UTF-8")
  
  mlns <- lns[seq(1, startpos)]
  
  st <- Sys.time()
  
  stm <-  difftime(st, as.POSIXct(suspendtime), units = "secs")
  
  mlns[length(mlns) + 1] <- separator
  mlns[length(mlns) + 1] <- "Log Suspended: " %p% suspendtime

  mlns[length(mlns) + 1] <- "Log Resumed: " %p% st
  mlns[length(mlns) + 1] <- "Elapsed Time: " %p% dhms(as.numeric(stm))
  
  mlns[length(mlns) + 1] <- separator
  
  blnk <- TRUE
  if (!is.null(e$log_blank_after)) {
    blnk <- e$log_blank_after 
  }
  if (blnk) {
    mlns[length(mlns) + 1] <- ""
  }
  
  
  file.remove(file_name)
  
  f <- file(file_name, open = "a", encoding = "native.enc")
  

  # Print the string
  writeLines(enc2utf8(mlns), con = f, useBytes = TRUE)
  
  close(f)
  
  
  return(file_name)
}
