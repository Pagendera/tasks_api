defmodule TasksApiWeb.AccountJSON do

  def show_token(%{account: account, token: token}) do
    %{
      id: account.id,
      email: account.email,
      token: token
    }
  end
end
