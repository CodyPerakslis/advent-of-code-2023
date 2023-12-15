defmodule Day14 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def getLineLength(file) do 
        file 
            |> String.split("\n")
            |> (fn [line | _] -> line |> String.length() end).()
    end

    def parseInput(file) do 
        colSize = file 
            |> String.split("\n")
            |> (fn [line | _] -> line |> String.length() end).()
        data = file 
            |> String.split("")
            |> Enum.filter(fn c -> 
                case c do 
                    "." -> true 
                    "O" -> true 
                    "#" -> true 
                    "" -> false
                    "\n" -> false
                end 
            end)
        rowSize = div(Enum.count(data), colSize)
        {colSize, rowSize, data}
    end

    def scoreColumn({colSize, rowSize, data}, col, maxRow, row) do 
        case Enum.at(data, row * colSize + col, :empty) do 
            :empty -> 0
            "." -> scoreColumn({colSize, rowSize, data}, col, maxRow, row + 1)
            "O" -> (rowSize - maxRow) + scoreColumn({colSize, rowSize, data}, col, maxRow + 1, row + 1)
            "#" -> scoreColumn({colSize, rowSize, data}, col, row + 1, row + 1)
        end 
    end

    def solve(input) do 
        File.read!(input)
            |> check("input")
            |> parseInput()
            |> check("data model")
            |> (fn {colSize, rowSize, data} -> 
                Enum.map(
                    0..(colSize - 1), 
                    fn col -> scoreColumn({colSize, rowSize, data}, col, 0, 0)
                end)
            end).()
            |> check("load by column")
            |> Enum.sum()
            |> check("total load")
    end

    def test do 
        solve("test.txt")
    end

    def answer do 
        solve("input.txt")
    end
end

Day14.answer