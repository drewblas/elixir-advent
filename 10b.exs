defmodule Ten do
  def say(str) when is_binary(str), do: str |> String.to_char_list |> say
  def say([h|t]), do: say(t, [], h , 1)
  def say([], acc, letter, count) do
    words = count |> to_string |> String.to_char_list
    ([letter] ++ words ++ acc) |> Enum.reverse
  end

  def say([h|t], acc, letter, count) do
    case h do
      ^letter ->
        say(t, acc, letter, count + 1)
      _ ->
        words = count |> to_string |> String.to_char_list
        say(t,  [letter] ++ words ++ acc, h, 1)
    end
  end
end

# result = 1..6 |> Enum.reduce("1" |> String.to_char_list, fn(i, acc) ->
#   IO.puts "#{i} - #{length(acc)} - #{acc}"
#   Ten.say(acc)
# end)

result = 1..50 |> Enum.reduce("3113322113" |> String.to_char_list, fn(i, acc) ->
  IO.puts "#{i} - #{length(acc)}"
  Ten.say(acc)
end)

IO.puts length(result)
