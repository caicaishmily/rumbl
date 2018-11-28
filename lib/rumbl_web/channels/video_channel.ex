defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> video_id, _params, socket) do
    :timer.send_interval(5_000, :ping)
    {:ok, socket}
  end

  def handle_in("new_annotation", params, socket) do
    broadcast!(socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    })

    {:reply, :ok, socket}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})

    {:noreply, assign(socket, :count, count + 1)}
  end
end
