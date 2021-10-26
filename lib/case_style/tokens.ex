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

  @type t :: [possible_tokens]
  @type possible_tokens ::
          AfterSpacingChar.t()
          | AfterSpacingDigit.t()
          | Char.t()
          | Digit.t()
          | End.t()
          | FirstLetter.t()
          | Literal.t()
          | Spacing.t()
          | Start.t()
end

defmodule CaseStyle.Tokens.Spacing do
  defstruct []
  @moduledoc "how words are split"
  @type t :: %__MODULE__{}
end

defmodule CaseStyle.Tokens.FirstLetter do
  defstruct [:value]
  @moduledoc "first char in the stream"
  @type t :: %__MODULE__{value: charlist}
end

defmodule CaseStyle.Tokens.Char do
  defstruct [:value]
  @moduledoc "just a char"
  @type t :: %__MODULE__{value: charlist}
end

defmodule CaseStyle.Tokens.AfterSpacingChar do
  defstruct [:value]
  @moduledoc "first char after split"
  @type t :: %__MODULE__{value: charlist}
end

defmodule CaseStyle.Tokens.Digit do
  defstruct [:value]
  @moduledoc "just a digit"
  @type t :: %__MODULE__{value: charlist}
end

defmodule CaseStyle.Tokens.AfterSpacingDigit do
  defstruct [:value]
  @moduledoc "first digit after split"
  @type t :: %__MODULE__{value: charlist}
end

defmodule CaseStyle.Tokens.Literal do
  defstruct [:value]
  @moduledoc "text that should not be treated"
  @type t :: %__MODULE__{value: binary}
end

defmodule CaseStyle.Tokens.End do
  defstruct []
  @moduledoc "end of the stream"
  @type t :: %__MODULE__{}
end

defmodule CaseStyle.Tokens.Start do
  defstruct []
  @moduledoc "start of the stream"
  @type t :: %__MODULE__{}
end
