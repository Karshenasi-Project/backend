defmodule Backend.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts.User
  alias Backend.Accounts.Guardian
  import Pbkdf2

  defp get_user_by_username(phone_number) when is_binary(phone_number)do
    case Repo.get_by(User, phone_number: phone_number) do
      nil ->
        no_user_verify()
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end

  def get_user_by_pub_key(pub_key) when is_binary(pub_key)do
    case Repo.get_by!(User, pub_key: pub_key) do
      nil ->
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end

  def get_user_by_phone_number(phone_number) when is_binary(phone_number)do
    case Repo.get_by(User, phone_number: phone_number) do
      nil ->
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end

  defp verify_password(code, %User{} = user) when is_binary(code) do
    if verify_pass(code, user.code) do
      {:ok, user}

    else
      {:error, :invalid_password}
    end
  end

  defp user_password_auth(phone_number, code) when is_binary(phone_number) and is_binary(code) do
    with {:ok , user} <- get_user_by_username(phone_number),
    do: verify_password(code , user)
  end

  def token_sign_in(phone_number , code) do
    case user_password_auth(phone_number , code) do
      {:ok , user} ->
        {Guardian.encode_and_sign(user),user}

      _ ->
        {:error , :unauthorized}
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user_all!(id), do: Repo.get!(User, id)
  def get_user_all(id), do: Repo.get(User, id)
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_code(attrs \\ %{}) do
    IO.inspect(attrs)
    random_number = to_string(Enum.random(1_00000..9_99999))
    attrs = Map.put(attrs, "code", random_number)
    # IO.inspect(attrs)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
