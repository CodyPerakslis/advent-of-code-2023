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
            x == 42 -> {:gear}
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
                                                                {:gear} -> true
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

    def getGears(surronding, baseIndex, rowLen) do 
        Enum.with_index(surronding, fn element, index -> {element, 
            cond do 
                index <= 2 -> baseIndex + index
                index === 3 -> baseIndex + rowLen
                index === 4 -> baseIndex + rowLen + 2
                true -> baseIndex + 2*rowLen + index - 5
            end
        } end) 
            |> Enum.filter(fn {element, _} -> case parse(element) do
                {:gear} -> true 
                _ -> false
                end
            end)
            |> Enum.map(fn {_, index} -> index end)
    end

    def mergeGearTables(gT1, gT2) do 
        Map.merge(gT1, gT2, fn _, v1, v2 -> v1 ++ v2 end)
    end

    def addGears(gearTable, [], _) do 
        gearTable
    end

    def addGears(gearTable, [gear], number) do 
        mergeGearTables(gearTable, %{gear => [number]})
    end

    def addGears(gearTable, [gear | otherGears], number) do 
        addGears(gearTable, [gear], number)
            |> addGears(otherGears, number)
    end

    def parseGearClump([l1, l2, l3], rowIndex, rowLen) do 
        parseGearClump(to_charlist(l1), to_charlist(l2), to_charlist(l3), rowIndex*rowLen, rowLen, 0, [], %{})
    end

    def parseGearClump([_, _], [_, _], [_, _], _, _, num, gears, gearTable) do
        addGears(gearTable, gears, num)
    end

    def parseGearClump([s11 | [s12 | [s13 | s1r]]], [s21 | [s22 | [s23 | s2r]]], [s31 | [s32 | [s33 | s3r]]], baseIndex, rowLen, num, gears, gearTable) do 
        case parse(s22) do 
            {:num, val} -> parseGearClump([s12 | [s13 | s1r]], 
                                    [s22 | [s23 | s2r]], 
                                    [s32 | [s33 | s3r]], 
                                    baseIndex + 1,
                                    rowLen,
                                    10*num+val, 
                                    gears ++ getGears([s11, s12, s13, s21, s23, s31, s32, s33], baseIndex, rowLen),
                                    gearTable)
            _ -> parseGearClump([s12 | [s13 | s1r]], 
                            [s22 | [s23 | s2r]], 
                            [s32 | [s33 | s3r]],
                            baseIndex + 1,
                            rowLen,
                            0,
                            [],
                            addGears(gearTable, Enum.uniq(gears), num))
        end
    end

    def getGearValue(numbers) do 
        case numbers do 
            [a, b] -> a * b
            _ -> 0
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

    def question2 do 
        File.read!("day03.txt")
            |> String.split()
            |> (fn [line | rest] -> [String.duplicate(".", String.length(line)) | [line | rest]] end).()
            |> Day03.getClumps()
            |> Enum.with_index(fn element, index -> {index, element} end)
            |> Enum.map(fn {index, [l1 | rest]} -> Day03.parseGearClump([l1 | rest], index, String.length(l1)) end)
            |> Enum.reduce(fn map, acc -> Day03.mergeGearTables(acc, map) end)
            |> Map.values()
            |> Enum.map(fn numbers -> Day03.getGearValue(numbers) end)
            |> Enum.sum()
            |> IO.inspect()
    end


end

Day03.question2