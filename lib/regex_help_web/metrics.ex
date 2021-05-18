defmodule RegexHelpWeb.Metrics do
  use GenServer

  @name __MODULE__

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:num_visits, _from, state) do
    {:reply, state.visits, state}
  end

  @impl true
  def handle_call(:visit, _from, state) do
    state = Map.put(state, :visits, state.visits + 1)
    {:reply, [], state}
  end

  def start_link(_params) do
    GenServer.start_link(__MODULE__, %{visits: 0}, name: @name)
  end

  def num_visits do
    GenServer.call(__MODULE__, :num_visits)
  end

  def visit do
    GenServer.call(__MODULE__, :visit)
  end
end
