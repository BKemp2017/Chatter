defmodule ChatterWeb.ChatHTML do
  use Phoenix.Component
  use ChatterWeb, :html

  embed_templates "chat_html/*"
end
