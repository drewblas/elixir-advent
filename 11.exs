defmodule Eleven do
  def next_password(str) do
    next = advance(str)
    if valid?(next) do
      next
    else
      next_password(next)
    end
  end

  def valid?(str) do
    # IO.puts "Checking #{str}"
    # IO.puts three_letter_run?(str)
    # IO.puts !String.match?(str, ~r{[iol]})
    # IO.puts String.match?(str, ~r{(\w)\1.*([^\1])\2})

    !String.match?(str, ~r{[iol]}) &&
    String.match?(str, ~r{(\w)\1.*([^\1])\2}) &&
    three_letter_run?(str)
  end

  def three_letter_run?([]), do: false

  def three_letter_run?([first|rest]) do
    case rest do
      [_ | []] -> false # Only one letter left
      [second | [third | _ ] ] ->
        (second == next_codepoint(first) &&
        third == next_codepoint(second)) ||
        three_letter_run?(rest)
    end
  end

  def three_letter_run?(str) when is_binary(str) do
    three_letter_run?(String.codepoints(str))
  end

  def advance(str) do
    i = str |> String.to_integer(36)
    i+1 |> Integer.to_string(36) |> String.replace("0", "a")
  end

  # def next_codepoint("z"), do: "a"
  def next_codepoint(<<char :: utf8>>), do: << char + 1 >>
end

# IO.puts Eleven.advance("abc")
# IO.puts Eleven.advance("abz")
# IO.puts Eleven.advance("azz")
#
# IO.puts Eleven.valid?("hijklmmn")
# IO.puts Eleven.valid?("abbceffg")
# IO.puts Eleven.valid?("abbcegjk")
#
# IO.puts Eleven.next_password("abcdefgh")
# IO.puts Eleven.next_password("ghijklmn")

# IO.puts Eleven.next_password("hepxcrrq")
IO.puts Eleven.next_password("hepxxyzz")
