class Numeric
  def quarter
    (3 * self).months
  end
  alias_method :quarters, :quarter
end

module EmailIntegrator
  module Time
    INFINITY = 1.0 / 0.0
    PERIODS = [:second, :minute, :hour, :day, :week, :month, :quarter, :year].freeze
    ITERATE_BY = PERIODS + PERIODS.map { |period| period.to_s.pluralize.to_sym }

    private def valid_period?(period)
      raise ArgumentError, "Unknown time period: #{period}" if PERIODS.exclude?(period)
    end

    private def method_for_period(method, period)
      period = period.to_sym
      valid_period?(period)
      send("#{method}_#{period}".to_sym)
    end

    def beginning_of(period)
      method_for_period(:beginning_of, period)
    end

    def end_of(period)
      method_for_period(:end_of, period)
    end

    def iterate(by:, every: 1)
      by = by.to_sym
      if ITERATE_BY.exclude?(by)
        raise ArgumentError, "Unknown period to iterate by: #{by}"
      end

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
  include EmailIntegrator::Time
end

class ActiveSupport::TimeWithZone
  include EmailIntegrator::Time
end
