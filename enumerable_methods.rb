# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    index = 0
    while index < size
      yield(self[index])
      index += 1
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    index = 0
    while index < size
      yield(self[index], index)
      index += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    selected = []
    my_each do |element|
      result = yield(element)
      next unless result

      selected << element
    end
    selected
  end

  def my_all?
    result = false
    if block_given?
      my_each do |element|
        result = yield(element)
      end
    else
      my_each do |element|
        result = true unless element.nil? || element == false
      end
    end
    result
  end
end

test_my_each = [1, 2, 3, 4, 5]
test_my_each_with_index = %w[test for each with index method]
test_my_select = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

#test_my_each.my_each { |el| puts el }
#test_my_each_with_index.my_each_with_index { |el, i| puts "Element = #{el} corresponding index = #{i}" }
#print test_my_select.my_select { |element| element < 8 }
#print %w[ant bear cat].all? { |word| word.length >= 3 } #=> true
