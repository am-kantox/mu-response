defmodule MuResponse.Router do
  use MuResponse.Web, :router

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

  scope "/", MuResponse do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", MuResponse.Api, as: :api  do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      get "/", MusController, :index
      resources "/holidays", HolidayController, only: [:index, :show, :update] do
        # [AM] Later on we probably will permit updating holidays thru web interface
        # http://www.phoenixframework.org/docs/routing#section-nested-resources
      end
      resources "/hedge_info", HedgeInfoController, only: [:index] do
      end
    end
  end

end
