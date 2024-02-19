defmodule PolarWeb.Streams.ItemController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Streams.Item

  def show(conn, %{"space_token" => space_token, "id" => id}) do
    credential =
      Accounts.get_space_credential(token: space_token)
      |> Repo.preload([:space])

    if credential do
      %{
        bucket: bucket,
        default_cdn_host: default_cdn_host
      } = Polar.Assets.config()

      item = Repo.get!(Item, id)

      endpoint = credential.space.cdn_host || default_cdn_host

      url = Path.join(["https://", endpoint, bucket, item.path])

      redirect(conn, external: url)
    end
  end
end