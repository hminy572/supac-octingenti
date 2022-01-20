defmodule Supac.Accounts.UserNotifier do
  import Swoosh.Email

  alias Supac.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Supac", "hminy572@gmail.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "アカウント作成に伴うメールアドレスの確認手続きのご案内", """

    ==============================

    #{user.name}さん、こんにちは。

    #{user.name}さんのアカウントが下記の内容で作成されました。
    氏名：#{user.name}
    Eメールアドレス：#{user.email}

    下記のリンクをクリックするとアカウントの登録が完了されます。アカウントの登録が完了しないとログインしても中のコンテンツをご覧いただけません。

    <a href=#{url}>#{url}</a>

    もしアカウントを作成していない、またはこのメールに心当たりがない場合はこのメールを無視してください。

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "パスワード変更手続きのご案内", """

    ==============================

    #{user.name}さん、こんにちは。

    下記のリンクをクリックいただくとパスワードの変更が完了します。

    <a href=#{url}>#{url}</a>

    もしパスワードの変更手続きを行っていないという場合はこのメールを無視してください。

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Eメールアドレス変更手続きのご案内", """

    ==============================

    #{user.name}さん、こんにちは。

    下記リンクをクリックいただくとEメールアドレスの変更手続きが完了します。

    <a href=#{url}>#{url}</a>

    もしEメールアドレスの変更手続きを行っていないという場合はこのメールを無視してください。

    ==============================
    """)
  end
end
