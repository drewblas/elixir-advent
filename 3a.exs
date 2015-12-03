defmodule Three do
  def go do
    IO.read(:stdio, :all)
    |> String.strip
    |> visit({0,0}, [])
  end

  def visit("^" <> str, {x,y}, houses) do
    visit(str, {x, y+1}, [{x,y}] ++ houses)
  end

  def visit("v" <> str, {x,y}, houses) do
    visit(str, {x, y-1}, [{x,y}] ++ houses)
  end

  def visit("<" <> str, {x,y}, houses) do
    visit(str, {x-1, y}, [{x,y}] ++ houses)
  end

  def visit(">" <> str, {x,y}, houses) do
    visit(str, {x+1, y}, [{x,y}] ++ houses)
  end

  def visit("", _location, houses) do
    Enum.uniq(houses) |> Enum.count
  end

end

IO.puts Three.go
