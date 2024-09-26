RSpec.describe TimeIterator do
  let(:time) { Time.gm(2000, 1, 1, 0, 0, 0) }

  describe '.iterate' do
    it 'uses an Enumerator' do
      expect(
        described_class.iterate(time, by: {days: 1})
      ).to be_a(Enumerator)
    end

    describe 'argument errors' do
      it 'when by is not a Hash, it raises' do
        expect {
          described_class.iterate(time, by: :colors)
        }.to raise_error(ArgumentError, /`by` must be a Hash/i)
      end

      it 'when by is missing, it raises' do
        expect {
          described_class.iterate(time)
        }.to raise_error(ArgumentError, /missing keyword: :by/i)
      end

      it 'when by is nil, it raises' do
        expect {
          described_class.iterate(time, by: nil)
        }.to raise_error(ArgumentError, /`by` must be a Hash/i)
      end

      it 'when the by key is invalid, it raises' do
        expect {
          described_class.iterate(time, by: { eons: 42 })
        }.to raise_error(ArgumentError, /Cannot iterate by \[:eons\]/i)
      end

      it 'when the by Hash is empty, it raises' do
        expect {
          described_class.iterate(time, by: {})
        }.to raise_error(ArgumentError, /`by` must not be empty/i)
      end
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

    it "works with time zones" do
      expect(
        described_class.iterate(
          Time.local(2000, 1, 1),
          by: { days: 3 },
          to: Time.local(2000, 1, 9)
        ).to_a
      ).to eq [
        Time.local(2000, 1, 1),
        Time.local(2000, 1, 4),
        Time.local(2000, 1, 7)
      ]
    end

    it 'does not alter the original time' do
      orig = time.clone
      described_class.iterate(time, by: {weeks: 2}).take(5)
      expect( time ).to eq orig
    end
  end
end
