defmodule PolarWeb.Plugs.HealthCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health"} = conn, _opts) do
    conn
    |> send_resp(
      200,
      Jason.encode!(%{
        status: "Polar serving images."
      })
    )
    |> halt()
  end

  def call(conn, _opts), do: conn
end
