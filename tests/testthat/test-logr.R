context("logr tests")

test_that("the log_open function handles invalid parameters.", {
  

  nm <- log_open(logfolder = TRUE)
  log_print("Here is the first log message")
  log_print("Here is a second log message")
  log_close()
  
  lf <- "./log/script.log"
  
  ret <- file.exists(lf)
  
  expect_equal(nm, lf)
  expect_equal(TRUE, ret)
  
  if (ret)
    file.remove(lf)
  
  if (dir.exists("log")) {
    unlink("log", force = TRUE, recursive = TRUE)
  }
  
})

test_that("the log_print function handles invalid parameters.", {
  
  
  lp <- log_open(logfolder = TRUE)
  log_print("Here is the first log message")
  log_print("Here is a second log message")
  log_close()
  
  lf <- "./log/script.log"
  
  ret <- file.exists(lf)
  
  expect_equal(basename(lp), basename(lf))
  expect_equal(TRUE, ret)
  
  if (ret)
    file.remove(lf)
  
  if (dir.exists("log")) {
    unlink("log", force = TRUE, recursive = TRUE)
  }
  
})



test_that("the logr package can create a log with no errors or warnings.", {
  
  
  lf <- log_open("test.log", logfolder = TRUE)
  log_print("Here is the first log message")
  log_print(mtcars)
  log_print("Here is a second log message")
  
  mp <- Sys.getenv("msg_path")
  log_close()
  
  ret <- file.exists(lf)
  ret2 <- file.exists(mp)
  
  expect_equal(ret, TRUE)
  expect_equal(ret2, FALSE)
  
  # clean up
  if (ret) {
    file.remove(lf)
  }
  if (ret2) {
    file.remove(mp)
  }
  if (dir.exists("log")) {
    unlink("log", force = TRUE, recursive = TRUE)
  }
  
})

# Not sure how to intentionally generate an error, trap it with the logger, 
# and yet not crash the check.
test_that("the logr package can create a log with errors and warnings.", {


  lf <- log_open("test.log", logfolder = TRUE)
  log_print("Here is the first log message")
  log_print(mtcars)
  warning("Test warning")
  generror
  log_print("Here is a second log message")
  mp <- Sys.getenv("msg_path")
  log_close()

  ret <- file.exists(lf)
  ret2 <- file.exists(mp)

  expect_equal(ret, TRUE)
  expect_equal(ret2, TRUE)

  # clean up
  if (ret) {
    file.remove(lf)
  }
  if (ret2) {
    file.remove(mp)
  }
  if (dir.exists("log")) {
    unlink("log", force = TRUE, recursive = TRUE)
  }

})






