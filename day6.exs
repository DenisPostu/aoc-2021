defmodule Pod do
  def create(timers), do: timers |> Enum.frequencies()

  def tick(pod, days) do
    Enum.reduce(1..days, pod, fn _, pod -> Pod.tick(pod) end)
  end

  def tick(pod) do
    %{
      0 => Map.get(pod, 1, 0),
      1 => Map.get(pod, 2, 0),
      2 => Map.get(pod, 3, 0),
      3 => Map.get(pod, 4, 0),
      4 => Map.get(pod, 5, 0),
      5 => Map.get(pod, 6, 0),
      6 => Map.get(pod, 7, 0) + Map.get(pod, 0, 0),
      7 => Map.get(pod, 8, 0),
      8 => Map.get(pod, 0, 0)
    }
  end

  def count(pod), do: pod |> Map.values() |> Enum.sum()
end

File.read("./inputs/day6.txt")
|> then(&elem(&1, 1))
|> String.split(",", trim: true)
|> Enum.map(&String.to_integer/1)
|> Pod.create()
|> Pod.tick(256)
|> Pod.count()
|> IO.inspect()
