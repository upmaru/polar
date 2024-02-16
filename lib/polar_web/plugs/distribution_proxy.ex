defmodule PolarWeb.Plugs.DistributionProxy do
  import Plug.Conn

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Accounts.Space

  alias Polar.Streams.Item

  def init(options), do: options

  def call(conn, _options) do
    {space_token, ["items", item_id]} = List.pop_at(conn.path_info, 0)

    credential =
      Accounts.get_space_credential(token: space_token)
      |> Repo.preload([:space])

    if credential && host_valid?(conn, credential.space) do
      Accounts.increment_space_credential_access(credential)

      item = Repo.get!(Item, item_id)

      signed_url = Polar.AWS.get_signed_url(item.path, scheme: "http://")

      tesla_client =
        Tesla.client([
          Tesla.Middleware.Logger
        ])

      reverse_proxy_options =
        ReverseProxyPlug.init(upstream: signed_url, client_options: [tesla_client: tesla_client])

      conn
      |> Map.put(:path_info, [])
      |> ReverseProxyPlug.call(reverse_proxy_options)
    else
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(
        :unprocessable_entity,
        Jason.encode!(%{status: "make sure the space token and cdn_host is valid"})
      )
      |> halt()
    end
  end

  defp host_valid?(conn, %Space{cdn_host: cdn_host}) when is_binary(cdn_host),
    do: conn.host == cdn_host

  defp host_valid?(_conn, %Space{cdn_host: nil}), do: true
end
