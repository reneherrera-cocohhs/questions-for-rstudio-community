library(tidyverse)
library(lubridate)
library(Rnssp)

# create random data 
set.seed(66)
my_data <- dplyr::tibble(
  date = sample(seq.Date(
    from = lubridate::date("2022-04-01"),
    to = lubridate::date("2022-08-01"),
    by = "day"
  ),
  size = 99,
  replace = TRUE),
  group = sample(
    seq(1:3),
    size = 99,
    replace = TRUE
  )
)

# initiate the Rnssp::alert_ewma function 
my_alert <- my_data %>%
  dplyr::group_by(date) %>%
  dplyr::count() %>%
  dplyr::ungroup() %>%
  Rnssp::alert_ewma(
    t = date,
    y = n
  )

# plot, but notice that there are never an zero days
my_alert %>%
  ggplot(
    mapping = aes(
      x = date,
      y = n
    )
  ) +
  geom_line(
    color = "grey"
  ) +
  geom_line(
    data = subset(my_alert, alert != "grey"),
    color = "blue"
  ) +
  geom_point(
    data = subset(my_alert, alert == "blue"),
    color = "blue"
  ) +
  geom_point(
    data = subset(my_alert, alert == "yellow"),
    color = "yellow"
  ) +
  geom_point(
    data = subset(my_alert, alert == "red"),
    color = "red"
  ) +
  ylim(0,NA)

# try my alert again 
my_new_alert <- my_data %>%
  dplyr::group_by(date) %>%
  dplyr::count() %>%
  dplyr::ungroup() %>%
  tidyr::complete(
    date = seq.Date(date("2022-04-01"), date("2022-08-01"), by = "day"),
    fill = list(n = 0),
    explicit = FALSE
  ) %>%
  Rnssp::alert_ewma(
    t = date,
    y = n
  )

# plot, and now there are zero days 
my_new_alert %>%
  ggplot(
    mapping = aes(
      x = date,
      y = n,
      group = group
    )
  ) +
  geom_line(
    color = "grey"
  ) +
  geom_line(
    data = subset(my_new_alert, alert != "grey"),
    color = "blue"
  ) +
  geom_point(
    data = subset(my_new_alert, alert == "blue"),
    color = "blue"
  ) +
  geom_point(
    data = subset(my_new_alert, alert == "yellow"),
    color = "yellow"
  ) +
  geom_point(
    data = subset(my_new_alert, alert == "red"),
    color = "red"
  ) +
  ylim(0,NA)

# but, how can I apply the alert_ewma function by group?
my_new_alert_group <- my_data %>%
  dplyr::group_by(date, group) %>%
  dplyr::count() %>%
  dplyr::ungroup() %>%
  tidyr::complete(
    date = seq.Date(date("2022-04-01"), date("2022-08-01"), by = "day"),
    fill = list(n = 0),
    nesting(group),
    explicit = FALSE
  ) %>%
  group_by(group) %>%
  Rnssp::alert_ewma(
    t = date,
    y = n
  )

my_new_alert_group %>%
  ggplot(
    mapping = aes(
      x = date,
      y = n,
      group = as_factor(group),
      color = as_factor(group)
    )
  ) +
  geom_line()