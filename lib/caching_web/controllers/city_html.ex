defmodule CachingWeb.CityHTML do
  use CachingWeb, :html

  embed_templates "city_html/*"

  @doc """
  Renders a city form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def city_form(assigns)
end
