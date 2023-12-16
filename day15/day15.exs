defmodule Day15 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    # prime values give a 1-1 function from one mod to another
    def constructModMap(prime, modulus) do 
        Enum.map(0..(modulus-1), fn x -> rem(x * prime, modulus) end)
    end 

    def removeLens(label, lensMap, modMap, modulus) do 
        Map.get_and_update(
            lensMap, 
            hashString(label, modMap, modulus, 0),
            fn lenses -> {
                lenses,
                case lenses do 
                    nil -> []
                    _ -> lenses |> Enum.filter(fn {l, _} -> l !== label end)
                end
            }
            end)
            |> elem(1)
    end 

    def updateLensBox([], targetLabel, targetFocal) do
        [{targetLabel, targetFocal}]
    end 

    def updateLensBox([{label, focal} | lenses], targetLabel, targetFocal) do
        case label do 
            ^targetLabel -> [{label, targetFocal} | lenses]
            _ -> [{label, focal} | updateLensBox(lenses, targetLabel, targetFocal)]
        end
    end 

    def addLens(label, focal, lensMap, modMap, modulus) do 
        Map.get_and_update(
            lensMap, 
            hashString(label, modMap, modulus, 0),
            fn lenses -> {
                lenses,
                case lenses do 
                    nil -> [{label, focal}]
                    _ -> updateLensBox(lenses, label, focal)
                end
            }
            end)
            |> elem(1)
    end

    def doInstruction(instruction, lensMap, modMap, modulus) do 
        check(instruction, "instruction")
        case String.split(instruction, "=") do 
            [label, focal] -> addLens(label, String.to_integer(focal), lensMap, modMap, modulus)
            [^instruction] -> removeLens(String.slice(instruction, 0..-2), lensMap, modMap, modulus)
        end
    end 

    def boxScore(lenses) do 
        boxScore(lenses, 1)
    end 

    def boxScore([], _) do 
        0
    end 

    def boxScore([{_, focal} | lenses], count) do 
        focal * count + boxScore(lenses, count + 1)
    end 

    def addMods(m1, m2, modMap, modulus) do 
        m3 = m1 + m2 
        cond do 
            m3 >= modulus -> Enum.at(modMap, m3 - modulus)
            true -> Enum.at(modMap, m3)
        end
    end 

    def hashString("", _, _, total) do 
        total
    end 

    def hashString(<<c::utf8, rest::binary>>, modMap, modulus, total) do 
        hashString(rest, modMap, modulus, addMods(c, total, modMap, modulus))
    end 

    def solve(input, prime, modulus) do 
        modMap = constructModMap(prime, modulus)
        File.read!(input)
            |> String.split(",")
            |> check("input")
            |> Enum.map(fn x -> hashString(x, modMap, modulus, 0) end)
            |> check("hashes")
            |> Enum.sum()
            |> check("sum")
    end

    def solve2(input, prime, modulus) do 
        modMap = constructModMap(prime, modulus)
        File.read!(input)
            |> String.split(",")
            |> check("input")
            |> Enum.reduce(
                %{},
                fn instruction, accMap -> doInstruction(instruction, accMap, modMap, modulus) 
                    |> check("current map")
            end)
            |> check("lens maps")
            |> Map.to_list()
            |> check("lens list")
            |> Enum.map(fn {box, lenses} -> (box + 1) * boxScore(lenses) end)
            |> check("box scores")
            |> Enum.sum()
            |> check("sum")
    end

    def test do 
        solve("test.txt", 17, 256)
    end

    def answer do 
        solve("input.txt", 17, 256)
    end

    def test2 do 
        solve2("test.txt", 17, 256)
    end

    def answer2 do 
        solve2("input.txt", 17, 256)
    end
end

Day15.answer2