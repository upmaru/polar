defmodule PolarWeb.Dashboard.Credential.NewLive do
  alias PolarWeb.CoreComponents
  use PolarWeb, :live_view

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Accounts.Space

  def render(assigns) do
    ~H"""
    <div class="space-y-10 divide-y divide-gray-900/10">
      <div class="grid grid-cols-1 gap-x-8 gap-y-8 md:grid-cols-3">
        <div class="px-4 sm:px-0">
          <h2 class="text-base font-semibold leading-7 text-slate-200">
            <%= gettext("Create a credential") %>
          </h2>
          <p class="mt-1 text-sm leading-6 text-slate-400">
            <%= gettext("Credentials allow you to control your simplestreams feed.") %>
          </p>
        </div>
        <.simple_form
          for={@credential_form}
          id="new-credential-form"
          phx-submit="save"
          phx-change="validate"
          class="bg-white shadow-sm ring-1 ring-slate-900/5 sm:rounded-xl md:col-span-2"
        >
          <div class="px-4 py-6 sm:p-8">
            <div class="grid max-w-2xl grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6">
              <div class="sm:col-span-4">
                <.input field={@credential_form[:name]} label={gettext("Name")} required />
              </div>
              <div class="col-span-full">
                <div class="flex items-center justify-between">
                  <h2 class="text-sm font-medium leading-6 text-gray-900">
                    <%= gettext("Expiry days") %>
                  </h2>
                </div>
                <fieldset class="mt-2">
                  <legend class="sr-only"><%= gettext("Choose expiry policy") %></legend>
                  <input
                    type="hidden"
                    name={@credential_form[:expires_in].name}
                    value={@credential_form.source.changes[:expires_in]}
                  />
                  <div class="grid grid-cols-3 gap-3 sm:grid-cols-6">
                    <label
                      :for={range <- Space.Credential.expires_in_range()}
                      for={Phoenix.HTML.Form.input_id(:credential, :expires_in, range.label)}
                      class={[
                        "flex items-center justify-center rounded-md py-3 px-3 text-sm font-semibold sm:flex-1 cursor-pointer focus:outline-none",
                        "#{if @credential_form.source.changes[:expires_in] == range.value, do: "bg-indigo-600 text-white hover:bg-indigo-500", else: "ring-1 ring-inset ring-slate-300 bg-white text-slate-900 hover:bg-slate-50"}"
                      ]}
                    >
                      <.input
                        type="radio"
                        id={Phoenix.HTML.Form.input_id(:credential, :expires_in, range.label)}
                        field={@credential_form[:expires_in]}
                        value={range.value}
                        class="sr-only"
                      />
                      <span><%= Phoenix.Naming.humanize(range.label) %></span>
                    </label>
                  </div>
                </fieldset>
              </div>
              <div class="col-span-full">
                <div class="flex items-center justify-between">
                  <h2 class="text-sm font-medium leading-6 text-gray-900">
                    <%= gettext("Type") %>
                  </h2>
                </div>
                <fieldset class="mt-2">
                  <legend class="sr-only"><%= gettext("Choose credential type") %></legend>
                  <input
                    type="hidden"
                    name={@credential_form[:type].name}
                    value={@credential_form.source.changes[:type]}
                  />
                  <div class="grid grid-cols-3 gap-3 sm:grid-cols-6">
                    <label
                      :for={type <- Space.Credential.types()}
                      for={Phoenix.HTML.Form.input_id(:credential, :type, type)}
                      class={[
                        "flex items-center justify-center rounded-md py-3 px-3 text-sm font-semibold sm:flex-1 cursor-pointer focus:outline-none",
                        "#{if @credential_form.source.changes[:type] == type, do: "bg-indigo-600 text-white hover:bg-indigo-500", else: "ring-1 ring-inset ring-slate-300 bg-white text-slate-900 hover:bg-slate-50"}"
                      ]}
                    >
                      <.input
                        id={Phoenix.HTML.Form.input_id(:credential, :type, type)}
                        type="radio"
                        field={@credential_form[:type]}
                        value={type}
                        class="sr-only"
                      />
                      <span><%= type %></span>
                    </label>
                  </div>
                </fieldset>
                <.error :for={
                  msg <- Enum.map(@credential_form[:type].errors, &CoreComponents.translate_error/1)
                }>
                  <%= msg %>
                </.error>
              </div>
            </div>
          </div>
          <:actions>
            <div class="flex items-center justify-end gap-x-6 border-t border-gray-900/10 px-4 py-4 sm:px-8">
              <.link
                navigate={~p"/dashboard/spaces/#{@space.id}"}
                class="text-sm font-semibold leading-6 text-gray-900"
              >
                <%= gettext("Cancel") %>
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

  def mount(%{"space_id" => space_id}, _session, %{assigns: assigns} = socket) do
    space = Repo.get_by!(Space, owner_id: assigns.current_user.id, id: space_id)

    credential_form =
      to_form(Accounts.change_space_credential(%Space.Credential{space_id: space.id}))

    socket =
      socket
      |> assign(:credential_form, credential_form)
      |> assign(:space, space)
      |> assign(:page_title, gettext("New credential"))
      |> assign(:current_path, ~p"/dashboard")

    {:ok, socket}
  end

  def handle_event("validate", %{"credential" => credential_params}, %{assigns: assigns} = socket) do
    credential_form =
      assigns.credential_form.source
      |> Accounts.change_space_credential(credential_params)
      |> Map.put(:action, :validate)
      |> to_form()

    socket =
      socket
      |> assign(:credential_form, credential_form)

    {:noreply, socket}
  end

  def handle_event("save", %{"credential" => credential_params}, %{assigns: assigns} = socket) do
    case Accounts.create_space_credential(assigns.space, assigns.current_user, credential_params) do
      {:ok, credential} ->
        socket =
          socket
          |> put_flash(:info, gettext("Credential successfully created!"))
          |> push_navigate(
            to: ~p"/dashboard/spaces/#{assigns.space.id}/credentials/#{credential.id}"
          )

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        credential_form = to_form(changeset)

        socket =
          socket
          |> assign(:check_errors, true)
          |> assign(:credential_form, credential_form)

        {:noreply, socket}
    end
  end
end
