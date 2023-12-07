defmodule Day07 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def getCardCounts("", map) do 
        Map.values(map)
            |> Enum.sort()
    end

    def getCardCounts(<<card, rest::binary>>, map) do 
        getCardCounts(rest, Map.update(map, card, 1, fn x -> x + 1 end))
    end

    def getHandType(hand) do 
        case getCardCounts(hand, %{}) do 
            [5] -> 6
            [1, 4] -> 5
            [2, 3] -> 4
            [1, 1, 3] -> 3
            [1, 2, 2] -> 2
            [1, 1, 1, 2] -> 1
            _ -> 0
        end
    end

    def cardValue(card) do 
        case card do 
            65 -> 14
            75 -> 13
            81 -> 12
            74 -> 11
            84 -> 10
            _ -> card - 48
        end
    end

    def lowerHandCards(<<c1::utf8, h1::binary>>, <<c2::utf8, h2::binary>>) do 
        case c1 == c2 do 
            true -> lowerHandCards(h1, h2)
            false -> cardValue(c1) < cardValue(c2)
        end
    end

    def question1 do 
        File.read!("day07.txt")
            |> String.split("\n")
            |> Enum.map(fn line -> String.split(line)
                |> (fn [hand, bid] -> {hand, String.to_integer(bid), getHandType(hand)} end).()
            end)
            |> check("hands")
            |> Enum.sort(fn {h1, _, k1}, {h2, _, k2} -> 
                case k1 == k2 do 
                    true -> lowerHandCards(h1, h2)
                    false -> k1 < k2
                end
            end)
            |> check("sorted hands")
            |> Enum.reduce({1, 0}, fn {_, bid, _}, {idx, total} -> {idx + 1, total + idx * bid} end)
            |> check("total")
    end
end

Day07.question1