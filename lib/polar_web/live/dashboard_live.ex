defmodule PolarWeb.DashboardLive do
  use PolarWeb, :live_view

  import PolarWeb.Dashboard.DataLoader

  def render(assigns) do
    ~H"""
    <div class="overflow-hidden bg-white sm:rounded-lg sm:shadow">
      <div class="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
        <div class="-ml-4 -mt-2 flex flex-wrap items-center justify-between sm:flex-nowrap">
          <div class="ml-4 mt-2">
            <h3 class="text-base font-semibold leading-6 text-gray-900">
              <%= gettext("Your spaces") %>
            </h3>
          </div>
          <div :if={Enum.count(@spaces) > 0} class="ml-4 mt-2 flex-shrink-0">
            <.link
              navigate={~p"/dashboard/spaces/new"}
              class="relative inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            >
              <.icon name="hero-plus-solid" class="-ml-0.5 mr-1.5 h-5 w-5 text-white" />
              <%= gettext("Create new space") %>
            </.link>
          </div>
        </div>
      </div>
      <div :if={Enum.count(@spaces) == 0} class="px-4 py-12">
        <div class="text-center">
          <.icon name="hero-folder-plus" class="mx-auto h-12 w-12 text-slate-400" />
          <h3 class="mt-2 text-sm font-semibold text-gray-900"><%= gettext("No spaces") %></h3>
          <p class="mt-1 text-sm text-gray-500">
            <%= gettext("Get started by creating a new space.") %>
          </p>
          <div class="mt-6">
            <.link
              navigate={~p"/dashboard/spaces/new"}
              class="inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            >
              <.icon name="hero-plus-solid" class="-ml-0.5 mr-1.5 h-5 w-5 text-white" />
              <%= gettext("Create new space") %>
            </.link>
          </div>
        </div>
      </div>
      <ul class="divide-y divide-slate-100">
        <li
          :for={space <- @spaces}
          id={"space_#{space.id}"}
          class="relative flex justify-between gap-x-6 px-4 py-5 hover:bg-gray-50 sm:px-6"
        >
          <div class="min-w-0">
            <div class="flex items-start gap-x-3">
              <p class="text-sm font-semibold leading-6 text-gray-900"><%= space.name %></p>
            </div>
            <div class="mt-1 flex items-center gap-x-2 text-xs leading-5 text-gray-500">
              <p class="whitespace-nowrap">
                <%= gettext("Created on") %>
                <time datetime={space.inserted_at}>
                  <%= Calendar.strftime(space.inserted_at, "%d %b %Y") %>
                </time>
              </p>
              <svg viewBox="0 0 2 2" class="h-0.5 w-0.5 fill-current">
                <circle cx="1" cy="1" r="1" />
              </svg>
              <p class="truncate"><%= gettext("Owned by") %> <%= space.owner.email %></p>
            </div>
          </div>
          <div class="flex flex-none items-center gap-x-4">
            <.link
              navigate={~p"/dashboard/spaces/#{space.id}"}
              class="hidden rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:block"
            >
              <%= gettext("View space") %>
            </.link>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  def mount(_params, _session, %{assigns: assigns} = socket) do
    spaces = load_spaces(assigns.current_user)

    socket =
      socket
      |> assign(:current_path, ~p"/dashboard")
      |> assign(:page_title, gettext("Dashboard"))
      |> assign(:spaces, spaces)

    {:ok, socket}
  end
end
