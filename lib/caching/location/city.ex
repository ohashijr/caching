defmodule Caching.Location.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
