defmodule PolarWeb.Publish.SessionJSON do
  def create(%{token: token}) do
    %{data: %{token: token}}
  end
end
