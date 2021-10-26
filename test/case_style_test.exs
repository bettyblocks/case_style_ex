defmodule CaseStyleTest do
  use ExUnit.Case
  doctest CaseStyle

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

  describe "from string" do
    test "SnakeCase" do
      assert {:ok,
              %CaseStyle{
                from_type: CaseStyle.SnakeCase,
                tokens: [
                  %Start{},
                  %Literal{value: "__"},
                  %FirstLetter{value: 't'},
                  %Char{value: 'e'},
                  %Char{value: 's'},
                  %Char{value: 't'},
                  %Spacing{},
                  %AfterSpacingChar{value: 't'},
                  %Char{value: 'e'},
                  %Char{value: 's'},
                  %Char{value: 't'},
                  %Spacing{},
                  %AfterSpacingDigit{value: '9'},
                  %Digit{value: '1'},
                  %Spacing{},
                  %AfterSpacingChar{value: 'C'},
                  %Char{value: 'A'},
                  %Char{value: 'P'},
                  %Char{value: 'I'},
                  %Char{value: 'T'},
                  %Char{value: 'A'},
                  %Char{value: 'L'},
                  %Digit{value: '1'},
                  %Digit{value: '2'},
                  %Digit{value: '3'},
                  %End{}
                ]
              }} == CaseStyle.from_string("__test_test_91_CAPITAL123", CaseStyle.SnakeCase)
    end

    test "CamelCase" do
      assert {:ok,
              %CaseStyle{
                from_type: CaseStyle.CamelCase,
                tokens: [
                  %Start{},
                  %FirstLetter{value: 't'},
                  %Char{value: 'e'},
                  %Char{value: 's'},
                  %Char{value: 't'},
                  %Spacing{},
                  %AfterSpacingChar{value: 'T'},
                  %Char{value: 'e'},
                  %Char{value: 's'},
                  %Char{value: 't'},
                  %Digit{value: '9'},
                  %Digit{value: '1'},
                  %Literal{value: '_'},
                  %Char{value: 'o'},
                  %Char{value: 'k'},
                  %Literal{value: ':'},
                  %Literal{value: ')'},
                  %End{}
                ]
              }} == CaseStyle.from_string("testTest91_ok:)", CaseStyle.CamelCase)
    end

    test "KebabCase" do
      assert {:ok,
              %CaseStyle{
                from_type: CaseStyle.KebabCase,
                tokens: [
                  %Start{},
                  %FirstLetter{value: 't'},
                  %Char{value: 'e'},
                  %Char{value: 's'},
                  %Char{value: 't'},
                  %Char{value: 'T'},
                  %Char{value: 'e'},
                  %Char{value: 's'},
                  %Char{value: 't'},
                  %Digit{value: '9'},
                  %Digit{value: '1'},
                  %Spacing{},
                  %AfterSpacingChar{value: 'o'},
                  %Char{value: 'k'},
                  %Literal{value: ':'},
                  %Literal{value: ')'},
                  %End{}
                ]
              }} == CaseStyle.from_string("testTest91-ok:)", CaseStyle.KebabCase)
    end
  end

  describe "convert" do
    test "camel to snake" do
      {:ok, casing} = CaseStyle.from_string("testTesting", CaseStyle.CamelCase)

      assert "test_testing" == CaseStyle.SnakeCase.to_string(casing)
    end

    test "snake to camel" do
      {:ok, casing} = CaseStyle.from_string("test_testing", CaseStyle.SnakeCase)

      assert "testTesting" == CaseStyle.CamelCase.to_string(casing)
    end
  end
end
