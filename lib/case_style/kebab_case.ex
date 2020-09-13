defmodule CaseStyle.KebabCase do
  defstruct tokens: []

  @behaviour CaseStyle

  alias CaseStyle.Tokens.{
    Spacing,
    FirstLetter,
    Char,
    AfterSpacingChar,
    Digit,
    AfterSpacingDigit,
    Literal,
    End,
    Start
  }

  use AbnfParsec,
    abnf: """
    case = [literal] [first-char] string 
    double-dash = "--"
    string = 1*char

    char = 1*(lowercase-spacing / uppercase-spacing / digitchar-spacing / lowercase / uppercase / digitchar / literal)
    first-char = lowerchar / upperchar
    lowercase = lowerchar
    lowercase-spacing = spacing-char lowerchar
    lowerchar = %x61-7A
    uppercase-spacing = spacing-char upperchar
    uppercase = upperchar
    upperchar = %x41-5A
    digitchar-spacing = spacing-char digit
    digitchar = digit
    digit = %x30-39
    literal = double-dash / %x21-2F / %x3A-40 /  %x5B-60 / %x7B-7E / spacing-char
    spacing-char = "-"

    """,
    unbox: [
      "lowerchar",
      "upperchar",
      "char",
      "case",
      "string",
      "digit",
      "spacing-char",
      "double-dash"
    ],
    # ignore: ["char"],
    parse: :case,
    transform: %{
      "case" => {:post_traverse, :post_processing}
    }

  defp post_processing(_a, b, c, _d, _e) do
    tokens = [%End{}] ++ Enum.flat_map(b, &parse_token/1) ++ [%Start{}]
    {tokens, c}
  end

  defp parse_token({:first_char, s}), do: [%FirstLetter{value: s}]
  defp parse_token({:lowercase, s}), do: [%Char{value: s}]
  defp parse_token({:lowercase_spacing, [_, s]}), do: [%AfterSpacingChar{value: [s]}, %Spacing{}]
  defp parse_token({:uppercase, s}), do: [%Char{value: s}]
  defp parse_token({:uppercase_spacing, [_, s]}), do: [%AfterSpacingChar{value: [s]}, %Spacing{}]
  defp parse_token({:digitchar, s}), do: [%Digit{value: s}]
  defp parse_token({:digitchar_spacing, [_, s]}), do: [%AfterSpacingDigit{value: [s]}, %Spacing{}]
  defp parse_token({:string, [s]}), do: [%Literal{value: s}]
  defp parse_token({:literal, ["--"]}), do: [%Literal{value: "--"}]
  defp parse_token({:literal, s}), do: [%Literal{value: s}]
  defp parse_token("-"), do: [%Spacing{}]

  def to_string(%CaseStyle{tokens: tokens}) do
    tokens |> Enum.map(&stringify_token/1) |> Enum.join()
  end

  defp stringify_token(%module{}) when module in [Start, End], do: ''
  defp stringify_token(%Spacing{}), do: '-'

  defp stringify_token(%module{value: [x]})
       when module in [FirstLetter, Char, AfterSpacingChar] and x in ?A..?Z,
       do: [x + 32]

  defp stringify_token(%module{value: x}) when module in [FirstLetter, Char, AfterSpacingChar],
    do: x

  defp stringify_token(%module{value: x}) when module in [Digit, AfterSpacingDigit], do: x
  defp stringify_token(%Literal{value: x}), do: x

  @lowercase_digits_and_dash Enum.concat([?a..?z, ?0..?9, '-'])
  def might_be?(input) do
    input |> String.to_charlist() |> Enum.all?(fn x -> x in @lowercase_digits_and_dash end)
  end
end
