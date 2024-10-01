require 'delegate'

class TimeRange < Range
  # @private
  #
  # A small wrapper for Time to add #succ so it works with Range.
  class Time < DelegateClass(Time)
    attr_accessor :by

    def initialize(time, by = nil)
      @time = time
      @by = by

      super(time)
    end

    def succ
      next_time = Advancer.advance_time(@time, @by)
      return self.class.new(next_time, @by)
    end
  end
end
