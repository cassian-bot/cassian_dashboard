defmodule CassianDashboard.AccountsTest do
  use CassianDashboard.DataCase

  alias CassianDashboard.Accounts

  describe "accounts" do
    alias CassianDashboard.Accounts.Account

    @valid_attrs %{avatar: "some avatar", discord_id: "some discord_id", refresh_token: "some refresh_token", token: "some token", username: "some username", valid_until: "2010-04-17T14:00:00Z"}
    @update_attrs %{avatar: "some updated avatar", discord_id: "some updated discord_id", refresh_token: "some updated refresh_token", token: "some updated token", username: "some updated username", valid_until: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{avatar: nil, discord_id: nil, refresh_token: nil, token: nil, username: nil, valid_until: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.avatar == "some avatar"
      assert account.discord_id == "some discord_id"
      assert account.refresh_token == "some refresh_token"
      assert account.token == "some token"
      assert account.username == "some username"
      assert account.valid_until == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.avatar == "some updated avatar"
      assert account.discord_id == "some updated discord_id"
      assert account.refresh_token == "some updated refresh_token"
      assert account.token == "some updated token"
      assert account.username == "some updated username"
      assert account.valid_until == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
