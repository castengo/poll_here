defmodule PollHere.Store do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{answers: [], question: ""} end, name: __MODULE__)
  end

  @spec add_answer(String.t) :: map
  def add_answer(new_answer) do
    Agent.get_and_update(__MODULE__, fn %{answers: answers}=state ->
      new_state = %{state | answers: [new_answer | answers]}
      {new_state, new_state}
    end)
  end

  @spec get() :: map()
  def get() do
    Agent.get(__MODULE__, fn state -> state end)
  end

  @spec new_question(String.t) :: :ok
  def new_question(new_question) do
    Agent.get_and_update(__MODULE__, fn state ->
      new_state = %{state | question: new_question}
      {new_state, new_state}
    end)
    |> broadcast!
  end

  defp broadcast!(state) do
    PollHereWeb.Endpoint.broadcast! "poll:all", "new_state", state
  end

end
