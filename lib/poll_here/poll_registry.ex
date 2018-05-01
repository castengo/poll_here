defmodule PollHere.PollRegistry do
  use GenServer
  require Logger
  alias PollHere.Store

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Starts a new poll with given name.
  """
  @spec new_poll(String.t) :: {:ok|:already_exists, String.t}
  def new_poll(name) do
    GenServer.call(__MODULE__, {:new, name})
  end

  @doc """
  Finds a poll `pid`` by name.
  """
  @spec find_poll(String.t) :: pid|nil
  def find_poll(name) do
    GenServer.call(__MODULE__, {:find, name})
  end

  ## CALLBACKS ##

  @impl true
  def init(_) do
    Logger.info "Started up Poll Registry"
    {:ok, %{}}
  end

  @impl true
  def handle_call({:new, name}, _from, state) do
    case Map.get(state, name) do
      nil ->
        {:ok, store_pid} = Store.start_link()
        {:reply, {:ok, store_pid}, Map.put(state, name, store_pid)}
      existing_pid ->
        {:reply, {:already_exists, existing_pid}, state}
    end
  end

  @impl true
  def handle_call({:find, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

end
