defmodule PolarWeb.Dashboard.Space.NewLive do
  use PolarWeb, :live_view

  alias Polar.Accounts
  alias Polar.Accounts.Space

  def render(assigns) do
    ~H"""
    <div class="space-y-10 divide-y divide-gray-900/10">
      <div class="grid grid-cols-1 gap-x-8 gap-y-8 md:grid-cols-3">
        <div class="px-4 sm:px-0">
          <h2 class="text-base font-semibold leading-7 text-slate-200">
            <%= gettext("Create a space") %>
          </h2>
          <p class="mt-1 text-sm leading-6 text-slate-400">
            <%= gettext(
              "Spaces group all your tokens, it can represent an organization or just a workspace."
            ) %>
          </p>
        </div>

        <.simple_form
          for={@space_form}
          id="new-space-form"
          phx-submit="save"
          phx-change="validate"
          class="bg-white shadow-sm ring-1 ring-slate-900/5 sm:rounded-xl md:col-span-2"
        >
          <div class="px-4 py-6 sm:p-8">
            <div class="grid max-w-2xl grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6">
              <div class="sm:col-span-4">
                <.input field={@space_form[:name]} label={gettext("Name")} required />
              </div>
            </div>
          </div>
          <:actions>
            <div class="flex items-center justify-end gap-x-6 border-t border-gray-900/10 px-4 py-4 sm:px-8">
              <.link navigate={~p"/dashboard"} class="text-sm font-semibold leading-6 text-gray-900">
                Cancel
              </.link>
              <.button
                type="submit"
                class="rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
              >
                <%= gettext("Save") %>
              </.button>
            </div>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    space_form = to_form(Accounts.change_space(%Space{}))

    socket =
      socket
      |> assign(:space_form, space_form)
      |> assign(:page_title, gettext("New space"))
      |> assign(:current_path, ~p"/dashboard")

    {:ok, socket}
  end

  def handle_event("validate", %{"space" => space_params}, %{assigns: assigns} = socket) do
    space_form =
      %Space{owner_id: assigns.current_user.id}
      |> Accounts.change_space(space_params)
      |> Map.put(:action, :validate)
      |> to_form()

    socket =
      socket
      |> assign(:space_form, space_form)

    {:noreply, socket}
  end

  def handle_event("save", %{"space" => space_params}, %{assigns: assigns} = socket) do
    case Accounts.create_space(assigns.current_user, space_params) do
      {:ok, space} ->
        socket =
          socket
          |> put_flash(:info, gettext("Space successfully created!"))
          |> push_navigate(to: ~p"/dashboard/spaces/#{space.id}")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        space_form = to_form(changeset)

        socket =
          socket
          |> assign(:check_errors, true)
          |> assign(:space_form, space_form)

        {:noreply, socket}
    end
  end
end
