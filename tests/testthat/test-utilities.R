context("utlities tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()

DEV <- FALSE

test_that("utils-01: get_package_versions() works as expected.", {
  
  res <- get_base_package_versions()
  
  res
  
  expect_equal(length(res), 1)
  
  res <- get_other_package_versions()
  
  res
  
  expect_equal(length(res), 1)
  
  
})


test_that("utils-02: read_suspended_log() works as expected.", {
  
  if (DEV) {
  
    pth <- file.path(base_path, "./log/resumeTest.log")
   
    res <- read_suspended_log(pth)
    
    res
    
    expect_equal(length(res) > 0, TRUE)
    expect_equal(res$StartPos, 20)
    expect_equal(res$Autolog, "FALSE")
  
  } else {
    
    expect_equal(TRUE, TRUE) 
  }
  
})

test_that("utils-03: print_resume_header() works as expected.", {
  
  if (DEV) {
  
    pth <- file.path(base_path, "./log/resumeTest.log")
    
    npth <- file.path(base_path, "./log/headerTest.log")
    
    if (file.exists(npth))
      file.remove(npth)
    
    file.copy(pth, npth)
    
    res <- read_suspended_log(npth)
    
    res
    
    res2 <- print_resume_header(npth, res$StartPos,  res$`Suspend Time`)
    
    expect_equal(length(res2) > 0, TRUE)
  
  } else {
    
    expect_equal(TRUE, TRUE) 
  }

  
})


