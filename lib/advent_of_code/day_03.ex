defmodule AdventOfCode.Day03 do
  def is_symbol(s) do
    !(String.match?(s, ~r/[1-9.]/) or s == "")
  end

  def c_around({x, y}) do
    out =
      for i <- -1..1 do
        for j <- -1..1 do
          case {x + i, y + j} do
            {-1, _} -> {100_000_000, y + j}
            {_, -1} -> {x + i, 100_000_000}
            {_, _} -> {x + i, y + j}
          end
        end
      end

    List.flatten(out)
  end

  def symbols_around(input, {x, y}) do
    Enum.map(c_around({x, y}), fn {i, j} ->
      input
      |> Enum.at(i, ["."])
      |> Enum.at(j, ".")
    end)
  end

  def symbols_with_c(input, {x, y}) do
    Enum.map(c_around({x, y}), fn {i, j} ->
      out =
        input
        |> Enum.at(i, ["."])
        |> Enum.at(j, ".")

      {{i, j}, out}
    end)
  end

  def transform_data(data) do
    Enum.reduce(data, %{}, fn {gears, num}, acc ->
      Enum.reduce(gears, acc, fn gear, acc ->
        Map.update(acc, gear, [num], &(&1 ++ [num]))
      end)
    end)
  end

  def part1(args) do
    parsed =
      args
      |> String.split(["\n", "\r"], trim: true)
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)

    hitmap =
      for {line, i} <- Enum.with_index(parsed) do
        for {token, j} <- Enum.with_index(line) do
          cond do
            String.match?(token, ~r/[0-9]/) ->
              around =
                parsed
                |> symbols_around({i, j})
                |> Enum.all?(&String.match?(&1, ~r/[0-9.]/))

              if around do
                token
              else
                "M" <> token
              end

            true ->
              "."
          end
        end
      end

    hitmap
    |> Enum.map(fn line ->
      line
      |> List.to_string()
      |> String.split(".")
      |> Enum.filter(&String.contains?(&1, "M"))
    end)
    |> List.flatten()
    |> Enum.map(fn s ->
      s
      |> String.replace("M", "")
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def part2(args) do
    parsed =
      args
      |> String.split(["\n", "\r"], trim: true)
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)

    hitmap =
      for {line, i} <- Enum.with_index(parsed) do
        for {token, j} <- Enum.with_index(line) do
          cond do
            String.match?(token, ~r/[0-9]/) ->
              around =
                parsed
                |> symbols_with_c({i, j})
                |> Enum.filter(fn {{_i, _j}, token} -> token == "*" end)
                |> Enum.map(fn {{i, j}, _t} -> {i, j} end)

              # |> IO.inspect()

              if around == [] do
                {[], token}
              else
                {around, token}
              end

            true ->
              "."
          end
        end
      end

    hitmap
    |> List.flatten()
    |> Enum.chunk_by(fn x -> x != "." end)
    |> Enum.reject(fn x -> Enum.all?(x, &(&1 == ".")) end)
    |> Enum.map(fn line ->
      line
      |> Enum.reduce({[], []}, fn
        {list, num}, {[], []} ->
          {list, num}

        {list, num}, {gear_list, nums} ->
          {gear_list ++ list, nums <> num}
      end)
    end)
    |> Enum.filter(fn {list, _num} -> list != [] end)
    |> Enum.map(fn {list, num} ->
      {MapSet.new(list), String.to_integer(num)}
    end)
    |> transform_data()
    |> Map.values()
    |> Enum.map(fn
      [x, y] ->
        x * y

      _not_two_parts ->
        0
    end)
    |> Enum.sum()
  end
end
