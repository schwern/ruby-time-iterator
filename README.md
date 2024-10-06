# TimeRange

Range over Time using time intervals without ActiveSupport.

## Installation

Install the gem and add to the application's Gemfile by executing:

    bundle add time_range

If bundler is not being used to manage dependencies, install the gem by executing:

    gem install time_range

## Usage

Works just like Range with one important change; **you must call `#step_by` to set a time interval.**

    require 'time_range'

    # Print the first day of each month of 2024.
    time_range = TimeRange
      .new(Time.local(2024), Time.local(2025), true)
      .step_by(months: 1)
    time_range.each { |time| puts time }

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/schwern/ruby-time_range>.
