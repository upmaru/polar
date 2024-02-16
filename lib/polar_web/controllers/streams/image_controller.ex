defmodule PolarWeb.Streams.ImageController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Streams

  action_fallback PolarWeb.FallbackController

  def index(conn, %{"space_token" => space_token, "flavor" => flavor})
      when flavor in ["lxd", "incus"] do
    credential = Accounts.get_space_credential(token: space_token)

    if credential do
      Accounts.increment_space_credential_access(credential)

      products =
        Streams.list_products([:active])
        |> Repo.preload(active_versions: [:items])

      render(conn, :index, %{products: products, flavor: flavor})
    end
  end

  def index(_conn, _), do: {:error, :not_found}
end
