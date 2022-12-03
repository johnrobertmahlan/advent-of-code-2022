require 'pry'

LOWER_CASE_PRIORITY_MAPPING = ("a".."z").to_a
UPPER_CASE_PRIORITY_MAPPING = ("A".."Z").to_a

class Rucksack
  def initialize(contents)
    @contents = contents
  end

  def contents
    @contents
  end
end

class GroupOfElves
  def initialize(rucksacks)
    @rucksacks = rucksacks
  end

  def find_common_item
    three_sacks = @rucksacks.map do |rucksack|
      rucksack.contents
    end

    three_sacks.first.each_char.select {|c| three_sacks[1].each_char.include?(c) && three_sacks.last.include?(c)}.uniq.first
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

  def self.generate_groups(rucksacks)
    groups = Array.new

    while rucksacks.count > 0
      three = rucksacks.take(3)
      groups.push(GroupOfElves.new(three))
      rucksacks = rucksacks - three
    end

    groups
  end

  def self.run(groups)
    priority = groups.reduce(0) do |total, group|
      common_item = group.find_common_item

      total += group.determine_priority(common_item)

      total
    end

    puts priority
  end
end

rucksacks = Calculate.ingest_input

groups = Calculate.generate_groups(rucksacks)

Calculate.run(groups)