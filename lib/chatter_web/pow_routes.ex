defmodule ChatterWeb.PowRoutes do
  use Pow.Phoenix.Routes

  def after_sign_in_path(_conn), do: "/chat"  # ✅ Use a plain string instead
end
