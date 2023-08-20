defmodule DigsyncWeb.CreateEventLive do
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Event
  alias Digsync.GeoCensus.Client
  require Logger

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    form = generate_form(current_user)

    {:ok,
     assign(socket,
       actor: current_user,
       form: form,
       selected_date: Date.to_string(DateTime.to_date(DateTime.utc_now())),
       calendar_open: nil
     )}
  end

  def handle_info({:selected_date, date}, socket) do
    socket = assign(socket, selected_date: date, calendar_open: true)
    {:noreply, socket}
  end

  defp generate_form(actor) do
    Event
    |> AshPhoenix.Form.for_create(:create, api: Digsync.Accounts, actor: actor)
    |> to_form()
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    address = Map.get(params, "address")

    Client.fetch_by_online_address(address)
    |> case do
      # do something
      {:ok, coords} ->
        IO.inspect("hey we found coords: #{inspect(coords)}")
        {:noreply, assign(socket, form: form)}

      {:error, _} ->
        Logger.error("invalid address")
        {:error, assign(socket, form: form)}
    end
  end

  def handle_event("submit", %{"form" => params}, socket) do

    case AshPhoenix.Form.submit(socket.assigns.form, params: params, actor: socket.assigns.actor) do
      {:ok, _message} ->
        {:noreply, put_flash(socket, :info, "Created Event!")}

      {:error, form} ->
        Logger.error("error on form submission")
        Logger.error(AshPhoenix.Form.errors(form, format: :raw))
        {:noreply, assign(socket, form: form)}
    end
  end

  def format_date(date) do
    date
    |> Timex.parse!("%Y-%m-%d", :strftime)

    # |> to_string()
  end
end
