defmodule ALUParser do
  def parse_instruction("inp " <> register), do: {:read, String.to_atom(register)}
  def parse_instruction("mul " <> params), do: to_binary_instruction(&*/2, params)
  def parse_instruction("add " <> params), do: to_binary_instruction(&+/2, params)
  def parse_instruction("mod " <> params), do: to_binary_instruction(&rem/2, params)
  def parse_instruction("div " <> params), do: to_binary_instruction(&div/2, params)
  def parse_instruction("eql " <> params), do: to_binary_instruction(&eql/2, params)

  defp to_binary_instruction(op, params) do
    [register, register_or_value] = params |> String.split()

    {:exec, String.to_atom(register), op, getter_for(register_or_value)}
  end

  defp getter_for(register_or_value) do
    case register_or_value do
      "w" ->
        fn {w, _, _, _} -> w end

      "x" ->
        fn {_, x, _, _} -> x end

      "y" ->
        fn {_, _, y, _} -> y end

      "z" ->
        fn {_, _, _, z} -> z end

      _ ->
        number = String.to_integer(register_or_value)
        fn _ -> number end
    end
  end

  defp eql(a, b) when a == b, do: 1
  defp eql(a, b) when a != b, do: 0
end

memo = %{}

defmodule ALUValidator do
  def is_valid(instructions, serial) do
    IO.inspect(serial)
    is_valid_internal(instructions, serial, _cpu = {_w = 0, _x = 0, _y = 0, _z = 0})
  end

  defp is_valid_internal(_, [0 | _], _), do: false
  defp is_valid_internal([], [], {_, _, _, 0}), do: true
  defp is_valid_internal([], [], _), do: false

  defp is_valid_internal([{:read, register} | instructions], [input | serial], cpu) do
    next_cpu = update_cpu(cpu, register, fn _ -> input end)
    memo_key = Enum.join(serial) <> "w" <> (cpu |> Tuple.to_list() |> Enum.join(","))

    # if Map.has_key?(memo, memo_key) do
    #   memo[memo_key]
    # else
    is_valid =
      is_valid_internal(
        instructions,
        serial,
        next_cpu
      )

    # memo = Map.put(memo, memo_key, is_valid)
    is_valid
    # end
  end

  defp is_valid_internal([{:exec, register, op, getter} | instructions], serial, cpu),
    do:
      is_valid_internal(
        instructions,
        serial,
        update_cpu(cpu, register, fn c -> op.(c, getter.(cpu)) end)
      )

  defp update_cpu({w, x, y, z}, :w, next), do: {next.(w), x, y, z}
  defp update_cpu({w, x, y, z}, :x, next), do: {w, next.(x), y, z}
  defp update_cpu({w, x, y, z}, :y, next), do: {w, x, next.(y), z}
  defp update_cpu({w, x, y, z}, :z, next), do: {w, x, y, next.(z)}
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
