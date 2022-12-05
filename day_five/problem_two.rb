require 'pry'

class Stack
  def initialize(crates)
    @crates = crates
  end

  def arrange_crates
    crates = @crates.compact
    crates = crates.reverse

    while crates.last == ""
      crates.pop
    end

    crates
  end
end

module Calculator
  def self.generate_stacks
    file = File.readlines("input.txt")
    num_stacks = file.index("\n")

    total_stacks = []

    num_stacks.times do |time|
      total_stacks.push(Array.new)
    end

    total_stacks
  end

  def self.get_stacks(total_stacks)
    File.open("input.txt").each do |f|
      next if f.include?("move")
      parsed_f = f.split(/\s/)

      row_count = 1
      loop do
          col = parsed_f[0]
          if col == ""
            total_stacks[row_count - 1].push(col)
            row_count += 1
            4.times do
              parsed_f.shift
            end
          else
            total_stacks[row_count - 1].push(col)
            row_count += 1
            parsed_f.shift
          end
          break if row_count > total_stacks.count
        end
    end

    total_stacks = total_stacks.map do |stacks|
      stacks.compact
    end

    total_stacks.each do |stack|
      stack.pop
    end

    total_stacks = total_stacks.map do |stack|
      Stack.new(stack)
    end

    total_stacks
  end

  def self.get_instructions
    instructions = []

    File.open("input.txt").each do |f|
      next unless f.include?("move")

      instructions.push(f)
    end

    instructions
  end

  def self.arrange_crates(stacks)
    stacks = stacks.map do |stack|
      stack.arrange_crates
    end

    stacks
  end

  def self.follow_instructions(instructions, stacks)
    instructions.each do |instruction|
      moves = instruction.scan(/\d+/)

      number_of_crates_to_move = moves.first.to_i
      stack_to_move_from = moves[1].to_i - 1
      stack_to_move_to = moves.last.to_i - 1

      temp_stack = []

      number_of_crates_to_move.times do |time|
        popped = stacks[stack_to_move_from].pop
        temp_stack.push(popped)
      end

      number_of_crates_to_move.times do |time|
        popped = temp_stack.pop
        stacks[stack_to_move_to].push(popped)
      end
    end

    stacks
  end

  def self.get_top_crates(stacks)
    top_crates = stacks.map do |stack|
      stack.last
    end

    puts top_crates.join.gsub(/\[|\]/, "")
  end
end

total_stacks = Calculator.generate_stacks

stacks = Calculator.get_stacks(total_stacks)

arranged_crates = Calculator.arrange_crates(stacks)

instructions = Calculator.get_instructions

rearranged_stacks = Calculator.follow_instructions(instructions, arranged_crates)

Calculator.get_top_crates(rearranged_stacks)