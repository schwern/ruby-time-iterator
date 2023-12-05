require 'rails_helper'

RSpec.describe Time do
  let(:time) { described_class.current }

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

    [ :second, :minute, :hour, :day, :week, :month, :quarter, :year,
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
    let(:time) {
      described_class.current.change(year: 2020, month: 2, day: 5)
    }

    it 'gives the days in the current month' do
      expect( time.days_in_month ).to eq 29
      expect( time.days_in_year ).to eq 366
    end
  end

  describe '#span_to_end_of_today', travel_to: described_class.current do
    it 'creates a span to the end of today' do
      start_span = 7.days.ago
      span = start_span.span_to_end_of_today
      end_span = described_class.current.tomorrow.beginning_of_day

      expect( span.begin ).to eq start_span
      expect( span.end ).to eq end_span
      expect( span ).to be_exclude_end

      # See https://github.com/rubocop-hq/rubocop-rspec/issues/926
      expect( span.cover?(start_span) ).to be_truthy
      expect( span.cover?(end_span) ).to be_falsey
      expect( span.cover?(end_span - 1.second) ).to be_truthy
    end
  end

  describe '#dow' do
    it 'returns the abbreviated day of the week' do
      wednesday = described_class.zone.local(2019, 9, 18)
      expect( wednesday.dow ).to eq 'Wed'
    end
  end

  describe '#iso_date' do
    it 'returns an ISO date' do
      time = described_class.zone.local(2019, 9, 8)
      expect( time.iso_date ).to eq '2019-09-08'
    end
  end

  describe '#human_date' do
    it 'formats the date for humans' do
      sunday = described_class.zone.local(2019, 9, 8)
      expect( sunday.human_date ).to eq 'Sun Sep 8 2019'
    end
  end
end
