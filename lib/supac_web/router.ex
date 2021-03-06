defmodule SupacWeb.Router do
  use SupacWeb, :router

  import SupacWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SupacWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SupacWeb do
    pipe_through :api

    post "/log_in", UserApiSessionController, :create
  end

  scope "/api", SupacWeb do
    pipe_through [:api, :verify_token]

    get "/status", UserApiSessionController, :status
    resources "/leads", LeadController, except: [:new, :edit, :update, :delete]
  end

  scope "/", SupacWeb do
    pipe_through :browser

    # get "/page", PageController, :index
  end

  # unconfirmed
  live_session :unconfirmed, on_mount: SupacWeb.Nav do
    scope "/", SupacWeb do
      pipe_through [:browser, :require_authenticated_user]

      # unconfrimed
      live "/unconfirmed", UnconfirmedLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SupacWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SupacWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SupacWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    # get "/users/register", UserRegistrationController, :new
    # post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  # main route
  live_session :default, on_mount: [SupacWeb.UserLiveAuth, SupacWeb.Nav] do
    scope "/", SupacWeb do
      pipe_through [:browser, :require_authenticated_user]

      # user settings
      get "/users/settings", UserSettingsController, :edit
      put "/users/settings", UserSettingsController, :update
      get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

      # page
      live "/page", PageLive

      # Lead
      live "/leads", LeadLive.Index, :index
      live "/leads/new", LeadLive.Index, :new
      live "/leads/:id/edit", LeadLive.Index, :edit

      # Prod
      live "/prods", ProdLive.Index, :index
      live "/prods/new", ProdLive.Index, :new
      live "/prods/:id/edit", ProdLive.Index, :edit

      # Task
      live "/tasks", TaskLive.Index, :index
      live "/tasks/new", TaskLive.Index, :new
      live "/tasks/:id/edit", TaskLive.Index, :edit

      # Com
      live "/coms", ComLive.Index, :index
      live "/coms/new", ComLive.Index, :new
      live "/coms/:id/edit", ComLive.Index, :edit

      # Con
      live "/cons", ConLive.Index, :index
      live "/cons/new", ConLive.Index, :new
      live "/cons/:id/edit", ConLive.Index, :edit

      # Appo
      live "/appos", AppoLive.Index, :index
      live "/appos/new", AppoLive.Index, :new
      live "/appos/:id/edit", AppoLive.Index, :edit

      # Update
      live "/upds", UpdLive.Index, :index

      # Chart
      live "/", ChartLive

      # Search
      live "/search", SearchLive

    end
  end

  scope "/", SupacWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
