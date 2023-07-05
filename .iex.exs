alias Digsync.Geo.Helpers
alias Digsync.Planning.Event
alias Digsync.GeoCensus.Client

defmodule Console do
  def make_event do
    {:ok, point} = Client.fetch_by_online_address("1100 3rd Ave N, Nashville, TN 37208")

    Event
    |> Ash.Changeset.for_create(:create, %{point: point})
    |> Digsync.Planning.create!()
  end
end
