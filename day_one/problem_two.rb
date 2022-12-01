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

  def find_three_elves_with_most_calories
    @elves.sort_by {|elf| elf.total_calories}.reverse.take(3)
  end

  def spit_out_max_calories(elves)
    calories = elves.reduce(0) do |total_calories, elf|
      total_calories += elf.total_calories
      total_calories
    end

    calories
  end
end

elves = File.read("input.txt").split("\n\n")

elves = elves.each_with_index.map do |calories, idx|
  Elf.new(calories: calories)
end

found_elves = Find.new(elves)

three_elves = found_elves.find_three_elves_with_most_calories

puts found_elves.spit_out_max_calories(three_elves)