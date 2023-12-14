require "active_support"
require "active_support/core_ext/integer/time"
require_relative "iterator/core_ext/numeric"
require_relative "iterator/core_ext/time"

class Time
  # Time iteration, and extra Time methods.
  module Iterator
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

    private def valid_period?(period)
      raise ArgumentError, "Unknown time period: #{period}" unless PERIODS.include?(period)
    end

    private def method_for_period(method, period)
      period = period.to_sym
      valid_period?(period)
      send("#{method}_#{period}")
    end

    def iterate(by:, every: 1)
      by = by.to_sym

      raise ArgumentError, "Unknown period to iterate by: #{by}" unless ITERATE_BY.include?(by)

      Enumerator.new do |block|
        (0..INFINITY).each do |num|
          block << (self + (num.send(by) * every))
        end
      end
    end
  end
end

class Time
  include Time::Iterator
end
