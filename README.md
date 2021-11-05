<!-- badges: start -->

[![logr version](https://www.r-pkg.org/badges/version/logr)](https://cran.r-project.org/package=logr)
[![logr lifecycle](https://img.shields.io/badge/lifecycle-stable-blue.svg)](https://cran.r-project.org/package=logr)
[![logr downloads](https://cranlogs.r-pkg.org/badges/logr)](https://cran.r-project.org/package=logr)
[![logr total downloads](https://cranlogs.r-pkg.org/badges/grand-total/logr)](https://cran.r-project.org/package=logr)
[![R-CMD-check](https://github.com/dbosak01/logr/workflows/R-CMD-check/badge.svg)](https://github.com/dbosak01/logr/actions)
[![Codecov test coverage](https://codecov.io/gh/dbosak01/logr/branch/master/graph/badge.svg)](https://codecov.io/gh/dbosak01/logr?branch=master)

<!-- badges: end -->

# Introduction to **logr**
<img src='man/images/logr2.png' align="left" height="138" style="margin-right:10px"/>

There are already several logging packages for R.  Why create another one? 

Because the other logging packages all have something in common: they were built
for *R package developers*.  

What is different about the **logr** package is
that it is built for *normal R users*: statisticians, analysts, researchers, 
students, teachers, business people, etc.

The **logr** package is for those people who just need a written record of their
program execution.  It is designed to be as simple as possible, yet still
produce a useful and complete log.  

There are only three steps to creating a **logr** log:

1. Open the log
2. Print to the log
3. Close the log

Now this a logging system that anyone can use!  


### Installation

The easiest way to install the **logr** package is to run the following 
command from your R console:

    install.packages("logr")


Then put the following line at the top of your script:

    library(logr)
    
For examples and usage 
information, please visit the **logr** documentation site 
[here](https://logr.r-sassy.org/articles/logr.html)

### Getting Help

If you need help, the first place 
to turn to is the [logr](https://logr.r-sassy.org) web site.  

If you want to look at the code for the **logr** package, visit the
github page [here](https://github.com/dbosak01/logr).

If you encounter a bug or have a feature request, please submit an issue 
[here](https://github.com/dbosak01/logr/issues). 


### See Also

The **logr** package is part of the **sassy** meta-package. 
The **sassy** meta-package includes several packages that help make R
easier for SAS® programmers.  You can read more about the **sassy** package
[here](https://sassy.r-sassy.org).
