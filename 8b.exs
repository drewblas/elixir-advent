defmodule Eight do
  def go do
    {chars, encoded} = IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.reduce({0,0}, &process/2)

    encoded - chars
  end

  def process(line, {chars, encoded}) do
    a = line |> String.length
    b = line |> inspect |> String.length
    {chars + a, encoded + b}
  end
end

IO.puts inspect Eight.go
