import MuResponse.Router.Helpers
alias MuResponse.Endpoint

defmodule MuResponse.Api.V1.HolidayController do
  use MuResponse.Web, :controller

  def index(conn, _params) do
    {:ok, files} = File.cwd!
                   |> Path.join("data/holidays")
                   |> File.ls
    links = Enum.map(files, fn(file) -> api_v1_holiday_url(Endpoint, :show, String.slice(file, 0..2)) end)
    json conn, %{ currencies: links }
  end

  def show(conn, %{"id" => id}) do
    holidays = get_currency(id)
    json conn, %{ holidays: %{ currency: id, days: holidays } }
  end

  #########################################
  ############## persistence ##############
  #########################################
  def get_currency(currency) do
    Agent.get(__MODULE__, fn map ->
      case Map.fetch(map, currency) do
        {:ok, value} -> value
        :error -> load_currency(currency)
      end
    end)
  end

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def load_currency(currency) do
    holidays = File.cwd!
               |> Path.join("data/holidays/#{currency}.yml")
               |> YamlElixir.read_from_file
    # Agent.update(__MODULE__, &Map.put(&1, currency, holidays))
    holidays
  end

end
