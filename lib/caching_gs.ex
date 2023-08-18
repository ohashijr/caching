defmodule Caching.CachingGs do
  use GenServer

  alias Caching.Location

  # client
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def cities do
    GenServer.call(__MODULE__, :cities)
  end

  # server
  def init(state) do
    :ets.new(:cities_cache, [:set, :named_table, :public, read_concurrency: true, write_concurrency: true])
    # do not block the init
    {:ok, state, {:continue, :get_from_db}}
  end

  def handle_continue(:get_from_db, state) do
    # pegar do banco
    cities = Location.list_cities()
    :ets.insert(:cities_cache, {:cities, cities})
    {:noreply, state}
  end

  def handle_call(:cities, _from, state) do
    reply = case :ets.lookup(:cities_cache, :cities) do
      [] -> []
      [{_key, value}] -> value
    end
    {:reply, reply, state}
  end

end
