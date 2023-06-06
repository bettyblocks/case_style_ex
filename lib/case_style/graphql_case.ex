defmodule CaseStyle.GraphQLCase do
  @moduledoc """
  Module for converting from and to graphql.
  This is just camelCase only that it doesnt allow that the string starts with a number.
  """
  @behaviour CaseStyle

  alias CaseStyle.CamelCase
  alias CaseStyle.Tokens.Digit
  alias CaseStyle.Tokens.Start

  @impl true
  def parse(<<?_, number::integer, rest::binary>>) when number in ?0..?9 do
    CamelCase.parse(<<number, rest::binary>>)
  end

  def parse(input), do: CamelCase.parse(input)

  @impl true
  def to_string(%CaseStyle{tokens: [%Start{}, %Digit{} | _]} = input) do
    "_#{CamelCase.to_string(input)}"
  end

  def to_string(input), do: CamelCase.to_string(input)

  @allowed_chars Enum.concat([?a..?z, ?A..?Z, ?0..?9, '_'])
  @impl true
  def might_be?(<<first_char, _>>) when first_char in ?A..?Z do
    false
  end

  def might_be?(input) do
    input
    |> String.to_charlist()
    |> Enum.all?(fn x -> x in @allowed_chars end)
  end
end
