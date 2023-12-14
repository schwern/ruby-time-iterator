RSpec.describe Numeric do
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
end
