defmodule CaseStyle.CamelCaseTest do
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
        assert CaseStyle.CamelCase.might_be?(output)
      end
    end
  )

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.CamelCase)
  end
end
