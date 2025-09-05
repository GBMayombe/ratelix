defmodule RatelixTest do
  use ExUnit.Case

  alias Ratelix.{LeakyBucket, TokenBucket}

  setup do
    _sup = start_supervised!(Ratelix.Supervisor)

    :ok
  end

  @name :server
  @opts [algorithm: :leaky_bucket, capacity: 1, interval: 1]
  describe "leaky bucket" do
    setup do
      assert {:ok, _worker} = Ratelix.start_process(@name, @opts)

      :ok
    end

    test "success: wait_for_turn/1" do
      queue = :queue.new()

      assert :ok = Ratelix.wait_for_turn(@name)

      # Simulate a delay to allow the queue to be emptied
      Process.sleep(1000)

      assert %LeakyBucket{length: 0, queue: ^queue} =
               Ratelix.bucket_stats(@name)
    end

    test "error: wait_for_turn/1 bucket full" do
      :ok = execute_concurrent_tasks(5)

      assert_receive {:error, :bucket_full}
    end
  end

  @opts [algorithm: :token_bucket, capacity: 5, rate: 1, interval: 1]
  describe "token bucket" do
    setup do
      assert {:ok, _worker} = Ratelix.start_process(@name, @opts)

      %{opts: Map.new(@opts)}
    end

    test "success: wait_for_turn/1", %{opts: %{capacity: capacity}} do
      assert :ok = Ratelix.wait_for_turn(@name)

      # Simulate a delay to allow the bucket to refill
      Process.sleep(1_500)

      assert %TokenBucket{tokens: ^capacity} =
               Ratelix.bucket_stats(@name)
    end

    test "error: wait_for_turn/1 no token", %{opts: %{capacity: capacity}} do
      :ok = execute_concurrent_tasks(capacity + 1)

      assert_receive {:error, :no_token}
    end
  end

  test "error: unregistered bucket" do
    assert {:error, :process_not_found} =
             Ratelix.wait_for_turn(:unregistered_bucket)
  end

  defp execute_concurrent_tasks(number_of_tasks) do
    pid = self()

    1..number_of_tasks
    |> Task.async_stream(
      fn _ ->
        resp = Ratelix.wait_for_turn(@name)
        send(pid, resp)
      end,
      timeout: :infinity,
      max_concurrency: number_of_tasks
    )
    |> Stream.run()
  end
end
