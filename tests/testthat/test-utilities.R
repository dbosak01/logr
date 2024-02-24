context("utlities tests")

base_path <- "c:\\packages\\logr\\tests\\testthat"

base_path <- tempdir()


test_that("get_package_versions() works as expected.", {
  
  res <- get_base_package_versions()
  
  res
  
  expect_equal(length(res), 1)
  
  res <- get_other_package_versions()
  
  res
  
  expect_equal(length(res), 1)
  
  
})
