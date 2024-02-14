defmodule PolarWeb.Plugs.ValidatePublishing do
  import Plug.Conn

  alias Polar.Accounts

  def init(options), do: options

  def call(conn, _options) do
    [token] = get_req_header(conn, "authorization")

    if user = Accounts.get_user_by_session_token(token) do
      assign(conn, :current_user, user)
    else
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(:unauthorized, Jason.encode!(%{status: "unauthorized"}))
      |> halt()
    end
  end
end
