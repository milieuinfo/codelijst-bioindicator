#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.csv
# to jsonld, /tmp/bioindicator.jsonld
Rscript ../R/csv_to_json.R

# Make formatted jsonld and turtle
riot --formatted=TURTLE /tmp/bioindicator.jsonld   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.ttl'
riot --formatted=JSONLD '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.ttl'   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/bioindicator/bioindicator.jsonld' 

