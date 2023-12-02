defmodule Day02 do
    def getFullGame(str) do
        [id, games] = String.split(str, ": ", parts: 2)
        [_, number] = String.split(id, " ", parts: 2)
        {String.to_integer(number), String.split(games, "; ")}
    end

    def getGameInstance(game) do
        Enum.map(String.split(game, ", "), fn instance ->
            getColorCount(instance)
        end)
    end

    def getColorCount(instance) do
        [count, color] = String.split(instance, " ", parts: 2)
        {String.trim(color), String.to_integer(count)}
    end

    def isValidCount({color, count}) do
        case color do
            "red" -> count <= 12
            "green" -> count <= 13
            "blue" -> count <= 14
        end
    end

    def isValidGame(games) do
        Enum.all?(games, fn game ->
            Enum.all?(getGameInstance(game), fn instance ->
                isValidCount(instance)
            end)
        end)
    end

    def addColorCount({red, green, blue, color, count}) do 
        case color do 
            "red" -> {max(red, count), green, blue}
            "green" -> {red, max(green, count), blue}
            "blue" -> {red, green, max(blue, count)}
        end
    end

    def getMaxColorCounts(games) do 
        games |> 
            Enum.flat_map(fn game -> getGameInstance(game) end) |>
            Enum.reduce({0,0,0}, fn {color,count}, {r,g,b} -> addColorCount({r,g,b,color,count}) end)
    end

    def question1 do 
        File.stream!("day02.txt") |> 
            Enum.map(&getFullGame/1) |>
            Enum.filter(fn {_, games} -> isValidGame(games) end) |>
            Enum.map(fn {id, _} -> id end) |>
            Enum.sum() |>
            IO.puts()
    end

    def question2 do 
        File.stream!("day02.txt") |> 
            Enum.map(&getFullGame/1) |>
            Enum.map(fn {_, games} -> games end) |>
            Enum.map(&getMaxColorCounts/1) |>
            Enum.map(fn {r,g,b} -> r*g*b end) |>
            Enum.sum() |>
            IO.puts()
        end
end
