defmodule AdventOfCode.Day02 do
  @max_key %{"red" => 12, "green" => 13, "blue" => 14}

  def find_highest([s]) do
    s
    |> String.replace(~r/[^0-9redgreenblue\s]/, "")
    |> String.split(" ", trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> {String.to_integer(a), b} end)
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.map(fn {colour, values} ->
      {colour, Enum.reduce(Enum.map(values, &elem(&1, 0)), &max/2)}
    end)
  end

  def filter_games(s) do
    s
    |> Enum.map(fn {colour, value} ->
      value <= @max_key[colour]
    end)
    |> Enum.all?()
  end

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      s
      |> String.split([":"])
      |> tl
      |> find_highest()
      |> filter_games()
    end)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      if value do
        index + 1
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      s
      |> String.split([":"])
      |> tl
      |> find_highest()
      |> Enum.map(fn {_c, number} -> number end)
    end)
    |> Enum.map(&Enum.product(&1))
    |> Enum.sum()
  end
end
