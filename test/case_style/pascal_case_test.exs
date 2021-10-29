defmodule CaseStyle.PascalCaseTest do
  use ExUnit.Case, async: true

  test "_Ok_teSting_12" do
    input = "_Ok_teSting_12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.SnakeCase)
    refute CaseStyle.PascalCase.might_be?(input)
    assert "_OkTesting_12" = output = CaseStyle.PascalCase.to_string(casing)
    refute CaseStyle.PascalCase.might_be?(output)
    assert CaseStyle.PascalCase.might_be?("OkTesting12")
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
        assert CaseStyle.PascalCase.might_be?(output)
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
end
