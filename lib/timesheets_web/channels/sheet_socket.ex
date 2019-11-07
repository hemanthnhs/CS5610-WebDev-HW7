defmodule TimesheetsWeb.SheetChannel do
  use TimesheetsWeb, :channel

  alias Timesheets.BackupAgent

  def join("sheets:" <> name, payload, socket) do
      {manager_id,_} = Integer.parse(name)
      IO.inspect(socket)
      BackupAgent.put(manager_id, socket)
      {:ok, %{"join" => name}, socket}
  end

  def broadcast_msg(%{"manager_id" => manager_id}) do
    socket = BackupAgent.get(manager_id)
    TimesheetsWeb.Endpoint.broadcast(socket.topic, "new_sheet", %{})
  end

end