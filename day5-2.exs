defmodule Math do
  def sign(x) when x > 0, do: 1
  def sign(x) when x < 0, do: -1
  def sign(_), do: 0
end

defmodule Field do
  def paint_point(map, [x, y]) do
    Map.update(map, "#{x},#{y}", 1, &(&1 + 1))
  end

  def paint(map, [[x, y], [x, y]]), do: Field.paint_point(map, [x, y])

  def paint(map, [[x1, y1], [x2, y2]]) do
    Field.paint(
      Field.paint_point(map, [x1, y1]),
      [[x1 + Math.sign(x2 - x1), y1 + Math.sign(y2 - y1)], [x2, y2]]
    )
  end

  def paint(map, _), do: map
end

File.read("./inputs/day5.txt")
|> then(&elem(&1, 1))
|> String.split([" -> ", "\n"], trim: true)
|> Enum.map(fn point -> String.split(point, ",") |> Enum.map(&String.to_integer/1) end)
|> Enum.chunk_every(2)
|> Enum.reduce(
  %{},
  &Field.paint(&2, &1)
)
|> Map.values()
|> Enum.count(&(&1 > 1))
|> IO.inspect()
