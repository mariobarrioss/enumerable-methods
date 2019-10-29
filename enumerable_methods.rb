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

  def my_count(item = nil)
    if block_given?
      counter = 0
      my_each do |element|
        result = yield(element)
        counter += 1 if result == true
      end
      counter
    elsif !item.nil?
      counter = 0
      my_each do |element|
        counter += 1 if element == item
      end
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
