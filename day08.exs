defmodule Day08 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def createMap([], map) do 
        map
    end

    def createMap([line | rest], map) do 
        createMap(rest, Map.put(
                map, 
                String.slice(line, 0..2),
                {String.slice(line, 7..9), String.slice(line, 12..14)}
            ))
    end

    def travelMap({directions, map}) do 
        travelMap(directions, "AAA", 0, map, directions)
    end

    def travelMap("", current, count, map, fullDirections) do 
        travelMap(fullDirections, current, count, map, fullDirections)
    end

    # Chaunge to <<_>> <> <<_>> <> "Z" for part 1
    def travelMap(_, "ZZZ", count, _, _) do 
        count
    end

    def travelMap(<<direction::utf8, rest::binary>>, current, count, map, fullDirections) do 
        {left, right} = Map.get(map, current)
        case direction do 
            ?L -> travelMap(rest, left, count + 1, map, fullDirections)
            ?R -> travelMap(rest, right, count + 1, map, fullDirections)
        end
    end

    def question1 do 
        File.read!("day08.txt")
            |> String.split("\n")
            |> check("lines")
            |> (fn [directions | [_ | map]] -> {directions, createMap(map, %{})} end).()
            |> check("map")
            |> travelMap()
            |> check("solution")
    end

    # def isDone([<<_>> <> <<_>> <> "Z" | rest]) do 
    #     isDone(rest)
    # end

    # def isDone([_ | _]) do 
    #     false
    # end

    # def isDone([]) do 
    #     true
    # end

    # def getNext([], _, _, found) do 
    #     found
    # end

    # def getNext([curr | rest], map, dir, found) do 
    #     {left, right} = Map.get(map, curr)
    #     case dir do 
    #         ?L -> getNext(rest, map, dir, found ++ [left])
    #         ?R -> getNext(rest, map, dir, found ++ [right])
    #     end
    # end

    def ghostTravel({directions, map}) do 
            Map.keys(map)
                |> Enum.filter(fn x -> String.at(x, 2) == "A" end)
                |> Enum.map(fn start -> travelMap(directions, start, 0, map, directions) end)
    end

    # def ghostTravel("", current, count, map, fullDirections) do 
    #     ghostTravel(fullDirections, current, count, map, fullDirections)
    # end

    # def ghostTravel(<<direction::utf8, rest::binary>>, current, count, map, fullDirections) do 
    #     case isDone(current) do 
    #         true -> count 
    #         false -> ghostTravel(rest, getNext(current, map, direction, []), count + 1, map, fullDirections)
    #     end
    # end

    # Brute force didn't work (too slow)
    # Possible solution to keep track of when they get in loops, then find LCM
    def question2 do 
        File.read!("day08.txt")
            |> String.split("\n")
            |> check("lines")
            |> (fn [directions | [_ | map]] -> {directions, createMap(map, %{})} end).()
            |> check("map")
            |> ghostTravel()
            |> check("solution")
    end
end

Day08.question2