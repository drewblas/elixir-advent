defmodule Twenty do
  def go(target, count) do
    deliver(count)
    |> Stream.filter(fn({cnt, _i}) -> cnt >= target end)
    |> Stream.drop(1)
    |> Stream.take(1)
    |> Enum.to_list
  end


  def deliver(count) do
    houses = Stream.cycle([0]) |> Stream.with_index |> Stream.take(count)
    deliver(houses, 1, count)
  end

  def deliver(houses, elf, max) when elf > max, do: houses

  def deliver(houses, elf, max) do
    houses |> Stream.map(fn({cnt, i}) ->
      if rem(i, elf) == 0 do
        {cnt + elf, i}
      else
        {cnt, i}
      end
    end)
    |> deliver(elf+1, max)
  end
end

# IO.puts inspect Twenty.go(15, 100)
IO.puts inspect Twenty.go(div(290000,11), 10000)
# IO.puts inspect Twenty.go(div(29000000,11), 100000)
