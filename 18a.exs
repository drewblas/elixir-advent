defmodule Eighteen do
  @max 99
  def go do
    blank_canvas
    |> read
    |> loop(100)
    |> show
    |> count
  end

  def blank_canvas do
    for x <- 0..@max, y <- 0..@max,
      do: {{x, y}, 0},
      into: %{}
  end

  def show(canvas) do
    for x <- 0..@max do
      for y <- 0..@max do
        c = case canvas[{x,y}] do
          1 -> "#"
          0 -> "."
          _ -> "X"
        end

        IO.write(c)
      end
      IO.puts ""
    end

    canvas
  end

  def count(canvas) do
    canvas
    |> Enum.count(fn({_, elem}) -> elem == 1 end)
  end

  def read(canvas) do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Stream.with_index
    |> Enum.reduce(canvas, &process_line/2)
  end

  def process_line({line, row}, canvas) do
    line
    |> String.split("", trim: true)
    |> Enum.with_index
    |> Enum.reduce(canvas, fn({char, col}, canvas) ->
      case char do
        "#" -> Map.put(canvas, {row,col}, 1)
        "." -> canvas # Already false
      end
    end)
  end

  def loop(canvas, times) do
    1..times
    |> Enum.reduce(canvas, &step/2)
  end

  def step(canvas), do: step(0, canvas)

  def step(_, canvas) do
    next = blank_canvas
    (for row <- 0..@max, col <- 0..@max, do: {row, col})
    |> Enum.reduce(next, fn({row,col}, next) ->
      light = canvas[{row,col}]
      n = neighbors(canvas, {row, col})
      cond do
        light == 1 && (n == 2 || n == 3) -> Map.put(next, {row,col}, 1)
        light == 0 && n == 3 -> Map.put(next, {row,col}, 1)
        true -> next
      end
    end)
  end

  def neighbors(canvas, {r,c}) do
    (for row <- (r-1)..(r+1), col <- (c-1)..(c+1), do: canvas[{row,col}])
    |> List.delete_at(4) # Not yourself
    |> Enum.reject(&is_nil/1)
    |> Enum.sum
  end
end

IO.puts Eighteen.go
