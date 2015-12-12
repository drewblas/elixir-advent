defmodule Twelve do
  def go do
    text
    |> extract_numbers
    |> Enum.sum
  end

  def text do
    IO.read(:stdio, :all)
    # |> Stream.map(&String.strip/1)
  end

  def extract_numbers(text) do
    Regex.scan(~r/-?\d+/, text)
    |> Enum.map(fn([item]) -> item end) #Regex.scan returns each element inside an extra list
    |> Enum.map(&String.to_integer/1)
  end

end

IO.puts Twelve.go
