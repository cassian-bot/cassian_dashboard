defmodule CassianDashboard.ConnectionsTest do
  use CassianDashboard.DataCase

  alias CassianDashboard.Connections

  describe "connections" do
    alias CassianDashboard.Connections.Connection

    @valid_attrs %{refresh_token: "some refresh_token", token: "some token", type: "some type"}
    @update_attrs %{
      refresh_token: "some updated refresh_token",
      token: "some updated token",
      type: "some updated type"
    }
    @invalid_attrs %{refresh_token: nil, token: nil, type: nil}

    def connection_fixture(attrs \\ %{}) do
      {:ok, connection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Connections.create_connection()

      connection
    end

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()
      assert Connections.list_connections() == [connection]
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert Connections.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      assert {:ok, %Connection{} = connection} = Connections.create_connection(@valid_attrs)
      assert connection.refresh_token == "some refresh_token"
      assert connection.token == "some token"
      assert connection.type == "some type"
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Connections.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()

      assert {:ok, %Connection{} = connection} =
               Connections.update_connection(connection, @update_attrs)

      assert connection.refresh_token == "some updated refresh_token"
      assert connection.token == "some updated token"
      assert connection.type == "some updated type"
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Connections.update_connection(connection, @invalid_attrs)

      assert connection == Connections.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = Connections.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> Connections.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = Connections.change_connection(connection)
    end
  end
end
