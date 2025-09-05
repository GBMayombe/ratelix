defmodule Ratelix.Supervisor do
  @moduledoc """
  Supervisor for Ratelix application.

  This module is responsible for starting and supervising the core components of Ratelix,
  including the registry and dynamic supervisor. It uses a `:one_for_one` supervision strategy,
  ensuring that if any child process terminates, only that process is restarted.
  """
  use Supervisor

  @doc """
  Starts the Ratelix supervisor.

  This function initializes the supervisor and its child processes.
  """
  @spec start_link(any()) :: Supervisor.on_start()
  def start_link(_args) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(nil) do
    children = [
      Ratelix.Registry,
      Ratelix.DynamicSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
