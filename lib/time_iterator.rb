require "active_support"
require "active_support/duration"

# Time iteration.
module TimeIterator
  class << self
    def iterate(start, by:)
      raise ArgumentError, "`by` must be an ActiveSupport::Duration" unless by.is_a?(ActiveSupport::Duration)

      Enumerator.new do |block|
        time = start
        loop do |_num|
          block << time
          time += by
        end
      end
    end
  end
end
