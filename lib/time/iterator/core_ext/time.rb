# Inject convenience methods into Time.
class Time
  def beginning_of(period)
    method_for_period(:beginning_of, period)
  end

  def end_of(period)
    method_for_period(:end_of, period)
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
