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
    if block_given?
      my_each do |element|
        result = yield(element)
        return false if result == false
      end
    else
      my_each do |element|
        return false if element.nil? || element == false
      end
    end
    true
  end

  def my_any?
    if block_given?
      my_each do |element|
        result = yield(element)
        return true if result == true
      end
    else
      my_each do |element|
        return true if element == true
      end
    end
    false
  end

  def my_none?
    if block_given?
      my_each do |element|
        result = yield(element)
        return false if result == true
      end
    else
      my_each do |element|
        return false if element == true
      end
    end
    true
  end
end

test_my_each = [1, 2, 3, 4, 5]
test_my_each_with_index = %w[test for each with index method]
test_my_select = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

#test_my_each.my_each { |el| puts el }
#test_my_each_with_index.my_each_with_index { |el, i| puts "Element = #{el} corresponding index = #{i}" }
#print test_my_select.my_select { |element| element < 8 }
# tests for my_all?
#puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
#puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
#puts [nil, true, 99].my_all?                              #=> false
#puts [].my_all?                                           #=> true
# tests for my_any
#puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
#puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
#puts [nil, true, 99].my_any?                              #=> true
#puts [].my_any?                                           #=> false
# tests for my_none?
#puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
#puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
#puts [].my_none?                                           #=> true
#puts [nil].my_none?                                        #=> true
#puts [nil, false].my_none?                                 #=> true
#puts [nil, false, true].my_none?                           #=> false
