defmodule Digsync.GeoCensus.Client do
  use Tesla, docs: true

  @moduledoc """
  # https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.html#_Toc7768590
  API Wrapper for Geocoding Census
  """

  # https://geocoding.geo.census.gov/geocoder/returntype/searchtype?parameters

  @return_type "locations"
  @benchmark "2020"
  @format "json"

  plug Tesla.Middleware.BaseUrl, "https://geocoding.geo.census.gov/geocoder"
  plug Tesla.Middleware.JSON

  @spec fetch_by_online_address(String.t()) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def fetch_by_online_address(address) do
    endpoint = "/#{@return_type}/onelineaddress"

    endpoint
    |> get(query: [address: address, benchmark: @benchmark, format: @format])
    |> case do
      {:ok,
       %{
         status: 200,
         body: %{
           "result" => %{"addressMatches" => [%{"coordinates" => coordinates} | _rest] = _matches}
         }
       } = _resp} ->
        {:ok, Digsync.Geo.Helpers.make_point(coordinates["x"], coordinates["y"])}

      {:ok, %{status: 404, body: %{"errors" => reason}}} ->
        {:error, reason}

      error ->
        error
    end
  end
end
