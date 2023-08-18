# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Caching.Repo.insert!(%Caching.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
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
