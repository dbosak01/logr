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

# On 30.06.2020 08:59, CRAN submission wrote:

Dear maintainer,
 
package logr_1.0.2.tar.gz does not pass the incoming checks automatically, please see the following pre-tests:
Windows: <https://win-builder.r-project.org/incoming_pretest/logr_1.0.2_20200630_144543/Windows/00check.log>
Status: 2 ERRORs, 2 NOTEs
Debian: <https://win-builder.r-project.org/incoming_pretest/logr_1.0.2_20200630_144543/Debian/00check.log>
Status: 1 NOTE
 

 
Please fix all problems and resubmit a fixed version via the webform.
If you are not sure how to fix the problems shown, please ask for help on the R-package-devel mailing list:
<https://stat.ethz.ch/mailman/listinfo/r-package-devel>
If you are fairly certain the rejection is a false positive, please reply-all to this message and explain.
 
More details are given in the directory:
<https://win-builder.r-project.org/incoming_pretest/logr_1.0.2_20200630_144543/>
The files will be removed after roughly 7 days.
 
No strong reverse dependencies to be checked.
 
Best regards,
CRAN teams' auto-check service


### Excerpt from Log:

 running tests for arch 'i386' ... [3s] ERROR
  Running 'testthat.R' [1s]
Running the tests in 'tests/testthat.R' failed.
Complete output:
  \> library(testthat)
  Error in library(testthat) : there is no package called 'testthat'
  Execution halted
 running tests for arch 'x64' ... [1s] ERROR
  Running 'testthat.R' [1s]
Running the tests in 'tests/testthat.R' failed.
Complete output:
  \> library(testthat)
  Error in library(testthat) : there is no package called 'testthat'
  Execution halted
  
  
