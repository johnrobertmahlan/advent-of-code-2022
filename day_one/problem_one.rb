require 'pry'

class Elf
  def initialize(calories:)
    @calories = calories
  end

  def total_calories
    @calories.split.map(&:to_i).reduce(:+)
  end
end

class Find
  def initialize(elves)
    @elves = elves
  end

  def find_elf_with_most_calories
    @elves.max_by {|elf| elf.total_calories}
  end

  def spit_out_max_calories(elf)
    elf.total_calories
  end
end

elves = File.read("input.txt").split("\n\n")

elves = elves.each_with_index.map do |calories, idx|
  Elf.new(calories: calories)
end

found_elves = Find.new(elves)

max_elf = found_elves.find_elf_with_most_calories

puts found_elves.spit_out_max_calories(max_elf)