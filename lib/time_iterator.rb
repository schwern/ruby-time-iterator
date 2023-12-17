require "active_support"
require "active_support/duration"

# Time iteration.
module TimeIterator
  class << self
    def iterate(start, by:, to: nil)
      raise ArgumentError, "`by` must be an ActiveSupport::Duration" unless by.is_a?(ActiveSupport::Duration)

      return to ? iterate_to(start, by: by, to: to) : iterate_endless(start, by: by)
    end

    private def iterate_endless(start, by:)
      Enumerator.new do |block|
        time = start
        loop do
          block << time
          time += by
        end
      end
    end

    private def iterate_to(start, by:, to:)
      Enumerator.new do |block|
        time = start
        while time <= to
          block << time
          time += by
        end
      end
    end
  end
end
