defmodule Backend.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: 120.5,
        code: "some code",
        last: 42,
        phone_number: "some phone_number",
        pub_key: "some pub_key",
        role: 42
      })
      |> Backend.Accounts.create_user()

    user
  end
end
