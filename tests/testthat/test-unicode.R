context("unicode tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()


test_that("uni-02: The print_windows() function works as expected.", {

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



test_that("uni-02: The print_other() function works as expected.", {

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

test_that("uni-03: Get_unicode() works as expected.", {
  
  v <- c("Hello 你好", "再见 goodbye", "Hello", "再见", "Hello 再见 goodbye")
  
  v2 <- enc2native(v)
  
  res <- get_unicode(v2)
  
  expect_equal(v, res)
  
  
})

# Should only print warning message to console.  
test_that("uni-04: Invalid file path is trapped in log_print.", {
  if (DEV) {
  
  tmp <- paste0("C:/PROGRA~1/R/R-43~1.2/bin/x64/Rterm.exe --no-save --no-restore ",
                "-s -e \nattach(NULL, name = 'tools:rstudio');\nsys.source(",
                "'C:/Program Files/RStudio/resources/app/R/modules/SourceWithProgress.R', ",
                "envir = as.environment('tools:rstudio'));\n.rs.sourceWithProgress(\n   ",
                "script = 'C:/Studies/Study1/test3.R',\n   encoding = 'UTF-8',\n   ",
                "con = stdout(),\n   importRdata = NULL,\n   exportRdata = NULL\n)")
  
  expect_warning(print_windows("test message", "", TRUE, FALSE))
  
  expect_warning(print_windows("test message", tmp, TRUE, FALSE))
  
  expect_warning(print_other("test message", "", TRUE, FALSE))
  
  expect_warning(print_other("test message", tmp, TRUE, FALSE))
  
  } else {
    
    
    expect_equal(TRUE, TRUE)
  }
  
})
