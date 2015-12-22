defmodule Nineteen do
  def go(target) do
    elements = split_elements(target)
    a = length(elements)
    b = elements |> Enum.filter(fn(el) -> el == "Ar" || el == "Rn" end) |> length
    c = elements |> Enum.filter(fn(el) -> el == "Y" end) |> length

    a - b - (c*2) - 1
  end

  def split_elements(input) do
    chars = Regex.scan(~r{([A-Z][a-z]?)}, input)
    (for [_,c] <- chars, do: c)
  end
end

# IO.puts inspect Nineteen.go("HOH")
# IO.puts inspect Nineteen.go("HOHOHO")

IO.puts Nineteen.go("CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl")
