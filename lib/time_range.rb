require 'date'
require 'delegate'

require_relative 'time_range/advancer'
require_relative 'time_range/time'

# Range over Time stepping by time intervals.
#
# Does not require ActiveSupport.
#
# Unlike a Range, it is necessary to call #by to say how long between
# each step.
#
# @example Print every week of 2024.
#   TimeRange
#     .new(Time.local(2024), Time.local(2025), true)
#     .by(weeks: 1)
#     .each { |week| puts week }
class TimeRange < Range
  # Same as Range.new, but it takes Time objects.
  #
  # @param first [Time] the beginning of the range
  # @param last [Time] the end of the range
  # @param exclude_last [Boolean] if true, exclude the last value from the range, default false
  #
  # @see Range.new
  def initialize(first, last, exclude_last = false) # rubocop:disable Style/OptionalBooleanParameter
    super(
      first ? TimeRange::Time.new(first) : first,
      last ? TimeRange::Time.new(last) : last,
      exclude_last
    )
  end

  # The time interval to use when iterating through the TimeRange.
  #
  # Returns the TimeRange object so you can safely chain
  # time_range = TimeRange.new(...).by(...)
  #
  # Currently cannot be negative.
  #
  # @param seconds [Numeric]
  # @param minutes [Numeric]
  # @param hours [Numeric]
  # @param days [Numeric]
  # @param weeks [Numeric]
  # @param months [Numeric]
  # @param years [Numeric]
  #
  # @return [TimeRange] the TimeRange object
  def by( # rubocop:disable Metrics/ParameterLists
    seconds: nil, minutes: nil, hours: nil,
    days: nil, weeks: nil, months: nil, years: nil
  )
    by = {
      seconds: seconds, minutes: minutes, hours: hours,
      days: days, weeks: weeks, months: months, years: years
    }.compact!

    self.begin&.by = by
    self.end&.by = by

    return self
  end

  # Like Range#eql?, but will be false if their #by is different.
  def eql?(other)
    return false if self.begin&.by != other.begin&.by || self.end&.by != other.end&.by

    super
  end
end
