RSpec.describe TimeIterator do
  let(:time) { Time.gm(2000, 1, 1, 0, 0, 0) }

  describe '.iterate' do
    it 'uses an Enumerator' do
      expect(
        described_class.iterate(time, by: {days: 1})
      ).to be_a(Enumerator)
    end

    it 'raises on an invalid `by`' do
      expect {
        described_class.iterate(time, by: :colors)
      }.to raise_error(ArgumentError, /`by` must be a Hash/i)
    end

    it "iterates Times" do
      expect(
        described_class.iterate(
          Time.gm(2000, 1, 1), by: {days: 3}
        ).take(3)
      ).to eq [
        Time.gm(2000, 1, 1),
        Time.gm(2000, 1, 4),
        Time.gm(2000, 1, 7)
      ]
    end

    it "iterates by multiple parts" do
      expect(
        described_class.iterate(
          Time.gm(2000, 1, 1), by: {days: 3, hours: 2}
        ).take(3)
      ).to eq [
        Time.gm(2000, 1, 1, 0),
        Time.gm(2000, 1, 4, 2),
        Time.gm(2000, 1, 7, 4)
      ]
    end

    it "iterates Dates" do
      require 'date'

      expect(
        described_class.iterate(
          Date.new(2000, 1, 1), by: {days: 3}
        ).take(3)
      ).to eq [
        Date.new(2000, 1, 1),
        Date.new(2000, 1, 4),
        Date.new(2000, 1, 7)
      ]
    end

    it "raises when iterating a Date by time part" do
      require 'date'

      expect {
        described_class.iterate(
          Date.new(2000, 1, 1), by: {seconds: 10}
        )
      }.to raise_error(ArgumentError, /cannot iterate Date by \[:seconds\]/i)
    end

    it "stops before `to`" do
      expect(
        described_class.iterate(
          Time.gm(2000, 1, 1),
          by: {days: 3},
          to: Time.gm(2000, 1, 12)
        ).to_a
      ).to eq [
        Time.gm(2000, 1, 1),
        Time.gm(2000, 1, 4),
        Time.gm(2000, 1, 7),
        Time.gm(2000, 1, 10)
      ]
    end

    it "includes `to`" do
      expect(
        described_class.iterate(
          Time.gm(2000, 1, 1),
          by: {days: 3},
          to: Time.gm(2000, 1, 10)
        ).to_a
      ).to eq [
        Time.gm(2000, 1, 1),
        Time.gm(2000, 1, 4),
        Time.gm(2000, 1, 7),
        Time.gm(2000, 1, 10)
      ]
    end

    it 'does not alter the original time' do
      orig = time.clone
      described_class.iterate(time, by: {weeks: 2}).take(5)
      expect( time ).to eq orig
    end
  end
end
