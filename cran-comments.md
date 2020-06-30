# On 30.06.2020 06:51, CRAN submission wrote:

Thanks, please do not start your Description with "This package", 
package name or similar.

Please add '()' behind all function names (e.g. log_print() without 
quotation marks) in your Description text.

Please replace \dontrun{} by \donttest{} or unwap the examples if they 
can be executed in less than 5 sec per Rd-file.

Please ensure that your functions do not modify (save or delete) the 
user's home filespace in your examples/vignettes/tests. That is not 
allow by CRAN policies. Please only write/save files if the user has 
specified a directory. In your examples/vignettes/tests you can write to 
tempdir(). I.e.

log_open(file.path(tempdir(), "test.log"))
