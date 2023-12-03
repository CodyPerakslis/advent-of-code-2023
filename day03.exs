defmodule Day03 do


    def getNextThreeLines([l1 | [l2 | [l3 | rest]]]) do 
        {["." <> l1 <> ".", "." <> l2 <> ".", "." <> l3 <> "."], [l2 | [l3 | rest]]}
    end

    def getNextThreeLines([l1, l2]) do 
        {["." <> l1 <> ".", "." <> l2 <> ".", String.duplicate(".", String.length(l1)+2)], []}
    end

    def getClumps(lines) do 
        getClumps([], lines)
    end

    def getClumps(clumps, lines) do 
        case lines do 
            [] -> clumps 
            _ -> getNextThreeLines(lines) |> (fn {clump, rest} -> getClumps(clumps ++ [clump], rest) end).()
        end
    end

    def parse(x) do 
        cond do  
            x == 46 -> {:skip}
            x >= 48 and x <= 57 -> {:num, x - 48}
            true -> {:sym, x}
        end
    end

    def parseClump([l1, l2, l3]) do 
        parseClump(to_charlist(l1), to_charlist(l2), to_charlist(l3), 0, false, 0)
    end

    def parseClump([_, _], [_, _], [_, _], num, hasTouched, sum) do
        case hasTouched do 
            true -> sum + num 
            false -> sum
        end
    end

    def parseClump([s11 | [s12 | [s13 | s1r]]], [s21 | [s22 | [s23 | s2r]]], [s31 | [s32 | [s33 | s3r]]], num, hasTouched, sum) do 
        case parse(s22) do 
            {:num, val} -> parseClump([s12 | [s13 | s1r]], 
                                    [s22 | [s23 | s2r]], 
                                    [s32 | [s33 | s3r]], 
                                    10*num+val, 
                                    hasTouched or Enum.any?([s11, s12, s13, s21, s23, s31, s32, s33],
                                                            fn p -> case parse(p) do 
                                                                {:sym, _} -> true
                                                                _ -> false
                                                                end
                                                            end),
                                    sum)
            _ -> parseClump([s12 | [s13 | s1r]], 
                            [s22 | [s23 | s2r]], 
                            [s32 | [s33 | s3r]],
                            0,
                            false,
                            case hasTouched do 
                                true -> sum + num
                                false -> sum
                            end)
        end
    end

    def question1 do 
        File.read!("day03.txt")
            |> String.split()
            |> (fn [line | rest] -> [String.duplicate(".", String.length(line)) | [line | rest]] end).()
            |> Day03.getClumps()
            |> Enum.map(fn clump -> Day03.parseClump(clump) end)
            |> Enum.sum()
            |> IO.inspect()
    end
end

Day03.question1