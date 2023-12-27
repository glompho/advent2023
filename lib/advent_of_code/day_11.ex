# import Aja

defmodule AdventOfCode.Day11 do
  def contained_in_col?(map, col, value) do
    Enum.any?(map, fn {{x, _y}, v} -> x == col and v == value end)
  end

  def contained_in_row?(map, row, value) do
    Enum.any?(map, fn {{_x, y}, v} -> y == row and v == value end)
  end

  def l_parse(args) do
    args
    |> String.split(["\n", "\r"], trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def transpose(list_parse) do
    list_parse |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
  end

  def m_parse(list_parse) do
    for {line, y} <- Enum.with_index(list_parse),
        {char, x} <- Enum.with_index(line),
        into: %{} do
      {{x, y}, char}
    end
  end

  def expand_rows(list_parse) do
    for line <- list_parse, reduce: [] do
      emap ->
        cond do
          Enum.member?(line, "#") -> emap ++ [line]
          true -> emap ++ [line] ++ [line]
        end
    end
  end

  def find_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def cp(list) do
    Enum.flat_map(list, fn x ->
      Enum.map(list, fn y -> {x, y} end)
    end)
  end

  defp pairs([]), do: []
  defp pairs([_]), do: []

  defp pairs([h | t]) do
    Enum.map(t, &{h, &1}) ++ pairs(t)
  end

  def find_distances(list) do
    list |> pairs() |> Enum.map(fn {p1, p2} -> find_distance(p1, p2) end)
  end

  def parse(args) do
    args
    |> l_parse()
    |> m_parse()
  end

  def expand_map(map, factor) do
    empty_rows =
      for {{x, _y}, _char} <- map, reduce: MapSet.new() do
        acc ->
          if !contained_in_row?(map, x, "#") do
            MapSet.put(acc, x)
          else
            acc
          end
      end

    empty_cols =
      for {{_x, y}, _char} <- map, reduce: MapSet.new() do
        acc ->
          if !contained_in_col?(map, y, "#") do
            MapSet.put(acc, y)
          else
            acc
          end
      end

    for {{x, y}, char} <- map, into: %{} do
      cols_passed = Enum.count(Enum.filter(empty_cols, fn col -> col < x end))
      rows_passed = Enum.count(Enum.filter(empty_rows, fn row -> row < y end))
      {{x + cols_passed * (factor - 1), y + rows_passed * (factor - 1)}, char}
    end
  end

  def part1(args) do
    expanded_l =
      args
      |> l_parse()
      |> expand_rows()
      |> transpose()
      |> expand_rows()
      |> transpose()

    map = expanded_l |> m_parse()

    inverted_map =
      Enum.group_by(
        map,
        fn {_key, value} -> value end,
        fn {key, _value} -> key end
      )

    # |> IO.inspect()
    galaxy_locs = inverted_map["#"]

    find_distances(galaxy_locs) |> Enum.sum()
  end

  def part2(args) do
    part2_with_factor(args, 1_000_000)
  end

  def part2_with_factor(args, factor) do
    map = args |> l_parse() |> m_parse() |> expand_map(factor)

    inverted_map =
      Enum.group_by(
        map,
        fn {_key, value} -> value end,
        fn {key, _value} -> key end
      )

    galaxy_locs = inverted_map["#"]

    find_distances(galaxy_locs) |> Enum.sum()
  end
end
