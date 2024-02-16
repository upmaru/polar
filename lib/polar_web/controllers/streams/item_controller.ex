defmodule PolarWeb.Streams.ItemController do
  use PolarWeb, :controller

  def show(conn, %{"space_token" => space_token, "id" => id}) do
    redirect(conn, to: "/distributions/#{space_token}/items/#{id}")
  end
end
