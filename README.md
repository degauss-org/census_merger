# census_merger <a href='https://degauss.org'><img src='https://github.com/degauss-org/degauss_hex_logo/raw/main/PNG/degauss_hex.png' align='right' height='138.5' /></a>

[![](https://img.shields.io/github/v/release/degauss-org/census_merger?color=469FC2&label=version&sort=semver)](https://github.com/degauss-org/census_merger/releases)
[![container build status](https://github.com/degauss-org/census_merger/workflows/build-deploy-release/badge.svg)](https://github.com/degauss-org/census_merger/actions/workflows/build-deploy-release.yaml)

## Using

If 

- `my_address_file_geocoded_census_block_group_0.5.1_2010.csv` is a file in the current working directory with a column prefixed with `fips_tract_id` containing census tract identifiers from the [DeGAUSS census_block_group container]() and

- `census_level_data.csv` is a second file in the current working directory with its first column also containing census tract identifiers, then the [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands):

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/census_merger:0.1.0 my_address_file_geocoded_census_block_group_0.5.1_2010.csv census_level_data.csv
```

will produce a merged file called `my_address_file_geocoded_census_block_group_0.5.1_2010_census_level_data_census_merger_0.1.0.csv`.

### Required Argument

Note that this container requires two arguments -- the name of each file to be merged. This container performs a [left join](https://statisticsglobe.com/r-dplyr-join-inner-left-right-full-semi-anti), so the data in the second file will be added on to the first file. In many cases, file 1 will be your individual- or patient-level data, and file 2 will be your census tract-level data. The two files will always be joined using the `fips_tract_id_xxxx` (where `xxxx` denotes the census vintage) column in file 1 and the first column in file 2, regardless of name.

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
