defmodule AdventOfCode.Day06 do
  def parse(input) do
    input
    |> String.split(["\n", "\r"], trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(":")
      |> tl
      |> hd
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def gen_wins(time, d_to_win) do
    # Naive method probably would have been quick enough
    for hold_time <- 1..time do
      (time - hold_time) * hold_time > d_to_win
    end
  end

  def quadratic(a, b, c) do
    b_squared = b ** 2
    q = b_squared - 4 * a * c

    if q < 0 do
      :no_real_solutions
    else
      q_root = :math.sqrt(q)
      [(-b + q_root) / (2 * a), (-b - q_root) / (2 * a)]
    end
  end

  def find_ways({time, d_to_win}) do
    # d_to_win + 1 because we want to win not draw
    [p, q] = Enum.sort(quadratic(1, -time, d_to_win + 1))
    # +1 because we want number of integers not range. So 2 to 5 should give 4
    abs(:math.floor(q)) - :math.ceil(p) + 1
  end

  def part1(args) do
    [time, distance] = parse(args)

    Enum.zip(time, distance)
    |> Enum.map(&find_ways/1)
    |> Enum.product()
  end

  def part2(args) do
    [[t], [d]] = parse(String.replace(args, " ", ""))
    # gen_wins(t, d) |> Enum.filter(fn x -> x end) |> Enum.count() #takes 3 seconds
    find_ways({t, d})
  end
end
