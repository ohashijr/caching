defmodule Caching.LocationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Caching.Location` context.
  """

  @doc """
  Generate a city.
  """
  def city_fixture(attrs \\ %{}) do
    {:ok, city} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Caching.Location.create_city()

    city
  end
end
