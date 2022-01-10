defmodule Helpers do
  def count_increasing(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a,b] -> a < b end)
  end
end
