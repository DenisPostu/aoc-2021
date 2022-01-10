defmodule ALUParser do
  def parse_instruction("inp " <> register), do: {:read, String.to_atom(register)}
  def parse_instruction("mul " <> params), do: to_binary_instruction(&*/2, params)
  def parse_instruction("add " <> params), do: to_binary_instruction(&+/2, params)
  def parse_instruction("mod " <> params), do: to_binary_instruction(&rem/2, params)
  def parse_instruction("div " <> params), do: to_binary_instruction(&div/2, params)
  def parse_instruction("eql " <> params), do: to_binary_instruction(&eql/2, params)

  defp to_binary_instruction(op, params) do
    [register, register_or_value] = params |> String.split()

    {:exec, String.to_atom(register), op, to_register_or_value(register),
     to_register_or_value(register_or_value)}
  end

  defp to_register_or_value(register_or_value) do
    if is_register(register_or_value) do
      register = String.to_atom(register_or_value)
      fn cpu -> cpu[register] end
    else
      number = String.to_integer(register_or_value)
      fn _ -> number end
    end
  end

  defp is_register("w"), do: true
  defp is_register("x"), do: true
  defp is_register("y"), do: true
  defp is_register("z"), do: true
  defp is_register(_), do: false

  defp eql(a, b) when a == b, do: 1
  defp eql(a, b) when a != b, do: 0
end

defmodule ALUValidator do
  def is_valid(instructions, serial) do
    IO.inspect(serial)
    is_valid_internal(instructions, serial, %{w: 0, x: 0, y: 0, z: 0})
  end

  defp is_valid_internal(_, [0 | _], _), do: false
  defp is_valid_internal([], _, %{:z => 0}), do: true
  defp is_valid_internal([], _, %{:z => _}), do: false

  defp is_valid_internal([{:read, r} | instructions], [input | serial], cpu),
    do: is_valid_internal(instructions, serial, %{cpu | r => input})

  defp is_valid_internal([{:exec, r, op, a, b} | instructions], serial, cpu),
    do: is_valid_internal(instructions, serial, %{cpu | r => op.(a.(cpu), b.(cpu))})
end

instructions =
  File.read("./inputs/day24.txt")
  |> then(&elem(&1, 1))
  |> String.split("\n", trim: true)
  |> Enum.map(&ALUParser.parse_instruction/1)

IO.puts("Instructions parsed..")

Range.new(999_999_999_999_99, 111_111_111_111_11, -1)
|> Stream.map(fn n ->
  n |> to_string |> String.graphemes() |> Enum.map(&String.to_integer/1)
end)
|> Stream.filter(&ALUValidator.is_valid(instructions, &1))
|> Enum.take(1)
|> IO.inspect()
