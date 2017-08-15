defmodule ParallelTask do
  @moduledoc """
  Elixir library to run multiple functions in parallel and capture the results.

  Suitable for multiple slow tasks such as API calls and database queries which can be performed concurrently. The process will be blocked until all functions have returned or the timeout has been reached.

  ## Examples

  Run two functions in parallel. `results` will be a map of keys and results.
      results = ParallelTask.new
                # Add some long running tasks eg. API calls
                |> ParallelTask.add(first_task: fn -> "Result from first task" end)
                |> ParallelTask.add(second_task: fn -> "Result from second task" end)
                |> ParallelTask.perform


  Use pattern matching to easily extract the results.
      %{
        first_task: first_result,
        second_task
      } = results

      IO.puts first_result # "Result from first task"
      IO.puts second_result # "Result from second task"
  """

  defstruct task_functions: %{}

  @doc """
  Creates a new parallel task
  """
  def new do
    %__MODULE__{}
  end

  @doc """
  Adds new functions to a parallel task. Every function is bound to a key.

      ParallelTask.new |> ParallelTask.add(first: fn -> "First function", second: fn -> "Second function")

      ParallelTask.new
      |> ParallelTask.add(first: fn -> "First function" end)
      |> ParallelTask.add(second: fn -> "Second function" end)
  """
  def add(%__MODULE__{} = object, new_functions \\ []) do
    %__MODULE__{
      task_functions: Map.merge(
        object.task_functions,
        Enum.into(new_functions, %{})
      )
    }
  def add(%__MODULE__{} = object, key, function), do: add(object, [{key, function}])
  end


  @doc """
  Runs a parallel task and returns a map of the results.

  The process will be blocked until all functions have returned or the timeout has been reached.

  A custom timeout can optionally be passed. Functions running longer than the timeout will automatically be killed and their result will be nil.
  The default timeout is 5 seconds.

      iex> ParallelTask.new |> ParallelTask.add(first: fn -> "Hello world" end) |> ParallelTask.perform
      %{
        first: "Hello world"
      }
  """
  def perform(%__MODULE__{} = object, timeout \\ 5000) do
    tasks = Enum.map(Map.values(object.task_functions), &Task.async/1)

    tasks_with_results = Task.yield_many(tasks, timeout)

    task_results = Enum.map(tasks_with_results, fn {task, res} ->
      # Shutdown the tasks that did not reply nor exit
      case res || Task.shutdown(task, :brutal_kill) do
        {:ok, results} -> results
        _ -> nil
      end
    end)

    # Create map with function keys and the task results
    Enum.reduce(Enum.with_index(object.task_functions),
                %{},
                fn {{key, _}, i}, results ->
      Map.put(results, key, Enum.at(task_results, i))
    end)

  end

end
