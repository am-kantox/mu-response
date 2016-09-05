defmodule MuResponse.PageControllerTest do
  use MuResponse.ConnCase

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
