defmodule Solutions.Day3 do
  @behaviour Solution

  @test_input """
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  357
  """
  def solve_part_1(input) do
    input
    |> banks()
    |> Enum.sum_by(&max_joltage(&1, 2))
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  3121910778619
  """
  def solve_part_2(input) do
    input
    |> banks()
    |> Enum.sum_by(&max_joltage(&1, 12))
  end

  defp banks(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp max_joltage(bank, count, joltages \\ [])

  defp max_joltage(_bank, 0, joltages) do
    joltages
    |> Enum.reverse()
    |> Integer.undigits()
  end

  defp max_joltage(bank, count, joltages) do
    {max, max_index} =
      bank
      |> Enum.with_index()
      |> Enum.drop(-(count - 1))
      |> Enum.max_by(&elem(&1, 0))

    rest = Enum.drop(bank, max_index + 1)

    max_joltage(rest, count - 1, [max | joltages])
  end
end
