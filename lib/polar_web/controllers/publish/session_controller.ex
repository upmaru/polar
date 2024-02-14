defmodule PolarWeb.Publish.SessionController do
  use PolarWeb, :controller

  alias Polar.Accounts
  alias Polar.Accounts.Automation

  action_fallback PolarWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    email = Automation.email()
    %{"password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      session_token = Accounts.generate_user_session_token(user)

      render(conn, :create, %{token: session_token})
    else
      {:error, :unauthorized}
    end
  end
end
