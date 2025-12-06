defmodule Solutions.Day6 do
  alias Util.Parsing

  @behaviour Solution

  @test_input """
  123 328  51 64\s
   45 64  387 23\s
    6 98  215 314
  *   +   *   +
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  4277556
  """
  def solve_part_1(input) do
    input
    |> line_problems()
    |> Enum.sum_by(&solve_problem/1)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  3263827
  """
  def solve_part_2(input) do
    input
    |> column_problems()
    |> Enum.sum_by(&solve_problem/1)
  end

  defp line_problems(input) do
    {numbers, [operations]} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.split(-1)

    Enum.map_reduce(operations, numbers, fn operation, numbers ->
      column = Enum.map(numbers, &hd/1)
      numbers = Enum.map(numbers, &tl/1)

      {{operation, Parsing.integers(column)}, numbers}
    end)
    |> elem(0)
  end

  defp column_problems(input) do
    {number_lines, [operations_line]} =
      input
      |> String.split("\n", trim: true)
      |> Enum.split(-1)

    chars = Enum.map(number_lines, &String.graphemes/1)
    column_count = chars |> hd() |> length()

    numbers =
      Enum.reduce(1..column_count, {[[]], chars}, fn _, {[current | rest] = all, chars} ->
        column = Enum.map(chars, &hd/1)
        chars = Enum.map(chars, &tl/1)

        case column |> Enum.join() |> String.trim() do
          "" -> {[[] | all], chars}
          number -> {[[String.to_integer(number) | current] | rest], chars}
        end
      end)
      |> elem(0)

    operations_line
    |> String.split(" ", trim: true)
    |> Enum.reverse()
    |> Enum.zip(numbers)
  end

  defp solve_problem({"+", numbers}), do: Enum.sum(numbers)
  defp solve_problem({"*", numbers}), do: Enum.product(numbers)
end
