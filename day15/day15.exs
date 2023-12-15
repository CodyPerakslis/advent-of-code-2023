defmodule Day15 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    # prime values give a 1-1 function from one mod to another
    def constructModMap(prime, modulus) do 
        Enum.map(0..(modulus-1), fn x -> rem(x * prime, modulus) end)
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

    def test do 
        solve("test.txt", 17, 256)
    end

    def answer do 
        solve("input.txt", 17, 256)
    end
end

Day15.answer