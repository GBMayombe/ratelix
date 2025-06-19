defmodule Ratelix.DynamicSupervisor do
  @moduledoc false
  use DynamicSupervisor

  alias Ratelix.{LeakyBucket, TokenBucket}

  @spec start_link(keyword()) :: Supervisor.on_start()
  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec start_process(atom(), keyword()) :: {:ok, pid()}
  def start_process(name, opts) do
    mod =
      opts
      |> Keyword.fetch!(:algorithm)
      |> get_module()

    child_spec = %{
      id: mod,
      restart: :transient,
      start: {mod, :start_link, [name, opts]}
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # Private helper to select the rate limiter module based on the algorithm option.
  defp get_module(:leaky_bucket), do: LeakyBucket
  defp get_module(:token_bucket), do: TokenBucket
end
