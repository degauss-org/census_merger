#!/usr/local/bin/Rscript

dht::greeting()

## load libraries without messages or warnings
withr::with_message_sink("/dev/null", library(dplyr))
withr::with_message_sink("/dev/null", library(tidyr))
withr::with_message_sink("/dev/null", library(readr))

doc <- "
      Usage:
      entrypoint.R <filename1> <filename2>
      "

opt <- docopt::docopt(doc)

## for interactive testing
## opt <- docopt::docopt(doc, args = c('test/my_address_file_geocoded_census_block_group_0.5.1_2010.csv', 'test/census_mega_example.csv'))

message("reading input file...")
d1 <- readr::read_csv(opt$filename1, col_types = cols(fips_tract_id = col_character()))
d2 <- readr::read_csv(opt$filename2, col_types = cols(fips_tract_id = col_character()))

dht::check_for_column(d1, "fips_tract_id", d1$fips_tract_id, "character")
dht::check_for_column(d2, "fips_tract_id", d2$fips_tract_id, "character")

n_both <- length(intersect(d1$fips_tract_id[!is.na(d1$fips_tract_id)], d2$fips_tract_id[!is.na(d2$fips_tract_id)]))
n_d1 <- length(unique((d1$fips_tract_id[!is.na(d1$fips_tract_id)])))
n_d2 <- length(unique((d2$fips_tract_id[!is.na(d2$fips_tract_id)])))

cli::cli_alert_info("There are {n_d1} unique tract ids in dataset 1, {n_d2} unique tract ids in dataset 2, and {n_both} unique tract ids present in both datasets.")

## add code here to calculate geomarkers
d <- left_join(d1, d2, by = "fips_tract_id")

file_name_merged <- glue::glue("{stringr::str_remove(opt$filename1, '.csv')}_{basename(opt$filename2)}")

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(d = d, filename = file_name_merged)
