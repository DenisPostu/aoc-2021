{:ok, input} = File.read("./inputs/day2.txt")

parse_direction = fn direction ->
  case direction do
    "up" -> :up
    "down" -> :down
    "forward" -> :forward
  end
end

parse_command = fn command ->
  [direction, value] = String.split(command, " ")
  [parse_direction.(direction), String.to_integer(value)]
end

input
|> String.split("\n", trim: true)
|> Enum.map(parse_command)
|> List.foldl([0, 0], fn ([direction, value], [distance, depth]) ->
  case direction do
    :up -> [distance, depth - value]
    :down -> [distance, depth + value]
    :forward -> [distance + value, depth]
  end
end)
|> fn [distance, depth] -> distance * depth end.()
|> IO.inspect()
