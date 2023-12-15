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

    def parseInput2(file) do 
        {colSize, rowSize, _} = parseInput(file)
        data = file 
            |> String.split("")
            |> parseInput2(0, 0)
        {colSize, rowSize, data}
    end 

    def parseInput2([], _, _) do 
        []
    end 

    def parseInput2([c | chars], row, col) do 
        case c do 
            "." -> parseInput2(chars, row, col + 1)
            "O" -> [{"O", row, col} | parseInput2(chars, row, col + 1)]
            "#" -> [{"#", row, col} | parseInput2(chars, row, col + 1)]
            "" -> parseInput2(chars, row, col)
            "\n" -> parseInput2(chars, row + 1, 0)
        end
    end 

    def scoreColumn({colSize, rowSize, data}, col, maxRow, row) do 
        case Enum.at(data, row * colSize + col, :empty) do 
            :empty -> 0
            "." -> scoreColumn({colSize, rowSize, data}, col, maxRow, row + 1)
            "O" -> (rowSize - maxRow) + scoreColumn({colSize, rowSize, data}, col, maxRow + 1, row + 1)
            "#" -> scoreColumn({colSize, rowSize, data}, col, row + 1, row + 1)
        end 
    end

    def moveNorth(data, _, colSize) do 
        Enum.reduce(
            0..(colSize - 1),
            data,
            fn col, acc -> moveColNorth(acc, col)
        end)
    end 

    def moveColNorth(data, column) do 
        {target, rest} = Enum.split_with(data, fn {_, _, col} -> col == column end)
        rest ++ moveNorth(
            Enum.sort_by(target, fn {_, r, _} -> r end),
            0
        )
    end 

    def moveNorth([], _) do 
        []
    end 

    def moveNorth([{c, row, col} | sortedColumn], maxRow) do 
        case c do 
            "O" -> [{"O", maxRow, col} | moveNorth(sortedColumn, maxRow + 1)]
            "#" -> [{"#", row, col } | moveNorth(sortedColumn, row + 1)]
        end 
    end

    def moveSouth(data, _, colSize) do 
        Enum.reduce(
            0..(colSize - 1),
            data,
            fn col, acc -> moveColSouth(acc, col, colSize)
        end)
    end 

    def moveColSouth(data, column, colSize) do 
        {target, rest} = Enum.split_with(data, fn {_, _, col} -> col == column end)
        rest ++ moveSouth(
            Enum.sort_by(target, fn {_, r, _} -> r end, :desc),
            colSize - 1
        )
    end 

    def moveSouth([], _) do 
        []
    end 

    def moveSouth([{c, row, col} | sortedColumn], minRow) do 
        case c do 
            "O" -> [{"O", minRow, col} | moveSouth(sortedColumn, minRow - 1)]
            "#" -> [{"#", row, col } | moveSouth(sortedColumn, row - 1)]
        end 
    end

    def moveWest(data, rowSize, _) do 
        Enum.reduce(
            0..(rowSize - 1),
            data,
            fn row, acc -> moveRowWest(acc, row)
        end)
    end 

    def moveRowWest(data, row) do 
        {target, rest} = Enum.split_with(data, fn {_, r, _} -> r == row end)
        rest ++ moveWest(
            Enum.sort_by(target, fn {_, _, col} -> col end),
            0
        )
    end 

    def moveWest([], _) do 
        []
    end 

    def moveWest([{c, row, col} | sortedColumn], maxCol) do 
        case c do 
            "O" -> [{"O", row, maxCol} | moveWest(sortedColumn, maxCol + 1)]
            "#" -> [{"#", row, col } | moveWest(sortedColumn, col + 1)]
        end 
    end

    def moveEast(data, rowSize, _) do 
        Enum.reduce(
            0..(rowSize - 1),
            data,
            fn row, acc -> moveRowEast(acc, row, rowSize)
        end)
    end 

    def moveRowEast(data, row, rowSize) do 
        {target, rest} = Enum.split_with(data, fn {_, r, _} -> r == row end)
        rest ++ moveEast(
            Enum.sort_by(target, fn {_, _, col} -> col end, :desc),
            rowSize - 1
        )
    end 

    def moveEast([], _) do 
        []
    end 

    def moveEast([{c, row, col} | sortedColumn], minCol) do 
        case c do 
            "O" -> [{"O", row, minCol} | moveEast(sortedColumn, minCol - 1)]
            "#" -> [{"#", row, col } | moveEast(sortedColumn, col - 1)]
        end 
    end
    
    def cycle(data, _, _, 0, _, _, _) do 
        data 
    end

    def stringify(data) do 
        data |>
            Enum.sort(fn {_, r, c}, {_, r2, c2} -> 
                case r == r2 do 
                    true -> c > c2 
                    false -> r > r2
                end
            end)
            |> Enum.reduce("", fn {chr, row, col}, acc -> acc <> chr <> Integer.to_string(row) <> Integer.to_string(col) end)
    end

    def cycle(data, rowSize, colSize, count, map, target, rep) do 
        check({count, getLoad(data, rowSize), rep}, "cycle")
        k = stringify(data)
        result = Map.get(map, k, :miss)
        check(k, "key")
        check(target, "target")
        check(result, "result")
        case result do 
            :miss -> data 
                |> moveNorth(rowSize, colSize)
                |> moveWest(rowSize, colSize)
                |> moveSouth(rowSize, colSize)
                |> moveEast(rowSize, colSize)
                |> (fn newData -> cycle(newData, rowSize, colSize, count - 1, Map.put(map, k, newData), target, rep + 1) end).()
            _ -> case target do 
                :nil -> cycle(result, rowSize, colSize, count - 1, map, k, 0)
                ^k -> cycle(data, rowSize, colSize, rem(count, rep+1), map, :nil, 0)
                _ -> cycle(result, rowSize, colSize, count - 1, map, target, rep + 1)
            end
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

    def getLoad(data, rowSize) do 
        Enum.reduce(
                data,
                0,
                fn {c, row, _}, acc -> case c do 
                    "O" -> acc + (rowSize - row)
                    "#" -> acc
                end
            end)
    end 

    def getLoadAfterCycles({colSize, rowSize, data}, cycles) do 
        cycle(data, rowSize, colSize, cycles, %{}, :nil, 0)
            |> getLoad(rowSize)
    end 

    def solvep2(input) do 
        File.read!(input)
            |> check("input")
            |> parseInput2()
            |> check("data model")
            |> getLoadAfterCycles(1000000000)
            |> check("load")
    end

    def test do 
        solve("test.txt")
    end

    def answer do 
        solve("input.txt")
    end

    def testp2 do 
        solvep2("test.txt")
    end

    def answerp2 do 
        solvep2("input.txt")
    end
end

Day14.answerp2