#!/usr/bin/Rscript
library(tidyr)
library(dplyr)
library(jsonlite)

df <- read.csv(file = "../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.csv", sep=",", na.strings=c("","NA"))

# hasTopConcept relatie uit inverse relatie
schemes <- na.omit(distinct(df['topConceptOf']))
for (scheme in as.list(schemes$topConceptOf)) {
  topconceptof <- subset(df, topConceptOf == scheme ,
                         select=c(uri, topConceptOf))
  hastopconcept <- as.list(topconceptof["uri"])
  df2 <- data.frame(scheme, hastopconcept)
  names(df2) <- c("uri","hasTopConcept")
  df <- bind_rows(df, df2)
}












tco <- subset(df, topConceptOf == 'https://data.omgeving.vlaanderen.be/id/conceptscheme/bioindicator' ,
                   select=c(uri, topConceptOf))
htc <- as.list(tco["uri"])
df2 <- data.frame('https://data.omgeving.vlaanderen.be/id/conceptscheme/bioindicator', htc)
names(df2) <- c("uri","hasTopConcept")
df <- bind_rows(df, df2)


df <- df %>%
  rename("@id" = uri,
         "@type" = type)
write.csv(df,"../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator_separate_rows.csv", row.names = FALSE)
context <- jsonlite::read_json("../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/context.json")
df_in_list <- list('@graph' = df, '@context' = context)
df_in_json <- toJSON(df_in_list, auto_unbox=TRUE)
write(df_in_json, "/tmp/bioindicator.jsonld")

# serialiseer jsonld naar mooie turtle en mooie jsonld
# hiervoor dienen jena cli-tools geinstalleerd, zie README.md
system("riot --formatted=TURTLE /tmp/bioindicator.jsonld > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.ttl")
system("riot --formatted=JSONLD ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.ttl > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.jsonld")
