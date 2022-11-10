library("rentrez")
library("glue")
library("tidyverse")
library("ggplot2")

#searching for articles that discuss Campylobacter jejuni and aerotolerance
campy_aerotolerance <- entrez_search(db = "pubmed", term = "Campylobacter jejuni[TITL] AND aerotolerance[TITL]", retmax = 10)

campy_aerotolerance

#summary to find relevant details to search for
campy_aero_summary <- entrez_summary(db = "pubmed", id = campy_aerotolerance$ids)

campy_aero_summary

#fetching title, publication date, and full journal name for each article
extract_details <- extract_from_esummary(campy_aero_summary, c("title", "pubdate", "fulljournalname"), simplify = TRUE)

extract_details

#going to compare number of articles published over time about salmonellosis, a type of food poisoning caused by non-typhoidal salmonella, versus the number of articles published over time on Campylobacter jejuni, the other major cause of food poisoning. Unfortunately there are multiple species of salmonella that can cause salmonellosis, which is why I'm not simply comparing one species to another.  
year <- 1950:2022
campy_search <- glue("Campylobacter jejuni[TITL] AND {year}[PDAT]")
salmonella_search <- glue("salmonellosis[TITL] and {year}[PDAT]")

search_plot <- tibble(year = year, campy_search = campy_search, salmonella_search = salmonella_search) %>%
  mutate(campylobacter = map_dbl(campy_search, ~entrez_search(db = "pubmed", term = .x)$count), salmonellosis = map_dbl(salmonella_search, ~entrez_search(db = "pubmed", term = .x)$count))

#creating plot of the two variables
search_plot %>%
  select(year, campylobacter, salmonellosis) %>%
  pivot_longer(-year) %>%
  ggplot(aes(x = year, y = value, group = name, color = name))+
  geom_line(size = 1) +
  geom_smooth() +
  theme_bw()
