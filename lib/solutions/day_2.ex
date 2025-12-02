defmodule Solutions.Day2 do
  @behaviour Solution

  @test_input """
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  1227775554
  """
  def solve_part_1(input) do
    input
    |> ranges()
    |> Enum.flat_map(&invalids_in_range(&1, fn _ -> 2 end))
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  4174379265
  """
  def solve_part_2(input) do
    input
    |> ranges()
    |> Enum.flat_map(&invalids_in_range(&1, fn digits -> length(digits) end))
    |> Enum.sum()
  end

  defp ranges(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(fn [first, last] -> {String.to_integer(first), String.to_integer(last)} end)
  end

  defp invalids_in_range({first, last}, max_repeats_fun) do
    Enum.filter(first..last, fn id ->
      digits = Integer.digits(id)
      max_repeats = max(max_repeats_fun.(digits), 2)

      Enum.any?(2..max_repeats, &invalid?(digits, &1))
    end)
  end

  def invalid?(digits, repeats) do
    length = length(digits)

    if rem(length, repeats) == 0 do
      chunk_size = div(length, repeats)
      chunks = Enum.chunk_every(digits, chunk_size)

      chunks |> Enum.uniq() |> length() == 1
    else
      false
    end
  end

  # defp invalids_in_range_fast({first, last}) do
  #   (first - 1)
  #   |> Stream.iterate(&next_invalid/1)
  #   |> Stream.drop(1)
  #   |> Enum.take_while(&(&1 <= last))
  # end

  # defp next_invalid(id) do
  #   digits = Integer.digits(id)
  #   full_length = length(digits)
  #   left_length = div(full_length, 2)
  #   {left_digits, right_digits} = Enum.split(digits, left_length)
  #   left = Integer.undigits(left_digits)
  #   right = Integer.undigits(right_digits)

  #   next_left_digits =
  #     cond do
  #       rem(full_length, 2) == 1 -> [1 | List.duplicate(0, left_length)]
  #       right < left -> left_digits
  #       true -> Integer.digits(left + 1)
  #     end

  #   Integer.undigits(next_left_digits ++ next_left_digits)
  # end
end
