defmodule Rumbl.AccountsTest do
  use Rumbl.DataCase

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  describe "register_user/2" do
    @valid_attrs %{
      name: "User",
      username: "eva",
      credential: %{email: "eva@test", password: "secret"}
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "User"
      assert user.username == "eva"
      assert user.credential.email == "eva@test"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "enforces unique usernames" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)
      assert %{username: ["has already been taken"]} = errors_on(changeset)
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
      {:error, changeset} = Accounts.register_user(attrs)
      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "require  password to be at least 6 charslong" do
      attrs = put_in(@valid_attrs, [:credential, :password], "12345")
      {:error, changeset} = Accounts.register_user(attrs)
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)[:credential]
      assert Accounts.list_users() == []
    end

  end

  describe "authenticate_by_email_and_pass" do
    @email "user@localhost"
    @pass "123456"

    setup do
      {:ok, user: user_fixture(email: @email, password: @pass)}
    end

    test "returns user with correct password", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authenticate_by_email_and_pass(@email, @pass)
    end

    test "returns unauthorized error with invalid password" do
      assert {:error, :unauthorized} = Accounts.authenticate_by_email_and_pass(@email, "badpass")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} = Accounts.authenticate_by_email_and_pass("bademail@localhost", @pass)
    end

  end

  # describe "credentials" do
  #   alias Rumbl.Accounts.Credential

  #   @valid_attrs %{" email": "some  email", password_hash: "some password_hash"}
  #   @update_attrs %{" email": "some updated  email", password_hash: "some updated password_hash"}
  #   @invalid_attrs %{" email": nil, password_hash: nil}

  #   def credential_fixture(attrs \\ %{}) do
  #     {:ok, credential} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Accounts.create_credential()

  #     credential
  #   end

  #   test "list_credentials/0 returns all credentials" do
  #     credential = credential_fixture()
  #     assert Accounts.list_credentials() == [credential]
  #   end

  #   test "get_credential!/1 returns the credential with given id" do
  #     credential = credential_fixture()
  #     assert Accounts.get_credential!(credential.id) == credential
  #   end

  #   test "create_credential/1 with valid data creates a credential" do
  #     assert {:ok, %Credential{} = credential} = Accounts.create_credential(@valid_attrs)
  #     assert credential. email == "some  email"
  #     assert credential.password_hash == "some password_hash"
  #   end

  #   test "create_credential/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Accounts.create_credential(@invalid_attrs)
  #   end

  #   test "update_credential/2 with valid data updates the credential" do
  #     credential = credential_fixture()
  #     assert {:ok, %Credential{} = credential} = Accounts.update_credential(credential, @update_attrs)

      
  #     assert credential. email == "some updated  email"
  #     assert credential.password_hash == "some updated password_hash"
  #   end

  #   test "update_credential/2 with invalid data returns error changeset" do
  #     credential = credential_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
  #     assert credential == Accounts.get_credential!(credential.id)
  #   end

  #   test "delete_credential/1 deletes the credential" do
  #     credential = credential_fixture()
  #     assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
  #     assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
  #   end

  #   test "change_credential/1 returns a credential changeset" do
  #     credential = credential_fixture()
  #     assert %Ecto.Changeset{} = Accounts.change_credential(credential)
  #   end
  # end
end
