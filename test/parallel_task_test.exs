defmodule ParallelTaskTest do
  use ExUnit.Case
  doctest ParallelTask

  test "simple task" do
    results = ParallelTask.new |> ParallelTask.add(simple: fn -> "Testing" end) |> ParallelTask.perform

    assert %{simple: "Testing"} == results
  end

  test "multiple tasks" do
    results = ParallelTask.new
              |> ParallelTask.add(first: fn -> 1 end, second: fn -> 2 end)
              |> ParallelTask.add(third: fn -> 3 end)
              |> ParallelTask.perform

    assert %{first: 1, second: 2, third: 3} == results
  end

  test "timeout" do
    results = ParallelTask.new
              |> ParallelTask.add(timeout: fn -> :timer.sleep(200); 1 end)
              |> ParallelTask.perform(100)

    assert %{timeout: nil} == results
  end

  test "closure" do
    value = "Value"
    results = ParallelTask.new |> ParallelTask.add(closure: fn -> value end) |> ParallelTask.perform

    assert %{closure: value} == results
  end

end
