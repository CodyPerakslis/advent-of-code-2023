defmodule Day13 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def hasReflectionPoint(line, reflection) do 
        {s1, s2} = String.split_at(line, reflection)
        String.ends_with?(s1, String.reverse(s2)) or String.starts_with?(s2, String.reverse(s1))
    end 

    def hasMatch([], _) do 
        true 
    end 

    def hasMatch(_, []) do 
        true
    end 

    def hasMatch([l1 | lines1], [l2 | lines2]) do
        String.equivalent?(l1, l2) and hasMatch(lines1, lines2)
    end 

    def hasReflectionPointHor(lines, reflection) do 
        {l1, l2} = Enum.split(lines, reflection)
        hasMatch(Enum.reverse(l1), l2)
    end 

    def determineReflectionPoint([line | lines]) do 
        determineReflectionPoint([line | lines], 1..(String.length(line)-1))
    end 

    def determineReflectionPoint(_, []) do 
        0
    end

    def determineReflectionPoint([], [reflectionPoint]) do 
        reflectionPoint
    end

    def determineReflectionPoint([line | lines], reflectionPoints) do 
        determineReflectionPoint(
            lines, 
            Enum.filter(
                reflectionPoints, 
                fn r -> hasReflectionPoint(line, r) end
                )
            )
    end

    def determineReflectionPointHor(lines) do 
        case Enum.filter(
            1..(Enum.count(lines)-1),
            fn r -> hasReflectionPointHor(lines, r) 
        end) do 
            [reflectionPoint] -> reflectionPoint
            [] -> 0
        end
    end 

    def getScore(lines) do 
        100 * determineReflectionPointHor(lines) + determineReflectionPoint(lines)
    end 

    def getStoreByStr(lineString) do 
        String.split(lineString, "\n")
            |> getScore()
    end 

    def isNewScore(score, realValue) do 
        score > 0 and score !== realValue
    end 

    def offByOneValue(c, o, lineString, restString, realValue) do 
        score = getStoreByStr(restString <> c <> lineString)
        cond do 
            score == 0 or score == realValue -> offByOne(lineString, restString <> o, realValue)
            true -> score 
        end
    end 

    def offByOne(<<c>> <> lineString, restString, realValue) do 
        case c do 
            ?. -> if isNewScore(getStoreByStr(restString <> ?# <> lineString)) do 
    end 

    def solve(input) do 
        File.read!(input)
            |> String.split("\n\n")
            |> check("input")
            |> Enum.map(fn lines -> String.split(lines, "\n") 
                |> getScore()
            end)
            |> check("results")
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

Day13.answer