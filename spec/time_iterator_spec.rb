RSpec.describe TimeIterator do
  let(:time) { Time.gm(2000, 1, 1, 0, 0, 0) }

  describe '.iterate' do
    it 'uses an Enumerator' do
      expect(
        described_class.iterate(time, by: ActiveSupport::Duration.days(1))
      ).to be_a(Enumerator)
    end

    it 'raises on an invalid `by`' do
      expect {
        described_class.iterate(time, by: :colors)
      }.to raise_error(ArgumentError)
    end

    it "iterates" do
      expect(
        described_class.iterate(
          Time.gm(2000, 1, 1), by: ActiveSupport::Duration.days(3)
        ).take(3)
      ).to eq [
        Time.gm(2000, 1, 1),
        Time.gm(2000, 1, 4),
        Time.gm(2000, 1, 7)
      ]
    end

    it 'does not alter the original time' do
      orig = time.clone
      described_class.iterate(time, by: ActiveSupport::Duration.weeks(2)).take(5)
      expect( time ).to eq orig
    end
  end
end
