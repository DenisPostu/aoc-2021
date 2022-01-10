defmodule Helpers do
  def count_increasing(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end
end

File.read("./inputs/day1.txt")
|> then(&elem(&1, 1))
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)
|> Helpers.count_increasing()
|> IO.puts()
