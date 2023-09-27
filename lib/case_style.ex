defmodule CaseStyle do
  @moduledoc """
  Library from converting to different `CaseSyle`s

  Currently implemented:
  - `CaseStyle.CamelCase`
  - `CaseStyle.SnakeCase`
  - `CaseStyle.KebabCase`
  """
  defstruct tokens: [], from_type: nil

  @type t :: %__MODULE__{tokens: CaseStyle.Tokens.t(), from_type: module}

  @type nimble_parsec_error ::
          {:error, binary, binary, map, {pos_integer, pos_integer}, pos_integer}
  @type parser_output :: {:ok, list, binary, map, {pos_integer, pos_integer}, pos_integer}

  @callback parse(input :: binary) :: parser_output | nimble_parsec_error
  @callback matches?(input :: binary) :: boolean
  @callback to_string(CaseStyle.t()) :: binary

  @doc """
  parse given input with the given module

  ```elixir
  iex> CaseStyle.from_string("snake_case", CaseStyle.SnakeCase)
  {:ok,
     %CaseStyle{
       from_type: CaseStyle.SnakeCase,
       tokens: [
         %CaseStyle.Tokens.Start{},
         %CaseStyle.Tokens.FirstLetter{value: 's'},
         %CaseStyle.Tokens.Char{value: 'n'},
         %CaseStyle.Tokens.Char{value: 'a'},
         %CaseStyle.Tokens.Char{value: 'k'},
         %CaseStyle.Tokens.Char{value: 'e'},
         %CaseStyle.Tokens.Spacing{},
         %CaseStyle.Tokens.AfterSpacingChar{value: 'c'},
         %CaseStyle.Tokens.Char{value: 'a'},
         %CaseStyle.Tokens.Char{value: 's'},
         %CaseStyle.Tokens.Char{value: 'e'},
         %CaseStyle.Tokens.End{}
       ]
     }
  }
  ```
  """
  @spec from_string(binary, module) :: {:ok, CaseStyle.t()} | parser_output | nimble_parsec_error
  def from_string(input, module) do
    case module.parse(input) do
      {:ok, tokens, "", _, _, _} ->
        {:ok, %__MODULE__{from_type: module, tokens: tokens}}

      {:ok, _, left_over, ctx, line, byte_offset} ->
        {:error, "tokens leftover", left_over, ctx, line, byte_offset}

      e ->
        e
    end
  end

  @doc """
  dump given input with the given module

  ```elixir
  iex> input = %CaseStyle{
  ...>  from_type: CaseStyle.SnakeCase,
  ...>  tokens: [
  ...>   %CaseStyle.Tokens.Start{},
  ...>   %CaseStyle.Tokens.FirstLetter{value: 's'},
  ...>   %CaseStyle.Tokens.Char{value: 'n'},
  ...>   %CaseStyle.Tokens.Char{value: 'a'},
  ...>   %CaseStyle.Tokens.Char{value: 'k'},
  ...>   %CaseStyle.Tokens.Char{value: 'e'},
  ...>   %CaseStyle.Tokens.Spacing{},
  ...>   %CaseStyle.Tokens.AfterSpacingChar{value: 'c'},
  ...>   %CaseStyle.Tokens.Char{value: 'a'},
  ...>   %CaseStyle.Tokens.Char{value: 's'},
  ...>   %CaseStyle.Tokens.Char{value: 'e'},
  ...>   %CaseStyle.Tokens.End{}
  ...>  ]
  ...> }
  iex> CaseStyle.to_string(input, CaseStyle.CamelCase)
  "snakeCase"
  ```
  """
  @spec to_string(CaseStyle.t(), module) :: binary
  def to_string(%CaseStyle{} = input, module) do
    module.to_string(input)
  end

  ### convenience functions

  @available_casings [
    snake: CaseStyle.SnakeCase,
    camel: CaseStyle.CamelCase,
    pascal: CaseStyle.PascalCase,
    kebab: CaseStyle.KebabCase,
    graphql: CaseStyle.GraphQLCase
  ]

  Enum.flat_map(@available_casings, fn {casing_from, module_from} ->
    Enum.flat_map(@available_casings, fn {casing_to, module_to} ->
      if casing_from == casing_to do
        []
      else
        [{:"#{casing_from}_to_#{casing_to}", module_from, module_to}]
      end
    end)
  end)
  |> Enum.map(fn {func_name, from, to} ->
    @spec unquote(func_name)(binary) :: {:ok, binary} | nimble_parsec_error
    @doc "Converts from `#{from |> Module.split() |> Enum.join(".")}` to `#{to |> Module.split() |> Enum.join(".")}`"
    def unquote(func_name)(input) do
      case from_string(input, unquote(from)) do
        {:ok, casing} ->
          {:ok, to_string(casing, unquote(to))}

        e ->
          e
      end
    end

    @spec unquote(:"#{func_name}!")(binary) :: binary
    @doc "same as `#{func_name}` but return a string on success and raises on error on failure"
    def unquote(:"#{func_name}!")(input) do
      case from_string(input, unquote(from)) do
        {:ok, casing} ->
          to_string(casing, unquote(to))

        _ ->
          raise "Unable to convert #{input} in #{unquote(func_name)}"
      end
    end
  end)
end
