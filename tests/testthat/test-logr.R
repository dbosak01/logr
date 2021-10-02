context("logr tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()

DEV <- FALSE

test_that("the log_open function handles invalid parameters.", {
  
  tmp <- tempdir()
  
  nm <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  log_print("Here is a second log message")
  log_close()
  
  lf <- file.path(gsub("\\", "/", tmp, fixed = TRUE), "log/test.log")
  
  ret <- file.exists(lf)
  
  expect_equal(nm, lf)
  expect_equal(TRUE, ret)
  
  
})

test_that("the log_print function handles invalid parameters.", {
  
  tmp <- tempdir()
  
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



test_that("the logr package can create a log with no errors or warnings.", {
  
  tmp <- tempdir()
  
  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  log_print(mtcars)
  log_print("Here is a second log message")
  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})



test_that("the logr package can create a log with warnings.", {
  
  tmp <- tempdir()
  
  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  expect_warning(warning("here is a test warning"))

  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})


test_that("logr.notes = FALSE works as expected.", {
  
  tmp <- tempdir()
  
 options("logr.notes" = FALSE)

  
  lf <- log_open(file.path(tmp, "test.log"))
  log_print("No notes in this log.")

  

  log_close()
  
  ret <- file.exists(lf)
  
  expect_equal(ret, TRUE)

  
  readLines(lf)
  
  options("logr.notes" = TRUE)
  
})


test_that("logr.notes = TRUE works as expected.", {
  
  tmp <- tempdir()
  
  options("logr.notes" = TRUE)
  
  
  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Notes in this log.")
  
  
  
  log_close()
  
  ret <- file.exists(lf)
  
  expect_equal(ret, TRUE)
  
  
  readLines(lf)
  
  
})



test_that("the logr package can create a log with error", {
  
  tmp <- tempdir()
  
  lf <- log_open(file.path(tmp, "test.log"))
  log_print("Here is the first log message")
  expect_error(stop("here is a test warning"))
  
  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})


test_that("the logr package can log vectors, factors, and lists with no errors or warnings.", {
  
  tmp <- tempdir()
  
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
  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})


test_that("log_hook works as expected when autolog is off.", {
  
  tmp <- tempdir()
  
  log_hook("Should not generate anything")
  
  lf <- log_open(file.path(tmp, "test.log"))
  
  
  log_print("Should show up in log")
  log_hook("Should not show up in log")

  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})


test_that("log_hook works as expected when autolog is on.", {
  
  tmp <- tempdir()
  
  log_hook("Should not generate anything")
  
  lf <- log_open(file.path(tmp, "test.log"), autolog = TRUE)
  
  
  log_print("Should show up in log")
  log_hook("Should also show up in log")
  
  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})



test_that("tidylog integration works as expected when autolog is on.", {
  
  library(dplyr)
  #library(tidylog, warn.conflicts = FALSE)
  
  # Connect tidylog to logr
  #options("tidylog.display" = list(log_quiet), "logr.notes" = TRUE)
  
  tmp <- tempdir()

  
  lf <- log_open(file.path(tmp, "test.log"), autolog = TRUE)
  
  
  log_print("Should show up in log")
  
  log_hook("Should also show up in log")
  
  dat <- select(mtcars, mpg, cyl, disp) 
  dat <- filter(dat, mpg > 20)
  
  put(dat)
  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  #writeLines(readLines(lf, encoding = "UTF-8"))
  
})


test_that("Logging of tibbles works as expected.", {
  
  library(dplyr)

  tmp <- base_path
  
  tbl <- as_tibble(mtcars)
  
  
  lf <- log_open(file.path(tmp, "test.log"), autolog = FALSE)
  
  sep("Here is a tibble")
  put(tbl)
      
  mp <- e$msg_path
  log_close()
  
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  lns <- readLines(lf, encoding = "UTF-8")
  print(lns)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})

test_that("log_path() function works as expected", {
  
  tmp <- file.path(tempdir(), "test.log")
  
  lf <- log_open(tmp)
  
  lp <- log_path()
  
  log_close()
  
  
  expect_equal(lp, lf)
  expect_equal(is.null(log_path()), TRUE)
  
})


test_that("log_print() function works as expected when log is closed", {
  

  log_print("Log closed message")
  
  
  expect_equal(TRUE, TRUE)

  
})


test_that("log_status() function works as expected", {
  
  
  options("logr.on" = FALSE)
  
  expect_equal(log_status(), "off")
  
  options("logr.on" = TRUE)
  
  expect_equal(log_status(), "on")
  
  
  tmp <- file.path(tempdir(), "test.log")
  
  lf <- log_open(tmp)
  
  expect_equal(log_status(), "open")
  

  log_close()
  
  expect_equal(log_status(), "closed")
  
  
})

test_that("logr.on = FALSE work as expected.", {

    options("logr.on" = FALSE)
  
    tmp <- file.path(tempdir(), "/log/test.log")
    
    if (file.exists(tmp))
      file.remove(tmp)
    
    lf <- log_open(tmp)
    
    log_print("Hello")
    
    log_close()
    
    
    expect_equal(file.exists(lf), FALSE)

    
    
})

test_that("logr.on = TRUE works as expected.", {
  
  
  options("logr.on" = TRUE)
  
  tmp <- file.path(tempdir(), "test.log")
  
  
  if (file.exists(tmp))
    file.remove(tmp)
  
  lf <- log_open(tmp)
  
  log_print("Hello")
  
  log_close()
  
  
  expect_equal(file.exists(lf), TRUE)
})

test_that("logr.autolog = FALSE works as expected.", {
  
  library(dplyr)
  
  options("logr.autolog" = FALSE)
  
  tmp <- file.path(tempdir(), "/test.log")
  
  
  if (file.exists(tmp))
    file.remove(tmp)
  
  lf <- log_open(tmp)
  
  put("No tidy select here")
  
  dat <- select(mtcars, cyl = 8)
  
  log_close()
  
  
  expect_equal(file.exists(lf), TRUE)
  
  readLines(lf)

  
})


test_that("logr.autolog = TRUE works as expected.", {

  library(dplyr)

  options("logr.autolog" = TRUE)

  tmp <- file.path(tempdir(), "test.log")


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




test_that("Logging of Unicode characters prints correctly.", {

  print("First just test that anything works: 你好")

  tmp <- tempdir()

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





test_that("Logging of Unicode dataframe prints correctly.", {
  
  tmp <- tempdir()
  
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



test_that("clear_codes function works as expected.", {
  
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





