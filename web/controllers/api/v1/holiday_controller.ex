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
    currencies =  case id do
                    "*" -> get_currency_list
                    _   -> String.split(id, ~r{,})
                  end
    days = Enum.reduce(currencies, %{}, fn(currency, acc) ->
      Map.put(acc, currency, get_currency(currency))
    end)
    holidays = Map.put(days, :all, Enum.uniq(Enum.reduce(days, [], fn({_, v}, acc) ->
      acc ++ v
    end)))
    json conn, holidays
  end

  #########################################
  ############## persistence ##############
  #########################################
  def start_link do
    case Agent.start_link(fn -> %{} end, name: __MODULE__) do
      {:ok, pid} ->
        reload_currencies
        {:ok, pid}
      _ -> :error
    end
  end

  def get_currency_path do
    File.cwd! |> Path.join("data/holidays")
  end

  def get_currency_list do
    Agent.get(__MODULE__, &Map.keys(&1))
  end

  def get_currency(currency) do
    Agent.get(__MODULE__, fn map ->
      case Map.fetch(map, currency) do
        {:ok, value} -> value
        :error -> []
      end
    end)
  end

  def load_currency_list do
    case get_currency_path |> File.ls do
      {:ok, files} ->
        Enum.map(files, fn file -> String.slice(file, 0..2) end)
      _ -> :error
    end
  end

  def load_currency(currency) do
    File.cwd!
    |> Path.join("data/holidays/#{currency}.yml")
    |> YamlElixir.read_from_file
  end

  def load_currencies do
    Enum.reduce(load_currency_list, %{}, fn(currency, acc) ->
      Map.put(acc, currency, load_currency(currency))
    end)
  end

  def update_currency(currency) do
    Agent.update(__MODULE__, &Map.put(&1, currency, load_currency(currency)))
  end

  def update_currencies do
    Enum.each(load_currency_list, fn(currency) -> update_currency(currency) end)
  end

  def reload_currencies do
    unwatch_currencies
    Agent.get_and_update(__MODULE__, fn map ->
      { Enum.into(map, []), load_currencies }
    end)
    watch_currencies
  end

  # inotify should be installed on target https://github.com/massemanet/inotify
  # iex(1)> :inoteefy.watch('/tmp/ghgh', fn (x)-> IO.puts(x) end)
  # iex(2)> [info] [{:current_function, {:inoteefy, :maybe_call_back, 1}},
  #                 {:line, 92},
  #                 ...]
  def watch_currencies do
    :inoteefy.watch(String.to_char_list(get_currency_path), fn params ->
      case params do
        {_, [:create], _, _} -> reload_currencies
        {_, [:close_write], _, _} -> reload_currencies
        {_, [:move_from], _, _} -> reload_currencies
        _ -> :noop
      end
    end)
  end

  def unwatch_currencies do
    :inoteefy.unwatch(String.to_char_list(get_currency_path))
    case get_currency_path |> File.ls do
      {:ok, files} ->
        Enum.each(files, fn file -> :inoteefy.unwatch(String.to_char_list(file)) end)
      _ -> :error
    end
  end

end
