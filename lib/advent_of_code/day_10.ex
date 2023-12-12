defmodule AdventOfCode.Day10 do
  @valid_map %{
    {-1, 0} => ["|", "7", "F"],
    {1, 0} => ["|", "L", "J"],
    {0, -1} => ["-", "L", "F"],
    {0, 1} => ["-", "7", "J"]
  }
  @move_map %{
    "-" => [{0, 1}, {0, -1}],
    "|" => [{1, 0}, {-1, 0}],
    "7" => [{1, 0}, {0, -1}],
    "F" => [{1, 0}, {0, 1}],
    "J" => [{-1, 0}, {0, -1}],
    "L" => [{-1, 0}, {0, 1}]
  }

  def parse(args) do
    args
    |> String.split(["\n", "\r"], trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_index} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, char_index} ->
        {{line_index, char_index}, char}
      end)
    end)
    |> Map.new()
  end

  def find_valid_next({x, y}, map) do
    for {i, j} <- Map.keys(@valid_map) do
      char = Map.get(map, {x + i, j + y}, nil)

      if char in @valid_map[{i, j}] do
        {x + i, j + y}
      else
        nil
      end
    end
    |> Enum.filter(&(&1 != nil))
  end

  def follow_path({x, y}, map, route) do
    # IO.inspect({{x, y}, route})
    char = Map.get(map, {x, y})

    if char == "S" do
      route
    else
      next_loc =
        Map.get(@move_map, char)
        |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
        |> Enum.filter(fn new -> new != hd(route) end)
        |> hd

      # IO.inspect({next_loc, [{x, y}] ++ route})
      follow_path(next_loc, map, [{x, y}] ++ route)
    end
  end

  def find_path(map) do
    {start_x, start_y} =
      map
      |> Enum.find(fn {_key, val} -> val == "S" end)
      |> elem(0)

    {next_x, next_y} = find_valid_next({start_x, start_y}, map) |> hd

    follow_path({next_x, next_y}, map, [{start_x, start_y}])
  end

  def part1(args) do
    map =
      parse(args)

    route_len =
      find_path(map)
      |> Enum.count()

    Float.floor(route_len / 2)
  end

  def shoe_lace(path) do
    length = Enum.count(path)

    s =
      path
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [{xi, yi}, {xj, yj}] ->
        (yi + yj) * (xi - xj)
      end)
      |> Enum.sum()

    area = 0.5 * s
  end

  def flood_fill(map, path) do
    # is this the way?
    nil
  end

  def part2(args) do
    map = parse(args)

    path = find_path(map)
    IO.inspect(Enum.count(path))
    # this doesn't seem to get anywhere near the truth.
    area = shoe_lace(path)
  end
end
