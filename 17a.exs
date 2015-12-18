defmodule Seventeen do
  @volume 150
  def go do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.map(&process/1)
    |> solve
  end

  def process(line) do
    line |> String.to_integer
  end

  def solve(containers) do
    all_combinations(containers)
    |> Enum.count(fn(c) -> Enum.sum(c) == @volume end)
  end

  def all_combinations(list) do
    1..length(list)
    |> Enum.reduce([], fn(n, acc) ->
      combination(n,list) ++ acc
    end)
  end

  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [h|t]) do
    (for x <- combination(n-1, t), do: [h|x]) ++ combination(n, t)
  end
end

IO.puts inspect Seventeen.go
