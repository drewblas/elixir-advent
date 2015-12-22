defmodule Nineteen do
  def go(input) do
    read
    |> solve(input)
    |> Enum.uniq
    |> Enum.count
  end

  def read do
    IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.reduce(%{}, &process_line/2)
  end

  def process_line(line, map) do
    [_, start, finish] = Regex.run(~r{(\w+) => (\w+)}, line)
    list = Map.get(map, start, [])
    Map.put(map, start, [finish | list])
  end

  def solve(swaps, input) do
    chars = Regex.scan(~r{([A-Z][a-z]?)}, input)
    chars = (for [_,c] <- chars, do: c)

    0..(length(chars) - 1)
    |> Enum.flat_map(fn(i) ->  # For each "pivot point" called i
      {left, [char | right]} = Enum.split(chars, i)     # Split on that point

      if swaps[char] == nil do
        # IO.puts "CAN'T SWAP UNKNOWN #{char}"
        []
      else
        Enum.map(swaps[char], fn(new) ->
          left ++ [new] ++ right |> Enum.join
        end)
      end
    end)
  end

end

# IO.puts inspect Nineteen.go("HOH")
# IO.puts inspect Nineteen.go("HOHOHO")
IO.puts Nineteen.go("CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl")
