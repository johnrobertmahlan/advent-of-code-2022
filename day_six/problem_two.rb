require 'pry'

str = File.read("input.txt")

idx = 0

loop do
  if str.chars.take(14).tally.values.all? {|v| v == 1}
    idx += 14
    break
  else
    str[0] = ""
    idx += 1
  end
end

puts idx