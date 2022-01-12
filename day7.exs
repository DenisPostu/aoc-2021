defmodule Inputs do
  def small, do: "16,1,2,0,4,2,7,1,2,14"
end

defmodule Crabs do
  # calculates the best fuel consumption possible to align all crabs at the same position
  # does so inefficiently by checking each the fuel cost of each position
  # in the range min(crabs) -> max(crabs)
  def get_best_fuel_to_align(crabs) do
    Enum.min(crabs)..Enum.max(crabs)
    |> Enum.map(&get_fuel_to_align(&1, crabs))
    |> Enum.min()
  end

  # calculates the fuel cost of moving a single crab
  # from position 'from' to position 'to'
  defp get_fuel_to_align(from, to) when is_integer(from) and is_integer(to) do
    abs(from - to)
  end

  # calculates the fuel cost of moving all crabs in list
  # to position 'target'
  defp get_fuel_to_align(target, crabs) do
    crabs
    |> Enum.map(&get_fuel_to_align(&1, target))
    |> Enum.sum()
  end
end

Inputs.small()
|> String.split(",")
|> Enum.map(&String.to_integer/1)
|> IO.inspect()
|> Crabs.get_best_fuel_to_align()
|> IO.inspect()
