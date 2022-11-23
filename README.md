# ActiveRecord TimescaleDB Adapter

The activerecord-timescaledb-adapter provides access to features of the [Timescale](https://www.timescale.com/) Postgres extension from ActiveRecord. 

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activerecord-timescaledb-adapter

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install activerecord-timescaledb-adapter

## Usage

TODO: Write usage instructions here

## Roadmap

- [] [Hypertable](https://docs.timescale.com/api/latest/hypertable/) ActiveRecord::Migration methods
- [] [Distributed Hypertable](https://docs.timescale.com/api/latest/distributed-hypertables/) ActiveRecord::Migration methods
- [] [Hyperfunction](https://docs.timescale.com/api/latest/hyperfunctions/)s on ActiveRecord models

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/grnhse/activerecord-timescaledb-adapter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
