defmodule Fourteen do
  def go do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.map(&process/1)
    |> solve(2503)
  end

  def process(line) do
    [_, name, speed, endurance, rest ] = Regex.run(~r{(.+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}, line)

    speed = String.to_integer(speed)
    endurance = String.to_integer(endurance)
    rest = String.to_integer(rest)

    %{name: name, speed: speed, endurance: endurance, rest: rest}
  end

  def solve(reindeers, finish) do
    reindeers
    |> Enum.map(&distance_after(&1, finish))
    |> Enum.max
  end

  def distance_after(reindeer, time) do
    total_time = reindeer.endurance + reindeer.rest
    loops = div(time, total_time) # How many times it can do a full run + rest cycle
    remaining_time = rem(time, total_time)

    extra_distance = Enum.min([reindeer.endurance, remaining_time]) * reindeer.speed

    (loops * reindeer.speed * reindeer.endurance) + extra_distance
  end

end

IO.puts inspect Fourteen.go
