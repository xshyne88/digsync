defmodule DigsyncWeb.CreateEventLive do
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Event

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

  @impl true
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
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _message} ->
        {:noreply, put_flash(socket, :info, "Created Group!")}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end
end
