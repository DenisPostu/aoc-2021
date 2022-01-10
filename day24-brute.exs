defmodule ALUParser do
  def parse_instruction("inp " <> register), do: {:inp, String.to_atom(register)}
  def parse_instruction("mul " <> params), do: to_binary_instruction(:mul, params)
  def parse_instruction("add " <> params), do: to_binary_instruction(:add, params)
  def parse_instruction("mod " <> params), do: to_binary_instruction(:mod, params)
  def parse_instruction("div " <> params), do: to_binary_instruction(:div, params)
  def parse_instruction("eql " <> params), do: to_binary_instruction(:eql, params)

  defp to_binary_instruction(instruction, params) do
    [register, value] = params |> String.split()

    {instruction, String.to_atom(register), to_register_or_value(value)}
  end

  defp to_register_or_value(register_or_value) do
    if is_register(register_or_value) do
      String.to_atom(register_or_value)
    else
      String.to_integer(register_or_value)
    end
  end

  defp is_register("w"), do: true
  defp is_register("x"), do: true
  defp is_register("y"), do: true
  defp is_register("z"), do: true
  defp is_register(_), do: false
end

defmodule ALUValidator do
  def is_valid(instructions, monad) do
    is_valid_internal(instructions, monad, %{w: 0, x: 0, y: 0, z: 0})
  end

  defp is_valid_internal([], _, %{:z => 0}), do: true
  defp is_valid_internal([], _, %{:z => _}), do: false

  defp is_valid_internal([{:inp, r} | instructions], [input | monad], cpu),
    do: is_valid_internal(instructions, monad, %{cpu | r => input})

  defp is_valid_internal([{:add, r, r2_or_num} | instructions], monad, cpu),
    do: is_valid_internal(instructions, monad, next_cpu(cpu, &+/2, r, r2_or_num))

  defp is_valid_internal([{:mul, r, r2_or_num} | instructions], monad, cpu),
    do: is_valid_internal(instructions, monad, next_cpu(cpu, &*/2, r, r2_or_num))

  defp is_valid_internal([{:mod, r, r2_or_num} | instructions], monad, cpu),
    do: is_valid_internal(instructions, monad, next_cpu(cpu, &rem/2, r, r2_or_num))

  defp is_valid_internal([{:div, r, r2_or_num} | instructions], monad, cpu),
    do: is_valid_internal(instructions, monad, next_cpu(cpu, &div/2, r, r2_or_num))

  defp is_valid_internal([{:eql, r, r2_or_num} | instructions], monad, cpu),
    do: is_valid_internal(instructions, monad, next_cpu(cpu, &op_eql/2, r, r2_or_num))

  defp next_cpu(cpu, op, r, r2_or_num),
    do: %{cpu | r => next_register_value(cpu, op, r, r2_or_num)}

  defp next_register_value(cpu, op, r, r2_or_num) when is_integer(r2_or_num),
    do: op.(cpu[r], r2_or_num)

  defp next_register_value(cpu, op, r, r2), do: op.(cpu[r], cpu[r2])

  defp op_eql(a, b) when a == b, do: 1
  defp op_eql(a, b) when a != b, do: 0
end

# defmodule MonadGenerator do
#   def generate_monads(length): do

#   end
# end

instructions =
  File.read("./inputs/day24.txt")
  |> then(&elem(&1, 1))
  |> String.split("\n", trim: true)
  |> Enum.map(&ALUParser.parse_instruction/1)
  |> IO.inspect(label: "instructions")

instructions
|> ALUValidator.is_valid([1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5])
|> IO.inspect(label: "is_valid")
