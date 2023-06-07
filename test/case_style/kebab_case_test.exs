defmodule CaseStyle.KebabCaseTest do
  use ExUnit.Case, async: true

  test "-ok-teSting-12" do
    input = "-ok-teSting-12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.KebabCase)
    refute CaseStyle.KebabCase.might_be?(input)
    assert "-ok-testing-12" = output = CaseStyle.KebabCase.to_string(casing)
    assert CaseStyle.KebabCase.might_be?(output)
  end

  Enum.each(
    [
      "",
      "t",
      "testing123",
      "testing",
      "--testing--",
      "12341234",
      "test213-123",
      "1234-testing--"
    ],
    fn input ->
      @input input
      test "#{@input}" do
        {:ok, casing} = CaseStyle.from_string(@input, CaseStyle.KebabCase)
        assert @input = output = CaseStyle.KebabCase.to_string(casing)
        assert CaseStyle.KebabCase.might_be?(output)
      end
    end
  )

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.KebabCase)
  end

  describe "might_be?" do
    test "camelcase" do
      refute CaseStyle.KebabCase.might_be?("testProperty")
    end

    test "snakecase" do
      refute CaseStyle.KebabCase.might_be?("test_property")
    end

    test "kebabcase" do
      assert CaseStyle.KebabCase.might_be?("test-property")
    end

    test "pascalcase" do
      refute CaseStyle.KebabCase.might_be?("TestProperty")
    end

    test "starting with number" do
      assert CaseStyle.KebabCase.might_be?("1-testing")
    end
  end
end
