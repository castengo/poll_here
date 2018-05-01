defmodule PollHereWeb.Router do
  use PollHereWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PollHereWeb do
    pipe_through :browser # Use the default browser stack

    resources "/", PageController, only: [:index, :create]
    get "/join", PageController, :join
  end

end
