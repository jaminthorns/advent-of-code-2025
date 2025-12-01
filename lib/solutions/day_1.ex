defmodule Solutions.Day1 do
  @behaviour Solution

  @test_input """
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  3
  """
  def solve_part_1(input) do
    input
    |> rotations()
    |> zeros(50)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  6
  """
  def solve_part_2(input) do
    input
    |> rotations()
    |> Enum.flat_map(&expand_rotation/1)
    |> zeros(50)
  end

  defp rotations(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {dir, turns} = String.split_at(line, 1)
      {dir, String.to_integer(turns)}
    end)
  end

  defp zeros(rotations, start_position) do
    rotations
    |> Enum.reduce([start_position], &[turn(hd(&2), &1) | &2])
    |> Enum.count(&(&1 == 0))
  end

  defp turn(position, {"L", turns}), do: rem(position - turns + 100, 100)
  defp turn(position, {"R", turns}), do: rem(position + turns, 100)

  defp expand_rotation({dir, turns}), do: List.duplicate({dir, 1}, turns)
end
