defmodule Day01 do
  def getFirstNumber(str) do
    case str do 
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
        <<_, rest::binary>> -> getFirstNumber(rest)
    end
  end

  def getFirstAndLastNumbers({first, currentLast, rest}) do
    case getFirstNumber(rest) do
      {:error, _} -> {first, currentLast}
      {number, rest} -> getFirstAndLastNumbers({first, number, rest})
    end
  end

  def getFirstAndLastNumbers(str) do 
    case getFirstNumber(str) do
      {:error, _} -> {:error, "No number found"}
      {number, rest} -> getFirstAndLastNumbers({number, number, rest})
    end
  end
end


IO.puts("Hello, world!")

{number, rest} = Day01.getFirstAndLastNumbers("a4eu3shs2o")

IO.puts(number)
IO.puts(rest)
