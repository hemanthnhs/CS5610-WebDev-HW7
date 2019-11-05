defmodule TimesheetsWeb.Router do
  use TimesheetsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TimesheetsWeb.Plugs.FetchCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimesheetsWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/jobs", JobController, except: [:delete]
    resources "/sheets", SheetController,only: [:show, :new, :create, :delete]
    get "/dashboard", SheetController, :index
    post "/approve", SheetController, :approve
    resources "/sessions", SessionController,
              only: [:new, :create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimesheetsWeb do
  #   pipe_through :api
  # end
end
