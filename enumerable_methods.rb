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
    to_a.my_each do |element|
      next unless yield(element)

      selected << element
    end
    selected
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |element| return false unless yield(element) }
    elsif arg.nil?
      my_each { |element| return false unless element }
    else
      my_each { |element| return false unless check_arg(element, arg) }
    end
    true
  end

  def my_any?(arg = nil, &block)
    if block_given?
      my_each { |element| return true if block.call(element) }
    elsif arg.nil?
      my_each { |element| return true if element }
    else
      my_each { |element| return true if check_arg(element, arg) }
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(item = nil)
    counter = 0
    if block_given?
      my_each { |element| counter += 1 if yield(element) }
      counter
    elsif item
      my_each { |element| counter += 1 if element == item }
      counter
    else
      size
    end
  end

  def my_map(proc = nil)
    return to_enum unless block_given?

    mapped = []
    to_a.my_each do |element|
      mapped << (block_given? ? yield(element) : proc.call)
    end
    mapped
  end

  def my_inject(*args)
    enum = to_a.dup
    if block_given?
      memo =
        args[0] || enum.shift
      enum.my_each { |element| memo = yield(memo, element) }
      memo
    else
      my_inject_helper(args, enum)
    end
  end

  private

  # rubocop:disable Style/CaseEquality
  def check_arg(item, argument)
    if argument.class == Class
      item.class.ancestors.include? argument
    else
      item === argument
    end
  end
  # rubocop:enable Style/CaseEquality

  def my_inject_helper(args, enum)
    if args[0] && args[1]
      memo = args[0]
      enum.my_each { |element| memo = memo.send(args[1], element) }
    elsif args[0].is_a? Symbol
      memo = enum.shift
      enum.my_each { |element| memo = memo.send(args[0], element) }
    end
    memo
  end
end

def multiply_els(enum)
  enum.my_inject(:*)
end
