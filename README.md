# ParallelTask

Elixir library to run multiple functions in parallel and capture the results.

Suitable for multiple slow tasks such as API calls and database queries which can be performed concurrently. The process will be blocked until all functions have returned or the timeout has been reached.

Full documentation available on [hexdocs](https://hexdocs.pm/parallel_task/ParallelTask.html).

## Installation

The package can be installed by adding `parallel_task` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:parallel_task, "~> 0.1.0"}]
end
```

## Usage

Run two functions in parallel. `results` will be a map of keys and results.
```elixir
results = ParallelTask.new
          # Add some long running tasks eg. API calls
          |> ParallelTask.add(first_task: fn -> "Result from first task" end)
          |> ParallelTask.add(second_task: fn -> "Result from second task" end)
          |> ParallelTask.perform
```

Use pattern matching to easily extract the results.
```elixir
%{
  first_task: first_result,
  second_task: second_result
} = results

IO.puts first_result # "Result from first task"
IO.puts second_result # "Result from second task"
```

## License

Licensed under MIT.
