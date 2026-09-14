defmodule ShipExWeb.LinkController do
  use ShipExWeb, :controller

  alias ShipEx.Links

  def create(conn, %{"url" => url}) do
    case Links.create_link(%{"original_url" => url}) do
      {:ok, link} ->
        conn
        |> put_status(:created)
        |> json(%{code: link.code, short_url: "/r/#{link.code}"})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  def redirect_link(conn, %{"code" => code}) do
    case Links.get_by_code(code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Link not found"})

      link ->
        Links.track_click(link)
        redirect(conn, external: link.original_url)
    end
  end

  def stats(conn, %{"code" => code}) do
    case Links.get_by_code(code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Link not found"})

      link ->
        json(conn, %{
          code: link.code,
          original_url: link.original_url,
          clicks: link.clicks
        })
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
