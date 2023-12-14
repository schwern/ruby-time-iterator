require "active_support"
require "active_support/core_ext/integer/time"

# Inject 3.quarters
class Numeric
  def quarter
    (3 * self).months
  end
  alias quarters quarter
end

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

    def beginning_of(period)
      method_for_period(:beginning_of, period)
    end

    def end_of(period)
      method_for_period(:end_of, period)
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

    def days_in_month
      ::Time.days_in_month( month, year )
    end

    def days_in_year
      ::Time.days_in_year( year )
    end

    # Creates a Range from the Time to the end of today
    # @return [Range]
    def span_to_end_of_today
      beginning_of_next_day = ::Time.current.tomorrow.beginning_of_day
      (self...beginning_of_next_day)
    end

    # @return [String] the abbreviated day of the week
    def dow
      strftime("%a")
    end

    def iso_date
      strftime("%Y-%m-%d")
    end

    def human_date
      strftime("%a %b %-d %Y")
    end
  end
end

class Time
  include Time::Iterator
end
