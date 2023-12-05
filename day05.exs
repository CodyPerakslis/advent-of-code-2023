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
end 


Day05.question1