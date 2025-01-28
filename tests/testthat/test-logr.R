context("logr tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()

DEV <- FALSE

test_that("logr1: the log_open function handles invalid parameters.", {
  
  tmp <- base_path
  
  nm <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  log_print("Here is a second log message")
  log_close()
  
  lf <- file.path(gsub("\\", "/", tmp, fixed = TRUE), "log/test.log")
  
  ret <- file.exists(lf)
  
  expect_equal(nm, lf)
  expect_equal(TRUE, ret)
  
  
})

test_that("logr2: the log_print function handles invalid parameters.", {
  
  tmp <- base_path
  
  lp <- log_open(file.path(tmp, "test.log"))
  
  log_print("Here is the first log message")
  log_print("Here is a second log message")
  log_close()
  
  lf <- file.path(gsub("\\", "/", tmp, fixed = TRUE), "log/test.log")
  
  ret <- file.exists(lf)
  
  expect_equal(basename(lp), basename(lf))
  expect_equal(TRUE, ret)
  # 
  # if (ret)
  #   file.remove(lf)
  # 
  # if (dir.exists(file.path(tmp, "log"))) {
  #   unlink("log", force = TRUE, recursive = TRUE)
  # }
  
})



test_that("logr3: the logr package can create a log with no errors or warnings.", {
  
  tmp <- base_path
  
  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  log_print(mtcars)
  log_print("Here is a second log message")
  
  mp <- sub(".log", ".msg", lf, fixed = TRUE) 
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})



test_that("logr4: the logr package can create a log with warnings.", {

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  expect_warning(warning("here is a test warning"))
  # warning("here is a test warning")

  log_print("Another message")

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})


test_that("logr5: logr.notes = FALSE works as expected.", {

  tmp <- base_path

 options("logr.notes" = FALSE)


  lf <- log_open(file.path(tmp, "test.log"))
  log_print("No notes in this log.")



  log_close()

  ret <- file.exists(lf)

  expect_equal(ret, TRUE)


  readLines(lf)

  options("logr.notes" = TRUE)

})


test_that("logr6: logr.notes = TRUE works as expected.", {

  tmp <- base_path

  options("logr.notes" = TRUE)


  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Notes in this log.")



  log_close()

  ret <- file.exists(lf)

  expect_equal(ret, TRUE)


  readLines(lf)


})


test_that("logr7: the logr package can create a log with error", {

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  expect_error(stop("here is a test error"))
  #stop("here is a test error")

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})

# This won't work.  Need to actually generate a warning.
test_that("logr8: the logr package can create a log with warning", {

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  expect_warning(warning("here is a test warning"))
  # warning("here is a test warning")

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})

# This won't work.  Need to actually generate a warning.
test_that("logr9: the logr package can clear warnings", {

  tmp <- base_path

  suppressWarnings(warning("here is a warning"))

  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")

  mp <- sub(".log", ".msg", lf, fixed = TRUE)

  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})


test_that("logr10: the logr package can log vectors, factors, and lists with no errors or warnings.", {

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test.log"))

  log_print("Here is a vector")
  v1 <- c("1", "2", "3")
  log_print(v1)

  log_print("Here is a factor")
  f1 <- factor(c("A", "B", "B", "A"), levels = c("A", "B"))
  log_print(f1)

  log_print("Here is a list")
  l1 <- list("A", 1, Sys.Date())
  log_print(l1)

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})


test_that("logr11: log_hook works as expected when autolog is off.", {

  tmp <- base_path

  log_hook("Should not generate anything")

  lf <- log_open(file.path(tmp, "test.log"))


  log_print("Should show up in log")
  log_hook("Should not show up in log")


  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})


test_that("logr12: log_hook works as expected when autolog is on.", {

  tmp <- base_path

  log_hook("Should not generate anything")

  lf <- log_open(file.path(tmp, "test.log"), autolog = TRUE)


  log_print("Should show up in log")
  log_hook("Should also show up in log")


  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})



test_that("logr13: tidylog integration works as expected when autolog is on.", {

  library(dplyr)
  #library(tidylog, warn.conflicts = FALSE)

  # Connect tidylog to logr
  #options("tidylog.display" = list(log_quiet), "logr.notes" = TRUE)

  tmp <- base_path


  lf <- log_open(file.path(tmp, "test.log"), autolog = TRUE)


  log_print("Should show up in log")

  log_hook("Should also show up in log")

  dat <- select(mtcars, mpg, cyl, disp)
  dat <- filter(dat, mpg > 20)

  put(dat)

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)

  #writeLines(readLines(lf, encoding = "UTF-8"))

})


test_that("logr14: Logging of tibbles works as expected.", {

  library(dplyr)

  tmp <- base_path

  tbl <- as_tibble(mtcars)


  lf <- log_open(file.path(tmp, "test.log"), autolog = FALSE)

  sep("Here is a tibble")
  put(tbl)

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()


  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  lns <- readLines(lf, encoding = "UTF-8")
  print(lns)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})


test_that("logr15: log_print() function works as expected when log is closed", {


  log_print("Log closed message")


  expect_equal(TRUE, TRUE)


})

test_that("logr16: logr.on = FALSE work as expected.", {

    options("logr.on" = FALSE)

    tmp <- file.path(base_path, "/log/test.log")

    if (file.exists(tmp))
      file.remove(tmp)

    lf <- log_open(tmp)

    log_print("Hello")

    log_close()

    expect_equal(file.exists(lf), FALSE)

})

test_that("logr17: logr.on = TRUE works as expected.", {


  options("logr.on" = TRUE)

  tmp <- file.path(base_path, "test.log")


  if (file.exists(tmp))
    file.remove(tmp)

  lf <- log_open(tmp)

  log_print("Hello")

  log_close()

  expect_equal(file.exists(lf), TRUE)

})

test_that("logr18: logr.autolog = FALSE works as expected.", {

  library(dplyr)

  options("logr.autolog" = FALSE)

  tmp <- file.path(base_path, "/test.log")


  if (file.exists(tmp))
    file.remove(tmp)

  lf <- log_open(tmp)

  put("No tidy select here")

  dat <- select(mtcars, cyl = 8)

  log_close()


  expect_equal(file.exists(lf), TRUE)

  readLines(lf)


})


test_that("logr19: logr.autolog = TRUE works as expected.", {

  library(dplyr)

  options("logr.autolog" = TRUE)

  tmp <- file.path(base_path, "test.log")


  if (file.exists(tmp))
    file.remove(tmp)

  lf <- log_open(tmp)

  log_print("Tidy select here")

  dat <- select(mtcars, cyl = 8)

  log_close()


  expect_equal(file.exists(lf), TRUE)

  lns <- readLines(lf, encoding = "UTF-8")
  print(lns)

  options("logr.autolog" = FALSE)
})




test_that("logr20: Logging of Unicode characters prints correctly.", {

  print("First just test that anything works: 你好")

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test.log"), autolog = FALSE,
                 show_notes = FALSE)


  log_print("Here are some special chars â ã Ï Ó µ ¿ ‰")


  log_print("Here is some Russian Пояснения")

  log_print("Here is some Italian Attività")

  log_print("Here is some Chinese 你好")


  log_close()

  lns <- readLines(lf, encoding = "UTF-8")
  print(lns)

  expect_equal(file.exists(lf), TRUE)
})





test_that("logr21: Logging of Unicode dataframe prints correctly.", {

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test.log"), autolog = FALSE,
                 show_notes = FALSE)


  log_print("Here are some special chars â ã Ï Ó µ ¿ ‰")

  log_print("Here is a data frame with special characters:")

  df1 <- data.frame(E = c("â", "ã", "Ï", "Ó", "µ", "¿"),
                    R = c("П", "о", "я", "с", "н", "е"),
                    I = c("t", "i", "v", "i", "t", "à"),
                    C = c("你", "好", "再", "见", "家", "园"))

  log_print(df1)

  log_close()

  lns <- readLines(lf, encoding = "UTF-8")
  print(lns)

  expect_equal(file.exists(lf), TRUE)

})



test_that("logr22: clear_codes function works as expected.", {

  if (DEV) {

    tmp1 <- file.path(base_path, "log/test8.log")
    tmp2 <- file.path(base_path, "log/test9.log")

    file.copy(tmp1, tmp2)


    clear_codes(tmp1)


    expect_equal(file.exists(tmp1), TRUE)

    lns <- readLines(tmp1, encoding = "UTF-8")

    res <- grep("\x1B[90m", lns, fixed = TRUE)

    expect_equal(length(res), 0)


    file.remove(tmp1)
    file.copy(tmp2, tmp1)
    file.remove(tmp2)

  } else
    expect_equal(TRUE, TRUE)


})



test_that("logr23: default name works as expected.", {
  if (DEV) {



    lf <- log_open()


    put("Here is a log message")


    log_close()

    expect_equal(file.exists(lf), TRUE)


  } else
    expect_equal(TRUE, TRUE)

})



test_that("logr24: compact option works as expected.", {

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test11.log"), compact = TRUE)
  log_print("Here is the first log message")
  log_print(mtcars)
  log_print("Here is a second log message")

  log_close()

  ret <- file.exists(lf)

  expect_equal(ret, TRUE)

})

test_that("logr24: compact option works as expected.", {

  tmp <- base_path

  options("logr.compact" = TRUE)

  lf <- log_open(file.path(tmp, "test12.log"))
  log_print("Here is the first log message")
  log_print(mtcars)
  log_print("Here is a second log message")

  log_close()

  ret <- file.exists(lf)

  expect_equal(ret, TRUE)

})

test_that("logr26: traceback parameter works as expected.", {

  tmp <- base_path

  lf <- log_open(file.path(tmp, "test.log"), traceback = FALSE)
  log_print("Here is the first log message")
  expect_error(stop("here is a test error"))
  #stop("here is a test error")

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})

test_that("logr27: traceback option works as expected.", {

  tmp <- base_path

  options("logr.traceback" = FALSE)

  lf <- log_open(file.path(tmp, "test.log"), traceback = FALSE)
  log_print("Here is the first log message")
  expect_error(stop("here is a test error"))
  #stop("here is a test error")

  mp <- sub(".log", ".msg", lf, fixed = TRUE)
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)


})

test_that("logr28: can log a very long string.", {

tmp <- base_path

lf <- log_open(file.path(tmp, "test13.log"))
log_print("Here is the first log message")
log_print(mtcars)
log_print(paste("Here is a second log message that is really long",
                "it's going to get longer and longer and see if it will wrap",
                "but we're not done yet going to keep going and going",
                "like the energizer bunny. So let's go even further, and",
                "further, I say, just so we can see if the wrapping is",
                "working as expected."))


log_close()

ret <- file.exists(lf)

expect_equal(ret, TRUE)

})


test_that("logr29: Log directory is not appended if user specifies it.", {

  tmp <- base_path

  pth <- file.path(tmp, "log/test29.log")

  lf <- log_open(pth)
  log_print("Here is the first log message")



  log_close()

  ret <- file.exists(lf)

  expect_equal(lf, pth)



  pth <- file.path(tmp, "fork/test29.log")

  lf <- log_open(pth)
  log_print("Here is the first log message")



  log_close()

  ret <- file.exists(lf)

  exp <- file.path(dirname(pth), "log", basename(pth))

  expect_equal(lf, exp)


  pth <- file.path(tmp, "fork/test29.log")

  lf <- log_open(pth, logdir = FALSE)
  log_print("Here is the first log message")



  log_close()

  ret <- file.exists(lf)

  expect_equal(lf, pth)


})


test_that("logr30: Warnings are recorded on source.", {
  
  if (DEV) {
    tmp <- base_path
    
    lpth <- file.path(tmp, "/programs/log/srctest1.msg")
    
    if (file.exists(lpth)) {
      
      file.remove(lpth) 
    }
    
    
    pth <- file.path(tmp, "/programs/srctest1.R")
    
    e <- new.env()
    
    source(pth)
    
    
    expect_equal(file.exists(lpth), TRUE)
  
  } else {
    
    expect_equal(TRUE, TRUE) 
    
  }
  
})

test_that("logr31: Errors are recorded on source.", {
  
  if (DEV) {
    tmp <- base_path
    
    lpth <- file.path(tmp, "/programs/log/srctest2.msg")
    
    if (file.exists(lpth)) {
      
      file.remove(lpth) 
    }
    
    
    pth <- file.path(tmp, "/programs/srctest2.R")
    
    e <- new.env()
    
    source(pth)
    
    
    expect_equal(file.exists(lpth), TRUE)
    
  } else {
    
    expect_equal(TRUE, TRUE) 
    
  }
  
})



test_that("logr32: Warnings are recorded on source.all().", {
  
  if (DEV) {
    tmp <- base_path
    
    lpth <- file.path(tmp, "/programs/log/srctest1.msg")
    
    if (file.exists(lpth)) {
      
      file.remove(lpth) 
    }
    
    
    pth <- file.path(tmp, "/programs")
    
    
    source.all(pth, isolate = TRUE, pattern = "srctest1")
    
    
    expect_equal(file.exists(lpth), TRUE)
    
  } else {
    
    expect_equal(TRUE, TRUE) 
    
  }
  
})


test_that("logr33: Errors are recorded on source.all().", {
  
  if (DEV) {
    tmp <- base_path
    
    lpth <- file.path(tmp, "/programs/log/srctest2.msg")
    
    if (file.exists(lpth)) {
      
      file.remove(lpth) 
    }
    
    
    pth <- file.path(tmp, "/programs")
  
    
    source.all(pth, isolate = TRUE, pattern = "srctest2")
    
    
    expect_equal(file.exists(lpth), TRUE)
    
  } else {
    
    expect_equal(TRUE, TRUE) 
    
  }
  
})


test_that("logr34: header and footer options work as expected.", {
  
  tmp <- base_path
  
  lf <- log_open(file.path(tmp, "test35.log"), header = FALSE)
  log_print("Here is the first log message")
  log_print(mtcars)
  
  
  
  log_close(footer = FALSE)
  
  ret <- file.exists(lf)
  
  expect_equal(ret, TRUE)
  
})




test_that("logr35: suspend and resume functions works as expected.", {
  
  
  tmp <- base_path
  
  lf <- log_open(file.path(tmp, "test35.log"))
  log_print("Before suspend")
  
  
  log_suspend()
  
  
  log_print("During suspend")
  
  log_resume(lf)
  
  log_print("After suspend")
  
  log_close()
  
  ret <- file.exists(lf)
  
  expect_equal(ret, TRUE)
  
})


test_that("logr36: get_warnings() function works as expected.", {
  
  tmp <- base_path
  
  lp <- log_open(file.path(tmp, "test36.log"))
  
  log_print("Message 1")
  log_warning("Warning 1")
  log_print("Message 2")
  
  if (DEV) {
    warning("Warning 2")
  }
  
  log_close()
  
  mfl <- file.path(tmp, "./log/test36.msg")
  
  
  expect_equal(file.exists(lp), TRUE)
  expect_equal(file.exists(mfl), TRUE)
  
  res <- get_warnings()
  
  res
  
  expect_equal(length(res) > 0, TRUE)
  expect_equal(res[1], "Warning: Warning 1")
  
  if (DEV) {
    expect_equal(res[2], "Warning: Warning 2")
  }
  
  res2 <- getOption("logr.warnings")
  
  
  if (DEV) {
    expect_equal(length(res2), 2)
  } else {
    expect_equal(length(res2), 1) 
  }

})



# Should print error message to console.  
test_that("logr37: Invalid file path is trapped in log_open.", {
  
  if (DEV) {

  res1 <- log_open(" ")

  tmp <- paste0("C:/PROGRA~1/R/R-43~1.2/bin/x64/Rterm.exe --no-save --no-restore ",
                "-s -e \nattach(NULL, name = 'tools:rstudio');\nsys.source(",
                "'C:/Program Files/RStudio/resources/app/R/modules/SourceWithProgress.R', ",
                "envir = as.environment('tools:rstudio'));\n.rs.sourceWithProgress(\n   ",
                "script = 'C:/Studies/Study1/test3.R',\n   encoding = 'UTF-8',\n   ",
                "con = stdout(),\n   importRdata = NULL,\n   exportRdata = NULL\n)")
  
  
  expect_error(log_open(tmp))
  
  } else {
    
    expect_equal(TRUE, TRUE)
  } 
  

  #expect_equal(TRUE, TRUE)
  
})



test_that("logr38: log_warnings() accepts a null.", {
  
  tmp <- base_path
  
  lp <- log_open(file.path(tmp, "test38.log"))
  
  log_print("Message 1")
  log_warning("test me")
  log_warning(NULL)
  
  log_close()
  
  
  res <- get_warnings()
  
  expect_equal(length(res) == 1, TRUE)
  
})

test_that("logr39: logr.stdout option works as expected.", {
  
  tmp <- base_path
  
  options("logr.stdout" = TRUE)
  
  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  log_print(mtcars)
  log_print("Here is a second log message")
  
  mp <- sub(".log", ".msg", lf, fixed = TRUE) 
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, FALSE)
  expect_equal(ret2, FALSE)
  
  options("logr.stdout" = NULL)
  
})


test_that("logr40: logr.stdout parameter works as expected.", {
  
  tmp <- base_path
  

  lf <- log_open(file.path(tmp, "test.log"), stdout = TRUE)
  log_print("Here is the first log message")
  log_print(mtcars)
  log_print("Here is a second log message")
  
  mp <- sub(".log", ".msg", lf, fixed = TRUE) 
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, FALSE)
  expect_equal(ret2, FALSE)
  

})



