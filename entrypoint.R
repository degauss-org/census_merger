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

message("reading input files...")
d1 <- suppressWarnings(
  readr::read_csv(opt$filename1,
                  col_types = cols(fips_tract_id_2020 = col_character(),
                                   fips_tract_id_2010 = col_character(),
                                   fips_tract_id_2000 = col_character(),
                                   fips_tract_id_1990 = col_character(),
                                   fips_tract_id_1980 = col_character(),
                                   fips_tract_id_1970 = col_character(),
                                   fips_block_group_id_2020 = col_character(),
                                   fips_block_group_id_2010 = col_character(),
                                   fips_block_group_id_2000 = col_character(),
                                   fips_block_group_id_1990 = col_character()
                                   )
                  )
  )

d2 <- readr::read_csv(opt$filename2, col_types = list(col_character()))

f1_name <- names(d1)[substr(names(d1), 1, 13) == "fips_tract_id"]
f2_name <- names(d2)[1]
names(d2)[1] <- f1_name

if(length(f1_name) < 1) {
  cli::cli_alert_danger("File 1 does not contain a column name matching output from the DeGAUSS census_block_group container.")
  stop()
}

cli::cli_alert_info("Data will be joined using the {f1_name} column from file 1 and the {f2_name} column from file 2")



n_both <- length(intersect(d1 %>%
                             dplyr::select({{f1_name}}) %>%
                             dplyr::filter(!is.na(.)) %>%
                             pull(),
                           d2 %>%
                             dplyr::select({{f1_name}}) %>%
                             dplyr::filter(!is.na(.)) %>%
                             pull()))

n_d1 <- length(unique((d1 %>%
                         dplyr::select({{f1_name}}) %>%
                         dplyr::filter(!is.na(.)) %>%
                         pull())))

n_d2 <- length(unique((d2 %>%
                         dplyr::select({{f1_name}}) %>%
                         dplyr::filter(!is.na(.)) %>%
                         pull())))

cli::cli_alert_info("There are {n_d1} unique tract ids in dataset 1, {n_d2} unique tract ids in dataset 2, and {n_both} unique tract ids present in both datasets.")

## add code here to calculate geomarkers
d <- left_join(d1, d2, by = {{f1_name}})

file_name_merged <- glue::glue("{stringr::str_remove(opt$filename1, '.csv')}_{basename(opt$filename2)}")

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(d = d, filename = file_name_merged)
