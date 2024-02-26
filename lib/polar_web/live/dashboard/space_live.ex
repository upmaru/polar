defmodule PolarWeb.Dashboard.SpaceLive do
  use PolarWeb, :live_view

  alias Polar.Repo
  alias Polar.Accounts.Space

  def render(assigns) do
    ~H"""
    <div class="overflow-hidden bg-white sm:rounded-lg sm:shadow">
      <div class="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
        <div class="-ml-4 -mt-2 flex flex-wrap items-center justify-between sm:flex-nowrap">
          <div class="ml-4 mt-2">
            <h3 class="text-base font-semibold leading-6 text-gray-900">
              <%= gettext("Credentials") %>
            </h3>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"id" => id}, _session, %{assigns: assigns} = socket) do
    space = Repo.get_by(Space, owner_id: assigns.current_user.id, id: id)

    if space do
      socket =
        socket
        |> assign(:page_title, space.name)

      {:ok, socket}
    else
      socket =
        socket
        |> put_flash(:error, gettext("Space not found"))
        |> push_navigate(to: ~p"/dashboard")

      {:ok, socket}
    end
  end
end
