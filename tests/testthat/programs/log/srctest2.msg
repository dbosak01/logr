Error in reporter$stop_if_needed() :
Traceback:
6: stop(fallback)
5: signal_abort(cnd, .file)
4: abort("Test failed")
3: reporter$stop_if_needed()
2: (function () 
   expr)()
1: test_that("logr33: Errors are recorded on source.all().", {
       if (DEV) {
           tmp <- base_path
           lpth <- file.path(tmp, "/programs/log/srctest2.msg")
           if (file.exists(lpth)) {
               file.remove(lpth)
           }
           pth <- file.path(tmp, "/programs")
           source.all(pth, isolate = TRUE, pattern = "srctest2")
           expect_equal(file.exists(lpth), TRUE)
       }
       else {
           expect_equal(TRUE, TRUE)
       }
   })

