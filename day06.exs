defmodule Day06 do
    def check(val, label) do 
        IO.inspect(val, charlists: :as_lists, label: label)
    end

    def combine([], [], result) do 
        result
    end

    def combine([n1 | l1], [n2 | l2], result) do 
        combine(l1, l2, result ++ [{n1, n2}])
    end

    def combine2([], [], {r1, r2}) do 
        {String.to_integer(r1), String.to_integer(r2)}
    end

    def combine2([n1 | l1], [n2 | l2], {r1, r2}) do 
        combine2(l1, l2, {r1 <> n1, r2 <> n2})
    end

    def quadratic(time, distance) do 
        sqrDiscriminant = (time**2 - 4*distance) ** 0.5
        {(time + sqrDiscriminant) / 2, (time - sqrDiscriminant) / 2}
    end

    def getWinCount({time, distance}) do 
        # Solve for the 0's using the quadratic formula
        # The solution is all the numbers in the middle
        {upper, lower} = quadratic(time, distance)
        # strictly greater, so nudge integers
        delta = 0.00000000000001
        check({upper, lower}, time)
        1 + floor(upper - delta) - ceil(lower + delta)
    end

    def question1 do 
        File.read!("day06.txt")
            |> String.split("\n")
            |> Enum.map(fn line -> String.split(line) 
                |> Enum.drop(1) 
                |> Enum.map(fn num -> String.to_integer(num) end)
            end)
            |> (fn [l1, l2] -> combine(l1, l2, []) end).()
            |> check("parsed input")
            |> Enum.map(fn x -> getWinCount(x) end)
            |> check("win counts")
            |> Enum.product()
            |> check("result")
    end

    def question2 do 
        File.read!("day06.txt")
            |> String.split("\n")
            |> Enum.map(fn line -> String.split(line) 
                |> Enum.drop(1) 
            end)
            |> (fn [l1, l2] -> combine2(l1, l2, {"",""}) end).()
            |> check("parsed input")
            |> getWinCount()
            |> check("result")
    end
end