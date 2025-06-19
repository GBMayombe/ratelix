defmodule Ratelix.MixProject do
  use Mix.Project

  @version "0.3.0"
  @source_url "https://github.com/GBMayombe/ratelix"

  def project do
    [
      app: :ratelix,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      description: description(),
      aliases: aliases(),
      deps: deps(),
      docs: docs(),

      # Testing
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        check: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.json": :test,
        "coveralls.html": :test
      ],

      # Dialyzer
      dialyzer: dialyzer(),

      # Hex
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ratelix.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Documentation
      {:ex_doc, "~> 0.38", only: :dev, runtime: false},

      # Test & Code Analysis
      {:excoveralls, "~> 0.18", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Ratelix is a rate limiting library for Elixir applications.
    It provides a simple and flexible way to implement rate limiting
    strategies to control the flow of requests in your application.
    """
  end

  defp docs do
    [
      main: "Ratelix",
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp aliases do
    [
      check: [
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "coveralls.html",
        "dialyzer --format short"
      ]
    ]
  end

  defp package do
    [
      name: :ratelix,
      licenses: ["Apache-2.0"],
      maintainers: ["Gradie B. Mayombe"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :eex, :ex_unit],
      plt_file: {:no_warn, "priv/plts/" <> plt_file_name()},
      flags: [
        :unmatched_returns,
        :error_handling,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end

  defp plt_file_name do
    "dialyzer-#{Mix.env()}-#{System.otp_release()}-#{System.version()}.plt"
  end
end
