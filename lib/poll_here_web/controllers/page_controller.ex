defmodule PollHereWeb.PageController do
  use PollHereWeb, :controller
  alias PollHere.PollRegistry

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"poll_name" => poll_name}) do
    case PollRegistry.new(poll_name) do
      {:ok, _pid} ->
        render conn, "presenter.html", %{name: poll_name}
      {:existing, _pid} ->
        conn
        |> put_flash(:error, "Already a poll with that name")
        |> redirect(to: page_path(conn, :index))
    end
  end
end
