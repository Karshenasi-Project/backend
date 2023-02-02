defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def get_pub_key(conn, %{"phone_number" => phone_number}) do
    with {:ok, user} <- Accounts.get_user_by_phone_number(phone_number) do
      render(conn, "show1.json", user: user)
    end
  end

  # def set_pub_key(conn, %{"user" => user_params}) do
  #   user = Accounts.get_user_by_phone_number(user_params["phone_number"])
  #   case user do
  #     {:error, :not_found} ->
  #       Accounts.create_user(user_params)
  #     {:ok, user} ->
  #       with {:ok, %User{} = user} <- Accounts.update_user(user, %{"pub_key" => user_params["pub_key"]}) do
  #         render(conn, "show.json", user: user)
  #       end
  #   end

  # end

  def sign_up(conn, %{"user" => user_params}) do
    user = Accounts.get_user_by_phone_number(user_params["phone_number"])
    case user do
      {:error, :not_found} ->
        with {:ok, %User{} = user} <- Accounts.create_user_code(user_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_path(conn, :show, user))
          |> render("show2.json", user: user)
        end
      {:ok, user} ->

        if (user.pub_key != "") do
          with {:ok, %User{} = _user1} <- Accounts.update_user(user, %{"balance" => 0.0}) do
            render(conn, "show2.json", user: user)
          end
        else
          {bal, _} = Float.parse(user_params["balance"])
          with {:ok, %User{} = user} <- Accounts.update_user(user, %{"balance" => bal + user.balance}) do
            render(conn, "show2.json", user: user)
          end
        end
    end
  end

  def sign_in(conn, %{"user" => user_params}) do
    {:ok,user} = Accounts.get_user_by_phone_number(user_params["phone_number"])

    if (user.code == user_params["code"]) do
      with {:ok, %User{} = user} <- Accounts.update_user(user, %{"pub_key" => user_params["pub_key"] , "code" => to_string(Enum.random(1_00000..9_99999)) }) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show1.json", user: user)
      end
    else
      conn
        |> put_status(:unauthorized)
        |> render("error.json", message: "your code is not valid")
    end
  end

  def send_sms_kavenegar(number,sms) do
    m = "https://api.kavenegar.com/v1/732B6264364F7A6A4464534E3843747045785253366161305648612B37427A77654759434A566351584F733D/sms/send.json?receptor=#{number}&sender=10008663&message=#{sms}"
    HTTPoison.get(m)
  end

  def send_sms(conn, %{"phone_number" => phone_number}) do
    user = Accounts.get_user_by_phone_number(phone_number)
    case user do
      {:error, :not_found} ->
        with {:ok, %User{} = user} <- Accounts.create_user_code(%{"phone_number" => phone_number}) do
          IO.inspect(user)
          send_sms_kavenegar(user.phone_number, user.code)
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_path(conn, :show, user))
          |> render("show1.json", user: user)
        end
      {:ok, user} ->
        with {:ok, %User{} = user} <- Accounts.update_user(user, %{"code" => to_string(Enum.random(1_00000..9_99999))}) do
          send_sms_kavenegar(user.phone_number, user.code)
          render(conn, "show1.json", user: user)
        end
    end
  end



  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
