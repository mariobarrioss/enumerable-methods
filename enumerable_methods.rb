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
      my_each { |element| return false if yield(element) == false }
    else
      my_each { |element| return false if element.nil? || element == false }
    end
    true
  end

  def my_any?
    if block_given?
      my_each { |element| return true if yield(element) }
    else
      my_each { |element| return true if element }
    end
    false
  end

  def my_none?
    if block_given?
      my_each { |element| return false if yield(element) }
    else
      my_each { |element| return false if element }
    end
    true
  end

  def my_count(item = nil)
    counter = 0
    if block_given?
      my_each { |element| counter += 1 if yield(element) }
      counter
    elsif !item.nil?
      my_each { |element| counter += 1 if element == item }
      counter
    else
      size
    end
  end

  def my_map(proc = nil)
    return to_enum unless block_given?

    mapped = []
    my_each do |element|
      mapped << (block_given? ? yield(element) : proc.call)
    end
    mapped
  end

  def my_inject(initial = 0, operation = nil)
    if block_given?
      i = 0
      memo = initial
      while i < size
        memo = yield(memo, self[i])
        i += 1
      end
      memo
    elsif !operation.nil?
      block = case operation
              when Symbol
                ->(accum, value) { accum.send(operation, value) }
              else
                puts 'Invalid operation'
              end

      i = 0
      memo = initial
      while i < size
        memo = block.call(memo, self[i])
        i += 1
      end
      memo
    end
  end
end

def multiply_els(enum)
  enum.my_inject(1, :*)
end
