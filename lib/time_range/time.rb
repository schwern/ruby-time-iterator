require 'delegate'

class TimeRange < Range
  # @private
  #
  # A small wrapper for Time to add #succ so it works with Range.
  class Time < DelegateClass(Time)
    attr_accessor :step_by

    def initialize(time, step_by = nil)
      @time = time
      @step_by = step_by

      super(time)
    end

    def succ
      raise ArgumentError, 'step_by() not set for this TimeRange' if !@step_by || @step_by.empty?

      next_time = Advancer.advance_time(@time, @step_by)
      return self.class.new(next_time, @step_by)
    end
  end
end
