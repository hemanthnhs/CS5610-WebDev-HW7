defmodule TimesheetsWeb.SheetChannel do
  use TimesheetsWeb, :channel

  alias Timesheets.BackupAgent

  def join("sheets:" <> name, payload, socket) do
      {manager_id,_} = Integer.parse(name)
      IO.inspect(socket)
      BackupAgent.put(manager_id, socket)
      {:ok, %{"join" => name}, socket}
  end

  def broadcast_msg(%{"manager_id" => manager_id, "user_name" => user_name, "workdate" => workdate, "sheet_id" => sheet_id}) do
    IO.puts("Broadcastttttttt==============")
    socket = BackupAgent.get(manager_id)
    message = "#{user_name} has submitted timesheet for #{workdate} with less than 8 hours"
    TimesheetsWeb.Endpoint.broadcast(socket.topic, "less_hours_alert" , %{sheet_id: sheet_id, message: message})
  end

end