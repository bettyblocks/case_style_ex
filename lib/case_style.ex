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
          {:error, any, any, any, any, any}
  # {:error, list, binary, map, {pos_integer, pos_integer}, pos_integer}

  @type parser_ouput :: {:ok, list, binary, map, {pos_integer, pos_integer}, pos_integer}

  # @callback parse(input :: binary) :: {:ok, CaseStyle.t()} | parser_ouput | nimble_parsec_error
  @callback parse(input :: binary) :: parser_ouput | nimble_parsec_error
  @callback might_be?(input :: binary) :: boolean
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
  @spec from_string(binary, module) :: {:ok, CaseStyle.t()} | parser_ouput | nimble_parsec_error
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

  [
    {:snake_to_camel, CaseStyle.SnakeCase, CaseStyle.CamelCase},
    {:snake_to_kebab, CaseStyle.SnakeCase, CaseStyle.KebabCase},
    {:camel_to_snake, CaseStyle.CamelCase, CaseStyle.SnakeCase},
    {:camel_to_kebab, CaseStyle.CamelCase, CaseStyle.KebabCase},
    {:kebab_to_snake, CaseStyle.KebabCase, CaseStyle.SnakeCase},
    {:kebab_to_camel, CaseStyle.KebabCase, CaseStyle.CamelCase}
  ]
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
  end)
end
