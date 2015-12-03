defmodule Three do
  def go do
    IO.read(:stdio, :all)
    |> String.strip
    |> String.to_char_list
    |> visit({0,0}, {0,0}, [{0,0}])
  end

  def robovisit([dir | tail], santa, robo, houses) do
    to = move(dir,robo)
    visit(tail, santa, to, [to] ++ houses)
  end

  def visit([dir | tail], santa, robo, houses) do
    to = move(dir,santa)
    robovisit(tail, to, robo, [to] ++ houses)
  end

  def visit([], _santa, _robo, houses) do
    Enum.uniq(houses) |> Enum.count
  end

  def move(?^, {x,y}), do: {x,y+1}
  def move(?v, {x,y}), do: {x,y-1}
  def move(?<, {x,y}), do: {x-1,y}
  def move(?>, {x,y}), do: {x+1,y}

end

IO.puts Three.go
