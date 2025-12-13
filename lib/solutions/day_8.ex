defmodule Solutions.Day8 do
  alias Util.Sets

  @behaviour Solution

  @test_input """
  162,817,812
  57,618,57
  906,360,560
  592,479,940
  352,342,300
  466,668,158
  542,29,236
  431,825,988
  739,650,466
  52,470,668
  216,146,977
  819,987,18
  117,168,530
  805,96,715
  346,949,466
  970,615,88
  941,993,340
  862,61,35
  984,92,344
  425,690,689
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)}, 10)
  40
  """
  def solve_part_1(input, connections \\ 1000) do
    input
    |> positions()
    |> pairs_by_distance()
    |> Enum.take(connections)
    |> Enum.reduce([], &connect_pair/2)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  25272
  """
  def solve_part_2(input) do
    positions = positions(input)
    position_count = length(positions)

    positions
    |> pairs_by_distance()
    |> Enum.reduce_while([], fn {a, b}, circuits ->
      circuits = connect_pair({a, b}, circuits)

      if length(circuits) == 1 and MapSet.size(hd(circuits)) == position_count,
        do: {:halt, [a, b]},
        else: {:cont, circuits}
    end)
    |> Enum.product_by(&elem(&1, 0))
  end

  defp positions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp pairs_by_distance(positions) do
    positions
    |> Sets.combinations(2)
    |> Enum.to_list()
    |> Enum.map(&List.to_tuple/1)
    |> Enum.sort_by(&distance/1)
  end

  defp distance({{xa, ya, za}, {xb, yb, zb}}) do
    [Integer.pow(xa - xb, 2), Integer.pow(ya - yb, 2), Integer.pow(za - zb, 2)]
    |> Enum.sum()
    |> Kernel.+(0.0)
    |> Float.pow(0.5)
  end

  defp connect_pair({a, b}, circuits) do
    case {Enum.find(circuits, &(a in &1)), Enum.find(circuits, &(b in &1))} do
      {nil, nil} ->
        [MapSet.new([a, b]) | circuits]

      {a_circuit, nil} ->
        [MapSet.put(a_circuit, b) | circuits -- [a_circuit]]

      {nil, b_circuit} ->
        [MapSet.put(b_circuit, a) | circuits -- [b_circuit]]

      {a_circuit, b_circuit} ->
        [MapSet.union(a_circuit, b_circuit) | circuits -- [a_circuit, b_circuit]]
    end
  end
end
