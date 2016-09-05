defmodule MuResponse.PageController do
  use MuResponse.Web, :controller

  def index(connection, _params) do
    connection
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render("index.html")
  end
end
