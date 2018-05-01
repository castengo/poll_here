defmodule PollHere.Store do
  use Agent

  def start_link() do
    Agent.start_link fn -> %{answers: [], question: ""} end
  end

  @spec add_answer(pid, String.t) :: map
  def add_answer(poll, new_answer) do
    Agent.get_and_update poll, fn %{answers: answers}=state ->
      new_state = %{state | answers: [new_answer | answers]}
      {new_state, new_state}
    end
  end

  @spec get(pid) :: map
  def get(poll) do
    Agent.get(poll, fn state -> state end)
  end

  @spec new_question(pid, String.t) :: map
  def new_question(poll, new_question) do
    Agent.get_and_update poll, fn state ->
      new_state = %{state | question: new_question}
      {new_state, new_state}
    end
    |> IO.inspect
  end

end
