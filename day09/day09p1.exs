defmodule Day09Part1 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def findDelta(nums) do 
        findDelta(nums, [], [nums])
    end

    def findDelta([_], deltas, superDeltas) do 
        superDooperDeltas = [deltas] ++ superDeltas
        cond do 
            Enum.all?(deltas, fn x -> x == 0 end) -> superDooperDeltas
            true -> findDelta(deltas, [], superDooperDeltas)
        end
    end

    def findDelta([n1 | [n2 | rest]], deltas, superDeltas) do
        findDelta([n2 | rest], deltas ++ [n2 - n1], superDeltas)
    end


    def solve(input) do 
        File.read!(input)
            |> String.split("\n")
            |> Enum.map(fn line -> String.split(line) 
                |> Enum.map(fn n -> String.to_integer(n) end)
            end)
            |> check("input")
            |> Enum.map(fn nums -> findDelta(nums) end)
            |> check("deltas")
            |> Enum.map(fn superDeltas -> Enum.reduce(superDeltas, 0, fn deltas, sum -> sum + List.last(deltas) end) end)
            |> check("next values")
            |> Enum.sum()
            |> check("result")
    end

    def test do 
        solve("test.txt")
    end

    def answer do 
        solve("input.txt")
    end
end

Day09Part1.answer