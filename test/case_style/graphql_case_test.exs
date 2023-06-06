defmodule CaseStyle.GraphQLCaseTest do
  use ExUnit.Case, async: true

  test "okteSting12" do
    input = "_ok_teSting_12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.SnakeCase)
    assert CaseStyle.GraphQLCase.might_be?(input)
    assert "_okTesting_12" = output = CaseStyle.GraphQLCase.to_string(casing)
    assert CaseStyle.GraphQLCase.might_be?(output)
    assert CaseStyle.GraphQLCase.might_be?("okTesting12")
  end

  Enum.each(
    [
      "",
      "t",
      "testing123",
      "testing",
      "testingTesting",
      "_12341234",
      "test213123",
      "_1234Testing",
      "testTest",
      "testTest123"
    ],
    fn input ->
      @input input
      test "#{@input}" do
        {:ok, casing} = CaseStyle.from_string(@input, CaseStyle.GraphQLCase)
        assert @input = output = CaseStyle.GraphQLCase.to_string(casing)
        assert CaseStyle.GraphQLCase.might_be?(output)
      end
    end
  )

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.GraphQLCase)
  end
end
