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

RESULT_MAPPER = {
  'X' => 'lose',
  'Y' => 'draw',
  'Z' => 'win'
}

WIN_MAPPER = {
  'A' => 'Y',
  'B' => 'Z',
  'C' => 'X'
}

DRAW_MAPPER = {
  'A' => 'X',
  'B' => 'Y',
  'C' => 'Z'
}

LOSE_MAPPER = {
  'A' => 'Z',
  'B' => 'X',
  'C' => 'Y'
}

class Game
  def initialize(throws)
    @my_throw = throws[0]
    @opponent_throw = throws[1]
  end

  def determine_winner
    RESULT_MAPPER[@my_throw]
  end

  def determine_my_throw(result)
    case result
    when 'win'
      WIN_MAPPER[@opponent_throw]
    when 'lose'
      LOSE_MAPPER[@opponent_throw]
    else
      DRAW_MAPPER[@opponent_throw]
    end
  end

  def determine_points(winner)
    my_throwww = determine_my_throw(winner)

    points_for_throw = THROW_POINT_MAPPER[my_throwww]
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