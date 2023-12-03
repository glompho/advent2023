defmodule AdventOfCode.Day01 do
  @map %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  @pam Map.new(Enum.map(@map, fn {k, v} -> {String.reverse(k), v} end))

  def first_with_last("") do
    "0"
  end

  def first_with_last(s) do
    cond do
      String.length(s) < 2 -> s <> s
      true -> find_first_number(s) <> find_last_number(s)
    end
  end

  def find_first_number(s) do
    s
    |> String.replace(Map.keys(@map), fn s -> @map[s] end)
    |> String.replace(~r/[^0-9]/, "")
    |> String.first()
  end

  def find_last_number(s) do
    s
    |> String.reverse()
    |> String.replace(Map.keys(@pam), fn s -> @pam[s] end)
    |> String.replace(~r/[^0-9]/, "")
    |> String.first()
  end

  def part1(args) do
    args
    |> String.split("\n")
    |> Enum.map(&String.replace(&1, ~r/[^0-9]/, ""))
    |> Enum.map(fn s -> String.to_integer(first_with_last(s)) end)
    |> IO.inspect()
    |> Enum.reduce(&+/2)

    # |> IO.inspect(label: "Part 1 Results")
  end

  def part2(args) do
    args
    |> String.split("\n")
    |> Enum.map(fn s -> String.to_integer(first_with_last(s)) end)
    |> IO.inspect()
    |> Enum.reduce(&+/2)
  end
end
