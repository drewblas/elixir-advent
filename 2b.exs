defmodule Two do
  def go do
    read(0)
  end

  def read(acc) do
    case IO.read(:stdio, :line) do
      :eof -> acc
      {:error, reason} -> IO.puts "Error: #{reason}"
      data -> read(acc + line(data))
    end
  end

  def line(str) do
    str
    |> String.strip
    |> String.split("x", parts: 3, trim: true)
    |> Enum.map(&Integer.parse(&1))
    |> Enum.map(&elem(&1, 0))
    |> ribbon
  end

  def ribbon(dim) do
    wrap(dim) + bow(dim)
  end

  def wrap([l,w,h]) do
    2*l + 2*w + 2*h - (2 * Enum.max([l,w,h]))
  end

  def bow([l,w,h]), do: l*w*h
end

IO.puts Two.go
