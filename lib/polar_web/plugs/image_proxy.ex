defmodule PolarWeb.Plugs.ImageProxy do
  def init(options), do: options

  def call(conn, _options) do
    {space_token, object_segments} = List.pop_at(conn.path_info, 0)

    credential =
      Accounts.get_space_credential(token: space_token)
      |> Repo.preload([:space])

    if credential && host_valid?(conn, credential.space) do
      Accounts.increment_space_credential_access(credential)

      signed_url =
        object_segments
        |> Enum.join("/")
        |> Polar.AWS.get_signed_url()

      reverse_proxy_options = ReverseProxyPlug.init(upstream: signed_url)

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

  defp host_valid?(conn, %Space{cdn_host: nil}), do: true
end
