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

    def cardValue2(card) do 
        case card do 
            65 -> 13
            75 -> 12
            81 -> 11
            74 -> 1
            84 -> 10
            _ -> card - 48
        end
    end

    def lowerHandCards2(<<c1::utf8, h1::binary>>, <<c2::utf8, h2::binary>>) do 
        case c1 == c2 do 
            true -> lowerHandCards2(h1, h2)
            false -> cardValue2(c1) < cardValue2(c2)
        end
    end

    def getCardCounts2("", map, jokers) do 
        Map.values(map)
            |> Enum.sort(:desc)
            |> (fn l -> {l, jokers} end).()
    end

    def getCardCounts2(<<card, rest::binary>>, map, jokers) do 
        case card do 
            74 -> getCardCounts2(rest, map, jokers + 1)
            _ -> getCardCounts2(rest, Map.update(map, card, 1, fn x -> x + 1 end), jokers)
        end
    end

    def wildHand(score, 0) do 
        score
    end

    def wildHand(score, jokers) do 
        wildHand(cond do 
            score < 1 -> score + 1
            score < 4 -> score + 2
            score < 6 -> score + 1
        end, jokers - 1)
    end

    def getHandType2(hand) do 
        {counts, jokers} = getCardCounts2(hand, %{}, 0)
        wildHand(
            case counts do 
                [] -> -1
                [1 | _] -> 0
                [2 | [2 | _]] -> 2
                [2 | _] -> 1
                [3 | [2 | _]] -> 4
                [3 | _] -> 3
                [4 | _] -> 5
                [5] -> 6
            end,
            jokers
        )
    end

    def question2 do 
        File.read!("day07.txt")
            |> String.split("\n")
            |> Enum.map(fn line -> String.split(line)
                |> (fn [hand, bid] -> {hand, String.to_integer(bid), getHandType2(hand)} end).()
            end)
            |> check("hands")
            |> Enum.sort(fn {h1, _, k1}, {h2, _, k2} -> 
                case k1 == k2 do 
                    true -> lowerHandCards2(h1, h2)
                    false -> k1 < k2
                end
            end)
            |> check("sorted hands")
            |> Enum.reduce({1, 0}, fn {_, bid, _}, {idx, total} -> {idx + 1, total + idx * bid} end)
            |> check("total")
    end
end