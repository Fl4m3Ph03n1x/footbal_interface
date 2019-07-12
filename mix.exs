defmodule FootbalInterface.MixProject do
  use Mix.Project

  def project do
    [
      app: :footbal_interface,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {FootbalInterface.Application, []}
    ]
  end

  defp deps do
    [
      { :jason,             "~> 1.1"    },
      { :exprotobuf,        "~> 1.2"    },
      { :plug_cowboy,       "~> 2.0 "   },
      { :cowboy,            "~> 2.0"    },
      { :plug,              "~> 1.0"    },
      { :prometheus_plugs,  "~> 1.1.5"  },
      { :prometheus_ex,     "~> 3.0"    },
      { :footbal_engine,    git: "https://github.com/Fl4m3Ph03n1x/footbal_engine.git",  tag: "0.1.0" },

      # tracing
      { :observer_cli, "~> 1.5" },

      # test and dev
      { :excoveralls,     "~> 0.8",   only: [:test],        runtime: false  },
      { :dialyxir,        "~> 0.5",   only: [:dev],         runtime: false  },
      { :credo,           "~> 1.0.0", only: [:dev, :test],  runtime: false  },
      { :mix_test_watch,  "~> 0.8",   only: [:dev],         runtime: false  },
      { :ex_doc,          "~> 0.19",  only: [:dev],         runtime: false  }
    ]
  end
end
