defmodule ShipEx.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :original_url, :string
    field :code, :string
    field :clicks, :integer, default: 0

    timestamps()
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [:original_url, :code, :clicks])
    |> validate_required([:original_url, :code])
    |> unique_constraint(:code)
  end
end
