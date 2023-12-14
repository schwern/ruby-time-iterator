require "active_support"
require "active_support/core_ext/integer/time"
require_relative "time_iterator/core_ext/numeric"
require_relative "time_iterator/core_ext/time"

# Time iteration.
module TimeIterator
  INFINITY = 1.0 / 0.0
  PERIODS = {
    second: :seconds,
    minute: :minutes,
    hour: :hours,
    day: :days,
    week: :weeks,
    month: :months,
    quarter: :quarters,
    year: :years
  }.freeze
  ITERATE_BY = (PERIODS.keys + PERIODS.values).freeze

  class << self
    def iterate(start, by:, every: 1)
      by = by.to_sym

      raise ArgumentError, "Unknown period to iterate by: #{by}" unless ITERATE_BY.include?(by)

      Enumerator.new do |block|
        (0..INFINITY).each do |num|
          block << (start + (num.send(by) * every))
        end
      end
    end
  end
end
