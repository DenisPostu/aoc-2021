{:ok, input} = File.read("./inputs/day1-2.txt")

input
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)
|> Enum.chunk_every(3, 1, :discard)
|> Enum.map(fn [a,b,c] -> a + b + c end)
|> Helpers.count_increasing()
|> IO.inspect()
