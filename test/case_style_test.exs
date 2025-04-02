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
                  %Literal{value: ~c"_"},
                  %Spacing{},
                  %AfterSpacingChar{value: ~c"t"},
                  %Char{value: ~c"e"},
                  %Char{value: ~c"s"},
                  %Char{value: ~c"t"},
                  %Spacing{},
                  %AfterSpacingChar{value: ~c"t"},
                  %Char{value: ~c"e"},
                  %Char{value: ~c"s"},
                  %Char{value: ~c"t"},
                  %Spacing{},
                  %AfterSpacingDigit{value: ~c"9"},
                  %Digit{value: ~c"1"},
                  %Spacing{},
                  %AfterSpacingChar{value: ~c"C"},
                  %Char{value: ~c"A"},
                  %Char{value: ~c"P"},
                  %Char{value: ~c"I"},
                  %Char{value: ~c"T"},
                  %Char{value: ~c"A"},
                  %Char{value: ~c"L"},
                  %Digit{value: ~c"1"},
                  %Digit{value: ~c"2"},
                  %Digit{value: ~c"3"},
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
                  %FirstLetter{value: ~c"t"},
                  %Char{value: ~c"e"},
                  %Char{value: ~c"s"},
                  %Char{value: ~c"t"},
                  %Spacing{},
                  %AfterSpacingChar{value: ~c"T"},
                  %Char{value: ~c"e"},
                  %Char{value: ~c"s"},
                  %Char{value: ~c"t"},
                  %Digit{value: ~c"9"},
                  %Digit{value: ~c"1"},
                  %Literal{value: ~c"_"},
                  %Char{value: ~c"o"},
                  %Char{value: ~c"k"},
                  %Literal{value: ~c":"},
                  %Literal{value: ~c")"},
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
                  %FirstLetter{value: ~c"t"},
                  %Char{value: ~c"e"},
                  %Char{value: ~c"s"},
                  %Char{value: ~c"t"},
                  %Char{value: ~c"T"},
                  %Char{value: ~c"e"},
                  %Char{value: ~c"s"},
                  %Char{value: ~c"t"},
                  %Digit{value: ~c"9"},
                  %Digit{value: ~c"1"},
                  %Spacing{},
                  %AfterSpacingChar{value: ~c"o"},
                  %Char{value: ~c"k"},
                  %Literal{value: ~c":"},
                  %Literal{value: ~c")"},
                  %End{}
                ]
              }} == CaseStyle.from_string("testTest91-ok:)", CaseStyle.KebabCase)
    end
  end

  describe "convert" do
    test "snake to camel" do
      assert {:ok, "testTesting"} == CaseStyle.snake_to_camel("test_testing")
    end

    test "snake to kebab" do
      assert {:ok, "test-testing"} == CaseStyle.snake_to_kebab("test_testing")
    end

    test "snake to pascal" do
      assert {:ok, "TestTesting"} == CaseStyle.snake_to_pascal("test_testing")
    end

    test "camel to snake" do
      assert {:ok, "test_testing"} == CaseStyle.camel_to_snake("testTesting")
    end

    test "camel to kebab" do
      assert {:ok, "test-testing"} == CaseStyle.camel_to_kebab("testTesting")
    end

    test "camel to pascal" do
      assert {:ok, "TestTesting"} == CaseStyle.camel_to_pascal("testTesting")
    end

    test "kebab to snake" do
      assert {:ok, "test_testing"} == CaseStyle.kebab_to_snake("test-testing")
    end

    test "kebab to camel" do
      assert {:ok, "testTesting"} == CaseStyle.kebab_to_camel("test-testing")
    end

    test "kebab to pascal" do
      assert {:ok, "TestTesting"} == CaseStyle.kebab_to_pascal("test-testing")
    end
  end

  describe "convert!" do
    test "camel to snake" do
      assert "test_testing" == CaseStyle.camel_to_snake!("testTesting")
    end

    test "camel to kebab" do
      assert "test-testing" == CaseStyle.camel_to_kebab!("testTesting")
    end

    test "camel to pascal" do
      assert "TestTesting" == CaseStyle.camel_to_pascal!("testTesting")
    end

    test "snake to camel" do
      assert "testTesting" == CaseStyle.snake_to_camel!("test_testing")
    end

    test "snake to graphql" do
      assert "testTesting" == CaseStyle.snake_to_graphql!("test_testing")
      assert "_123Testing" == CaseStyle.snake_to_graphql!("123_testing")
    end

    test "snake to kebab" do
      assert "test-testing" == CaseStyle.snake_to_kebab!("test_testing")
    end

    test "snake to pascal" do
      assert "TestTesting" == CaseStyle.snake_to_pascal!("test_testing")
    end

    test "kebab to snake" do
      assert "test_testing" == CaseStyle.kebab_to_snake!("test-testing")
    end

    test "kebab to camel" do
      assert "testTesting" == CaseStyle.kebab_to_camel!("test-testing")
    end

    test "kebab to pascal" do
      assert "TestTesting" == CaseStyle.kebab_to_pascal!("test-testing")
    end

    test "graphql to snake" do
      assert "test_testing" == CaseStyle.graphql_to_snake!("testTesting")
      assert "123_testing" == CaseStyle.graphql_to_snake!("_123Testing")
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
        {"_Testing", "__testing"},
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

  test "snake to camel with double underscore" do
    assert "double_Underscore" == CaseStyle.snake_to_camel!("double__underscore")
  end

  test "snake to camel with starting underscore" do
    assert "_something" == CaseStyle.snake_to_camel!("_something")
  end

  test "snake to camel with starting double underscore" do
    assert "_Dunder" == CaseStyle.snake_to_camel!("__dunder")
  end

  test "might_be? still works" do
    # these tests will output deprecation warnings.
    # But we still want to test that they actually work

    refute CaseStyle.CamelCase.might_be?("test_property")
    assert CaseStyle.GraphQLCase.might_be?("test_property")
    assert CaseStyle.SnakeCase.might_be?("test_property")
    refute CaseStyle.PascalCase.might_be?("test_property")
    refute CaseStyle.KebabCase.might_be?("test_property")
  end
end
