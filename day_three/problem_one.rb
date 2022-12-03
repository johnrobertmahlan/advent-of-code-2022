require 'pry'

LOWER_CASE_PRIORITY_MAPPING = ("a".."z").to_a
UPPER_CASE_PRIORITY_MAPPING = ("A".."Z").to_a

class Rucksack
  def initialize(contents)
    @contents = contents
  end

  def split_compartments
    len = @contents.length
    midpoint = (len / 2) - 1

    first_compartment = @contents[0..midpoint]
    second_compartment = @contents[midpoint+1..-1]

    [first_compartment, second_compartment]
  end

  def find_common_item(first_compartment, second_compartment)
    first_compartment.each_char.select { |c| second_compartment.include?(c) }.uniq.first
  end

  def determine_priority(common_item)
    if LOWER_CASE_PRIORITY_MAPPING.include?(common_item)
      LOWER_CASE_PRIORITY_MAPPING.index(common_item) + 1
    else
      UPPER_CASE_PRIORITY_MAPPING.index(common_item) + 27
    end
  end
end

module Calculate
  def self.ingest_input
    rucksacks = Array.new

    rucksacks = File.read("input.txt").split("\n").map do |r|
      Rucksack.new(r)
    end

    rucksacks
  end

  def self.run(rucksacks)
    rucksacks.reduce(0) do |total, rucksack|
      first, second = rucksack.split_compartments
      common_item = rucksack.find_common_item(first, second)
      priority = rucksack.determine_priority(common_item)

      total += priority

      total
    end
  end
end

rucksacks = Calculate.ingest_input

total_priority = Calculate.run(rucksacks)

puts total_priority