RSpec.describe TimeIterator do
  let(:time) { Time.now }

  describe '.iterate' do
    it 'uses an Enumerator' do
      expect( described_class.iterate(time, by: :day) ).to be_a(Enumerator)
    end

    it 'raises on an invalid period' do
      expect do
        described_class.iterate(time, by: :colors)
      end.to raise_error(ArgumentError)
    end

    [
      :second, :minute, :hour, :day, :week, :month, :quarter, :year,
      :seconds, :minutes, :hours, :days, :weeks, :months, :quarter, :years
    ].each do |period|
      it "iterates by #{period}" do
        expect(
          described_class.iterate(time, by: period).take(3)
        ).to eq [time, time + 1.send(period), time + 2.send(period)]
      end
    end

    it 'iterates every X periods' do
      expect(
        described_class.iterate(time, by: :day, every: 3).take(3)
      ).to eq [time, time + 3.days, time + 6.days]
    end

    it 'does not alter the original time' do
      orig = time.clone
      described_class.iterate(time, by: :day).take(5)
      expect( time ).to eq orig
    end
  end
end
