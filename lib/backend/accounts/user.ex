defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :code, :string
    field :phone_number, :string
    field :pub_key, :string,default: ""
    field :balance, :float, default: 0.0
    field :is_admin, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone_number, :pub_key ,:balance, :code])
    |> validate_required([:phone_number])
    |> unique_constraint(:phone_number)
  end

  # defp put_code(%Ecto.Changeset{valid?: true, changes: %{code: code}} = changeset) do
  #   change(changeset, code: Pbkdf2.hash_pwd_salt(code))
  # end
end
