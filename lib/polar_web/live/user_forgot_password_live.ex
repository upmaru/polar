defmodule PolarWeb.UserForgotPasswordLive do
  use PolarWeb, :live_view

  alias Polar.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex min-h-full flex-col justify-center py-12 sm:px-6 lg:px-8">
      <.header class="sm:mx-auto sm:w-full sm:max-w-md text-center">
        <img class="mx-auto h-10 w-auto" src={~p"/images/opsmaru-logo.png"} alt="opsmaru.com" />
        <h1 class="mt-6 text-center text-2xl font-bold leading-9 tracking-tight text-white">
          <%= gettext("Forgot your password?") %>
        </h1>
        <:subtitle>
          <p class="mt-2 text-sm leading-6 text-slate-50">
            <%= gettext("We'll send a password reset link to your inbox") %>
          </p>
        </:subtitle>
      </.header>

      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-white px-6 py-12 shadow sm:rounded-lg sm:px-12">
          <.simple_form for={@form} id="reset_password_form" class="space-y-6" phx-submit="send_email">
            <div>
              <.input field={@form[:email]} type="email" placeholder="Email" required />
            </div>
            <:actions>
              <div>
                <.button
                  phx-disable-with="Sending..."
                  class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold leading-6 text-white hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                >
                  Send password reset instructions
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
          <%= gettext("Register") %>
        </.link>
        <.icon name="hero-ellipsis-vertical-solid" class="h-4 w-4 text-white" />
        <.link
          class="font-semibold text-brand hover:underline text-indigo-400"
          href={~p"/users/log_in"}
        >
          <%= gettext("Log in") %>
        </.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
