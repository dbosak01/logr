## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(rmarkdown.html_vignette.check_title = FALSE)


## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(tidyverse)
#  library(sassy)
#  
#  options("logr.autolog" = TRUE)
#  
#  # Get temp location for log and report output
#  tmp <- tempdir()
#  
#  # Open the log
#  lf <- log_open(file.path(tmp, "example1.log"))
#  
#  # Send code to the log
#  log_code()
#  
#  sep("Load the data")
#  
#  # Get path to sample data
#  pkg <- system.file("extdata", package = "logr")
#  
#  # Define data library
#  libname(sdtm, pkg, "csv")
#  
#  # Load the library into memory
#  lib_load(sdtm)
#  
#  
#  # Prepare Data -------------------------------------------------------------
#  sep("Prepare the data")
#  
#  # Define format for age groups
#  ageg <- value(condition(x > 18 & x <= 29, "18 to 29"),
#                condition(x >= 30 & x <= 44, "30 to 44"),
#                condition(x >= 45 & x <= 59, "45 to 59"),
#                condition(TRUE, "60+"))
#  
#  
#  # Manipulate data
#  final <- sdtm.DM %>%
#    select(USUBJID, BRTHDTC, AGE) %>%
#    mutate(AGEG = fapply(AGE, ageg)) %>%
#    arrange(AGEG, AGE) %>%
#    group_by(AGEG) %>%
#    datastep(retain = list(SEQ = 0),
#             calculate = {AGEM <- mean(AGE)},
#             attrib = list(USUBJID = dsattr(label = "Universal Subject ID"),
#                           BRTHDTC = dsattr(label = "Subject Birth Date",
#                                            format = "%m %B %Y"),
#                           AGE = dsattr(label = "Subject Age in Years",
#                                        justify = "center"),
#                           AGEG = dsattr(label = "Subject Age Group",
#                                         justify = "left"),
#                           AGEB = dsattr(label = "Age Group Boundaries"),
#                           SEQ = dsattr(label = "Subject Age Group Sequence",
#                                        justify = "center"),
#                           AGEM = dsattr(label = "Mean Subject Age",
#                                         format = "%1.2f"),
#                           AGEMC = dsattr(label = "Subject Age Mean Category",
#                                          format = c(B = "Below", A = "Above"),
#                                          justify = "right")),
#             {
#  
#               # Start and end of Age Groups
#               if (first. & last.)
#                 AGEB <- "Start - End"
#               else if (first.)
#                 AGEB <- "Start"
#               else if (last.)
#                 AGEB <- "End"
#               else
#                 AGEB <- "-"
#  
#               # Sequence within Age Groups
#               if (first.)
#                 SEQ <- 1
#               else
#                 SEQ <- SEQ + 1
#  
#               # Above or Below the mean age
#               if (AGE > AGEM)
#                 AGEMC <- "A"
#               else
#                 AGEMC <- "B"
#  
#             }) %>%
#    ungroup() %>%
#    put()
#  
#  # Put dictionary to log
#  dictionary(final) %>% put()
#  
#  # Create Report ------------------------------------------------------------
#  sep("Create report")
#  
#  
#  # Create table
#  tbl <- create_table(final)
#  
#  # Create report
#  rpt <- create_report(file.path(tmp, "./output/example1.rtf"),
#                       output_type = "RTF", font = "Arial") %>%
#    titles("Our first SASSY report", bold = TRUE) %>%
#    add_content(tbl)
#  
#  # write out the report
#  res <- write_report(rpt)
#  
#  
#  # Clean Up -----------------------------------------------------------------
#  sep("Clean Up")
#  
#  # Unload libname
#  lib_unload(sdtm)
#  
#  # Close the log
#  log_close()
#  
#  # View log
#  writeLines(readLines(lf, encoding = "UTF-8"))
#  
#  # View Report
#  # file.show(res$modified_path)
#  
#  

