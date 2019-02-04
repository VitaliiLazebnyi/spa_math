# frozen_string_literal: true

describe Calculator do
  describe 'singular canlculations' do
    let(:math) { Calculator.new([1, 2, 3, 4, 5]) }
    let(:outliers) { Calculator.new([1, 99, 100, 101, 103, 109, 110, 201]) }

    it 'minimum' do
      expect(math.minimum).to eq 1
    end

    it 'average' do
      expect(math.average).to eq 3.0
    end

    it 'median' do
      expect(math.median).to eq 3
    end

    it 'outliers' do
      expect(outliers.outliers).to eq [90.5, 114.5]
    end

    it 'caclulate' do
      expected = { average: 103.0,
                   median: 102.0,
                   minimum: 1,
                   outliers: [90.5, 114.5] }
      expect(outliers.caclulate).to eq expected
    end

    it 'expect valid error message for empty array' do
      expect(Calculator.new([]).caclulate)
        .to eq ['Input is invalid.']
    end

    it 'expect valid error message for invalid values' do
      expect(Calculator.new(['a']).caclulate)
        .to eq ['Input is invalid.']
    end
  end

  describe 'multiple calculations' do
    let(:error) do
      ['Input is invalid. ' \
      '2 dimensional array of integers is expected ']
    end

    it 'expect valid multiple calculations' do
      expect(Calculator.multiple_calc([[1, 2], [2, 3]]))
        .to eq [{ average: 1.5,
                  median: 1.5,
                  minimum: 1,
                  outliers: [1.0, 1.0] },
                { average: 2.5,
                  median: 2.5,
                  minimum: 2,
                  outliers: [2.0, 2.0] }]
    end

    it 'valid error message for empty parameter' do
      expect(Calculator.multiple_calc(nil))
        .to eq error
    end

    it 'valid error message for invalid parameter' do
      expect(Calculator.multiple_calc('dddd'))
        .to eq error
    end

    it 'empty array is processed properly' do
      expect(Calculator.multiple_calc([]))
        .to eq []
    end

    it 'valid error message when some subarray is invalid' do
      expect(Calculator.multiple_calc([[]]))
        .to eq [['Input is invalid.']]
    end
  end
end
