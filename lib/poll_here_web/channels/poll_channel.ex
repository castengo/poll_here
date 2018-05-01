defmodule PollHereWeb.PollChannel do
  use Phoenix.Channel
  alias PollHere.PollRegistry
  alias PollHere.Store

  def join("poll:" <> poll_name, _auth_message, socket) do
    case PollRegistry.find(poll_name) do
      nil ->
        {:error, "There's no poll with that name"}
      store_pid ->
        {:ok, assign(socket, :poll, store_pid)}
    end
  end

  def handle_in("new_answer", answer, %{assigns: %{poll: poll}}=socket) do
    broadcast! socket, "new_state", Store.add_answer(poll, answer)
    {:noreply, socket}
  end

  def handle_in("get", _nada, %{assigns: %{poll: poll}}=socket) do
    {:reply, {:ok, Store.get(poll)}, socket}
  end

  def handle_in("new_question", question, %{assigns: %{poll: poll}}=socket) do
    broadcast! socket, "new_state", Store.new_question(poll, question)
    {:noreply, socket}
  end

end
