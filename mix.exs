defmodule MuResponse.Mixfile do
  use Mix.Project

  def project do
    [app: :mu_response,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {MuResponse, []},
      applications: [
        :phoenix,
        :phoenix_html,
        :cowboy,
        :logger,
        :phoenix_ecto,
        :calendar,
        :mariaex,
        :yaml_elixir
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.1"},
      {:phoenix_ecto, "~> 2.0"},
      {:mariaex, "~> 0.4"},
      {:phoenix_html, "~> 2.1"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:calendar, "~> 0.12.4"},
      {:cowboy, "~> 1.0"},
      {:yaml_elixir, "~> 1.0"},
      {:yamerl, github: "yakaz/yamerl"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
