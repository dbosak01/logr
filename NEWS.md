# logr 1.2.9

* Added `traceback()` message when program errors.
* Added variable name to put statements.


# logr 1.2.8

* Fixed bug in elapsed time in log footer.

# logr 1.2.7

* Use current script path and name for log file name if not supplied by user.
* Added attached base packages and other packages to log header.
* Added FAQ page to documentation site.
* Added Complete Example vignette.

# logr 1.2.6

* Added covr and codecov
* Removed extraneous color codes from log by adding stripping function 
to `log_close()`.
* Added program path to log header.  Can now get this using `this.path()`.
* Added `log_code()` function to dump code to the log.

# logr 1.2.5

* Added `log_path()` function to return the path to the log.
* Added `log_status()` function to return the status of the log.
* Added support for Unicode characters on Windows.

# logr 1.2.4

* Added github action checks for 4 previous versions of R.

# logr 1.2.3

* Fixed printing of crayon color codes into log.

# logr 1.2.1

* Incorporated tidylog directly into the logr package. Can be turned on
using the 'autolog' parameter of `log_open()`, or by setting the global
option 'logr.autolog'.  
* Added `log_hook()` function to allow other packages to call into logr. 
* Added pkgdown site.

# logr 1.1.1

* Added NEWS file.

# logr 1.1.0

* Added `put()` function as an alias to `log_print()`.
* Added `sep()` function to create a log separator.  This make the log better
organized and easier to read
* Fixed bug to clear any existing errors/warnings on log_open

# logr 1.0.5

* Fixed bug when printing tibbles to the log.

# logr 1.0.4

* Fixed bug when printing objects with multiple classes.


# logr 1.0.3

* Added `log_open()` function to open the log.
* Added `log_print()` function to print to the log.
* Added `log_close()` function to print to the log.
