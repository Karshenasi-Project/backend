defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone_number, :string, default: ""
      add :pub_key, :string, default: ""
      add :code, :string, default: ""
      add :balance, :float, default: 0.0
      add :is_admin, :boolean, default: false
      timestamps()
    end

    create unique_index(:users, [:phone_number])

  end
end
