defmodule Fourteen do
  def go do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.map(&process/1)
    |> solve(1, 2504) # You must add an extra second on the end
  end

  def process(line) do
    [_, name, speed, endurance, rest ] = Regex.run(~r{(.+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}, line)

    speed = String.to_integer(speed)
    endurance = String.to_integer(endurance)
    rest = String.to_integer(rest)

    %{name: name, speed: speed, endurance: endurance, rest: rest, position: 0, points: 0}
  end

  def solve(reindeers, time, time) do
    reindeers
    |> Enum.max_by fn(reindeer) -> reindeer.points end
  end

  def solve(reindeers, time, finish) do
    reindeers
    |> advance_to(time)
    |> award_point
    |> solve(time + 1, finish)
  end

  def advance_to(reindeers, time) do
    reindeers
    |> Enum.map fn(reindeer) ->
      %{reindeer | position: position_after(reindeer, time)}
    end
  end

  def position_after(reindeer, time) do
    total_time = reindeer.endurance + reindeer.rest
    loops = div(time, total_time) # How many times it can do a full run + rest cycle
    remaining_time = rem(time, total_time)

    extra_distance = Enum.min([reindeer.endurance, remaining_time]) * reindeer.speed

    (loops * reindeer.speed * reindeer.endurance) + extra_distance
  end

  def award_point(reindeers) do
    lead = reindeers |> Enum.max_by fn(reindeer) -> reindeer.position  end

    reindeers
    |> Enum.map fn(reindeer) ->
      if reindeer.position == lead.position do
        %{reindeer | points: reindeer.points + 1}
      else
        reindeer
      end
    end
  end
end

IO.puts inspect Fourteen.go
