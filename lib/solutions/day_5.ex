defmodule Solutions.Day5 do
  alias Util.Parsing

  @behaviour Solution

  @test_input """
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  3
  """
  def solve_part_1(input) do
    {fresh_ranges, available} = ingredients(input)

    Enum.count(available, &Enum.any?(fresh_ranges, fn range -> &1 in range end))
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  14
  """
  def solve_part_2(input) do
    {fresh_ranges, _available} = ingredients(input)

    fresh_ranges
    |> merge_ranges()
    |> Enum.sum_by(&Enum.count/1)
  end

  defp ingredients(input) do
    [fresh_range_input, available_input] = String.split(input, "\n\n")

    fresh_ranges =
      fresh_range_input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.map(fn [from, to] -> String.to_integer(from)..String.to_integer(to) end)

    available =
      available_input
      |> String.split("\n", trim: true)
      |> Parsing.integers()

    {fresh_ranges, available}
  end

  defp merge_ranges(ranges) do
    [first | rest] = Enum.sort_by(ranges, & &1.first)

    Enum.reduce(rest, [first], fn range, [current | rest] = merged ->
      if Range.disjoint?(range, current),
        do: [range | merged],
        else: [join_ranges(range, current) | rest]
    end)
  end

  defp join_ranges(a, b), do: min(a.first, b.first)..max(a.last, b.last)
end
