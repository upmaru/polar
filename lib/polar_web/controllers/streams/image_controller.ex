defmodule PolarWeb.Streams.ImageController do
  use PolarWeb, :controller

  def index(conn, _params) do
    render(conn, :index, %{})
  end
end
