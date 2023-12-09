defmodule DayXYPartZ do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end


    def solve(input) do 
        File.read!(input)
            |> check("input")
    end

    def test do 
        solve("test.txt")
    end

    def answer do 
        solve("input.txt")
    end
end

DayXYPartZ.test