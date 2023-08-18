defmodule CachingWeb.CityControllerTest do
  use CachingWeb.ConnCase

  import Caching.LocationFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all cities", %{conn: conn} do
      conn = get(conn, ~p"/cities")
      assert html_response(conn, 200) =~ "Listing Cities"
    end
  end

  describe "new city" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/cities/new")
      assert html_response(conn, 200) =~ "New City"
    end
  end

  describe "create city" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/cities", city: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/cities/#{id}"

      conn = get(conn, ~p"/cities/#{id}")
      assert html_response(conn, 200) =~ "City #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/cities", city: @invalid_attrs)
      assert html_response(conn, 200) =~ "New City"
    end
  end

  describe "edit city" do
    setup [:create_city]

    test "renders form for editing chosen city", %{conn: conn, city: city} do
      conn = get(conn, ~p"/cities/#{city}/edit")
      assert html_response(conn, 200) =~ "Edit City"
    end
  end

  describe "update city" do
    setup [:create_city]

    test "redirects when data is valid", %{conn: conn, city: city} do
      conn = put(conn, ~p"/cities/#{city}", city: @update_attrs)
      assert redirected_to(conn) == ~p"/cities/#{city}"

      conn = get(conn, ~p"/cities/#{city}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, city: city} do
      conn = put(conn, ~p"/cities/#{city}", city: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit City"
    end
  end

  describe "delete city" do
    setup [:create_city]

    test "deletes chosen city", %{conn: conn, city: city} do
      conn = delete(conn, ~p"/cities/#{city}")
      assert redirected_to(conn) == ~p"/cities"

      assert_error_sent 404, fn ->
        get(conn, ~p"/cities/#{city}")
      end
    end
  end

  defp create_city(_) do
    city = city_fixture()
    %{city: city}
  end
end
