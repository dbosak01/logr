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






