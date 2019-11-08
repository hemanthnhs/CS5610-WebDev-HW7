defmodule Timesheets2Web.Router do
  use Timesheets2Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :ajax do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/ajax", Timesheets2Web do
    pipe_through :ajax

    resources "/sessions", SessionController, only: [:create], singleton: true
    resources "/jobs", JobController, only: [:index]
    resources "/sheets", SheetController,only: [:show, :index, :create]
    post "/approve", SheetController, :approve
  end


  scope "/", Timesheets2Web do
    pipe_through :browser
    get "/*path", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Timesheets2Web do
  #   pipe_through :api
  # end
end
