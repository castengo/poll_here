defmodule PollHereWeb.PollChannel do
  use Phoenix.Channel
  alias PollHere.Store

  def join("poll:" <> _poll_name, _auth_message, socket) do
    {:ok, socket}
  end

  def handle_in("new_answer", answer, socket) do
    broadcast! socket, "new_state", Store.add_answer(answer)
    {:noreply, socket}
  end

  def handle_in("get", _nada, socket) do
    {:reply, {:ok, Store.get()}, socket}
  end
end
