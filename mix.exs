defmodule DealerReviewScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :dealer_review_scraper,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [
        "test.watch": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:floki, "~> 0.32.0"},
      {:mix_test_watch, "~> 1.1", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.8"},
      {:bypass, "~> 2.1", only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
