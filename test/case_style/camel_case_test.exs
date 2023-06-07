defmodule CaseStyle.CamelCaseTest do
  use ExUnit.Case, async: true

  test "okteSting12" do
    input = "_ok_teSting_12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.SnakeCase)
    refute CaseStyle.CamelCase.matches?(input)
    assert "_okTesting_12" = output = CaseStyle.CamelCase.to_string(casing)
    refute CaseStyle.CamelCase.matches?(output)
    assert CaseStyle.CamelCase.matches?("okTesting12")
  end

  Enum.each(
    [
      "",
      "t",
      "testing123",
      "testing",
      "testingTesting",
      "12341234",
      "test213123",
      "1234Testing",
      "testTest",
      "testTest123"
    ],
    fn input ->
      @input input
      test "#{@input}" do
        {:ok, casing} = CaseStyle.from_string(@input, CaseStyle.CamelCase)
        assert @input = output = CaseStyle.CamelCase.to_string(casing)
        assert CaseStyle.CamelCase.matches?(output)
      end
    end
  )

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.CamelCase)
  end

  describe "matches?" do
    test "camelcase" do
      assert CaseStyle.CamelCase.matches?("testProperty")
    end

    test "snakecase" do
      refute CaseStyle.CamelCase.matches?("test_property")
    end

    test "kebabcase" do
      refute CaseStyle.CamelCase.matches?("test-property")
    end

    test "pascalcase" do
      refute CaseStyle.CamelCase.matches?("TestProperty")
    end

    test "starting with number" do
      assert CaseStyle.CamelCase.matches?("1Testing")
    end
  end
end
