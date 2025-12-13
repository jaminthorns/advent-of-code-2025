defmodule Solutions.Day7 do
  @behaviour Solution

  @test_input """
  .......S.......
  ...............
  .......^.......
  ...............
  ......^.^......
  ...............
  .....^.^.^.....
  ...............
  ....^.^...^....
  ...............
  ...^.^...^.^...
  ...............
  ..^...^.....^..
  ...............
  .^.^.^.^.^...^.
  ...............
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  21
  """
  def solve_part_1(input) do
    [first | rest] = manifold(input)
    start = Enum.find_index(first, &(&1 == "S"))

    count_splits([start], rest)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  40
  """
  def solve_part_2(input) do
    [first | rest] = manifold(input)
    start = Enum.find_index(first, &(&1 == "S"))

    count_timelines([{start, 1}], rest)
  end

  defp manifold(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp count_splits(beams, manifold, split_count \\ 0)
  defp count_splits(_beams, [], split_count), do: split_count

  defp count_splits(beams, [current | rest], split_count) do
    splitters =
      current
      |> Enum.with_index()
      |> Enum.filter(&(elem(&1, 0) == "^"))
      |> Enum.map(&elem(&1, 1))

    results =
      Enum.map(beams, fn beam ->
        if beam in splitters,
          do: {:split, [beam - 1, beam + 1]},
          else: {:continue, [beam]}
      end)

    split_count = split_count + Enum.count(results, &match?({:split, _}, &1))

    results
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.uniq()
    |> count_splits(rest, split_count)
  end

  defp count_timelines(beams, []), do: Enum.sum_by(beams, &elem(&1, 1))

  defp count_timelines(beams, [current | rest]) do
    splitters =
      current
      |> Enum.with_index()
      |> Enum.filter(&(elem(&1, 0) == "^"))
      |> Enum.map(&elem(&1, 1))

    beams
    |> Enum.flat_map(fn {beam, count} ->
      if beam in splitters,
        do: [{beam - 1, count}, {beam + 1, count}],
        else: [{beam, count}]
    end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {beam, counts} -> {beam, Enum.sum(counts)} end)
    |> count_timelines(rest)
  end
end
