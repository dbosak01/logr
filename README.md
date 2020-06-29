# logr <img src='man/images/logr.svg' align="right" height="138" />
The **logr** package helps create log files for R scripts.  The package 
provides easy logging, without the complexity of other logging systems.  It is 
designed for analysts who simply want a written log of the their program 
execution.  The package is designed as a wrapper to 
the base R `sink` function.

## How to use
There are only three **logr** functions:  
  * `log_open()`
  * `log_print()`
  * `log_close()`  

The `log_open()` function initiates the log.  The 
`log_print()` function prints an object to the log.  The `log_close()` function
closes the log.  In normal situations, a user would place the call to 
`log_open()` at the top of the program, call `log_print()` as needed in the 
program body, and call `log_close()` once at the end of the program.

A sample program is as follows:
```
# Open the log
log_open("test.log")

# Print a text string
log_print("Here is the first log message")

# Other code as needed ...
Sys.sleep(1)

# Print a data frame
log_print(mtcars)

# More code ...

# Generate an error
generror

# Close the log
log_close()

```

## What to print to the log
You can print to the log anything that you can print to the console: vectors,
lists, and data frames are all valid objects for logging.  Under the hood, 
**logr** calls the `print()` function on that object, and writes the results 
to the log. The `log_print()` function, by default, will also print the 
object to the console. That means you can replace calls to `print()` with 
`log_print()`, and there will be no loss of convenience during development.

## What the log looks like
The log created by **logr** is simpler than most logging packages.  This 
log is designed to be human-readable and increases the traceability of your
activities.  There are three main enhancements to a **logr** log:
  * A log header
  * Notes
  * A log footer

Here is an example log, created by the sample program above:
```
========================================================================= 
Log Path: ./log/test.log 
Working Directory: C:/packages/logr 
User Name: dbosak 
R Version: 4.0.0 (2020-04-24) 
Machine: BOSAK-MAIN x86-64 
Operating System: Windows 10 x64 build 18362 
Log Start Time: 2020-06-29 14:14:45 
========================================================================= 

Here is the first log message 

NOTE: Log Print Time:  2020-06-29 14:14:45 
NOTE: Elapsed Time in seconds: 0.253318071365356 

                     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

NOTE: Data frame has 32 rows and 11 columns. 

NOTE: Log Print Time:  2020-06-29 14:14:46 
NOTE: Elapsed Time in seconds: 1.18965315818787 

Error: object 'generror' not found
 

NOTE: Log Print Time:  2020-06-29 14:14:46 
NOTE: Elapsed Time in seconds: 0.0129709243774414 

========================================================================= 
Log End Time: 2020-06-29 14:14:46 
Log Elapsed Time: 0 00:00:01 
========================================================================= 
```

## Parts of the log

#### Log Header
The log header provides an introduction to your log. The header block 
contains the path of the log file, the working directory, the name of the user,
a date-time stamp, and other useful information concerning the 
operating environment.  

#### Notes
Notes will be written to the log for every call to `log_print()`. The notes 
will follow the printing of the object, and will include a date-time stamp
and the elapsed time since the last call to `log_print()`. If the object
is of class `data.frame` the number of rows and columns will also be noted. 

#### Log Footer
The log footer concludes the log with another date-time stamp for the log
end time, and a total elapsed time for the entire script.  Note that during
batch runs or when sourcing a script, the log
footer may not be generated if the script errors. Instead, the last line of 
the log will be the error message.

## Additional Features

### Errors and Warnings
**logr** will write all errors and the last warning to the log.  Errors are
written at the point they are encountered.  Warnings will be written at the 
end of the log.  

### Message File \*.msg
If errors or warnings are generated, they will also be written to a separate 
file called a message file.  The message file has the same name as the log, 
but with a *.msg* extension.  The purpose of the message file is so that 
errors and warnings that occur during execution of the script can be 
observed from the file system.  The presence or absence of the *.msg* file 
will indicate whether or not the program ran clean.

### Log subdirectory /log
By default, `logr` prints the log to a subdirectory named *log*.  If that 
subdirectory does not exist, the `log_open()` function will create it.  The 
default behavior can be overridden by setting the `logdir` parameter on the
`log_open()` function to `FALSE`.  
