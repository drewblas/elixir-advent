defmodule Wire do
  use Bitwise

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  # Adds/sets the operator for a given wire
  def add_op(name, op) do
    Agent.update(__MODULE__, fn map ->
      {ins, _, value} = Map.get(map, name, {nil, nil, nil})
      Map.put(map, name, {ins, op, value})
    end)
  end

  # Adds an input for a given wire
  def add_input(name, input) do
    Agent.update(__MODULE__, fn map ->
      {ins, op, value} = Map.get(map, name, {nil, nil, nil})

      # To int if possible
      new_input = case Integer.parse(input) do
        {num, _} -> num
        :error -> input
      end

      # If there's already one input, make the inputs into a tuple
      all_inputs = case ins do
        nil -> new_input
        existing -> {existing, new_input}
      end

      Map.put(map, name, {all_inputs, op, value})
    end)
  end

  def get do
    Agent.get(__MODULE__, fn map -> map end)
  end

  def process do
    Agent.update(__MODULE__, fn map -> process(map) end)
  end

  # Recursive call to keep processing as long as we don't have the answer
  def process(map) do
    # IO.puts inspect map
    cond do
      # elem(map["a"], 2) != nil -> map # If a has a value we're done
      Enum.all?(map, fn({_,{_,_,value}}) -> is_number(value) end) -> map
      true ->
        map |> iterate |> process
    end
  end

  def iterate do
    Agent.update(__MODULE__, fn map -> iterate(map) end)
  end

  # A single iteration through the map
  def iterate(map) do
    Enum.reduce(map, map, fn(entry, map) ->
      {name, {ins, op, _val}} = entry

      ins = case ins do
        {x,y} -> {
          convert_name_to_number(map, x),
          convert_name_to_number(map, y)
        }
        x -> convert_name_to_number(map, x)
      end

      case ins do
        x when is_number(x) ->
          Map.put(map, name, {ins, op, exec(op, ins)})
        {x,y} when is_number(x) and is_number(y) ->
          Map.put(map, name, {ins, op, exec(op, ins)})
        _ ->
          map
      end
    end)
  end

  # No-op when the name is already a number
  def convert_name_to_number(_map, num) when is_number(num), do: num

  def convert_name_to_number(map, name) do
    case Map.get(map, name) do
      {_, _, nil} -> name # No value so we continue to return the name
      {_, _, x} when is_number(x) -> x
    end
  end

  def exec(nil, num), do: num
  def exec("OR", {a,b}), do: bor(a,b)
  def exec("AND", {a,b}), do: band(a,b)
  def exec("NOT", a), do: 65535 - a
  def exec("LSHIFT", {a,b}), do: bsl(b,a)
  def exec("RSHIFT", {a,b}), do: bsr(b,a)
end

defmodule Seven do
  def go do
    Wire.start_link
    read
    IO.puts inspect Wire.get
    Wire.process
    IO.puts inspect Wire.get
    inspect Wire.get["a"]
  end

  def read do
    case IO.read(:stdio, :line) do
      :eof -> nil
      {:error, reason} -> IO.puts "Error: #{reason}"
      data ->
        data |> String.strip |> String.split |> Enum.reverse |> process_line
        read
    end
  end

  def process_line([wire | tokens]) do
    process_line(wire, tokens)
  end

  # drop the ->
  def process_line(wire, ["->" | tokens]) do
    process_line(wire, tokens)
  end

  def process_line(wire, [token | rest]) do
    case token do
      op when op in ["AND", "OR", "LSHIFT", "RSHIFT", "NOT"] -> Wire.add_op(wire, op)
      input -> Wire.add_input(wire, input)
    end

    process_line(wire, rest)
  end

  def process_line(_, []), do: nil
end

IO.puts Seven.go
