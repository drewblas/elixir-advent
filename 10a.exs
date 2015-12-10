defmodule Ten do
  def say(str), do: say(str,"")
  def say("", acc), do: acc

  def say(str, acc) do
    #["11122", "111", "1", "22"] = Regex.run(..., "11122")
    [_, run, number, rest] = Regex.run(~r/((\d)\2*)(.*)/, str)

    run = run |> String.length |> to_string
    number = number |> to_string

    say(rest, acc <> run <> number)
  end
end

result = 1..50 |> Enum.reduce("3113322113", fn(i, acc) -> 
  IO.puts i
  Ten.say(acc)
end)
IO.puts String.length(result)
