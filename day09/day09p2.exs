Code.require_file("day09p1.exs")
defmodule Day09Part2 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def solve(input) do 
        Day09Part1.parseDeltas(input)
            |> check("deltas")
            |> Enum.map(fn superDeltas -> 
                Enum.reduce(superDeltas, 0, fn [delta | _], difference -> delta - difference end) 
            end)
            |> check("previous values")
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

Day09Part2.answer