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
end

test = [1, 2, 3, 4, 5]
test2 = %w[test for each with index method]

test.my_each { |el| puts el }
test2.my_each_with_index { |el, i| puts "Element = #{el} correspondign index = #{i}" }
