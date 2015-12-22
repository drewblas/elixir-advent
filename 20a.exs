defmodule Twenty do
  def go(target), do: go(670000, target)

  def go(n, target) do
    result = house(n)
    if result >= target do
      IO.puts "Found"
      IO.puts inspect {n, result}
      go(n-1, target)
    else
      go(n-1, target)
    end
  end

  def house(n), do: n + house(n, div(n,2))
  def house(_, 0), do: 0
  def house(_, 1), do: 1
  def house(n, d) do
    if rem(n,d) == 0 do
      d + house(n, d-1)
    else
      house(n, d-1)
    end
  end

end

# IO.puts inspect Twenty.go(15)
IO.puts inspect Twenty.go(2900000)
