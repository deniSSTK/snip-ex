defmodule ShipExWeb.Router do
  use ShipExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated_api do
    plug :accepts, ["json"]
    plug ShipExWeb.Plugs.EnsureApiKey
  end

  scope "/api", ShipExWeb do
    pipe_through :authenticated_api

    post "/links", LinkController, :create
    get "/links/:code/stats", LinkController, :stats
  end

  scope "/r", ShipExWeb do
    pipe_through :api

    get "/:code", LinkController, :redirect_link
  end
end
