defmodule Day10Part1 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def firstLineLength(str) do 
        firstLineLength(str, 0)
    end

    def firstLineLength("\n" <> _, count) do 
        count 
    end

    def firstLineLength(<<_>> <> rest, count) do 
        firstLineLength(rest, count + 1)
    end

    def findStart(pipes) do 
        findStart(pipes, 0)
    end

    def findStart(["S" | _], idx) do 
        idx
    end

    def findStart([_ | rest], idx) do 
        findStart(rest, idx + 1)
    end

    def getNextOptions(pipes, idx, lineLength) do 
        case Enum.at(pipes, idx, :none) do 
            "|" -> [idx - lineLength, idx + lineLength]
            "-" -> [idx - 1, idx + 1]
            "7" -> [idx - 1, idx + lineLength]
            "J" -> [idx - 1, idx - lineLength]
            "F" -> [idx + lineLength, idx + 1]
            "L" -> [idx - lineLength, idx + 1]
        end
    end

    def validToPipeDir(pipe, dir) do 
        case pipe do 
            "|" -> dir == :top or dir == :bottom
            "-" -> dir == :left or dir == :right
            "7" -> dir == :right or dir == :top
            "J" -> dir == :right or dir == :bottom
            "F" -> dir == :top or dir == :left
            "L" -> dir == :bottom or dir == :left 
            _ -> false
        end
    end

    def validToIndexDir(pipes, idx, dir) do 
        Enum.at(pipes, idx, :none)
            |> validToPipeDir(dir)
    end

    def pipeLength({lineLength, pipes}) do 
        start = findStart(pipes)
        [top, right, bottom, left] = [start - lineLength, start + 1, start + lineLength, start - 1]
        cond do 
            validToIndexDir(pipes, top, :top) -> pipeLength(pipes, lineLength, start, top, 1, start)
            validToIndexDir(pipes, right, :right) -> pipeLength(pipes, lineLength, start, right, 1, start)
            validToIndexDir(pipes, bottom, :bottom) -> pipeLength(pipes, lineLength, start, bottom, 1, start)
            validToIndexDir(pipes, left, :left) -> pipeLength(pipes, lineLength, start, left, 1, start)
        end
    end

    def pipeLength(_, _, _, start, count, start) do 
        count
    end

    def pipeLength(pipes, lineLength, prev, curr, count, start) do 
        [next] = getNextOptions(pipes, curr, lineLength) |> Enum.filter(fn x -> x !== prev end)
        pipeLength(pipes, lineLength, curr, next, count + 1, start)
    end

    def solve(input) do 
        File.read!(input)
            |> check("file")
            |> (fn file -> {
                firstLineLength(file), 
                String.split(file, "", trim: true)
                    |> Enum.filter(fn c -> c !== "\n" end)
            } end).()
            |> check("input")
            |> pipeLength()
            |> check("total length")
            |> div(2)
            |> check("furthest distance")
    end

    def test do 
        solve("test.txt")
    end

    def answer do 
        solve("input.txt")
    end
end

Day10Part1.answer