defmodule Eight do
  def go do
    {chars, codepoints} = IO.stream(:stdio, :line)
    |> Stream.map(&String.strip/1)
    |> Enum.reduce({0,0}, &process/2)

    chars - codepoints
  end

  def process(line, {chars, codepoints}) do
    a = String.length(line)
    {str, _} = Code.eval_string(line)
    b = String.length(str)
    {chars + a, codepoints + b}
  end
end

IO.puts inspect Eight.go
