{:ok, input} = File.read("./inputs/day2-2.txt")

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
|> List.foldl([0, 0, 0], fn ([direction, value], [distance, depth, aim]) ->
  case direction do
    :up -> [distance, depth, aim - value]
    :down -> [distance, depth, aim + value]
    :forward -> [distance + value, depth + aim * value, aim]
  end
end)
|> fn [distance, depth, aim] -> distance * depth end.()
|> IO.inspect()
