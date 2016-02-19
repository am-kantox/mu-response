import MuResponse.Router.Helpers
# alias MuResponse.Endpoint

defmodule MuResponse.Api.V1.HedgeInfoController do
  use MuResponse.Web, :controller

  def index(conn, _params) do
    # [AM] FIXME USE ECTO
    { :ok, p } = Mariaex.Connection.start_link(username: "root", database: "kantox_demo_20160118")
    { status, result } = Mariaex.Connection.query(p, "SELECT * FROM hedge_with_bids LIMIT 2")
    result = case status do
        :ok -> format_result(result.rows)
        _   -> "Could not fetch hedges..."
      end
    json conn, %{ status: status, result: result }
  end

  #########################################
  ################ privates ###############
  #########################################

  def format_result(result) do
    # [[2921, "H-T451SZNXE", {{2013, 4, 4}, {9, 5, 38, 0}}, ...
    Enum.map(result, fn row ->
      Enum.map(row, fn value ->
        case value do
          {y, m, d} -> rjust(y) <> "-" <> rjust(m) <> "-" <> rjust(d)
          {h, min, sec, _} -> rjust(h) <> ":" <> rjust(min) <> ":" <> rjust(sec)
          {{y, m, d}, {h, min, sec, _}} -> rjust(y) <> "-" <> rjust(m) <> "-" <> rjust(d) <> " " <> rjust(h) <> ":" <> rjust(min) <> ":" <> rjust(sec)
          _ -> value
        end
      end)
    end)
  end

  def rjust(date_part) when date_part > 60 do # seconds in minute > days in month, if anybody is curious
    String.rjust("#{date_part}", 4, ?0)
  end

  def rjust(date_part) do
    String.rjust("#{date_part}", 2, ?0)
  end

end
