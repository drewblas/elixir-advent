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
      {name, String.to_integer(amt)}
    end)
    |> Enum.into(%{})
    {id, features}
  end

  def solve(aunts) do
    clues = %{
      "children" => 3,
      "cats" => 7,
      "samoyeds" => 2,
      "pomeranians" => 3,
      "akitas" => 0,
      "vizslas" => 0,
      "goldfish" => 5,
      "trees" => 3,
      "cars" => 2,
      "perfumes" => 1,
    }

    aunts
    |> Enum.find(fn({_, features}) ->
      features |> Enum.all?(fn({name, amt}) ->
        case name do
          n when n in ["cats", "trees"] -> amt > clues[name]
          n when n in ["pomeranians", "goldfish"] -> amt < clues[name]
          _ -> amt == clues[name]
        end
      end)
    end)
  end

end

IO.puts inspect Sixteen.go
