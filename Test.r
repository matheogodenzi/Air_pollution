########################################################################################
##
## ENV409 example script
## Spring 2025
##
########################################################################################

## ------------------------------------------------------------------------
# Install from CRAN
#install.packages("tidyverse")
## Load libraries
library(tidyverse)

## ------------------------------------------------------------------------
## Specify settings
Sys.setlocale("LC_TIME","C")
options(stringsAsFactors=FALSE)
theme_set(theme_bw()) # just my preference for plots

## ------------------------------------------------------------------------
## Define input file (located in same directory)
filename <- "./data/BAS.csv"
file.exists(filename)

## ------------------------------------------------------------------------
## Read data file
data <- read_delim(filename, delim=";", skip=6,
                   col_names=c("datetime","O3","NO2","CO","PM10","TEMP","PREC","RAD"))

## ------------------------------------------------------------------------
## View information stored in object
str(data)

## ------------------------------------------------------------------------
## View first 6 lines
head(data)

## ------------------------------------------------------------------------
## View first 6 lines formatted differently
knitr::kable(head(data))

## ------------------------------------------------------------------------
data[["datetime"]] <- parse_date_time(data[["datetime"]], "%d.%m.%Y %H:%M", tz = "CEST")
data[["month"]] <- month(data[["datetime"]])
data[["date"]] <- date(data[["datetime"]])

## ------------------------------------------------------------------------
## View modified data table
str(data)
head(data)

## ---- fig.width=8, fig.height=5------------------------------------------
ggplot(data)+
  geom_line(aes(datetime, O3))


## To export, save graphics from RStudio pulldown menu, or print to pdf/png device

## Create an outputs directory.
dir.create("outputs")

## Save graphics to an object.
ggp <- ggplot(data)+
  geom_line(aes(datetime, O3))

## Print to pdf file.
pdf("outputs/fig1.pdf")
print(ggp)
dev.off()

## -----------------------------------------------------------------------------
## Convert to "long" format
lf <- data %>%
  pivot_longer(c(O3, NO2, CO, PM10, TEMP, PREC, RAD), names_to = "variable", values_to = "value")

## inspect
head(lf)
tail(lf)

## -----------------------------------------------------------------------------
## Monthly summary (means)
monthly.means <- lf %>%
  group_by(variable, month) %>%
  summarize(average = mean(value, na.rm=TRUE))

## inspect
head(monthly.means)
tail(monthly.means)

## reformat
monthly.means %>%
  pivot_wider(names_from = variable, values_from = average)

## -----------------------------------------------------------------------------
## Plot
ggplot(lf)+
  facet_grid(variable~., scale="free_y")+
  geom_line(aes(datetime, value)) +
  scale_x_datetime(name = "Date", date_labels = "%b")

