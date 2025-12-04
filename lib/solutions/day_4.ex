defmodule Solutions.Day4 do
  alias Util.Grid

  @behaviour Solution

  @test_input """
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  13
  """
  def solve_part_1(input) do
    grid = Grid.new(input)

    Enum.count(grid, &accessible?(&1, grid))
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  43
  """
  def solve_part_2(input) do
    input
    |> Grid.new()
    |> removable_count()
  end

  defp accessible?({position, "@"}, grid) do
    Grid.all_directions()
    |> Enum.map(&Grid.step(position, &1))
    |> Enum.count(&(Map.get(grid, &1) == "@")) < 4
  end

  defp accessible?(_position, _grid), do: false

  defp removable_count(grid, count \\ 0) do
    case grid |> Enum.filter(&accessible?(&1, grid)) |> Enum.map(&elem(&1, 0)) do
      [] -> count
      removable -> grid |> Map.drop(removable) |> removable_count(count + length(removable))
    end
  end
end
