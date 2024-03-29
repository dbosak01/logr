% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/supplements.R
\name{log_status}
\alias{log_status}
\title{Get the status of the log}
\usage{
log_status()
}
\value{
The status of the log as a character string.
}
\description{
The \code{log_status} function gets the status of the
log.  Possible status values are 'on', 'off', 'open', or 'closed'.
The function takes no parameters.
}
\examples{
# Check status before the log is opened
log_status()
# [1] "closed"

# Create temp file location
tmp <- file.path(tempdir(), "test.log")

# Open log
lf <- log_open(tmp)

# Check status after log is opened
log_status()
# [1] "open"

# Close log
log_close()
}
