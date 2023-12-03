defmodule Mix.Tasks.UpdateMixes do
  use Mix.Task

  def update_mix(filename, n) do
    input = File.read!(filename)

    File.write!(
      filename,
      String.replace(input, "nil", "AdventOfCode.Input.get!(#{n}, 2023)")
    )
  end

  @shortdoc "Update Mixes"
  def run(_args) do
    for n <- 1..9 do
      filename = "./lib/mix/tasks/d0#{n}.p1.ex"
      update_mix(filename, n)
      filename = "./lib/mix/tasks/d0#{n}.p2.ex"
      update_mix(filename, n)
    end

    for n <- 10..25 do
      filename = "./lib/mix/tasks/d#{n}.p1.ex"
      update_mix(filename, n)
      filename = "./lib/mix/tasks/d#{n}.p2.ex"
      update_mix(filename, n)
    end
  end
end
