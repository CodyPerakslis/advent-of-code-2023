Code.require_file("day10p1.exs")
defmodule Day10Part2 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def getPipe({lineLength, pipes}) do 
        start = Day10Part1.findStart(pipes)
        [top, right, bottom, left] = [start - lineLength, start + 1, start + lineLength, start - 1]
        cond do 
            Day10Part1.validToIndexDir(pipes, top, :top) -> getPipe(pipes, lineLength, start, top, [start])
            Day10Part1.validToIndexDir(pipes, right, :right) -> getPipe(pipes, lineLength, start, right, [start])
            Day10Part1.validToIndexDir(pipes, bottom, :bottom) -> getPipe(pipes, lineLength, start, bottom, [start])
            Day10Part1.validToIndexDir(pipes, left, :left) -> getPipe(pipes, lineLength, start, left, [start])
        end
    end

    def getPipe(_, _, _, start, [start | rest]) do 
        rest
    end

    def getPipe(pipes, lineLength, prev, curr, result) do 
        [next] = Day10Part1.getNextOptions(pipes, curr, lineLength) |> Enum.filter(fn x -> x !== prev end)
        getPipe(pipes, lineLength, curr, next, result ++ [next])
    end

    def addTargetPipe(modifiedPipes, [], _, _) do 
        modifiedPipes
    end

    def addTargetPipe(modifiedPipes, [_ | originalPipes], [], idx) do 
        addTargetPipe(modifiedPipes ++ ["."], originalPipes, [], idx + 1)
    end

    def addTargetPipe(modifiedPipes, [op | originalPipes], [pipe | targetPipe], pipe) do 
        addTargetPipe(modifiedPipes ++ [op], originalPipes, targetPipe, pipe + 1)
    end

    def addTargetPipe(modifiedPipes, [_ | originalPipes], [pipe | targetPipe], idx) do 
        addTargetPipe(modifiedPipes ++ ["."], originalPipes, [pipe | targetPipe], idx + 1)
    end

    def addTargetPipe(originalPipes, targetPipe) do 
        addTargetPipe([], originalPipes, targetPipe, 0)
    end

    def zeroTheEdges(pipes, lineLength, idx) do 
        val = Enum.at(pipes, idx)
        newPipes = case
    end

    def solve(input) do 
        {lineLength, originalPipes} = File.read!(input)
            |> check("file")
            |> (fn file -> {
                Day10Part1.firstLineLength(file), 
                String.split(file, "", trim: true)
                    |> Enum.filter(fn c -> c !== "\n" end)
            } end).()
            |> check("input")

        targetPipe = getPipe({lineLength, originalPipes})
            |> Enum.sort()
            |> check("real pipe")

        emptyPipes = addTargetPipe(originalPipes, targetPipe)
            |> check("empty pipe") 
    end

    def test do 
        solve("test.txt")
    end

    def answer do 
        solve("input.txt")
    end
end

Day10Part2.test