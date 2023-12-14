RSpec.describe Time::Iterator do
  let(:time) { Time.now }

  describe '#quarter(s)' do
    [:quarter, :quarters].each do |method|
      it 'adds 3 months per quarter' do
        expect( time + 1.send(method) ).to eq time + 3.months
        expect( time + 3.send(method) ).to eq time + 9.months
        expect( time + 4.send(method) ).to eq time + 1.year
      end
    end
  end

  describe 'period check' do
    it 'raises on invalid period' do
      expect { time.beginning_of(:time) }.to raise_error(ArgumentError)
      expect { time.end_of(:universe) }.to raise_error(ArgumentError)
      expect { time.iterate(by: :colors) }.to raise_error(ArgumentError)
    end
  end

  describe '#beginning_of' do
    periods2methods = {
      minute: :beginning_of_minute,
      hour: :beginning_of_hour,
      day: :beginning_of_day,
      week: :beginning_of_week,
      month: :beginning_of_month,
      quarter: :beginning_of_quarter,
      year: :beginning_of_year
    }.freeze

    periods2methods.each do |period, method|
      it "handles #{period}" do
        expect(time.beginning_of(period)).to eq time.send(method)
      end
    end
  end

  describe '#end_of' do
    periods2methods = {
      minute: :end_of_minute,
      hour: :end_of_hour,
      day: :end_of_day,
      week: :end_of_week,
      month: :end_of_month,
      quarter: :end_of_quarter,
      year: :end_of_year
    }.freeze

    periods2methods.each do |period, method|
      it "handles #{period}" do
        expect(time.end_of(period)).to eq time.send(method)
      end
    end
  end

  describe '#iterate' do
    it 'uses an Enumerator' do
      expect( time.iterate(by: :day) ).to be_a(Enumerator)
    end

    [
      :second, :minute, :hour, :day, :week, :month, :quarter, :year,
      :seconds, :minutes, :hours, :days, :weeks, :months, :quarter, :years
    ].each do |period|
      it "iterates by #{period}" do
        expect(
          time.iterate(by: period).take(3)
        ).to eq [time, time + 1.send(period), time + 2.send(period)]
      end
    end

    it 'iterates every X periods' do
      expect(
        time.iterate(by: :day, every: 3).take(3)
      ).to eq [time, time + 3.days, time + 6.days]
    end

    it 'does not alter the original time' do
      orig = time.clone
      time.iterate(by: :day).take(5)
      expect( time ).to eq orig
    end
  end

  describe '#days_in_month/year' do
    # Make sure it's accounting for a leap year
    let(:time) do
      Time.now.change(year: 2020, month: 2, day: 5)
    end

    it 'gives the days in the current month' do
      expect( time.days_in_month ).to eq 29
      expect( time.days_in_year ).to eq 366
    end
  end

  describe '#span_to_end_of_today', travel_to: Time.now do
    let(:span_begin) { 7.days.ago }
    let(:span_end) { Time.now.tomorrow.beginning_of_day }
    let(:span) { span_begin.span_to_end_of_today }

    it 'creates an excluding span to the end of today' do
      expect( span.begin ).to eq span_begin
      expect( span.end ).to eq span_end
      expect( span ).to be_exclude_end
    end

    it 'covers from the start and excluding the end' do
      # See https://github.com/rubocop-hq/rubocop-rspec/issues/926 for why it isn't using to include.
      # See https://github.com/rubocop/rubocop-rspec/issues/466 for why its disabled (be_cover(start_span))
      # rubocop:disable RSpec/PredicateMatcher
      expect( span.cover?(span_begin) ).to be_truthy
      expect( span.cover?(span_end) ).to be_falsey
      expect( span.cover?(span_end - 1.second) ).to be_truthy
      # rubocop:enable RSpec/PredicateMatcher
    end
  end

  describe '#dow' do
    it 'returns the abbreviated day of the week' do
      wednesday = Time.local(2019, 9, 18)
      expect( wednesday.dow ).to eq 'Wed'
    end
  end

  describe '#iso_date' do
    it 'returns an ISO date' do
      time = Time.local(2019, 9, 8)
      expect( time.iso_date ).to eq '2019-09-08'
    end
  end

  describe '#human_date' do
    it 'formats the date for humans' do
      sunday = Time.local(2019, 9, 8)
      expect( sunday.human_date ).to eq 'Sun Sep 8 2019'
    end
  end
end
