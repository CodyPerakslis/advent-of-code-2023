defmodule Day04 do 
    def sortNumbers(line) do
        String.split(line)
            |> Enum.map(fn numStr -> String.to_integer(numStr) end)
            |> Enum.sort()
    end

    def commonNumbers(l1, l2) do 
        MapSet.intersection(MapSet.new(l1), MapSet.new(l2))
    end

    def question1 do 
        File.read!("day04.txt")
            |> String.split("\n")
            |> Enum.map(fn line -> String.split(line, ": ") end)
            |> Enum.map(fn [_, numbers] -> String.split(numbers, " | ") end)
            |> Enum.map(fn [lottery, guess] -> [sortNumbers(lottery), sortNumbers(guess)] end)
            |> Enum.map(fn [lottery, guess] -> commonNumbers(lottery, guess) end)
            |> Enum.filter(fn common -> MapSet.size(common) > 0 end)
            |> Enum.map(fn common -> 2**(MapSet.size(common)-1) end)
            |> Enum.sum()
            |> IO.inspect()
    end
end

Day04.question1