defmodule CaseStyle.SnakeCaseTest do
  use ExUnit.Case, async: true

  test "_ok_teSting_12" do
    input = "_ok_teSting_12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.SnakeCase)
    refute CaseStyle.SnakeCase.might_be?(input)
    assert "_ok_testing_12" = output = CaseStyle.SnakeCase.to_string(casing)
    assert CaseStyle.SnakeCase.might_be?(output)
  end

  Enum.each(
    [
      "",
      "t",
      "testing123",
      "testing",
      "__testing__",
      "12341234",
      "test213_123",
      "1234_testing__"
    ],
    fn input ->
      @input input
      test "#{@input}" do
        {:ok, casing} = CaseStyle.from_string(@input, CaseStyle.SnakeCase)
        assert @input = output = CaseStyle.SnakeCase.to_string(casing)
        assert CaseStyle.SnakeCase.might_be?(output)
      end
    end
  )

  test "__testing__!" do
    {:ok,
     %CaseStyle{
       from_type: CaseStyle.SnakeCase,
       tokens: [
         %CaseStyle.Tokens.Start{},
         %CaseStyle.Tokens.Literal{value: '_'},
         %CaseStyle.Tokens.Spacing{},
         %CaseStyle.Tokens.AfterSpacingChar{value: 't'},
         %CaseStyle.Tokens.Char{value: 'e'},
         %CaseStyle.Tokens.Char{value: 's'},
         %CaseStyle.Tokens.Char{value: 't'},
         %CaseStyle.Tokens.Char{value: 'i'},
         %CaseStyle.Tokens.Char{value: 'n'},
         %CaseStyle.Tokens.Char{value: 'g'},
         %CaseStyle.Tokens.Literal{value: '_'},
         %CaseStyle.Tokens.Literal{value: '_'},
         %CaseStyle.Tokens.Literal{value: '!'},
         %CaseStyle.Tokens.End{}
       ]
     }} = CaseStyle.from_string("__testing__!", CaseStyle.SnakeCase)
  end

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.SnakeCase)
  end
end
