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

    def addWins(rest, {_, 0}) do 
        rest
    end

    def addWins(rest, {0, _}) do 
        rest
    end

    def addWins([], _) do
        []
    end

    def addWins([{nWin, nCount} | rest], {win, count}) do 
        [
            {nWin, nCount + count} | 
            addWins(rest, {win - 1, count})
            ]
    end

    def setWins(wins) do 
        setWins(wins, [])
    end

    def setWins([], result) do 
        result
    end

    def setWins([next | rest], result) do 
        addWins(rest, next)
            |> setWins(result ++ [next])
    end

    def question2 do 
        File.read!("day04.txt")
            |> String.split("\n")
            |> Enum.map(fn line -> String.split(line, ": ") end)
            |> Enum.map(fn [_, numbers] -> String.split(numbers, " | ") end)
            |> Enum.map(fn [lottery, guess] -> [sortNumbers(lottery), sortNumbers(guess)] end)
            |> Enum.map(fn [lottery, guess] -> commonNumbers(lottery, guess) end)
            |> Enum.map(fn set -> {MapSet.size(set), 1} end)
            |> IO.inspect(label: "wins")
            |> Day04.setWins()
            |> IO.inspect(label: "counts")
            |> Enum.reduce(0, fn {_, count}, acc -> acc + count end)
            |> IO.inspect(label: "answer")
    end
end