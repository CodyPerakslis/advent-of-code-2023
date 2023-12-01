defmodule Day01 do
  def getFirstNumber(a) do
    case a do 
        "" -> {:error, "No number found"}
        "1" <> rest -> {1, rest}
        "2" <> rest -> {2, rest}
        "3" <> rest -> {3, rest}
        "4" <> rest -> {4, rest}
        "5" <> rest -> {5, rest}
        "6" <> rest -> {6, rest}
        "7" <> rest -> {7, rest}
        "8" <> rest -> {8, rest}
        "9" <> rest -> {9, rest}
        <<first::utf8, rest::binary>> -> getFirstNumber(rest)
    end
  end
end


IO.puts("Hello, world!")

{number, rest} = Day01.getFirstNumber("a1k2x3o")

IO.puts(number)
IO.puts(rest)
