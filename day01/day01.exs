defmodule Day01 do
  def getFirstNumber(str) do
    case str do 
        "" -> {:error, "No number found"}
        "1" <> rest -> {1, rest}
        "one" <> rest -> {1, "e" <> rest} # keep the "e" for "eight"
        "2" <> rest -> {2, rest}
        "two" <> rest -> {2, "o" <> rest} # keep the "o" for "one"
        "3" <> rest -> {3, rest}
        "three" <> rest -> {3, "e" <> rest} # keep the "e" for "eight"
        "4" <> rest -> {4, rest}
        "four" <> rest -> {4, rest}
        "5" <> rest -> {5, rest}
        "five" <> rest -> {5, "e" <> rest} # keep the "e" for "eight"
        "6" <> rest -> {6, rest}
        "six" <> rest -> {6, rest}
        "7" <> rest -> {7, rest}
        "seven" <> rest -> {7, "n" <> rest} # keep the "n" for "nine"
        "8" <> rest -> {8, rest}
        "eight" <> rest -> {8, "t" <> rest} # keep the "t" for "three" and "two"
        "9" <> rest -> {9, rest}
        "nine" <> rest -> {9, "e" <> rest} # keep the "e" for "eight"
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
      {:error, message} -> {:error, message}
      {number, rest} -> getFirstAndLastNumbers({number, number, rest})
    end
  end
end

File.stream!("day01.txt") |> 
    Enum.map(&Day01.getFirstAndLastNumbers/1) |>
    Enum.map(fn
        {:error, message} -> raise message
        {first, last} -> first * 10 + last
    end) |>
    Enum.sum() |>
    IO.puts()


