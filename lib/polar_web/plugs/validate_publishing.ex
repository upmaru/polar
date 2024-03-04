defmodule PolarWeb.Plugs.ValidatePublishing do
  import Plug.Conn

  alias Polar.Accounts
  alias Polar.Accounts.User

  def init(options), do: options

  def call(conn, _options) do
    with [token] <- get_req_header(conn, "authorization"),
         %User{} = user <-
           token
           |> Base.decode64!()
           |> Accounts.get_user_by_session_token() do
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(:unauthorized, Jason.encode!(%{status: "unauthorized"}))
        |> halt()
    end
  end
end
