defmodule PollHereWeb.PageController do
  use PollHereWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
