defmodule Ratelix.Registry do
  @moduledoc false

  @spec child_spec(any()) :: Supervisor.child_spec()
  def child_spec(_opts) do
    Registry.child_spec(
      keys: :unique,
      name: __MODULE__
    )
  end

  @spec lookup(atom()) :: module() | nil
  def lookup(key) do
    case Registry.lookup(__MODULE__, key) do
      [{_pid, module}] -> module
      [] -> nil
    end
  end
end
