defmodule PolarWeb.RootLive do
  use PolarWeb, :live_view

  alias Polar.Repo
  alias Polar.Streams.Version

  import Ecto.Query, only: [from: 2]

  @arch_colors %{
    "amd64" =>
      "inline-flex items-center rounded-full bg-amber-100 px-2 py-1 text-xs font-medium text-amber-800",
    "arm64" =>
      "inline-flex items-center rounded-full bg-cyan-100 px-2 py-1 text-xs font-medium text-cyan-700"
  }

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
                      <%= gettext("Aliases") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Serial") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("OS") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Release") %>
                    </th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                      <%= gettext("Arch") %>
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
                        <%= for alias <- version.product.aliases do %>
                          <span class="inline-flex items-center rounded-md bg-indigo-100 px-2 py-1 text-xs font-medium text-indigo-700">
                            <%= alias %>
                          </span>
                        <% end %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= version.serial %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= version.product.os %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <%= version.product.release %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                        <span class={Map.fetch!(@arch_colors, version.product.arch)}>
                          <%= version.product.arch %>
                        </span>
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
    versions =
      from(
        v in Version,
        where: v.current_state == ^"active",
        join: p in assoc(v, :product),
        preload: [{:product, p}],
        order_by: [asc: [p.os]],
        order_by: [desc: [p.release]]
      )
      |> Repo.all()

    socket =
      socket
      |> assign(:versions, versions)
      |> assign(:page_title, gettext("OpsMaru Images"))
      |> assign(:current_path, ~p"/")
      |> assign(:arch_colors, @arch_colors)

    {:ok, socket}
  end
end
