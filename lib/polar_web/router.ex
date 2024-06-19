defmodule PolarWeb.Router do
  use PolarWeb, :router

  import PolarWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PolarWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :publish do
    plug PolarWeb.Plugs.ValidatePublishing
  end

  # scope "/", PolarWeb do
  #   pipe_through :browser

  #   live_session :current_user,
  #     on_mount: [{PolarWeb.UserAuth, :mount_current_user}] do
  #   end
  # end

  ## Authentication routes

  scope "/", PolarWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{PolarWeb.UserAuth, :mount_current_user}] do
      live "/", RootLive, :show

      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end

    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", PolarWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      layout: {PolarWeb.Layouts, :auth},
      on_mount: [{PolarWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PolarWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PolarWeb.UserAuth, :ensure_authenticated}] do
      live "/dashboard", DashboardLive, :show

      live "/dashboard/spaces/new", Dashboard.Space.NewLive, :new
      live "/dashboard/spaces/:id", Dashboard.SpaceLive, :show

      live "/dashboard/spaces/:space_id/credentials/new", Dashboard.Credential.NewLive, :new
      live "/dashboard/spaces/:space_id/credentials/:id", Dashboard.CredentialLive, :show

      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/spaces/:space_token", PolarWeb do
    pipe_through :api

    get "/", SpaceController, :show

    scope "/streams/v1" do
      get "/index.json", StreamController, :index
      get "/images.json", Streams.ImageController, :index
    end

    resources "/items", Streams.ItemController, only: [:show]
  end

  scope "/publish", PolarWeb.Publish, as: :publish do
    pipe_through :api

    resources "/sessions", SessionController, only: [:create]

    scope "/" do
      pipe_through :publish

      resources "/storage", StorageController, only: [:show], singleton: true

      resources "/products", ProductController, only: [:show] do
        resources "/versions", VersionController, only: [:create]
      end

      scope "/versions/:version_id", Version, as: :version do
        resources "/events", EventController, only: [:create]
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PolarWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:polar, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PolarWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
