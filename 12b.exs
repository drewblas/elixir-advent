# USE `mix run 12b.exs < 12.in

defmodule Twelve do
  def go do
    text
    |> decode
    |> sum
  end

  def text do
    IO.read(:stdio, :all)
  end

  def decode(text) do
    Poison.decode!(text)
  end

  def sum(nil), do: 0
  def sum([]), do: 0
  def sum(num) when is_number(num), do: num
  def sum(str) when is_binary(str), do: 0

  def sum([h|t]) do
    sum(h) + sum(t)
  end

  def sum(obj) do
    v = obj |> Map.values
    if Enum.member?(v, "red") do
      0
    else
      sum(v)
    end
  end

end

IO.puts inspect Twelve.go
