defmodule CacheServer do
  use GenServer

  @table :ets_cache_table
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Put items into the cache.
  """
  @spec put(any(), any(), atom() | non_neg_integer()) :: :ok
  def put(key, value, ttl \\ :infinity) do
    GenServer.cast(__MODULE__, {:put, key, value, ttl})
  end

  @doc """
  Get items from the cache.
  """
  @spec get(any()) :: :not_found | {:ok, any()}
  def get(key) do
    case :ets.lookup(@table, key) do
      [{^key, value, expiry}] ->
        if expiry == :infinity or expiry > :erlang.system_time(:millisecond) do
          {:ok, value}
        else
          delete(key)
          {:error, :not_found}
        end

      [] ->
        {:error, :not_found}
    end
  end

  def get_all do
    {:ok, :ets.tab2list(@table)}
  end

  defp delete(key) do
    :ets.delete(@table, key)
  end

  ## @callbacks
  @spec init(any()) :: {:ok, %{}}
  def init(_) do
    :ets.new(@table, [:named_table, :public, read_concurrency: true])
    {:ok, %{}}
  end

  def handle_cast({:put, key, value, ttl}, state) do
    expiry =
      case ttl do
        :infinity -> :infinity
        ms when is_integer(ms) -> :erlang.system_time(:millisecond) + ms
      end

    :ets.insert(:ets_cache_table, {key, value, expiry})
    {:noreply, state}
  end

  def handle_info(:cleanup, state) do
    now = :erlang.system_time(:millisecond)

    :ets.select_delete(@table, [
      {{:"$1", :"$2", :"$3"}, [{:"/=", :"$3", :infinity}, {:<, :"$3", now}], [true]}
    ])

    Process.send_after(self(), :cleanup, 60_000)

    {:noreply, state}
  end
end
