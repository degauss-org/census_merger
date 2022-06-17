.PHONY: build test shell clean

build:
	docker build -t census_merger .

test:
	docker run --rm -v "${PWD}/test":/tmp census_merger my_address_file_geocoded_census_block_group_0.5.1_2010.csv census_mega_example.csv

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp census_merger

clean:
	docker system prune -f
