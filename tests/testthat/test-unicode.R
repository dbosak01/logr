context("unicode tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()


test_that("the print_windows() function works as expected.", {

  pth <- file.path(base_path, "log/test6.log")

  if (file.exists(pth))
    file.remove(pth)

  lg <- log_open(pth)

  print_windows("Hello", pth, blank_after = TRUE, hide_notes = FALSE)
  print_windows(c("Hello 你好", "再见 goodbye"), pth,
                blank_after = TRUE, hide_notes = FALSE)
  print_windows(mtcars, pth, blank_after = TRUE, hide_notes = FALSE)


  log_close()

  ret <- file.exists(pth)

  expect_true(ret)



})



test_that("the print_other() function works as expected.", {

  pth <- file.path(base_path, "log/test7.log")

  if (file.exists(pth))
    file.remove(pth)

  lg <- log_open(pth)

  print_other("Hello", pth, blank_after = TRUE, hide_notes = FALSE)
  print_other(c("Hello 你好", "再见 goodbye"), pth,
                blank_after = TRUE, hide_notes = FALSE)
  print_other(mtcars, pth, blank_after = TRUE, hide_notes = FALSE)

  log_close()

  ret <- file.exists(pth)

  expect_true(ret)



})

test_that("get_unicode() works as expected.", {
  
  v <- c("Hello 你好", "再见 goodbye", "Hello", "再见", "Hello 再见 goodbye")
  
  v2 <- enc2native(v)
  
  res <- get_unicode(v2)
  
  expect_equal(v, res)
  
  
})
