defmodule AdventOfCode.Day09 do
  def parse(args) do
    args
    |> String.split(["\n", "\r"], trim: true)
    |> Enum.map(fn line ->
      line |> String.split() |> Enum.map(&String.to_integer/1)
    end)
  end

  def find_diffs(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x, y] -> y - x end)
  end

  def find_next(list) do
    # Rewrote in terms of part 2 function.
    find_prev(Enum.reverse(list))
  end

  def find_prev(list) do
    diffs = find_diffs(list)

    s = Enum.sum(diffs)

    case s do
      0 -> hd(list) - hd(diffs)
      _ -> hd(list) - find_prev(diffs)
    end
  end

  def part1(args) do
    parse(args)
    |> Enum.map(fn list ->
      find_next(list)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    parse(args)
    |> Enum.map(fn list ->
      find_prev(list)
    end)
    |> Enum.sum()
  end
end
