defmodule Thirteen do
  def go do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.reduce(%{}, &process/2)
    |> add_self
    |> solve
  end

  def process(line, map) do
    [_, from, gainloss, amount, to ] = Regex.run(~r/(.*) would (gain|lose) (\d*) happiness units by sitting next to (.*)\./, line)

    amount = String.to_integer(amount)
    if gainloss == "lose", do: amount = amount * -1

    map
    |> Map.put({from, to}, amount)
  end

  def add_self(likes) do
    likes
    |> extract_people
    |> Enum.reduce(likes, fn(person, map) ->
      map
      |> Map.put({person, "Myself"}, 0)
      |> Map.put({"Myself", person}, 0)
    end)
  end

  def solve(likes) do
    likes
    |> extract_people
    |> permute
    |> Enum.map(&happiness(&1, likes))
    |> Enum.min_max
  end

  def extract_people(likes) do
    likes
    |> Map.keys
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq
  end

  # Calculate the total happiness at a give table arrangement
  def happiness(table, likes) do
    [first|_] = table
    [last|_] = Enum.reverse(table)

    table
    |> Enum.chunk(2,1) # Pairs of people: [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]
    |> List.insert_at(0, [last,first]) # Add the wraparound connector
    |> Enum.map(fn([from, to]) -> likes[{from, to}] + likes[{to, from}] end)
    |> Enum.sum
  end

  def permute([]), do: [[]]
  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end

end

IO.puts inspect Thirteen.go
