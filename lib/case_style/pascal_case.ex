defmodule CaseStyle.PascalCase do
  @moduledoc """
  Module for converting from and to PascalCase
  """
  defstruct tokens: []

  @behaviour CaseStyle

  alias CaseStyle.Tokens

  alias CaseStyle.Tokens.{
    AfterSpacingChar,
    AfterSpacingDigit,
    Char,
    Digit,
    End,
    FirstLetter,
    Literal,
    Spacing,
    Start
  }

  @type t :: %__MODULE__{tokens: CaseStyle.Tokens.t()}

  use AbnfParsec,
    abnf_file: "priv/case_style/pascal_case.abnf",
    unbox: ["lowerchar", "upperchar", "char", "case", "string", "digit"],
    parse: :case,
    transform: %{
      "case" => {:post_traverse, :post_processing}
    }

  @external_resource "priv/case_style/pascal_case.abnf"

  defp post_processing(_a, b, c, _d, _e) do
    tokens = [%End{}] ++ Enum.flat_map(b, &parse_token/1) ++ [%Start{}]
    {tokens, c}
  end

  defp parse_token({:digitchar, s}), do: [%Digit{value: s}]
  defp parse_token({:lowercase, s}), do: [%Char{value: s}]
  defp parse_token({:uppercase, s}), do: [%AfterSpacingChar{value: s}, %Spacing{}]
  defp parse_token({:first_char, s}), do: [%FirstLetter{value: s}]
  defp parse_token({:literal, s}), do: [%Literal{value: s}]

  @impl true
  def to_string(%CaseStyle{tokens: tokens}) do
    Enum.map_join(tokens, &stringify_token/1)
  end

  @spec stringify_token(Tokens.possible_tokens()) :: charlist | binary
  defp stringify_token(%module{}) when module in [Start, End, Spacing], do: ''

  defp stringify_token(%module{value: [x]})
       when module in [AfterSpacingChar] and x in ?a..?z,
       do: [x - 32]

  defp stringify_token(%module{value: [x]})
       when module in [AfterSpacingChar],
       do: [x]

  defp stringify_token(%module{value: [x]}) when module in [FirstLetter] and x in ?a..?z,
    do: [x - 32]

  defp stringify_token(%module{value: [x]}) when module in [Char] and x in ?A..?Z, do: [x + 32]

  defp stringify_token(%module{value: x}) when module in [FirstLetter, Char],
    do: x

  defp stringify_token(%module{value: x}) when module in [Digit], do: x
  defp stringify_token(%module{value: x}) when module in [AfterSpacingDigit], do: [?_, x]
  defp stringify_token(%Literal{value: x}), do: x

  @deprecated "use matches?/1 instead"
  defdelegate might_be?(input), to: __MODULE__, as: :matches?

  @allowed_chars Enum.concat([?a..?z, ?A..?Z, ?0..?9])
  @impl true
  def matches?(<<first_char, _::binary>>) when first_char in ?a..?z or first_char in ?0..?9 do
    false
  end

  def matches?(input) do
    input
    |> String.to_charlist()
    |> Enum.all?(fn x -> x in @allowed_chars end)
  end
end
