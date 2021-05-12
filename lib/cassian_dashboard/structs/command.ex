defmodule CassianDashboard.Structs.Command do
  @moduledoc """
  Command struct used in the web view.
  """

  defstruct [
    :name,
    :arg,
    :placeholder,
    :description,
    :categories
  ]

  @typedoc """
  The struct object which defines a command.
  """
  @type t() :: %__MODULE__{
          name: String.t() | nil,
          arg: String.t() | nil,
          placeholder: String.t() | nil,
          description: String.t() | nil,
          categories: [String.t()]
        }

  @typedoc "The calling name of the command."
  @type name :: String.t()

  @typedoc "The argument of the command which isn't edited with the search bar,"
  @type arg :: String.t()

  @typedoc "The plcaholder value which is edited in the search bar."
  @type placeholder :: String.t()

  @typedoc "The description of the command."
  @type description :: String.t()

  @typedoc "The categories under which the command falls"
  @type categories :: String.t()

  @doc """
  Get the command struct from a keyword list.

  ## Examples

      iex> command!(name: "Hello", arg: "World")
      %Command{
        arg: "World",
        categories: ["misc"],
        description: nil,
        name: "Hello",
        placeholder: nil
      }

      iex> command!(name: "Hello", categories: "general")
      %Command{
        arg: "World",
        categories: ["general"],
        description: nil,
        name: "Hello",
        placeholder: nil
      }

      iex> command!(name: "ASDF", categories: ["general", "one"])
      %Command{
        arg: "World",
        categories: ["general", "one"],
        description: nil,
        name: "Hello",
        placeholder: nil
      }
  """
  @spec command!(
          keylist :: [
            name: String.t(),
            arg: String.t(),
            placeholder: String.t(),
            description: String.t(),
            categories: String.t() | [String.t()]
          ]
        ) :: %__MODULE__{}
  def command!(keylist) do
    %__MODULE__{
      name: Keyword.get(keylist, :name),
      arg: Keyword.get(keylist, :arg),
      placeholder: Keyword.get(keylist, :placeholder),
      description: Keyword.get(keylist, :description),
      categories: Keyword.get(keylist, :categories) |> category_list!()
    }
  end

  #  Always get the needed category list:
  #  * Pass if list.
  #  * Turn to list if single element.
  #  * Return ["misc"] if nil.
  #
  #  If the categories are NOT defined, then set it `misc` by default.
  #
  #  ## Examples
  #      iex> category_list!(["one", "two"])
  #
  @spec category_list!(argument :: [String.t()] | String.t() | nil) :: [String.t()]
  defp category_list!(argument) when is_list(argument) do
    argument
  end

  defp category_list!(nil), do: ["misc"]

  defp category_list!(argument), do: [argument]

  @doc """
  Append `-category` on every category element and join them with an empty space.

  This is used for HTML classes and JS to toggle them on and off.

  ## Examples

      iex> category_elements(%Command{categories: ["one", "two"]})
      "one-category two-category"
  """
  @spec category_classes(command :: %__MODULE__{}) :: String.t()
  def category_classes(command) do
    command.categories
    |> Enum.map(fn category -> "#{category}-category" end)
    |> Enum.join(" ")
  end
end
