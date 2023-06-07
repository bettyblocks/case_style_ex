defmodule CaseStyle.KebabCaseTest do
  use ExUnit.Case, async: true

  test "-ok-teSting-12" do
    input = "-ok-teSting-12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.KebabCase)
    refute CaseStyle.KebabCase.matches?(input)
    assert "-ok-testing-12" = output = CaseStyle.KebabCase.to_string(casing)
    assert CaseStyle.KebabCase.matches?(output)
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
        assert CaseStyle.KebabCase.matches?(output)
      end
    end
  )

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.KebabCase)
  end

  describe "matches?" do
    test "camelcase" do
      refute CaseStyle.KebabCase.matches?("testProperty")
    end

    test "snakecase" do
      refute CaseStyle.KebabCase.matches?("test_property")
    end

    test "kebabcase" do
      assert CaseStyle.KebabCase.matches?("test-property")
    end

    test "pascalcase" do
      refute CaseStyle.KebabCase.matches?("TestProperty")
    end

    test "starting with number" do
      assert CaseStyle.KebabCase.matches?("1-testing")
    end
  end
end
