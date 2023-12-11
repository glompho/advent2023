defmodule AdventOfCode.Day07 do
  @score_map %{[5] => 6, [4] => 5, [2, 3] => 4, [3] => 3, [2, 2] => 2, [2] => 1, [] => 0}
  @card_order %{"A" => 14, "K" => 13, "Q" => 12, "J" => 11, "T" => 10}
  @card_order2 Map.put(@card_order, "J", 11)

  def compare_ranks([a], [b]), do: a <= b

  def compare_ranks([head_a | tail_a], [head_b | tail_b]) do
    if head_a == head_b do
      compare_ranks(tail_a, tail_b)
    else
      head_a <= head_b
    end
  end

  def parse_hand(hand) do
    hand
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.put(acc, char, (acc[char] || 0) + 1)
    end)
  end

  def score_hand(hand) do
    hand_structure =
      parse_hand(hand)
      |> Map.values()
      |> Enum.filter(&(&1 != 1))
      |> Enum.sort()

    Map.get(@score_map, hand_structure)
  end

  def score_hand_wild("JJJJJ"), do: @score_map[[5]]

  def score_hand_wild(hand) do
    if String.contains?(hand, "J") do
      hand_structure =
        parse_hand(hand)

      jackless_hand = Map.drop(hand_structure, ["J"])

      {best_card, _} =
        jackless_hand
        |> Enum.max_by(fn {_key, value} -> value end)

      wild_hand =
        jackless_hand
        |> Map.update!(best_card, &(&1 + hand_structure["J"]))
        |> Map.values()
        |> Enum.filter(&(&1 != 1))
        |> Enum.sort()

      Map.get(@score_map, wild_hand)
    else
      score_hand(hand)
    end
  end

  def score_cards(hand, card_order) do
    hand
    |> String.graphemes()
    |> Enum.map(fn char ->
      if Map.has_key?(card_order, char) do
        Map.get(card_order, char, char)
      else
        String.to_integer(char)
      end
    end)
  end

  def do_solve(args, score_hand_f, card_order) do
    args
    |> String.split(["\n", "\r", " "], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [hand, rank] ->
      {[score_hand_f.(hand)] ++ score_cards(hand, card_order), rank}
    end)
    |> Enum.sort(fn {hr1, _}, {hr2, _} ->
      compare_ranks(hr1, hr2)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {{_, rank}, index} ->
      (index + 1) * String.to_integer(rank)
    end)
    |> Enum.sum()
  end

  def part1(args) do
    do_solve(args, &score_hand/1, @card_order)
  end

  def part2(args) do
    do_solve(args, &score_hand_wild/1, @card_order2)
  end
end
