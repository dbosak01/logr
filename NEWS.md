# logr 1.3.9

* Fixed bug on creating path for message file.
* Added "stdout" option to send log output to the console
instead of a file.
* Added `log_info()` function to send an informational message
to the log.
* Added vignette to explain **logr** integration with custom packages.
* Added option to control the line size on the log output.

# logr 1.3.8

* Fixed issue with recursive warnings.
* Fixed error caused by NULL warnings and 0 frame count.

# logr 1.3.7

* Ensure that error and warning handlers are disconnected if log is closed.
* Added options to not print header and footer if desired.  
* Added `log_suspend()` and `log_resume()` functions.
* Added `log_error()` and `log_warning()` functions.
* Added `get_warnings()` function.

# logr 1.3.6

* Fixed warnings. They are now printing as expected.
* Added line feed before other packages in log header.

# logr 1.3.5

* Fixed issue with UTF-8 characters in `log_code()` function.
* Removed code to strip color codes inserted by crayon package.

# logr 1.3.4

* Changed reference from this.path() to Sys.path() to avoid breaking changes
in this.path package.

# logr 1.3.3

* Fixed bug when passing full path and logdir parameter was TRUE. 
* Updated logo.

# logr 1.3.2

* Added option to turn off traceback if desired.
* Added `log_close()` to error handling function so that the log will
now close when an error is encountered.
* Fixed bug which gave an error on some operating systems when clearing warnings.

# logr 1.3.1
* Added compact option to log_open to remove unnecessary blank lines.  Also
added global option "logr.compact" for same functionality.

# logr 1.3.0

* Fixed bug in elapsed time in notes.

# logr 1.2.9

* Added `traceback()` message when program errors.

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
