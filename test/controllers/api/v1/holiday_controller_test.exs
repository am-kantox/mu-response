defmodule MuResponse.Api.V1.HolidayControllerTest do
  use MuResponse.ConnCase

  test "GET /api/v1/holidays" do
    conn = get build_conn(), "/api/v1/holidays"
    resp = json_response(conn, 200)
    assert Enum.count(resp) == 1
    assert Enum.count(resp["currencies"]) > 10
    assert {:ok, "http://localhost:4001/api/v1/holidays/AUD"} = Enum.fetch(resp["currencies"], 0)
  end

  test "GET /api/v1/holidays/AUD" do
    conn = get build_conn(), "/api/v1/holidays/AUD"
    resp = json_response(conn, 200)
    assert Enum.count(resp) == 3
    assert Enum.count(resp["AUD"]) > 10
  end

  test "GET /api/v1/holidays/XXX" do
    conn = get build_conn(), "/api/v1/holidays/XXX"
    resp = json_response(conn, 200)
    assert Enum.count(resp) == 3
    assert Enum.count(resp["XXX"]) == 0
  end

  test "GET /api/v1/holidays/AUD,EUR" do
    conn = get build_conn(), "/api/v1/holidays/AUD,EUR"
    resp = json_response(conn, 200)
    assert Enum.count(resp) == 4
    assert Enum.count(resp["AUD"]) > 10
    assert Enum.count(resp["EUR"]) > 10
    assert Enum.count(resp["all"]) > 10
    assert Enum.count(resp["all"]) < 1000
  end

  test "GET /api/v1/holidays/*" do
    conn = get build_conn(), "/api/v1/holidays/*"
    resp = json_response(conn, 200)
    assert Enum.count(resp) > 20
    assert Enum.count(resp["all"]) > 1000
  end

end
