defmodule AdventOfCode.Day05 do
  def parse(input) do
    [seed_string | rest] = String.split(input, ["\n", "\r"], trim: true)

    seeds =
      seed_string
      |> String.split(" ", trim: true)
      |> tl
      |> Enum.map(&String.to_integer(&1))

    maps =
      rest
      |> Enum.chunk_by(&String.contains?(&1, "map"))
      # filter out the map titles
      |> Enum.flat_map(fn
        [_map_name] ->
          []

        list ->
          [
            Enum.map(list, fn list ->
              list
              |> String.split(" ")
              |> Enum.map(&String.to_integer(&1))
            end)
          ]
      end)

    {seeds, maps}
  end

  def flatten_maps(maps) do
    maps
    # |> IO.inspect(label: "maps", charlists: :as_list)
  end

  def follow_maps(seeds, maps) do
    for seed <- seeds do
      for map <- maps, reduce: seed do
        seed ->
          [dest, source, _range] =
            Enum.find(map, [1, 1, 0], fn [_dest, source, range] ->
              source <= seed and seed <= source + range - 1
            end)

          seed - source + dest
      end
    end
    |> IO.inspect(label: "old results", charlists: :as_list)

    # |> Enum.min()
  end

  def f_o([seed_min, seed_range], [map_min, map_range]) do
    seed_max = seed_min + seed_range - 1
    map_max = map_min + map_range - 1
    # IO.inspect({[seed_min, seed_max], [map_min, map_max]}, label: "input", charlists: :as_list)

    cond do
      # [leave, change]

      seed_max < map_min ->
        # no overlap
        [[[seed_min, seed_range]], []]

      map_max < seed_min ->
        # no overlap
        [[[seed_min, seed_range]], []]

      seed_min >= map_min and seed_max <= map_max ->
        # seed range in map
        [[], [[seed_min, seed_range]]]

      map_min >= seed_min and map_max <= seed_max ->
        # map inside seed range
        [
          [[seed_min, map_min - seed_min], [map_max + 1, seed_max - map_max]],
          [[map_min, map_range]]
        ]

      seed_min <= map_max and map_max <= seed_max ->
        # seed range extends above map range
        [
          [[map_max + 1, seed_max - map_max]],
          [[seed_min, map_max - seed_min + 1]]
        ]

      seed_min <= map_min and map_min <= seed_max ->
        # seed range extends below map range
        [
          [[seed_min, map_min - seed_min]],
          [[map_min, seed_max - map_min + 1]]
        ]
    end
  end

  def shift_overlap([leave, change], offset) do
    leave ++ Enum.map(change, fn [min, range] -> [min - offset, range] end)
  end

  def find_and_apply([s, s_r], maps) do
    [target, start, r] =
      maps
      |> Enum.find([:no_match, -100, 1], fn [_dest, source, range] ->
        (source <= s and s <= source + range - 1) or
          (source <= s + s_r and s + s_r <= source + range - 1)
      end)

    if target == :no_match do
      # no match so just return the range
      [[s, s_r]]
    else
      # |> IO.inspect()
      split = f_o([s, s_r], [start, r])
      IO.inspect({[s, s + s_r - 1], [start, start + r - 1], split}, charlists: :as_list)
      shift_overlap(split, start - target)
    end
  end

  def follow_maps_r(seed_ranges, []) do
    seed_ranges
  end

  def follow_maps_r([], _) do
    []
  end

  def follow_maps_r([seed | later_seeds], [maps | later_maps]) do
    mapped_seeds = find_and_apply(seed, maps)

    follow_maps_r(later_seeds, [maps | later_maps]) ++ follow_maps_r(mapped_seeds, later_maps)
  end

  def part1(args) do
    {seeds, maps} = parse(args)

    follow_maps(seeds, maps)
    |> Enum.min()
  end

  def part2(args) do
    {seeds, maps} = parse(args)

    old =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.flat_map(fn [start, range] -> start..(start + range - 1) end)
      # |> IO.inspect(label: "new seeds", charlists: :as_list)
      |> follow_maps(maps)
      |> MapSet.new()

    # |> IO.inspect(label: "old results", charlists: :as_list)

    new =
      seeds
      |> Enum.chunk_every(2)
      |> follow_maps_r(maps)
      |> dbg()
      |> IO.inspect(label: "new range of results", charlists: :as_list)
      |> Enum.map(fn [x, y] -> Enum.to_list(x..(x + y - 1)) end)
      |> List.flatten()
      |> MapSet.new()

    # |> IO.inspect(label: "new range of result", charlists: :as_list)

    IO.inspect(MapSet.intersection(old, new), label: "overlap")
    IO.inspect(MapSet.difference(old, new), label: "difference")
    IO.inspect(MapSet.difference(new, old), label: "difference")
    Enum.min(old)
    # |> Enum.min()
  end
end
