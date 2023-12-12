defmodule Day11 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def getIndices(file) do 
        getIndices(file, 0, 0)
    end

    def getIndices("", _, _) do 
        []
    end 

    def getIndices(<<c>> <> file, row, col) do
        case c do 
            ?# -> [ {row, col} | getIndices(file, row, col + 1) ]
            ?. -> getIndices(file, row, col + 1)
            ?\n -> getIndices(file, row + 1, 0)
        end
    end

    def getGalaxyExpansion(cord, []) do 
        cord
    end 

    def getGalaxyExpansion(cord, [expanse | expansions]) do 
        cond do 
            # change the rate from 999999 -> 1 for part 1
            cord > expanse -> 999999 + getGalaxyExpansion(cord, expansions)
            true -> cord
        end
    end 

    def expand(galaxies) do 
        {xMap, yMap, xMax, yMax} = Enum.reduce(
            galaxies, 
            {MapSet.new(), MapSet.new(), 0, 0}, 
            fn {x, y}, {xMap, yMap, xMax, yMax} -> 
                {MapSet.put(xMap, x), MapSet.put(yMap, y), Enum.max([xMax, x]), Enum.max([yMax, y])}
            end)
        {xExpansions, yExpansions} = {
            MapSet.difference(MapSet.new(0..xMax), xMap) |> MapSet.to_list(),
            MapSet.difference(MapSet.new(0..yMax), yMap) |> MapSet.to_list()
        }
        Enum.map(galaxies, fn {x, y} -> {getGalaxyExpansion(x, xExpansions), getGalaxyExpansion(y, yExpansions)} end)
    end

    def getLength({x1, y1}, {x2, y2}) do 
        abs(x1 - x2) + abs(y1 - y2)
    end

    def pairwiseLength([]) do 
        0
    end

    def pairwiseLength([g | galaxies]) do 
        Enum.reduce(
            galaxies, 
            0, 
            fn g2, acc -> acc + getLength(g, g2)
            end) + pairwiseLength(galaxies)
    end 

    def solve(input) do 
        File.read!(input)
            |> check("input")
            |> getIndices()
            |> check("galaxies")
            |> expand()
            |> check("expansion")
            |> pairwiseLength()
            |> check("result")
    end

    def test do 
        solve("test.txt")
    end

    def answer do 
        solve("input.txt")
    end
end

Day11.answer