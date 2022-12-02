require 'pry'

THROW_POINT_MAPPER = {
  'X' => 1,
  'Y' => 2,
  'Z' => 3
}

RESULT_POINT_MAPPER = {
  'win'     => 6,
  'draw'    => 3,
  'lose'    => 0
}

WIN_CONDITIONS = {
  'X' => 'C',
  'Y' => 'A',
  'Z' => 'B'
}

DRAW_CONDITIONS = {
  'A' => 'X',
  'B' => 'Y',
  'C' => 'Z'
}

class Game
  def initialize(throws)
    @my_throw = throws[0]
    @opponent_throw = throws[1]
  end

  def determine_winner
    return "draw" if DRAW_CONDITIONS[@opponent_throw] == @my_throw

    WIN_CONDITIONS[@my_throw] == @opponent_throw ? "win" : "lose"
  end

  def determine_points(winner)
    points_for_throw = THROW_POINT_MAPPER[@my_throw]
    points_for_result = RESULT_POINT_MAPPER[winner]

    points_for_throw + points_for_result
  end
end

module Calculator
  def self.ingest_input
    games = Array.new

    File.read("input.txt").split("\n").each do |game|
        games.push(Game.new(game.reverse.gsub("\s", "")))
    end

    games
  end

  def self.determine_total_points(games)
    games.reduce(0) do |total, game|
      winner = game.determine_winner

      points = game.determine_points(winner)

      total += points

      total
    end
  end
end

games = Calculator.ingest_input

total_points = Calculator.determine_total_points(games)

puts total_points