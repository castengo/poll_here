defmodule PollHere.Store do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_answer(answer) do
    GenServer.call(__MODULE__, {:add_answer, answer})
  end

  def new_question(question) do
    GenServer.call(__MODULE__, {:new_question, question})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  ## CALLBACKS ##

  def init(_) do
    Logger.info "started poll here store"
    {:ok, %{answers: [], question: ""}}
  end


  def handle_call({:add_answer, new_answer}, _from, %{answers: answers}=state) do
    new_state = %{state | answers: [new_answer | answers]}
    {:reply, new_state, new_state}
  end

  def handle_call({:new_question, question}, _from, _state) do
    state = %{answers: [], question: question}
    broadcast(state)
    {:reply, state, state}
  end

  def handle_call(:get, _from, state), do: {:reply, state, state}

  defp broadcast(state) do
    PollHereWeb.Endpoint.broadcast! "poll:all", "new_state", state
  end
end
