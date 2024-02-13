defmodule PolarWeb.RootController do
  use PolarWeb, :controller

  def show(conn, _params) do
    render(conn, :show, layout: false)
  end
end
