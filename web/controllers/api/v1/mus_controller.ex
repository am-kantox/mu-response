import MuResponse.Router.Helpers
alias MuResponse.Endpoint

defmodule MuResponse.Api.V1.MusController do
  use MuResponse.Web, :controller

  def index(conn, _params) do
    json conn, %{ endpoints: %{ holidays: api_v1_holiday_url(Endpoint, :index) } }
  end
end
