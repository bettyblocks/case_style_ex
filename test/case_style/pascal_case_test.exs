defmodule CaseStyle.PascalCaseTest do
  use ExUnit.Case, async: true

  test "_Ok_teSting_12" do
    input = "_Ok_teSting_12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.SnakeCase)
    refute CaseStyle.PascalCase.matches?(input)
    assert "_OkTesting_12" = output = CaseStyle.PascalCase.to_string(casing)
    refute CaseStyle.PascalCase.matches?(output)
    assert CaseStyle.PascalCase.matches?("OkTesting12")
  end

  Enum.each(
    [
      "",
      "T",
      "Testing123",
      "Testing",
      "TestingTesting",
      "12341234",
      "Test213123",
      "1234Testing",
      "TestTest",
      "TestTest123"
    ],
    fn input ->
      @input input
      test "#{@input}" do
        {:ok, casing} = CaseStyle.from_string(@input, CaseStyle.PascalCase)
        assert @input = output = CaseStyle.PascalCase.to_string(casing)
        assert CaseStyle.PascalCase.matches?(output)
      end
    end
  )

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.PascalCase)
  end

  test "fails on lowercase char" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("t", CaseStyle.PascalCase)
  end

  test "fails on lowercase char at the start" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("testing", CaseStyle.PascalCase)
  end

  describe "matches?" do
    test "camelcase" do
      refute CaseStyle.PascalCase.matches?("testProperty")
    end

    test "snakecase" do
      refute CaseStyle.PascalCase.matches?("test_property")
    end

    test "kebabcase" do
      refute CaseStyle.PascalCase.matches?("test-property")
    end

    test "pascalcase" do
      assert CaseStyle.PascalCase.matches?("TestProperty")
    end

    test "starting with number" do
      assert CaseStyle.PascalCase.matches?("1Testing")
    end
  end
end
