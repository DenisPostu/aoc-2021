{:ok, input} = File.read("./inputs/day3.txt")

sum_by_position = fn a, b ->
  Enum.zip(a, b)
  |> Enum.map(fn { a, b } -> a + b end)
end

count_frequencies = fn ones_and_zeroes ->
  %{
    :count => Enum.count(ones_and_zeroes),
    :frequencies => List.foldl(ones_and_zeroes, List.duplicate(0, Enum.count(hd(ones_and_zeroes))), sum_by_position)
  }
end

compute_rates = fn %{ count: count, frequencies: frequencies } ->
  frequencies
  |> List.foldl(%{ gamma: 0, epsilon: 0 }, fn bit, %{ gamma: gamma, epsilon: epsilon } ->
    %{
      :gamma => gamma * 2 + (if bit >= count / 2, do: 1, else: 0),
      :epsilon => epsilon * 2 + (if bit >= count / 2, do: 0, else: 1)
    }
  end)
end

compute_power_consumption = fn %{ gamma: gamma, epsilon: epsilon } ->
  gamma * epsilon
end

input
|> String.split("\n", trim: true)
|> Enum.map(&String.graphemes/1)
|> Enum.map(fn bits -> Enum.map(bits, &String.to_integer/1) end)
|> count_frequencies.()
|> compute_rates.()
|> compute_power_consumption.()
|> IO.inspect()
