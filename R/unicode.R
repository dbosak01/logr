

# Printing functions ------------------------------------------------------


#' @noRd
print_windows <- function(x, file_path, blank_after, hide_notes, ...) {
  
  # Print to log or msg file
  tryCatch( {
    
    
    
    f <- file(file_path, open = "a", encoding = "native.enc")
 
    if (all(class(x) == "character")) {
      if (length(x) == 1 && nchar(x) < 100) {
        
        # Print the string
        writeLines(enc2utf8(x), con = f, useBytes = TRUE)
        

      } else {
        
        # Print the object
        withr::with_options(c("crayon.colors" = 1), { 
          
          strgs <- get_unicode_strings(x, ...)
          writeLines(strgs, con = f, useBytes = TRUE)
        })
      
        
      }
    
      
    } else {
      
      # Print the object
      withr::with_options(c("crayon.colors" = 1), { 
        strgs <- get_unicode_strings(x, ...)
        writeLines(strgs, con = f, useBytes = TRUE)
      })
      
    }
    
    # Add blank after if requested
    if (blank_after == TRUE)
      writeLines("", con = f, useBytes = TRUE)
    
  },
  error = function(cond) {
    
    print("Error: Object cannot be printed to log\n")
  },
  finally = {
    
    # Print time stamps on normal log_print
    if (hide_notes == FALSE) {
      tc <- Sys.time()
      
      if (e$log_show_notes == TRUE) {
        
        # Print data frame row and column counts
        if (any(class(x) == "data.frame")) {
          writeLines(paste("NOTE: Data frame has", nrow(x), "rows and", ncol(x), 
                    "columns."), con = f, useBytes = TRUE)
          if (e$log_blank_after)
            writeLines("", con = f, useBytes = TRUE)
        }
        
        # Print log timestamps
        ts <- get_time_diff(tc)
        writeLines(paste("NOTE: Log Print Time: ", tc), con = f, useBytes = TRUE)
        writeLines(paste("NOTE: Elapsed Time:", ts, attributes(ts)$units), 
                   con = f, useBytes = TRUE)
        if (e$log_blank_after)
          writeLines("", con = f, useBytes = TRUE)
      }
    }
    
    
    # Close file no matter what
    close(f)
  }
  ) 
  
}


#' @noRd
print_other <- function(x, file_path, blank_after, hide_notes, ...) {
  
  # Print to log or msg file
  tryCatch( {
    
    
    
    f <- file(file_path, open = "a", encoding = "UTF-8")
    # Use sink() function so print() will work as desired
    sink(f, append = TRUE)
    if (all(class(x) == "character")) {
      if (length(x) == 1 && nchar(x) < 100) {
        
        # Print the string
        cat(x, "\n")
        
      } else {
        
        # Print the object
        withr::with_options(c("crayon.colors" = 1), { 
          print(x, ..., )
        })
        
      }
      
      
    } else {
      
      # Print the object
      withr::with_options(c("crayon.colors" = 1), { 
        print(x, ...)
      })
      

    }
    
    if (blank_after == TRUE)
      cat("\n")
  },
  error = function(cond) {
    
    print("Error: Object cannot be printed to log\n")
  },
  finally = {
    
    # Print time stamps on normal log_print
    if (hide_notes == FALSE) {
      tc <- Sys.time()
      
      if (e$log_show_notes == TRUE) {
        
        # Print data frame row and column counts
        if (any(class(x) == "data.frame")) {
          cat(paste("NOTE: Data frame has", nrow(x), "rows and", ncol(x), 
                    "columns."), "\n")
          cat("\n")
        }
        
        # Print log timestamps
        ts <- get_time_diff(tc)
        cat(paste("NOTE: Log Print Time: ", tc), "\n")
        cat(paste("NOTE: Elapsed Time:", ts, attributes(ts)$units), "\n")
        cat("\n")
      }
    }
    
    # Release sink no matter what
    sink()
    
    # Close file no matter what
    close(f)
  }
  ) 
  
}



# Unicode handlers --------------------------------------------------------



#' @noRd
get_unicode_strings <- function(obj, ...) {
  
  if (!all(class(obj) == "character")) {
    
    strgs <-  utils::capture.output(print(obj, ...), file = NULL)
    
    ret <- get_unicode(strgs)
    
    
  } else {
  
    ret <- obj
  }

  
  
  
  return(ret)
}



#' @noRd
get_unicode <- Vectorize(function(string){
  
  ret <- string
  
  m <- gregexpr("<U\\+[0-9A-F]{4}>", string)
  
  if(m[[1]][1] != -1) {

  
    codes <- unlist(regmatches(string, m))
    replacements <- codes
    N <- length(codes)
    for(i in 1:N){
      replacements[i] <- intToUtf8(strtoi(paste0("0x", substring(codes[i], 4, 7))))
    }
    
    # if the string doesn't start with a unicode, copy its initial part
    # until first occurrence of unicode
    if(1 != m[[1]][1]){
      y <- substring(string, 1, m[[1]][1]-1)
      y <- paste0(y, replacements[1])
    }else{
      y <- replacements[1]
    }
    
    # if more than 1 unicodes in the string
    if(1 < N){
      for(i in 2:N){
        s <- gsub("<U\\+[0-9A-F]{4}>", replacements[i], 
                  substring(string, m[[1]][i-1]+8, m[[1]][i]+7))
        Encoding(s) <- "UTF-8"
        y <- paste0(y, s)
      }
    }
    
    # get the trailing contents
    if( nchar(string)>(m[[1]][N]+8) )
      ret <- paste0( y, substring(string, m[[1]][N]+8, nchar(string)) )
    else 
      ret <- y
  
  }
  
  return(ret)
  
}, USE.NAMES = FALSE)



