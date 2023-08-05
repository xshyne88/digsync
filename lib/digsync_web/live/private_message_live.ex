defmodule DigsyncWeb.PrivateMessageLive do
  use DigsyncWeb, :live_view

  def mount(%{"user_id" => user_id}, _session, socket) do
    current_user = socket.assigns.current_user
    form = generate_form(current_user)
    {:ok, assign(socket, actor: current_user, user_id: user_id, form: form)}
  end

  def render(assigns) do
    ~H"""
    <div class="w-full max-w-sm mx-auto">
      <div class="bg-white rounded-lg shadow-md p-6">
        <.form
          class="w-full max-w-sm mx-auto p-4 bg-white rounded-lg shadow-md"
          for={@form}
          phx-change="validate"
          phx-submit="submit"
        >
          <div class="mb-4">
            <.input
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              type="text"
              label="Text"
              field={@form[:message_text]}
            />
          </div>
          <.input type="hidden" value={@user_id} field={@form[:recipient]} />
          <.button class="bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
            Create Message
          </.button>
        </.form>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _message} ->
        {:noreply, put_flash(socket, :info, "Created Private Message!")}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  def generate_form(actor) do
    Digsync.Accounts.PrivateMessage
    |> AshPhoenix.Form.for_create(:create, api: Digsync.Accounts, actor: actor)
    |> to_form()
  end
end
