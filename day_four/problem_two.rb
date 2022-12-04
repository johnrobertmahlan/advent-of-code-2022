require 'pry'

class PairOfElves
  def initialize(sections)
    @sections = sections
    @first_elf = sections.split(",").first
    @second_elf = sections.split(",").last
  end

  def normalize_sections
    first_section = @first_elf.split("-").map {|n| n.to_i}
    second_section = @second_elf.split("-").map {|n| n.to_i}

    [first_section, second_section]
  end

  def compare_sections(first_section, second_section)
    return true if first_overlaps_second?(first_section, second_section)
    return true if first_overlaps_second?(second_section, first_section)

    false
  end

  def first_overlaps_second?(first_section, second_section)
    first_range = (first_section.first..first_section.last).to_a
    second_range = (second_section.first..second_section.last).to_a

    return false if first_range - second_range == first_range

    true
  end
end

module Calculator
  def self.ingest_data
    File.open("input.txt").map do |f|
      PairOfElves.new(f.gsub(/\n/, ""))
    end
  end

  def self.run(pairs)
    overlaps = pairs.reduce(0) do |count, pair|
      first_section, second_section = pair.normalize_sections

      count += 1 if pair.compare_sections(first_section, second_section)

      count
    end

    puts overlaps
  end
end

pairs = Calculator.ingest_data

Calculator.run(pairs)