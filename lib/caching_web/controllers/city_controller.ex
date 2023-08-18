defmodule CachingWeb.CityController do
  use CachingWeb, :controller

  alias Caching.Location
  alias Caching.Location.City

  def index(conn, _params) do
    cities = Location.list_cities()
    render(conn, :index, cities: cities)
  end

  def new(conn, _params) do
    changeset = Location.change_city(%City{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"city" => city_params}) do
    case Location.create_city(city_params) do
      {:ok, city} ->
        conn
        |> put_flash(:info, "City created successfully.")
        |> redirect(to: ~p"/cities/#{city}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    city = Location.get_city!(id)
    render(conn, :show, city: city)
  end

  def edit(conn, %{"id" => id}) do
    city = Location.get_city!(id)
    changeset = Location.change_city(city)
    render(conn, :edit, city: city, changeset: changeset)
  end

  def update(conn, %{"id" => id, "city" => city_params}) do
    city = Location.get_city!(id)

    case Location.update_city(city, city_params) do
      {:ok, city} ->
        conn
        |> put_flash(:info, "City updated successfully.")
        |> redirect(to: ~p"/cities/#{city}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, city: city, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    city = Location.get_city!(id)
    {:ok, _city} = Location.delete_city(city)

    conn
    |> put_flash(:info, "City deleted successfully.")
    |> redirect(to: ~p"/cities")
  end
end
