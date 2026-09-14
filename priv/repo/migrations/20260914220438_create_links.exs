defmodule ShipEx.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :original_url, :text, null: false
      add :code, :string, null: false
      add :clicks, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:links, [:code])
  end
end
