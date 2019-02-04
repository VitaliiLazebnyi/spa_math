# frozen_string_literal: true

class Calculator
  def self.multiple_calc(array_of_arrays)
    unless valid_multiple_input?(array_of_arrays)
      return ['Input is invalid. ' \
              '2 dimensional array of integers is expected ']
    end

    array_of_arrays.map do |arr|
      new(arr).caclulate
    end
  end

  def self.valid_multiple_input?(array_of_arrays)
    array_of_arrays.is_a?(Array) &&
      array_of_arrays&.reject do |el|
        el.is_a? Array
      end&.empty?
  end

  K = 1.5

  def initialize(arr)
    @array = arr
  end

  def caclulate
    return ['Input is invalid.'] unless valid_input?

    { minimum: minimum,
      average: average,
      median: median,
      outliers: outliers }
  end

  def minimum
    @array.min
  end

  def average
    sorted_array.inject(0) { |sum, el| sum + el }.to_f / length
  end

  def median
    length = sorted_array.length
    (sorted_array[(length - 1) / 2] + sorted_array[length / 2]) / 2.0
  end

  def outliers
    [q1 - (1.5 * iqr), q3 + (1.5 * iqr)]
  end

  private

  def valid_input?
    !@array&.empty? && @array&.reject do |el|
      el.to_i == el
    end&.empty?
  end

  def sorted_array
    @sorted_array ||= @array.sort
  end

  def length
    @array.length
  end

  def q1
    @q1 ||= (sorted_array[(length - 1) / 4] + sorted_array[length / 4]) / 2.0
  end

  def q3
    @q3 ||= (sorted_array[(length - 1) / 4 * 3] + sorted_array[length / 4 * 3]) / 2.0
  end

  def iqr
    @iqr ||= q3 - q1
  end
end
