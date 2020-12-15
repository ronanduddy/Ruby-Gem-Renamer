.PHONY: test shell irb bundle guard lint release rename

test:
	@docker-compose build test
	@docker-compose run --rm test

shell:
	@docker-compose build dev
	@docker-compose run --rm dev sh

irb:
	@docker-compose build dev
	@docker-compose run --rm dev bundle exec bin/console

bundle:
	@docker-compose build dev
	@docker-compose run --rm dev bundle

guard:
	@docker-compose build dev
	@docker-compose run --rm dev bundle exec guard -c

lint:
	@docker-compose build dev
	@docker-compose run --rm dev rubocop -a

release:
	@docker-compose build release
	@docker-compose run --rm release
