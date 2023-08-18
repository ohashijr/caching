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
