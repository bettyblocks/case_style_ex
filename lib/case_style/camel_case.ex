defmodule CaseStyle.CamelCase do
  defstruct tokens: []

  @behaviour CaseStyle

  alias CaseStyle.Tokens.{
    Spacing,
    FirstLetter,
    Char,
    AfterSpacingChar,
    Digit,
    Literal,
    End,
    Start
  }

  use AbnfParsec,
    abnf_file: "priv/case_style/camel_case.abnf",
    unbox: ["lowerchar", "upperchar", "char", "case", "string", "digit"],
    parse: :case,
    transform: %{
      "case" => {:post_traverse, :post_processing}
    }

  defp post_processing(_a, b, c, _d, _e) do
    tokens = [%End{}] ++ Enum.flat_map(b, &parse_token/1) ++ [%Start{}]
    {tokens, c}
  end

  defp parse_token({:digitchar, s}), do: [%Digit{value: s}]
  defp parse_token({:lowercase, s}), do: [%Char{value: s}]
  defp parse_token({:uppercase, s}), do: [%AfterSpacingChar{value: s}, %Spacing{}]
  defp parse_token({:first_char, s}), do: [%FirstLetter{value: s}]
  defp parse_token({:literal, s}), do: [%Literal{value: s}]

  def to_string(%CaseStyle{tokens: tokens}) do
    tokens |> Enum.map(&stringify_token/1) |> Enum.join()
  end

  defp stringify_token(%module{}) when module in [Start, End, Spacing], do: ''

  defp stringify_token(%module{value: [x]})
       when module in [AfterSpacingChar] and x in ?a..?z,
       do: [x - 32]

  defp stringify_token(%module{value: [x]})
       when module in [AfterSpacingChar],
       do: [x]

  defp stringify_token(%module{value: [x]})
       when module in [FirstLetter, Char] and x in ?A..?Z,
       do: [x + 32]

  defp stringify_token(%module{value: x}) when module in [FirstLetter, Char],
    do: x

  defp stringify_token(%module{value: x}) when module in [Digit, AfterSpacingDigit], do: x
  defp stringify_token(%Literal{value: x}), do: x

  @allowed_chars Enum.concat([?a..?z, ?A..?Z, ?0..?9])
  def might_be?(input) do
    input |> String.to_charlist() |> Enum.all?(fn x -> x in @allowed_chars end)
  end
end
