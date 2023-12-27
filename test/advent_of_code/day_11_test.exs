defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  input = "
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."

  @input input

  test "part1" do
    input = @input
    result = part1(input)

    assert result == 374
  end

  test "part2_factor_10" do
    input = @input
    result = part2_with_factor(input, 10)

    assert result == 1030
  end

  test "part2_factor 100" do
    input = @input
    result = part2_with_factor(input, 100)

    assert result == 8410
  end
end
