# Caching

```elixir
mix phx.gen.html Location City cities name:string
```

Add the resource to your browser scope in lib/caching_web/router.ex:

```elixir
resources "/cities", CityController
```

Remember to update your repository by running migrations:

```shell
$ mix ecto.migrate
```

Add the following code in the file /priv/repo/seeds.exs

```elixir
alias Caching.Repo
alias Caching.Location.City

capital_names = [
  "Rio Branco",
  "Maceió",
  "Macapá",
  "Manaus",
  "Salvador",
  "Fortaleza",
  "Brasília",
  "Vitória",
  "Goiânia",
  "São Luís",
  "Cuiabá",
  "Campo Grande",
  "Belo Horizonte",
  "Belém",
  "João Pessoa",
  "Curitiba",
  "Recife",
  "Teresina",
  "Rio de Janeiro",
  "Natal",
  "Porto Alegre",
  "Porto Velho",
  "Boa Vista",
  "Florianópolis",
  "São Paulo",
  "Aracaju",
  "Palmas"
]

Enum.each(capital_names, fn name ->
  City.changeset(%City{}, %{name: name})
  |> Repo.insert()
end)
```

Run the command

```elixir
mix run priv/repo/seeds.exs
```

# Approach 1 - GenServer

Create the file lib/caching_gs.ex

```elixir
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
```

In the file lib/caching/application.ex add `Caching.CachingGs` in the children function

```elixir
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CachingWeb.Telemetry,
      # Start the Ecto repository
      Caching.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Caching.PubSub},
      # Start Finch
      {Finch, name: Caching.Finch},
      # Start the Endpoint (http/https)
      CachingWeb.Endpoint,
      # Start a worker by calling: Caching.Worker.start_link(arg)
      # {Caching.Worker, arg}
      Caching.CachingGs
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Caching.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

In the file lib/caching_web/controllers/city_controller in the function index replace the database call to genserver

```elixir
  def index(conn, _params) do
    # cities = Location.list_cities()
    cities = CachingGs.cities()
    render(conn, :index, cities: cities)
  end
```
