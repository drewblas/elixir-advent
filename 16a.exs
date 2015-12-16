defmodule Sixteen do
  def go do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.map(&process/1)
    |> solve
  end

  def process(line) do
    [_, id, rest] = Regex.run(~r{Sue (\d+): (.*)}, line)

    features = String.split(rest, ",")
    |> Enum.map( fn(feature) ->
      [_, name, amt] = Regex.run(~r{(\w+): (\d+)}, feature)
      {name, amt}
    end)
    |> Enum.into(%{})
    {id, features}
  end

  def solve(aunts) do
    clues = %{
      "children" => "3",
      "cats" => "7",
      "samoyeds" => "2",
      "pomeranians" => "3",
      "akitas" => "0",
      "vizslas" => "0",
      "goldfish" => "5",
      "trees" => "3",
      "cars" => "2",
      "perfumes" => "1",
    }

    aunts
    |> Enum.find(fn({_, features}) ->
      keys = Map.keys(features)
      Map.take(clues, keys) == features
    end)
  end

end

IO.puts inspect Sixteen.go
