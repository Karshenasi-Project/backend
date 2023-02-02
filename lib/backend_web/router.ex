defmodule BackendWeb.Router do
  use BackendWeb, :router
  alias Backend.Accounts.AuthPipeline

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug AuthPipeline
  end

  scope "/api", BackendWeb do
    pipe_through :api
    post "/sign_up", UserController, :sign_up
    post "/sign_in", UserController, :sign_in
    get "/send_sms/:phone_number", UserController, :send_sms
    get "/get_pub_key/:phone_number", UserController, :get_pub_key
    resources "/users", UserController, except: [:new, :edit]
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
