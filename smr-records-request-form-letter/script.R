# objective: 
# knit an HTML document 

# package libraries 
library(here)
library(tidyverse)
library(stringr)

# my data looks something like this 
my_data <- tribble(
  ~id, ~first_name, ~last_name, ~date_01, ~date_02,
  "1", "Jandy", "Pifford", "21-10-1976", "11-11-2020",
  "2", "Karena", "Ramble", "19-04-1975", "17-01-2021",
  "3", "Odo", "Tommasi", "09-12-1977", "22-02-2021",
  "4", "Alvin", "Kimbrough", "13-01-1981", "13-06-2020",
  "5", "Doris", "Alfonzo", "07-08-1973", "06-12-2020")

intro_text <- "This is a request for the records of:"

conclusion <- "The team is reviewing the above listed and requires records."

str_c(
  "Name:",
  my_data$first_name,
  my_data$last_name,
  "|",
  "Date 1:",
  my_data$date_01,
  "|",
  "Date 2:",
  my_data$date_02,
  sep = " "
)

output <- vector("double", ncol(my_data))
  for (i in my_data$first_name) {
  output[[i]] <- str_c(
    intro_text,
    "Name:",
    i
  )
}
output

for(x in my_data) {
  assign(x = str_c(
    "Name:",
    my_data$first_name,
    my_data$last_name,
    "|",
    "Date 1:",
    my_data$date_01,
    "|",
    "Date 2:",
    my_data$date_02,
    sep = " "
  ),
  value = x)
}

