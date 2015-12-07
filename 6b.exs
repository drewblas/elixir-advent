defmodule Five do
  @max 999
  def go do
    canvas = for x <- 0..@max, y <- 0..@max,
               do: {{x, y}, 0},
               into: %{}

    canvas
    |> read
    # |> show
    |> count
  end

  def show(canvas) do
    for x <- 0..@max do
      IO.write("- ")
      for y <- 0..@max do
        c = case canvas[{x,y}] do
          0 -> " "
          a -> to_string(a)
        end

        IO.write(c)
      end
      IO.puts ""
    end

    canvas
  end

  def count(canvas) do
    canvas
    |> Enum.map(fn({_, elem}) -> elem end)
    |> Enum.sum
  end

  def read(canvas) do
    case IO.read(:stdio, :line) do
      :eof -> canvas
      {:error, reason} -> IO.puts "Error: #{reason}"
      str ->
        process_line(canvas, str) |> read
    end
  end

  def process_line(canvas, line) do
    command_fn = extract_command(line)
    [x1,y1,x2,y2] = convert_range(line)

    canvas = Enum.reduce(x1..x2, canvas, fn(x, canvas) ->
      Enum.reduce(y1..y2, canvas, fn(y,canvas) ->
        key = {x,y}
        val = canvas[key]
        Dict.put(canvas, key, command_fn.(val))
      end)
    end)

    canvas
  end

  def extract_command("turn off " <> _) do
    fn a ->
      cond do
        a <= 0 -> 0
        true -> a - 1
      end
    end
  end

  def extract_command("turn on " <> _) do
    fn a -> a + 1 end
  end

  def extract_command("toggle " <> _) do
    fn a -> a + 2 end
  end

  # Turns "499,499 through 500,500" into [499,499,500,500]
  def convert_range(str) do
    [_ | coords] = Regex.run(~r/(\d*),(\d*) through (\d*),(\d*)/, str)
    coords
    |> Enum.map(&Integer.parse(&1))
    |> Enum.map(&elem(&1, 0))
  end

end

IO.puts Five.go
