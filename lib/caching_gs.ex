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
    # do not block the init
    {:ok, state, {:continue, :get_from_db}}
  end

  def handle_continue(:get_from_db, _state) do
    # pegar do banco
    new_state = Location.list_cities()
    {:noreply, new_state}
  end

  def handle_call(:cities, _from, state) do
    {:reply, state, state}
  end

end
