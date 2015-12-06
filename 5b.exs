defmodule Five do
  def go do
    read(0)
  end

  def read(acc) do
    case IO.read(:stdio, :line) do
      :eof -> acc
      {:error, reason} -> IO.puts "Error: #{reason}"
      data ->
        # IO.puts line(data)
        read(acc + line(data))
    end
  end

  # Return 1 if it's nice, 0 if naughty
  def line(str) do
    cond do
      !Regex.match?(~r/([a-z]).\1/, str) -> 0 # xfx
      !Regex.match?(~r/([a-z][a-z]).*\1/, str) -> 0 # xyfxy
      true -> 1
    end
  end


end

IO.puts Five.go
