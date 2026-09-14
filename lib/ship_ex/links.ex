defmodule ShipEx.Links do
  import Ecto.Query, warn: false
  alias ShipEx.Repo
  alias ShipEx.Links.Link

  def create_link(attrs \\ %{}) do
    code = generate_random_code()
    attrs_with_code = Map.put_new(attrs, "code", code)

    %Link{}
    |> Link.changeset(attrs_with_code)
    |> Repo.insert()
  end

  def get_by_code(code) do
    Repo.get_by(Link, code: code)
  end

  def track_click(%Link{} = link) do
    from(l in Link, where: l.id == ^link.id)
    |> Repo.update_all(inc: [clicks: 1])
  end

  defp generate_random_code do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64(padding: false)
  end
end
