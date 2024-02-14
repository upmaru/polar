defmodule Polar.Accounts.Automation do
  alias Polar.Accounts

  @email "bot@opsmaru.com"

  def email, do: @email

  def generate_password do
    :crypto.strong_rand_bytes(24)
    |> Base.encode16()
    |> String.downcase()
  end

  def create_bot(password) do
    with {:ok, user} <-
           Accounts.register_user(%{
             email: @email,
             password: password
           }) do
      {:ok, user}
    else
      _ -> :error
    end
  end
end
