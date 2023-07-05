defmodule DigSync.Geo.Helpers do
  def make_point(lng, lat) do
    %Geo.Point{coordinates: {lng, lat}, srid: 4326}
  end
end
