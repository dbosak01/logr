context("logr tests")

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

  tmp <- tempdir()
  
  tbl <- as_tibble(mtcars)
  
  
  lf <- log_open(file.path(tmp, "test.log"), autolog = FALSE)
  
  
  put(tbl)
      
  mp <- e$msg_path
  log_close()
  
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  
})


# Not sure how to generate an error and not cause the test to fail.
# Commented out for now.
# test_that("the logr package can create a log with errors and warnings.", {
# 
# 
#   lf <- log_open("test.log")
#   log_print("Here is the first log message")
#   log_print(mtcars)
#   warning("Test warning")
#   generror
#   log_print("Here is a second log message")
#   mp <- e$msg_path
#   log_close()
# 
#   ret <- file.exists(lf)
#   ret2 <- file.exists(mp)
# 
#   expect_equal(ret, TRUE)
#   expect_equal(ret2, TRUE)
# 
#   # clean up
#   if (ret) {
#     file.remove(lf)
#   }
#   if (ret2) {
#     file.remove(mp)
#   }
#   if (dir.exists("log")) {
#     unlink("log", force = TRUE, recursive = TRUE)
#   }
# 
# })






