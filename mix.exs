defmodule ParallelTask.Mixfile do
  use Mix.Project

  def project do
    [app: :parallel_task,
     version: "0.1.0",
     elixir: "~> 1.0",
     description: "Run multiple functions in parallel and capture the results",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  defp deps do
    [
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Fabian Lindfors"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Fabianlindfors/parallel_task"},
      homepage_url: "https://github.com/Fabianlindfors/parallel_task"
    ]
  end
end
