defmodule Mix.Tasks.Solve do
  @moduledoc "Solve a puzzle for a specific day."
  @shortdoc "Solve a puzzle"

  use Mix.Task
  alias IO.ANSI

  @impl Mix.Task

  def run([day | _] = args) do
    Application.ensure_all_started(:advent_of_code)

    if String.to_integer(day) in Solution.implemented_days() do
      case args do
        [day] ->
          {{time_1, solution_1}, {time_2, solution_2}} = Solution.solve_timed(day)

          IO.puts("Part 1: #{inspect(solution_1)} #{format_time(time_1)}")
          IO.puts("Part 2: #{inspect(solution_2)} #{format_time(time_2)}")

        [day, part] ->
          part = String.to_integer(part)
          {time, solution} = Solution.solve_timed(day, part)

          IO.puts("#{inspect(solution)} #{format_time(time)}")
      end
    else
      IO.puts(:stderr, ANSI.red() <> "This day is not yet implemented.")
    end
  end

  def format_time(microseconds) do
    ANSI.light_black() <> "#{microseconds / 1000}ms" <> ANSI.reset()
  end
end
