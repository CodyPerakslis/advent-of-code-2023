defmodule Day05 do 
    def getNumbers(line) do 
        String.split(line)
            |> Enum.map(fn n -> String.to_integer(n) end)
            
    end

    def mapValue(key, [destStart, srcStart, range]) do 
        diff = key - srcStart
        cond do 
            diff < 0 -> {:miss, key}
            diff >= range -> {:miss, key}
            true -> {:found, destStart + diff}
        end
    end

    def beforeRange(start, range, target, _) do 
        cond do 
            start >= target  -> :none 
            start + range <= target -> {start, range}
            true -> {start, target - start}
        end
    end

    def midRange(start, range, target, targetRange) do 
        cond do 
            start + range <= target -> :none
            start >= target + targetRange -> :none 
            start <= target -> {target, Enum.min([start + range, target + targetRange])}
            true -> {start, Enum.min([start + range, target + targetRange])}
        end
    end

    def afterRange(start, range, target, targetRange) do 
        cond do 
            start + range <= target + targetRange -> :none 
            start >= target + targetRange -> {start, range}
            true -> {target, start + range - (target + targetRange)}
        end
    end

    def mapRange({seedStart, seedRange}, [destStart, srcStart, srcRange]) do 
        {
            beforeRange(seedStart, seedRange, srcStart, srcRange),
            midRange(seedStart, seedRange, srcStart, srcRange)
                |> (fn x -> case x do 
                    :none -> :none 
                    {start, range} -> {start + destStart - srcStart, range}
                    end
                end).(),
            afterRange(seedStart, seedRange, srcStart, srcRange),
        }
    end

    def getValueLists(map, waiting) do 
        getValueLists(map, waiting, [], [])
    end

    def getValueLists(_, [], misses, finds) do 
        {misses, finds}
    end

    def getValueLists(map, [{start, current} | remaining], misses, finds) do 
        case mapValue(current, map) do 
            {:miss, key} -> getValueLists(map, remaining, [{start, key} | misses], finds)
            {:found, key} -> getValueLists(map, remaining, misses, [{start, key} | finds])
        end
    end 

    def maybeAdd(rangeList, range) do 
        case range do 
            :none -> rangeList
            _ -> [range | rangeList]
        end
    end

    def getValueLists2(map, waiting) do 
        getValueLists2(map, waiting, [], [])
    end

    def getValueLists2(_, [], misses, finds) do 
        {misses, finds}
    end

    def getValueLists2(map, [seed | remaining], misses, finds) do 
        {r1, r2, r3 } = mapRange(seed, map)
        IO.inspect({seed, map, r1, r2, r3})
        getValueLists2(map, remaining, maybeAdd(misses, r1) |> maybeAdd(r3), maybeAdd(finds, r2))
    end 

    def travelMap2({seedValues, lines}) do 
        travelMap2(seedValues, lines, [])
    end

    def travelMap2(waitingValues, [], foundValues) do 
        waitingValues ++ foundValues
    end

    def travelMap2(waitingValues, [line | remainingLines], foundValues) do 
        case String.ends_with?(line, "map:") do 
            true -> travelMap2(waitingValues ++ foundValues, remainingLines, [])
            false -> getNumbers(line) 
                |> getValueLists2(waitingValues) 
                |> (fn {misses, finds} -> travelMap2(misses, remainingLines, finds ++ foundValues) end).()
        end
    end

    def travelMap({seedValues, lines}) do 
        travelMap(seedValues, lines, [])
    end

    def travelMap(waitingValues, [], foundValues) do 
        waitingValues ++ foundValues
    end

    def travelMap(waitingValues, [line | remainingLines], foundValues) do 
        case String.ends_with?(line, "map:") do 
            true -> travelMap(waitingValues ++ foundValues, remainingLines, [])
            false -> getNumbers(line) 
                |> getValueLists(waitingValues) 
                |> (fn {misses, finds} -> travelMap(misses, remainingLines, finds ++ foundValues) end).()
        end
    end

    def question1 do 
        File.read!("day05.txt")
            |> String.split("\n")
            |> Enum.filter(fn line -> line !== "" end)
            |> (fn ["seeds: " <> seeds | maps] -> {
                getNumbers(seeds) |> Enum.map(fn n -> {n, n} end), 
                maps
                } end).()
            |> IO.inspect(label: "lines")
            |> travelMap()
            |> IO.inspect(label: "mappings")
            |> Enum.min_by(fn {_, plot} -> plot end)
            |> IO.inspect(label: "minimum")
    end 

    def getSeeds([], groups) do 
        groups
    end

    def getSeeds([s1 | [s2 | seeds]], groups) do 
        getSeeds(seeds, [{s1, s2} | groups])
    end 


    def question2 do 
        File.read!("day05.test.txt")
            |> String.split("\n")
            |> Enum.filter(fn line -> line !== "" end)
            |> (fn ["seeds: " <> seeds | maps] -> {
                getNumbers(seeds) |> getSeeds([]), 
                maps
                } end).()
            |> IO.inspect(label: "lines")
            |> travelMap2()
            |> IO.inspect(label: "mappings")
    end 
end 


Day05.question2