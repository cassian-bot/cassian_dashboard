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
      categories: Keyword.get(keylist, :categories) |> as_list()
    }
  end

  def category_classes(command) do
    command.categories
    |> Enum.map(fn category -> "#{category}-category" end)
    |> Enum.join(" ")
  end

  defp as_list(argument) when is_list(argument) do
    argument
  end

  defp as_list(argument), do: [argument]
end
