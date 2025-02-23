defmodule ChatterWeb.ChatRoomChannel do
  use Phoenix.Channel
  import Ecto.Query, only: [from: 2]

  @impl true
  def join("chat_room:lobby", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("chat_room:lobby", _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # Handles ping request (for debugging)
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Broadcasts messages to all users in the chat room
  @impl true
  def handle_in("shout", %{"name" => name, "message" => message}, socket) do
    broadcast!(socket, "shout", %{name: name, message: message})
    {:noreply, socket}
  end

  # Stores new messages in the database and broadcasts to all users
  @impl true
  def handle_in("new_message", %{"name" => name, "message" => message}, socket) do
    changeset = Chatter.Message.changeset(%Chatter.Message{}, %{name: name, message: message})

    case Chatter.Repo.insert(changeset) do
      {:ok, msg} ->
        broadcast!(socket, "new_message", format_msg(msg))
        {:noreply, socket}

      {:error, _changeset} ->
        {:reply, {:error, %{reason: "Failed to save message"}}, socket}
    end
  end

  # Loads recent messages upon joining
  @impl true
  def handle_info(:after_join, socket) do
    messages =
      Chatter.Repo.all(from m in Chatter.Message, order_by: [desc: m.inserted_at], limit: 20)
      |> Enum.map(&format_msg/1)

    push(socket, "load_messages", %{messages: messages})
    {:noreply, socket}
  end

  # Helper function to format messages
  defp format_msg(%Chatter.Message{name: name, message: message, inserted_at: timestamp}) do
    %{
      name: name,
      message: message,
      timestamp: timestamp
    }
  end
end
