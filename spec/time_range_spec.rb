require "time_range"

RSpec.describe(TimeRange) do
  let(:first) { Time.local(2024, 2, 20) }
  let(:last) { Time.local(2024, 3, 20, 9, 8, 7) }
  let(:by) do
    { weeks: 1 }
  end
  let(:range) { described_class.new(first, last).by(**by) }

  shared_examples 'a Range' do
    it 'isa Range' do
      expect(range).to be_a(Range)
    end

    describe '#eql?' do
      subject { range.eql?(other_range) }

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
  end

  shared_examples 'it has a begin' do
    it 'has a begin' do
      expect(range.begin).to eq first
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
  end

  shared_examples 'it has an end' do
    it 'has an end' do
      expect(range.end).to eq last
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
  end

  context 'with no start' do
    let(:first) { nil }

    it_behaves_like 'a Range'

    it 'has no begin' do
      expect(range.begin).to be_nil
    end

    it_behaves_like 'it has an end'
  end

  context 'with no end' do
    let(:last) { nil }

    it_behaves_like 'a Range'
    it_behaves_like 'it has a begin'

    it 'has no end' do
      expect(range.end).to be_nil
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

    it '#count' do
      expect(range.count).to eq entries.size
    end

    it '#entries' do
      expect(range.entries).to eq entries
    end
  end
end
