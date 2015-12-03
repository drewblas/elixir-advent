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
    |> size
  end

  def size([l,w,h]) do
    2*l*w + 2*l*h + 2*w*h + Enum.min([l*w,l*h,w*h])
  end
end

IO.puts Two.go
