defmodule Four do
  def crack(str), do: crack(str, 0)

  def crack(str, add) do
    full = str <> to_string(add)
    case md5(full) do
      # Just switch between 5 and 6 zeros for part a/b
      "000000" <> _ -> full
      _ -> crack(str, add+1)
    end
  end

  def md5(str) do
    Base.encode16(:erlang.md5(str), case: :lower)
  end

end

# IO.puts Four.crack("abcdef")
# IO.puts Four.crack("pqrstuv")
IO.puts Four.crack("yzbqklnj")
