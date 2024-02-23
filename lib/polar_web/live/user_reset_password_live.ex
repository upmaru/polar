defmodule PolarWeb.UserResetPasswordLive do
  use PolarWeb, :live_view

  alias Polar.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex min-h-full flex-col justify-center py-12 sm:px-6 lg:px-8">
      <.header class="sm:mx-auto sm:w-full sm:max-w-md text-center">
        <img class="mx-auto h-10 w-auto" src={~p"/images/opsmaru-logo.png"} alt="opsmaru.com" />
        <h1 class="mt-6 text-center text-2xl font-bold leading-9 tracking-tight text-white">
          <%= gettext("Reset Password") %>
        </h1>
      </.header>

      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-white px-6 py-12 shadow sm:rounded-lg sm:px-12">
          <.simple_form
            for={@form}
            id="reset_password_form"
            phx-submit="reset_password"
            phx-change="validate"
            class="space-y-6"
          >
            <.error :if={@form.errors != []}>
              Oops, something went wrong! Please check the errors below.
            </.error>

            <div>
              <.input field={@form[:password]} type="password" label="New password" required />
            </div>
            <div>
              <.input
                field={@form[:password_confirmation]}
                type="password"
                label="Confirm new password"
                required
              />
            </div>
            <:actions>
              <div>
                <.button
                  class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold leading-6 text-white hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                  phx-disable-with="Resetting..."
                >
                  Reset Password
                </.button>
              </div>
            </:actions>
          </.simple_form>
        </div>
      </div>
      <p class="text-center text-sm mt-8">
        <.link
          class="font-semibold text-brand hover:underline text-indigo-400"
          href={~p"/users/register"}
        >
          Register
        </.link>
        <.icon name="hero-ellipsis-vertical-solid" class="h-4 w-4 text-white" />
        <.link
          class="font-semibold text-brand hover:underline text-indigo-400"
          href={~p"/users/log_in"}
        >
          Log in
        </.link>
      </p>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
