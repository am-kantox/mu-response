import MuResponse.Router.Helpers
alias MuResponse.Endpoint

defmodule MuResponse.Api.V1.HolidayController do
  use MuResponse.Web, :controller

  def index(conn, _params) do
    json conn, %{ currencies: Enum.map(get_currency_list, fn file ->
      api_v1_holiday_url(Endpoint, :show, file)
    end) }
  end

  def show(conn, %{"id" => id}) do
    json conn, %{ holidays: %{ currency: id, days: get_currency(id) } }
  end

  #########################################
  ############## persistence ##############
  #########################################
  def start_link do
    case Agent.start_link(fn -> %{} end, name: __MODULE__) do
      {:ok, pid} ->
        Enum.each(get_currency_list, fn(currency) -> load_currency(currency) end)
        {:ok, pid}
      _ -> :error
    end
  end

  def get_currency_list do
    case File.cwd! |> Path.join("data/holidays") |> File.ls do
      {:ok, files} ->
        Enum.map(files, fn file -> String.slice(file, 0..2) end)
      _ -> :error
    end
  end

  def get_currency(currency) do
    Agent.get(__MODULE__, fn map ->
      case Map.fetch(map, currency) do
        {:ok, value} -> value
        :error -> []
      end
    end)
  end

  def load_currency(currency) do
    holidays = File.cwd!
               |> Path.join("data/holidays/#{currency}.yml")
               |> YamlElixir.read_from_file
    Agent.update(__MODULE__, &Map.put(&1, currency, holidays))
  end

end
