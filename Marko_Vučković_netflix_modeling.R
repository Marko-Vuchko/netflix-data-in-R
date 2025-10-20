# Biblioteke
library(readr)
library(tidyverse)
library(ggplot2)

# Uvoz potrebnih podataka
titles <- read.csv("titles.csv")
ratings <- read.csv("ratings.csv")
genres <- read.csv("genres.csv")
countries <- read.csv("countries.csv")
certifications <- read.csv("certifications.csv")

# Pregled podataka
glimpse(titles)
glimpse(ratings)
glimpse(genres)
glimpse(countries)
glimpse(certifications)

# Filtriranje podataka - samo filmovi iz poslednjih pet godina
films <- titles |> filter(type == "MOVIE") |>
  filter(release_year >=  max(release_year, na.rm = TRUE) - 5) |>
  mutate(short_movie = ifelse(runtime < 90, TRUE, FALSE))

# Spajanje tabela pomoću left_join
films_conn_ratings <- films |> left_join(ratings, by = "id") |>
  filter(!is.na(imdb_score)) |> 
  mutate(high_rating = ifelse(imdb_score > 7.5, 1, 0))

# Grafički prikaz udela filmova sa ocenom većom od 7.5
ggplot(data = films_conn_ratings, 
       mapping = aes(x = runtime, fill = factor(high_rating))) +
  geom_density() +
  labs(
    title = "Udeo filmova sa ocenom većom od 7.5 po trajanju",
    x = "Trajanje filma (min)",
    y = "Gustina rasporedjenosti",
    fill = "Ocena veća od 7.5"
  ) +
  theme_minimal()

# Podela podataka za treniranje i testiranje modela
set.seed(123)
n <- nrow(films_conn_ratings)
train_index <- sample(1:n, size = 0.8 * n)
train_data <- films_conn_ratings[train_index, ]
test_data <- films_conn_ratings[-train_index, ]

# Kreiranje modela
model <- glm(high_rating ~ short_movie, data = train_data, family = binomial)

# Tumačimo model
summary(model)

# Izračunavanje verovatnoće
verovatnoce <- predict(model, newdata = films_conn_ratings, type = "response")
head(verovatnoce)

# Konvertovanje u 1/0 klasifikaciju
predikcija <- ifelse(verovatnoce > 0.5, 1, 0)

# Kreiranje confusion matrix tabelu
table(Realno = films_conn_ratings$high_rating, Predikcija = predikcija)

# Proveravamo koliko je model tačan
tacnost <- mean(predikcija == films_conn_ratings$high_rating)
tacnost

# Kreiramo novi hipotetički dataset
# 1. Kreiramo novi skup podataka
hypothetical_titles <- tibble(
  title = c("Quick look", "Long Road", "Instant Hit", "Mini Drama", "Marathon of Emotions"),
  runtime = c(85, 120, 75, 55, 135),
  release_year = c(2023, 2022, 2024, 2021, 2020),
  short_movie = c(TRUE, FALSE, TRUE, TRUE, FALSE)
)

# 2. Koristimo predikciju sa već kreiranim našim modelom
hypothetical_titles$predicted_prob <- predict(model, newdata = hypothetical_titles, type = "response")

# 3. Tabelarni prikaz rezultata
hypothetical_titles |> 
  select(title, runtime, release_year, predicted_prob) |>
  arrange(desc(predicted_prob))

# Grafički prikaz
ggplot(hypothetical_titles, aes(x = reorder(title, -predicted_prob), y = predicted_prob, fill = short_movie)) +
  geom_col(width = 0.6) +
  scale_fill_manual(values = c("FALSE" = "red", "TRUE" = "green")) +
  labs(
    title = "Predikcija verovatnoće uspeha po filmu",
    x = "Naslov",
    y = "Verovatnoća ocene veće od 7.5",
    fill = "Trajanje manje od 90min"
  ) +
  theme_minimal()

# ZAKLJUČAK - predlog timu
# Kao što možemo videti iz priloženog grafikona "Udeo filmova sa ocenom većom 
# od 7.5 po trajanju" možemo zaključiti na najbolje ocene imaju filmovi između
# 80 minuta i 110 minuta.
