defmodule PolarWeb.UserLoginLive do
  use PolarWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex min-h-full flex-col justify-center py-12 sm:px-6 lg:px-8">
      <.header class="sm:mx-auto sm:w-full sm:max-w-md text-center">
        <img class="mx-auto h-10 w-auto" src={~p"/images/opsmaru-logo.png"} alt="opsmaru.com" />
        <h1 class="mt-6 text-center text-2xl font-bold leading-9 tracking-tight text-white">
          <%= gettext("Sign in to your account") %>
        </h1>
        <:subtitle>
          <p class="mt-2 text-sm leading-6 text-slate-50">
            <%= gettext("Don't have an account?") %>
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              <%= gettext("Sign up") %>
            </.link>
            <%= gettext("for an account now.") %>
          </p>
        </:subtitle>
      </.header>

      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-white px-6 py-12 shadow sm:rounded-lg sm:px-12">
          <.simple_form
            for={@form}
            id="login_form"
            action={~p"/users/log_in"}
            class="space-y-6"
            phx-update="ignore"
          >
            <div>
              <.input field={@form[:email]} type="email" label="Email" required />
            </div>
            <div>
              <.input field={@form[:password]} type="password" label="Password" required />
            </div>

            <:actions>
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
                </div>

                <div>
                  <.link
                    href={~p"/users/reset_password"}
                    class="text-sm font-semibold text-indigo-600"
                  >
                    <%= gettext("Forgot your password?") %>
                  </.link>
                </div>
              </div>
            </:actions>
            <:actions>
              <div>
                <.button
                  phx-disable-with="Signing in..."
                  class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold leading-6 text-white hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                >
                  <%= gettext("Sign in") %>
                </.button>
              </div>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
