defmodule Timesheets2Web.SheetChannel do
  use Timesheets2Web, :channel

  alias Timesheets2.BackupAgent

  def join("sheets:" <> name, payload, socket) do
      {user_id,_} = Integer.parse(name)
      IO.inspect(socket)
      BackupAgent.put(user_id, socket)
      {:ok, %{"join" => name}, socket}
  end

  def broadcast_msg(%{"manager_id" => manager_id, "user_name" => user_name, "workdate" => workdate, "sheet_id" => sheet_id}) do
    socket = BackupAgent.get(manager_id)
    message = "#{user_name} has submitted timesheet for #{workdate} with less than 8 hours"
    Timesheets2Web.Endpoint.broadcast(socket.topic, "less_hours_alert" , %{sheet_id: sheet_id, message: message})
  end

  def broadcast_sheet(%{"manager_id" => manager_id}) do
    socket = BackupAgent.get(manager_id)
    Timesheets2Web.Endpoint.broadcast(socket.topic, "update_sheets" , %{})
  end

  def broadcast_approve(%{"worker_id" => worker_id}) do
    socket = BackupAgent.get(worker_id)
    Timesheets2Web.Endpoint.broadcast(socket.topic, "update_sheets" , %{})
  end

end