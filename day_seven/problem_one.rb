require 'pry'

data = File.readlines("input.txt")

directories = {"home" => []}

def find_the_directories(data, directories)
  dirs = data.select {|d| d.match(/dir/)}
  dirs.each do |d|
    dirname = d.gsub("\n", "").match(/(?<dirname>\w$)/)
    dirname = dirname[:dirname]
    directories[dirname] = Array.new
  end
end

find_the_directories(data, directories)

def find_where_each_directory_starts(data)
  indices = data.each_with_index.reduce([]) do |indices, line|
    real = line.first.gsub("\n", "")
    indices.push(line.last) if real.match(/ls$/)

    indices
  end

  indices.push(data.length)
end

indices = find_where_each_directory_starts(data)

def find_contents_of_each_directory(data, indices, directories)
#   binding.pry
  contents = indices.each_cons(2).map do |stuff|
    binding.pry if data[stuff.first + 1..stuff.last - 1] == []
    data[stuff.first + 1..stuff.last - 1]
  end

  directories["home"] = contents.first

  contents.each_with_index do |content, idx|
    last = content.last.gsub("\n", "")
    binding.pry if content.last.nil?
    if last.match(/cd \w$/)
      new_dir = last.match(/(?<dirname>\w$)/)
      new_dir = new_dir[:dirname]
      directories[new_dir] = contents[idx + 1]
    else
      puts "figure this out #{idx}"
    end
  end

  directories
end

find_contents_of_each_directory(data, indices, directories)

def is_a_bottom_level_dir?(contents)
  contents.select {|c| c.match(/^dir/)}.empty?
end

def calculate_directory_size(directories, contents)
  total_size = contents.each.reduce(0) do |total_size, content|
    files = contents.select {|c| c.match(/^\d+/)}
    dirname = directories.key(contents)

    #BASE CASE
    if is_a_bottom_level_dir?(contents)
      total_size += calculate_file_sizes(files)
      return total_size
    #RECURSIVE CASE
    else
      subdirs = contents.select {|c| c.match(/^dir/)}
      subdirs = subdirs.map {|d| d.gsub("\n", "").scan(/\w$/)}.flatten
      subdirs = directories.select {|k, v| subdirs.include?(k)}
      subdirs.each_value do |subdir|
        total_size += calculate_directory_size(directories, subdir)
      end
      total_size += calculate_file_sizes(files)
      return total_size
    end
  end
end

def calculate_file_sizes(files)
  file_sizes = files.reduce(0) do |total_size, file|
    size = file.match(/^(?<size>\d+)/)
    size = size[:size].to_i

    total_size += size

    total_size
  end

  file_sizes
end

sums = directories.each_value.reduce(0) do |total, directory|
  size = calculate_directory_size(directories, directory)

  total += size unless size > 100000

  total
end

puts sums