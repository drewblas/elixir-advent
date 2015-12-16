defmodule Ingredient do
  defstruct capacity: 0, durability: 0, flavor: 0, texture: 0, calories: 0

  def from_regex([_|fields]) do
    [_|nums] = fields
    [capacity, durability, flavor, texture, calories ] = nums |> Enum.map(&String.to_integer/1)

    %Ingredient{
      capacity: capacity, durability: durability, flavor: flavor, texture: texture, calories: calories}
  end
end

defmodule Fifteen do
  def go do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.map(&process/1)
    |> solve
  end

  def process(line) do
    Regex.run(~r{(.+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)}, line)
    |> Ingredient.from_regex
  end

  def score(amounts, ingredients) do
    cookie = Enum.zip(amounts, ingredients) |> Enum.into(%{})

    list = for facet <- [:capacity, :durability, :flavor, :texture] do
      points = for {amt, ing} <- cookie, do: Map.get(ing, facet) * amt
      points |> Enum.sum
    end

    list
    |> Enum.reduce(1, fn(facet, acc) ->
      if facet > 0 do
        acc * facet
      else
        acc * 0
      end
    end)
  end

  def solve(ingredients) do
    ingredients |>
    every_possible_four_cookie
    |> Enum.map(&score(&1, ingredients))
    |> Enum.max
  end

  def every_possible_two_cookie do
    for a <- 1..100,
        b <- 1..100,
        a + b <= 100,
        (inga.calories * a) + (ingb.calories * b) == 500,
        do: [a,b]
  end

  def every_possible_four_cookie([inga, ingb, ingc, ingd]) do
    for a <- 1..100,
        b <- 1..100,
        c <- 1..100,
        d <- 1..100,
        a + b + c + d <= 100,
        (inga.calories * a) + (ingb.calories * b) + (ingc.calories * c) + (ingd.calories * d) == 500,
        do: [a,b,c,d]
  end
end

IO.puts inspect Fifteen.go
