defmodule DigsyncWeb.Live.Components.AddLocationComponent do
  use DigsyncWeb, :live_component
  alias Digsync.GeoCensus.Client

  def render(assigns) do
    ~L"""
    <div class="mb-4">
      <input
        id="location-input"
        class="border rounded p-2 mr-2"
        type="text"
        placeholder="Enter location"
      />
      <button
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        phx-click="fetch-online-address"
        phx-value-location="location-input"
      >
        Add Location
      </button>
    </div>
    """
  end
end
