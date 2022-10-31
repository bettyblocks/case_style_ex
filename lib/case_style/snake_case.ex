defmodule CaseStyle.SnakeCase do
  @moduledoc """
  Module for converting from and to snake_case
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

  @type t :: %__MODULE__{tokens: Tokens.t()}

  @lowerchar Enum.to_list(?a..?z)
  @upperchar Enum.to_list(?A..?Z)
  @digit Enum.to_list(?0..?9)
  @spacing_char ?_
  @literal Enum.to_list(?!..?/) ++ Enum.to_list(?:..?@) ++ Enum.to_list(?[..?`) ++ [@spacing_char]
  @first_char @lowerchar ++ @upperchar
  @char []

  @spacing_binary to_string([@spacing_char])
  @upper_binary Enum.map(@upperchar, &to_string([&1]))
  @lower_binary Enum.map(@lowerchar, &to_string([&1]))
  @digit_binary Enum.map(@digit, &to_string([&1]))

  defguard is_lowercase_spacing(txt)
           when binary_part(txt, 0, 1) == @spacing_binary and
                  binary_part(txt, 1, 1) in @lower_binary

  defguard is_uppercase_spacing(txt)
           when binary_part(txt, 0, 1) == @spacing_binary and
                  binary_part(txt, 1, 1) in @upper_binary

  defguard is_digit_spacing(txt)
           when binary_part(txt, 0, 1) == @spacing_binary and
                  binary_part(txt, 1, 1) in @digit_binary

  def parse(text) do
    case do_parse(text, []) do
      {:ok, tokens, "", a, b, c} -> {:ok, [%Start{} | tokens] ++ [%End{}], "", a, b, c}
      err -> err
    end
  end

  defp do_parse(<<s, rest::bytes>> = text, []) when s in @literal do
    do_parse(rest, [%Literal{value: [s]}])
  end

  defp do_parse(<<s, rest::bytes>> = text, []) when s in @lowerchar or s in @upperchar do
    do_parse(rest, [%FirstLetter{value: [s]}])
  end

  defp do_parse(<<s, rest::bytes>> = text, [%Literal{}] = tokens)
       when s in @lowerchar or s in @upperchar do
    do_parse(rest, [%FirstLetter{value: [s]} | tokens])
  end

  defp do_parse("", tokens) do
    {:ok, :lists.reverse(tokens), "", :ok, :ok, :ok}
  end

  defp do_parse(<<_, s, rest::bytes>> = text, tokens)
       when is_lowercase_spacing(text) or is_uppercase_spacing(text) do
    do_parse(rest, [%AfterSpacingChar{value: [s]} | [%Spacing{} | tokens]])
  end

  defp do_parse(<<_, s, rest::bytes>> = text, tokens) when is_digit_spacing(text) do
    do_parse(rest, [%AfterSpacingDigit{value: [s]} | [%Spacing{} | tokens]])
  end

  defp do_parse(<<s, rest::bytes>> = text, tokens) when s in @lowerchar or s in @upperchar do
    do_parse(rest, [%Char{value: [s]} | tokens])
  end

  defp do_parse(<<s, rest::bytes>> = text, tokens) when s in @digit do
    do_parse(rest, [%Digit{value: [s]} | tokens])
  end

  defp do_parse(<<s, rest::bytes>> = text, tokens) when s in @literal do
    do_parse(rest, [%Literal{value: [s]} | tokens])
  end

  defp do_parse(_, tokens) do
    {:error, nil, nil, nil, nil, nil}
  end

  @impl true
  def to_string(%CaseStyle{tokens: tokens}) do
    Enum.map_join(tokens, &stringify_token/1)
  end

  @spec stringify_token(Tokens.possible_tokens()) :: charlist
  defp stringify_token(%module{}) when module in [Start, End], do: ''
  defp stringify_token(%Spacing{}), do: '_'

  defp stringify_token(%module{value: [x]})
       when module in [FirstLetter, Char, AfterSpacingChar] and x in ?A..?Z,
       do: [x + 32]

  defp stringify_token(%module{value: x}) when module in [FirstLetter, Char, AfterSpacingChar],
    do: x

  defp stringify_token(%module{value: x}) when module in [Digit, AfterSpacingDigit], do: x
  defp stringify_token(%Literal{value: x}), do: x

  @lowercase_digits_and_underscore Enum.concat([?a..?z, ?0..?9, '_'])
  @impl true
  def might_be?(input) do
    input
    |> String.to_charlist()
    |> Enum.all?(fn x -> x in @lowercase_digits_and_underscore end)
  end
end
