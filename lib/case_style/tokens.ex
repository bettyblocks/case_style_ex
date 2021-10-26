defmodule CaseStyle.Tokens do
  @moduledoc """
  `CaseStyle.Tokens.Spacing`
  how words are split

  `CaseStyle.Tokens.FirstLetter`
  first char in the stream

  `CaseStyle.Tokens.Char`
  just a char

  `CaseStyle.Tokens.AfterSpacingChar`
  first char after split

  `CaseStyle.Tokens.Digit`
  just a digit

  `CaseStyle.Tokens.AfterSpacingDigit`
  first digit after split

  `CaseStyle.Tokens.Literal`
  text that should not be treated

  `CaseStyle.Tokens.Start`
  start of the stream

  `CaseStyle.Tokens.End`
  end of the stream
  """
end

defmodule CaseStyle.Tokens.Spacing do
  defstruct []
  @moduledoc "how words are split"
end

defmodule CaseStyle.Tokens.FirstLetter do
  defstruct [:value]
  @moduledoc "first char in the stream"
end

defmodule CaseStyle.Tokens.Char do
  defstruct [:value]
  @moduledoc "just a char"
end

defmodule CaseStyle.Tokens.AfterSpacingChar do
  defstruct [:value]
  @moduledoc "first char after split"
end

defmodule CaseStyle.Tokens.Digit do
  defstruct [:value]
  @moduledoc "just a digit"
end

defmodule CaseStyle.Tokens.AfterSpacingDigit do
  defstruct [:value]
  @moduledoc "first digit after split"
end

defmodule CaseStyle.Tokens.Literal do
  defstruct [:value]
  @moduledoc "text that should not be treated"
end

defmodule CaseStyle.Tokens.End do
  defstruct []
  @moduledoc "end of the stream"
end

defmodule CaseStyle.Tokens.Start do
  defstruct []
  @moduledoc "start of the stream"
end
