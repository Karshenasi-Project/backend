defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      phone_number: user.phone_number,
      pub_key: user.pub_key,
      code: user.code,
      balance: user.balance,
      is_admin: user.is_admin
    }
  end

  def render("show1.json", %{user: user}) do
    %{data: render_one(user, UserView, "user1.json")}
  end

  def render("user1.json", %{user: user}) do
    %{
      phone_number: user.phone_number,
      pub_key: user.pub_key,
    }
  end

  def render("show2.json", %{user: user}) do
    %{data: render_one(user, UserView, "user2.json")}
  end

  def render("user2.json", %{user: user}) do
    %{
      phone_number: user.phone_number,
      pub_key: user.pub_key,
      balance: user.balance,
    }
  end

  def render("error.json", %{message: message}) do
    %{
      message: message,
    }
  end
end
