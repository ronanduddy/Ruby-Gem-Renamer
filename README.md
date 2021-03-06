# Rename Gem

This Ruby Gem is a work in progress, its goal is to be able to rename gems.

[![Build Status](https://travis-ci.org/ronanduddy/Ruby-Gem-Renamer.svg?branch=master)](https://travis-ci.org/ronanduddy/Ruby-Gem-Renamer)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rename_gem'
```

And then execute:

```Shell
bundle install
```

Or install it yourself as:

```Shell
gem install rename_gem
```

## Usage

```Shell
bundle exec rename_gem rename -f project_name -t foo_bar -p project
```

## Development

Run `make test` to run all the tests or `make guard` to use guard for testing. You can also run `make irb` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ronanduddy/Ruby-Gem-Renamer. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details on our code of conduct.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
