defmodule Solutions.Day9 do
  alias Util.Parsing
  alias Util.Sets

  @behaviour Solution

  # ..............
  # .......#XXX#..
  # .......XXXXX..
  # ..#XXXX#XXXX..
  # ..XXXXXXXXXX..
  # ..#XXXXXX#XX..
  # .........XXX..
  # .........#X#..
  # ..............
  @test_input """
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """

  # ..................
  # .......#XXX#......
  # .......XXXXX......
  # ..#XXXX#XXXX......
  # ..XXXXXXXXXX......
  # ..#X#X#XX#XX.#X#..
  # ....XXX..XXX.XXX..
  # ....XXX..#X#.XXX..
  # ....XXX......XXX..
  # ....XX#XXXXXX#XX..
  # ....#XXXXXXXXXX#..
  # ..................
  @test_input_modified """
  7,1
  11,1
  11,7
  9,7
  9,5
  6,5
  6,9
  13,9
  13,5
  15,5
  15,10
  4,10
  4,5
  2,5
  2,3
  7,3
  """

  @across_orientations MapSet.new([MapSet.new([:se, :nw]), MapSet.new([:sw, :ne])])

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  50
  """
  def solve_part_1(input) do
    input
    |> tiles()
    |> Sets.combinations(2)
    |> Stream.map(&List.to_tuple/1)
    |> Stream.map(fn {a, b} -> area(a, b) end)
    |> Enum.max()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input_modified)})
  24
  """
  def solve_part_2(input) do
    tiles = tiles(input)

    tiles |> right_turns() |> IO.inspect(label: "RIGHT TURNS")

    corners =
      Enum.zip([
        tiles,
        Enum.drop(tiles, 1) ++ Enum.take(tiles, 1),
        Enum.drop(tiles, 2) ++ Enum.take(tiles, 2)
      ])

    tile_orientations = Enum.map(corners, &tile_orientation/1)

    tile_orientations
    |> Sets.combinations(2)
    |> Stream.map(&List.to_tuple/1)
    |> Stream.filter(fn {{_, oa}, {_, ob}} -> across?(oa, ob) end)
    |> Stream.map(fn {{a, _}, {b, _}} -> {a, b} end)
    |> Stream.reject(&tiles_inside?(&1, tile_orientations))
    |> Stream.map(fn {a, b} -> area(a, b) end)
    |> Enum.max()
  end

  defp tiles(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Parsing.integers()
      |> List.to_tuple()
    end)
  end

  defp right_turns(tiles) do
    lines = Enum.zip([tiles, Enum.drop(tiles, 1) ++ Enum.take(tiles, 1)])

    directions =
      Enum.map(lines, fn {{xa, ya}, {xb, yb}} ->
        cond do
          xa == xb and yb > ya -> :down
          xa == xb and yb < ya -> :up
          ya == yb and xb > xa -> :right
          ya == yb and xb < xa -> :left
        end
      end)

    turns = Enum.zip([directions, Enum.drop(directions, 1) ++ Enum.take(directions, 1)])

    right_turns =
      Enum.reduce(turns, 0, fn
        {:right, :down}, dir -> dir + 1
        {:right, :up}, dir -> dir - 1
        {:left, :down}, dir -> dir - 1
        {:left, :up}, dir -> dir + 1
        {:up, :right}, dir -> dir + 1
        {:up, :left}, dir -> dir - 1
        {:down, :right}, dir -> dir - 1
        {:down, :left}, dir -> dir + 1
      end)

    if right_turns > 0, do: :right, else: :left
  end

  defp area({xa, ya}, {xb, yb}), do: (abs(xa - xb) + 1) * (abs(ya - yb) + 1)

  defp tile_orientation({{x_prev, y_prev}, {x, y}, {x_next, y_next}}, direction) do
    [x_min, x_max] = Enum.sort([x_prev, x_next])
    [y_min, y_max] = Enum.sort([y_prev, y_next])

    case {direction, {x_prev, y_prev}, {x, y}, {x_next, y_next}} do
      {{x, y_prev}, {x, y}, {x_next, y}} when y_prev < y and x_next < x
    end

    orientation =
      cond do
        x_max > x and y_max > y -> :se
        x_min < x and y_max > y -> :sw
        x_min < x and y_min < y -> :nw
        x_max > x and y_min < y -> :ne
      end

    {{x, y}, orientation}
  end

  defp across?(orientation_a, orientation_b) do
    MapSet.new([orientation_a, orientation_b]) in @across_orientations
  end

  defp tiles_inside?(pair, tile_orientations) do
    IO.puts("---")
    Enum.any?(tile_orientations, &tile_inside?(&1, pair))
  end

  defp tile_inside?({{x, y} = point, orientation}, {{xa, ya} = a, {xb, yb} = b}) do
    [x_min, x_max] = Enum.sort([xa, xb])
    [y_min, y_max] = Enum.sort([ya, yb])

    inside_x = x > x_min and x < x_max
    inside_y = y > y_min and y < y_max
    inside_inner = inside_x and inside_y

    inside_edge =
      cond do
        x == x_min and inside_y -> orientation in [:ne, :se]
        x == x_max and inside_y -> orientation in [:nw, :sw]
        y == y_min and inside_x -> orientation in [:sw, :se]
        y == y_max and inside_x -> orientation in [:nw, :ne]
        true -> false
      end

    {area(a, b), {a, b}, point, inside_inner, inside_edge} |> IO.inspect(label: "insides")

    inside_inner or inside_edge
  end
end
