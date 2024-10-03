require "time_range"

RSpec.describe(TimeRange) do
  let(:first) { Time.local(2024, 2, 20) }
  let(:last) { Time.local(2024, 3, 20, 9, 8, 7) }
  let(:by) do
    { weeks: 1 }
  end
  let(:range) { described_class.new(first, last).by(**by) }

  shared_examples 'it is infinite' do
    describe '#count' do
      subject { range.count }

      it { is_expected.to eq Float::INFINITY }
    end
  end

  shared_examples 'a Range' do
    it 'isa Range' do
      expect(range).to be_a(Range)
    end

    describe '#eql?' do
      subject { range.eql?(other_range) }

      context 'when the other is not a TimeRange' do
        let(:other_range) { Range.new(1, 5) }

        it { is_expected.to be false }
      end

      context 'when the other range is the same' do
        let(:other_range) { described_class.new(first, last).by(**by) }

        it { is_expected.to be true }
      end

      context 'when the other range has a different start' do
        let(:other_range) { described_class.new(Time.now, last).by(**by) }

        it { is_expected.to be false }
      end

      context 'when the other range has a different end' do
        let(:other_range) { described_class.new(first, Time.now).by(**by) }

        it { is_expected.to be false }
      end

      context 'when the other range has a different by' do
        let(:other_range) { described_class.new(first, last).by(minutes: 42) }

        it { is_expected.to be false }
      end
    end

    describe '#hash' do
      subject { range.hash == other_range.hash }

      context 'when the other range is the same' do
        let(:other_range) { described_class.new(first, last).by(**by) }

        it { is_expected.to be true }
      end

      context 'when the other range has a different by' do
        let(:other_range) { described_class.new(first, last).by(minutes: 42) }

        it { is_expected.to be false }
      end
    end

    describe '#inspect' do
      subject { range.inspect }

      it { is_expected.to include by.inspect }
    end

    describe '#size' do
      subject { range.size }

      it { is_expected.to be_nil }
    end
  end

  shared_examples 'it has a begin' do
    describe '#begin' do
      it 'has a begin' do
        expect(range.begin).to eq first
      end
    end

    describe '#first' do
      it 'has a first' do
        expect(range.first).to eq first
      end
    end

    describe '#cover?' do
      subject { range.cover?(item) }

      context 'with an item before the first' do
        let(:item) { first - 1 }

        it { is_expected.to be false }
      end

      context 'with the first item' do
        let(:item) { first }

        it { is_expected.to be true }
      end

      context 'with an item after the first' do
        let(:item) { first + 1 }

        it { is_expected.to be true }
      end
    end

    describe '#inspect' do
      subject { range.inspect }

      it { is_expected.to include first.inspect }
    end

    describe '#min' do
      subject { range.min }

      it { is_expected.to eq first }
    end
  end

  shared_examples 'it has an end' do
    describe '#end' do
      it 'has an end' do
        expect(range.end).to eq last
      end
    end

    describe '#last' do
      it 'has a last value' do
        expect(range.last).to eq last
      end
    end

    describe '#cover?' do
      subject { range.cover?(item) }

      context 'with an item before the last' do
        let(:item) { last - 1 }

        it { is_expected.to be true }
      end

      context 'with the last item' do
        let(:item) { last }

        it { is_expected.to be true }
      end

      context 'with an item after the last' do
        let(:item) { last + 1 }

        it { is_expected.to be false }
      end
    end

    describe '#inspect' do
      subject { range.inspect }

      it { is_expected.to include last.inspect }
    end

    describe '#max' do
      subject { range.max }

      it { is_expected.to eq last }
    end
  end

  context 'with no begin' do
    let(:first) { nil }

    it_behaves_like 'a Range'
    it_behaves_like 'it has an end'
    it_behaves_like 'it is infinite'

    it 'has no begin' do
      expect(range.begin).to be_nil
    end

    describe '#first' do
      it 'raises' do
        expect {
          range.first
        }.to raise_error(RangeError, /cannot get the first element of beginless range/)
      end
    end

    describe '#entries' do
      it 'raises' do
        expect {
          range.entries
        }.to raise_error(TypeError, /can't iterate from NilClass/)
      end
    end

    describe '#min' do
      it 'raises' do
        expect {
          range.min
        }.to raise_error(RangeError, /cannot get the minimum of beginless range/)
      end
    end
  end

  context 'with no end' do
    let(:last) { nil }

    it_behaves_like 'a Range'
    it_behaves_like 'it has a begin'
    it_behaves_like 'it is infinite'

    it 'has no end' do
      expect(range.end).to be_nil
    end

    describe '#last' do
      it 'raises' do
        expect {
          range.last
        }.to raise_error(RangeError, /cannot get the last element of endless range/)
      end
    end

    describe '#entries' do
      it 'raises' do
        expect {
          range.entries
        }.to raise_error(RangeError, /cannot convert endless range to an array/)
      end
    end

    describe '#max' do
      it 'raises' do
        expect {
          range.max
        }.to raise_error(RangeError, /cannot get the maximum of endless range/)
      end
    end
  end

  context 'with a start and end' do
    let(:entries) do
      [
        Time.local(2024, 2, 20),
        Time.local(2024, 2, 27),
        Time.local(2024, 3, 5),
        Time.local(2024, 3, 12),
        Time.local(2024, 3, 19)
      ]
    end

    it_behaves_like 'a Range'
    it_behaves_like 'it has a begin'
    it_behaves_like 'it has an end'

    describe '#%' do
      it 'skips entries' do
        expect( range.%(2).to_a ).to eq [entries[0], entries[2], entries[4]]
      end
    end

    describe '#count' do
      subject { range.count }

      it { is_expected.to eq entries.size }
    end

    describe '#entries' do
      subject { range.entries }

      it { is_expected.to eq entries }
    end
  end
end
