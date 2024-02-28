defmodule PolarWeb.RootLive do
  use PolarWeb, :live_view

  alias Polar.Streams

  def render(assigns) do
    ~H"""
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
          <table class="min-w-full divide-y divide-slate-700">
            <thead>
              <tr>
                <th
                  scope="col"
                  class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-white sm:pl-0"
                >
                  <%= gettext("Aliases") %>
                </th>
                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-white">
                  <%= gettext("Arch") %>
                </th>
                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-white">
                  <%= gettext("Variant") %>
                </th>
                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-white">
                  <%= gettext("Published At") %>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-900">
              <%= for {{os, release}, products} <- @grouped_products do %>
                <tr class="border-t border-slate-800">
                  <th
                    colspan="5"
                    scope="colgroup"
                    class="bg-slate-900 py-2 pl-4 pr-3 text-left text-sm font-semibold text-slate-50 sm:pl-3"
                  >
                    <%= Phoenix.Naming.humanize(os) %> - <%= release %>
                  </th>
                </tr>
                <%= for product <- products do %>
                  <tr>
                    <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-white sm:pl-0">
                      <%= for alias <- product.aliases do %>
                        <span class="inline-flex items-center rounded-md bg-green-500/10 px-2 py-1 text-xs font-medium text-green-400 ring-1 ring-inset ring-green-500/20">
                          <%= alias %>
                        </span>
                      <% end %>
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-slate-300">
                      <%= product.arch %>
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-slate-300">
                      <%= product.variant %>
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-slate-300">
                      <%= Calendar.strftime(
                        product.latest_version.inserted_at,
                        "%B %d, %Y %H:%M:%S"
                      ) %>
                    </td>
                  </tr>
                <% end %>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    products =
      Streams.list_products([:active, :with_latest_version])
      |> Enum.group_by(fn p -> {p.os, p.release} end)

    socket =
      socket
      |> assign(:grouped_products, products)
      |> assign(:page_title, gettext("OpsMaru Images"))
      |> assign(:current_path, ~p"/")

    {:ok, socket}
  end
end
