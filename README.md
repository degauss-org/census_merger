# census_merger <a href='https://degauss.org'><img src='https://github.com/degauss-org/degauss_hex_logo/raw/main/PNG/degauss_hex.png' align='right' height='138.5' /></a>

[![](https://img.shields.io/github/v/release/degauss-org/census_merger?color=469FC2&label=version&sort=semver)](https://github.com/degauss-org/census_merger/releases)
[![container build status](https://github.com/degauss-org/census_merger/workflows/build-deploy-release/badge.svg)](https://github.com/degauss-org/census_merger/actions/workflows/build-deploy-release.yaml)

## Using

If `my_address_file_geocoded_census_tract.csv` and `census_level_data.csv` are two files in the current working directory *both* with a column named `fips_tract_id`,  is  then the [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands):

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/census_merger:0.1.0 my_address_file_geocoded_census_tract.csv census_level_data.csv
```

will produce a merged file called `my_address_file_geocoded_census_tract_census_level_data_census_merger_0.1.0.csv`.

### Required Argument

Note that this container requires two arguments -- the name of each file to be merged. This container performs a [left join](https://statisticsglobe.com/r-dplyr-join-inner-left-right-full-semi-anti), so the data in the second file will be added on to the first file. In many cases, file 1 will be your individual- or patient-level data, and file 2 will be your census tract-level data. The column on which the files will be joined must be called `fips_tract_id`. 

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
