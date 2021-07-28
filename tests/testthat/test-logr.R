context("logr tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()


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



test_that("Logging of Unicode characters prints correctly.", {

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


# # Works
# test_that("Special characters work properly.", {
#   
#   file_path <- file.path(base_path, "log\\test1.log")
#   
#   v1 <- c("Here are some special characters â ã Ï Ó µ ¿ ‰", 
#           "Here is some Russian Пояснения",
#           "Here is some Italian Attività",
#           "Here is some Chinese 你好")
#   
#   f <- file(file_path, open = "w", encoding = "native.enc")
# 
#   
#   writeLines(enc2utf8(v1), con = f, useBytes = TRUE)
#   
#   
#   # sink(f, append = TRUE)
#   # 
#   # print(enc2utf8(" â ã Ï Ó µ ¿ ‰"))
#   # 
#   # sink()
#   
#   close(f)
#   
#   
# })
# 
# # Works, but no special characters
# test_that("Special characters work properly.", {
#   
#   file_path <- file.path(base_path, "log\\test2.log")
#   
#   
#   res <- utils::capture.output(print(mtcars), file = NULL)
#   
#   
#   f <- file(file_path, open = "w", encoding = "native.enc")
#   
#   
#   writeLines(enc2utf8(res), con = f, useBytes = TRUE)
#   
#   
#   # sink(f, append = TRUE)
#   # 
#   # print(enc2utf8(" â ã Ï Ó µ ¿ ‰"))
#   # 
#   # sink()
#   
#   close(f)
#   
#   
# })
# 
# 
# # Doesn't work 
# test_that("Special characters work properly.", {
#   
#   file_path <- file.path(base_path, "log\\test3.log")
#   
#   
#   v1 <- c("Here are some special characters â ã Ï Ó µ ¿ ‰", 
#           "Here is some Russian Пояснения",
#           "Here is some Italian Attività",
#           "Here is some Chinese 你好")
#   
#   v2 <- enc2utf8(v1)
#   
#   res <- utils::capture.output(print(v2), file = NULL)
#   
#   
#   f <- file(file_path, open = "w", encoding = "native.enc")
#   
#   
#   writeLines(res, con = f, useBytes = TRUE)
#   
#   
#   # sink(f, append = TRUE)
#   # 
#   # print(enc2utf8(" â ã Ï Ó µ ¿ ‰"))
#   # 
#   # sink()
#   
#   close(f)
#   
#   
# })
# 
# 
# 
# 
# test_that("Special characters work properly with sink.", {
#   
#   file_path <- file.path(base_path, "log\\test4.log")
#   
#   v1 <- c("Here are some special characters â ã Ï Ó µ ¿ ‰", 
#           "Here is some Russian Пояснения",
#           "Here is some Italian Attività",
#           "Here is some Chinese 你好")
#   
#   v2 <- enc2utf8(v1)
#   
#   f <- file(file_path, open = "w", encoding = "UTF-8")
#   
#   
#   sink(f)
#   
#   
#   print(v2)
#   
#   # sink(f, append = TRUE)
#   # 
#   # print(enc2utf8(" â ã Ï Ó µ ¿ ‰"))
#   # 
#   # sink()
#   
#   sink()
#   
#   close(f)
#   
#   
# })
# 
# test_that("Special characters work as expected.", {
#   
#   file_path <- file.path(base_path, "log\\test5.log")
#   
#   
#   v1 <- c("Here are some special characters â ã Ï Ó µ ¿ ‰", 
#           "Here is some Russian Пояснения",
#           "Here is some Italian Attività",
#           "Here is some Chinese 你好")
#   
#   df1 <- data.frame(E = c("â", "ã", "Ï", "Ó", "µ", "¿"),
#                     R = c("П", "о", "я", "с", "н", "е"),
#                     I = c("t", "i", "v", "i", "t", "à"), 
#                     C = c("你", "好", "再", "见", "家", "园"))
#                     
#   res1 <- enc2utf8(v1)
#   
#   as.character(df1)
#   
#   
#   res2 <- utils::capture.output(cat(df1[1, "C"]), file = NULL)
#   
#   res2 <- encodeString(df1[1, "C"])
#   
#   res3 <- charToRaw(res2)
#   
#   f <- file(file_path, open = "wt", encoding = "native.enc")
#   
#   
#   writeLines(res1, con = f, useBytes = TRUE)
#   writeLines(res2, con = f, useBytes = TRUE)
#   writeLines(res3, con = f, useBytes = TRUE)
#   
#   
#   
#   close(f)
#   
#   con <- file(file_path, open = "wt", encoding = "native.enc")
#   
#  # con <- rawConnection(file_path, open = "w")
#   sink(con)
#   
#   # cat(res1)
#   #res2
#   print.default(res2)
#   #cat(res3)
#   # cat(res1)
#   # cat(res2)
#   sink()
#   close(con)
# 
#   
#   sm <- Sys.getlocale()
#   
#   Sys.setlocale(category = "LC_ALL", locale = "UTF-8")
#   
#   l10n_info()
#   
#   Sys.getlocale()
# })

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






