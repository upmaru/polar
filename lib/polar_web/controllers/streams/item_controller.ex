defmodule PolarWeb.Streams.ItemController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Streams
  alias Polar.Streams.Item

  action_fallback PolarWeb.FallbackController

  def show(conn, %{"space_token" => space_token, "id" => id}) do
    credential =
      Accounts.get_space_credential(token: space_token)
      |> Repo.preload([:space])

    if Accounts.space_credential_valid?(credential) do
      %{
        default_cdn_host: default_cdn_host
      } = Polar.Assets.config()

      item = Repo.get!(Item, id)

      Streams.record_item_access(item, credential)

      url = Path.join(["https://", default_cdn_host, item.path])

      redirect(conn, external: url)
    end
  end
end
