defmodule ShipExWeb.Plugs.EnsureApiKey do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    expected_key = System.get_env("API_KEY") || "secret-token-123"

    case get_req_header(conn, "x-api-key") do
      [^expected_key] ->
        conn

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized: Invalid or missing x-api-key header"})
        |> halt()
    end
  end
end
