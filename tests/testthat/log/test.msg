Error: here is a test error

Traceback:
6: tryCatch({
       f <- file(file_path, open = "a", encoding = "native.enc")
       if (all(class(x) == "character")) {
           if (length(x) == 1 && nchar(x) < 100) {
               writeLines(enc2utf8(x), con = f, useBytes = TRUE)
           }
           else {
               withr::with_options(c(crayon.colors = 1), {
                   strgs <- get_unicode_strings(x, ...)
                   writeLines(strgs, con = f, useBytes = TRUE)
               })
           }
       }
       else {
           withr::with_options(c(crayon.colors = 1), {
               strgs <- get_unicode_strings(x, ...)
               writeLines(strgs, con = f, useBytes = TRUE)
           })
       }
       if (blank_after == TRUE) 
     ... at unicode.R#10
5: print_windows(x, file_path, blank_after, hide_notes, ...) at logr.R#435
4: log_print(x, console = FALSE, blank_after = blank_after, hide_notes = TRUE, 
       msg = msg) at logr.R#494
3: log_quiet(capture.output(traceback(7, max.lines = 1000)), msg = TRUE) at logr.R#626
2: (function () 
   {
       log_print(geterrmessage(), hide_notes = TRUE, blank_after = FALSE)
       log_print("Traceback:", hide_notes = TRUE, blank_after = FALSE)
       log_print(capture.output(traceback(7, max.lines = 1000)))
       log_quiet(geterrmessage(), msg = TRUE, blank_after = FALSE)
       log_quiet("Traceback:", msg = TRUE, blank_after = FALSE)
       log_quiet(capture.output(traceback(7, max.lines = 1000)), 
           msg = TRUE)
   })()
1: stop("here is a test error")

