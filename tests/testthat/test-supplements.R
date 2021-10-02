context("Supplements tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()

DEV <- FALSE


test_that("log_code() function works as expected.", {
  
  
  tmp <- base_path
  
  lf <- log_open(file.path(tmp, "test10.log"))
  
  log_code()
  
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


test_that("log_path() function works as expected.", {
  
  
  tmp <- base_path
  
  lf <- log_open(file.path(tmp, "test10.log"))
  

  res <- log_path()
  
  expect_equal(file.exists(res), TRUE)
  
  mp <- e$msg_path
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
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
