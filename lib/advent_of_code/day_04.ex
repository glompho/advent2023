defmodule AdventOfCode.Day04 do
  def input_to_scores(input) do
    input
    |> String.split(["\n", "\r"], trim: true)
    |> Enum.map(fn string ->
      string
      |> String.split(":")
      |> tl
      |> hd
      |> String.split("|")
      |> Enum.map(fn nums ->
        nums
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer(&1))
      end)
    end)
    |> Enum.map(fn [winners, mine] ->
      MapSet.intersection(MapSet.new(winners), MapSet.new(mine))
      |> MapSet.size()
    end)
  end

  def part1(args) do
    args
    |> input_to_scores()
    |> Enum.reduce(0, fn
      0, acc ->
        acc

      element, acc ->
        acc + Integer.pow(2, element - 1)
    end)
  end

  def recursive_score([]), do: []

  def recursive_score([{num, score}]), do: [{num, score}]

  def recursive_score([{num, score} | tail]) do
    {to_copy, leave} = Enum.split(tail, score)
    new_tail = Enum.map(to_copy, fn {n, s} -> {num + n, s} end) ++ leave
    [{num, score}] ++ recursive_score(new_tail)
  end

  def part2(args) do
    args
    |> input_to_scores()
    |> Enum.map(fn score -> {1, score} end)
    |> recursive_score()
    |> Enum.map(fn {total, _score} -> total end)
    |> Enum.sum()
  end
end
