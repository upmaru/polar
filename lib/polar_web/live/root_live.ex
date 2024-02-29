defmodule PolarWeb.RootLive do
  use PolarWeb, :live_view

  import __MODULE__.DataLoader

  @arch_colors %{
    "amd64" =>
      "inline-flex items-center rounded-full bg-amber-100 px-2 py-1 text-xs font-medium text-amber-800",
    "arm64" =>
      "inline-flex items-center rounded-full bg-cyan-100 px-2 py-1 text-xs font-medium text-cyan-700"
  }

  @os_colors %{
    "alpine" => "h-1.5 w-1.5 fill-cyan-500",
    "debian" => "h-1.5 w-1.5 fill-red-500",
    "ubuntu" => "h-1.5 w-1.5 fill-amber-500"
  }

  attr :filter, :map, default: %{}
  attr :tabs, :list, default: []

  def render(assigns) do
    ~H"""
    <div class="px-4 sm:px-0">
      <div class="sm:flex sm:items-center">
        <div class="sm:flex-auto">
          <h1 class="text-base font-semibold leading-6 text-white">
            <%= gettext("Active Images") %>
          </h1>
          <p class="mt-2 text-sm text-slate-300">
            <%= gettext("If you need something not available here please create an issue at the") %>
            <a
              href="https://github.com/upmaru/opsmaru-images"
              class="font-semibold text-brand hover:underline"
              target="_blank"
            >
              <%= gettext("opsmaru-images") %>
            </a>
            <%= gettext("repository.") %>
          </p>
        </div>
        <div class="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
          <.link
            :if={!Enum.empty?(@filter)}
            patch={~p"/"}
            class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            <.icon name="hero-x-circle" class="-ml-0.5 mr-1.5 h-5 w-5 text-white" />
            <%= gettext("Clear filter") %>
          </.link>
        </div>
      </div>
      <div class="mt-6">
        <span class="isolate inline-flex rounded-md shadow-sm">
          <%= for {tab, index} <- @tabs do %>
            <.link
              patch={~p"/?os=#{tab.os}"}
              class={"relative gap-x-1.5 inline-flex items-center #{if index == 1, do: "rounded-l-md"} #{if index == Enum.count(@tabs), do: "rounded-r-md"} px-3 py-2 text-sm font-semibold #{if tab.os == @filter["os"], do: "text-white bg-indigo-500", else: "bg-white text-slate-900 hover:bg-gray-50"} ring-inset focus:z-10"}
            >
              <%= Phoenix.Naming.humanize(tab.os) %>
              <span class="-mr-0.5 h-5 w-5 bg-white text-indigo-600 rounded-md text-center">
                <%= tab.count %>
              </span>
            </.link>
          <% end %>
        </span>
      </div>
      <div class="mt-8 flow-root">
        <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
            <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:rounded-lg">
              <table class="min-w-full divide-y divide-slate-300">
                <thead class="bg-gray-50">
                  <tr>
                    <th
                      scope="col"
                      class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6"
                    >
                      <%= gettext("OS") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Serial") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Aliases") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Release") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Arch") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Variant") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Published At") %>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                  <%= for version <- @versions do %>
                    <tr>
                      <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6">
                        <.link patch={~p"/?os=#{version.product.os}"}>
                          <span class="inline-flex items-center gap-x-1.5 rounded-md px-2 py-1 text-xs font-medium text-gray-900 ring-1 ring-inset ring-gray-200">
                            <svg
                              class={
                                Map.get(@os_colors, version.product.os, "h-1.5 w-1.5 fill-gray-500")
                              }
                              viewBox="0 0 6 6"
                              aria-hidden="true"
                            >
                              <circle cx="3" cy="3" r="3" />
                            </svg>
                            <%= Phoenix.Naming.humanize(version.product.os) %>
                          </span>
                        </.link>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= version.serial %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= for alias <- version.product.aliases do %>
                          <span class="inline-flex items-center rounded-md bg-indigo-100 px-2 py-1 text-xs font-medium text-indigo-700">
                            <%= alias %>
                          </span>
                        <% end %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= version.product.release %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <span class={
                          Map.get(
                            @arch_colors,
                            version.product.arch,
                            "inline-flex items-center rounded-full bg-gray-100 px-2 py-1 text-xs font-medium text-gray-600"
                          )
                        }>
                          <%= version.product.arch %>
                        </span>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= version.product.variant %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= Calendar.strftime(
                          version.inserted_at,
                          "%B %d, %Y %H:%M:%S"
                        ) %>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    tabs = load_tabs()

    socket =
      socket
      |> assign(:versions, [])
      |> assign(:page_title, gettext("LXD / Incus Image Server"))
      |> assign(:current_path, ~p"/")
      |> assign(:arch_colors, @arch_colors)
      |> assign(:os_colors, @os_colors)
      |> assign(:filter, %{})
      |> assign(:tabs, tabs)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    filter = Map.take(params, ["os"])

    versions = load_versions(filter)

    socket =
      socket
      |> assign(:versions, versions)
      |> assign(:filter, filter)

    {:noreply, socket}
  end
end
