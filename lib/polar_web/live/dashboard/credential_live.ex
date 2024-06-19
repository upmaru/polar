defmodule PolarWeb.Dashboard.CredentialLive do
  use PolarWeb, :live_view

  alias Polar.Repo
  alias Polar.Accounts.Space

  @cli_tools %{
    "lxd" => "lxc",
    "incus" => "incus"
  }

  def render(assigns) do
    ~H"""
    <div class="overflow-hidden bg-white shadow sm:rounded-lg">
      <div class="px-4 py-6 sm:px-6">
        <h3 class="text-base font-semibold leading-7 text-gray-900">
          <%= gettext("Credential Information") %>
        </h3>
        <p class="mt-1 max-w-2xl text-sm leading-6 text-gray-500">
          <%= gettext("Details about the credential and instructions on how to use it.") %>
        </p>
      </div>
      <div class="border-t border-gray-100">
        <dl class="divide-y divide-gray-100">
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
            <dt class="text-sm font-medium text-gray-900"><%= gettext("Name") %></dt>
            <dd class="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
              <%= @credential.name %>
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
            <dt class="text-sm font-medium text-gray-900"><%= gettext("Type") %></dt>
            <dd class="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
              <%= @credential.type %>
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
            <dt class="text-sm font-medium text-gray-900"><%= gettext("Release Channel") %></dt>
            <dd class="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
              <%= @credential.release_channel %>
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
            <dt class="text-sm font-medium text-gray-900"><%= gettext("Expires At") %></dt>
            <dd class="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
              <%= if @credential.expires_at do %>
                <%= Calendar.strftime(
                  @credential.expires_at,
                  "%d %b %Y"
                ) %>
              <% else %>
                <%= gettext("Never Expires") %>
              <% end %>
            </dd>
          </div>
          <div class="px-4 py-6 sm:gap-4 sm:px-6">
            <div class="rounded-md bg-yellow-50 p-4">
              <div class="flex">
                <div class="flex-shrink-0">
                  <.icon name="hero-exclamation-triangle-solid" class="h-5 w-5 text-yellow-400" />
                </div>
                <div class="ml-3">
                  <h3 class="text-sm font-medium text-yellow-800">
                    <%= gettext("Do not share your credential") %>
                  </h3>
                  <div class="mt-2 text-sm text-yellow-700">
                    <p>
                      <%= gettext(
                        "This credential is only meant for you, please do not share it with external parties."
                      ) %>
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <div class="mt-6 px-4 py-6 sm:gap-4 sm:px-6 font-mono bg-slate-800 text-slate-300 rounded-md">
              <%= Map.fetch!(@cli_tools, @credential.type) %> remote add opsmaru <%= url(
                @socket,
                ~p"/spaces/#{@credential.token}"
              ) %> --public --protocol simplestreams
            </div>
          </div>
        </dl>
      </div>
    </div>
    """
  end

  def mount(%{"space_id" => space_id, "id" => id}, _session, %{assigns: assigns} = socket) do
    space = Repo.get_by!(Space, owner_id: assigns.current_user.id, id: space_id)
    credential = Repo.get_by!(Space.Credential, space_id: space.id, id: id)

    socket =
      socket
      |> assign(:page_title, credential.name)
      |> assign(:current_path, ~p"/dashboard")
      |> assign(:space, space)
      |> assign(:credential, credential)
      |> assign(:cli_tools, @cli_tools)

    {:ok, socket}
  end
end
