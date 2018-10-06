defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts comntext.
  """

  alias Rumbl.Repo

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end
  
  def list_user do
    Repo.all(User)
  end
end