defmodule Caching.Repo do
  use Ecto.Repo,
    otp_app: :caching,
    adapter: Ecto.Adapters.Postgres
end
