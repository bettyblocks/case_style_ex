defmodule CaseStyleTest do
  use ExUnit.Case, async: true
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
      assert {:ok, "test_testing"} == CaseStyle.camel_to_snake("testTesting")
    end

    test "snake to camel" do
      assert {:ok, "testTesting"} == CaseStyle.snake_to_camel("test_testing")
    end

    test "camel to kebab" do
      assert {:ok, "test-testing"} == CaseStyle.camel_to_kebab("testTesting")
    end

    test "snake to kebab" do
      assert {:ok, "test-testing"} == CaseStyle.snake_to_kebab("test_testing")
    end

    test "kebab to snake" do
      assert {:ok, "test_testing"} == CaseStyle.kebab_to_snake("test-testing")
    end

    test "kebab to camel" do
      assert {:ok, "testTesting"} == CaseStyle.kebab_to_camel("test-testing")
    end
  end

  describe "snake to camel to snake, edge cases" do
    Enum.map(
      [
        {"testingTesting", "testing_testing"},
        {"testTTest", "test_t_test"},
        {"avgTBps", "avg_t_bps"},
        {"_type", "_type"},
        {"_123testing", "_123testing"},
        {"_123Testing", "_123_testing"},
        {"testing__Testing__Testing", "testing___testing___testing"},
        {"1234", "1234"},
        {"_tESTING", "_t_e_s_t_i_n_g"}
      ],
      fn {camel, snake} ->
        test "convert #{snake} to #{camel} back to #{snake}" do
          {:ok, converted} = CaseStyle.snake_to_camel(unquote(snake))
          assert converted == unquote(camel)
          {:ok, converted} = CaseStyle.camel_to_snake(converted)
          assert converted == unquote(snake)
          {:ok, converted} = CaseStyle.snake_to_camel(unquote(snake))
          assert converted == unquote(camel)
        end
      end
    )
  end
end
