context("utilities tests")

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


test_that("utils-04: path_valid() works as expected.", {
  
 # if (DEV) {
    lp <- file.path(base_path, "log/testme.log")
    
    
    res <- path_valid(lp)
    
    
    res
    
    expect_equal(res, TRUE)
    
    
    lp2 <- file.path(base_path, "log/more/testme.log")
    
  
    res2 <- path_valid(lp2)
    
    res2
    
    expect_equal(res2, FALSE)
    
    
    lp3 <- ""
    
    res3 <- path_valid(lp3)
    
    res3
    
    expect_equal(res3, FALSE)
    
    # lp4 <- file.path(base_path, "log/t!&e#s't~<>m%e.log")
    # 
    # 
    # res4 <- path_valid(lp4)
    # 
    # res4
    # 
    # expect_equal(res4, FALSE)
    
    # lp5 <- " "
    # 
    # res5 <- path_valid(lp5)
    # 
    # res5
    # 
    # expect_equal(res5, FALSE)
    

    # lp6 <- "./log/ .log"
    # 
    # res6 <- path_valid(lp6)
    # 
    # res6
    # 
    # expect_equal(res6, FALSE)
  
  # } else {
  # 
  #   expect_equal(TRUE, TRUE)
  # }
  
})



