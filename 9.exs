defmodule Nine do
  def go do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.reduce(%{}, &process/2)
    |> travel
  end

  def process(line, map) do
    [_, from, to, dist ] = Regex.run(~r/(.*) to (.*) = (\d*)/, line)
    dist = String.to_integer(dist)

    map
    |> Map.put({from, to}, dist)
    |> Map.put({to, from}, dist)
  end

  def travel(distances) do
    distances
    |> stops
    |> permute
    |> Enum.map(&trip_length(&1, distances))
    |> Enum.min_max
  end

  def stops(distances) do
    distances
    |> Map.keys
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq
  end

  # Calculate the length of a trip given the distances table
  def trip_length(trip, distances) do
    trip
    |> Enum.chunk(2,1) # Pairs of stops: [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]
    |> Enum.map(fn([from, to]) -> distances[{from, to}] end)
    |> Enum.sum
  end

  def permute([]), do: [[]]
  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end
end

IO.puts inspect Nine.go
