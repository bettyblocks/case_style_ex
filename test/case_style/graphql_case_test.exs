defmodule CaseStyle.GraphQLCaseTest do
  use ExUnit.Case, async: true

  test "okteSting12" do
    input = "_ok_teSting_12"
    {:ok, casing} = CaseStyle.from_string(input, CaseStyle.SnakeCase)
    assert "_okTesting_12" = CaseStyle.GraphQLCase.to_string(casing)
    assert CaseStyle.GraphQLCase.matches?("okTesting12")
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
        assert @input = CaseStyle.GraphQLCase.to_string(casing)
      end
    end
  )

  test "fails on emoji" do
    assert {:error, _, _, _, _, _} = CaseStyle.from_string("🦖", CaseStyle.GraphQLCase)
  end

  describe "matches?" do
    test "camelcase" do
      assert CaseStyle.GraphQLCase.matches?("testProperty")
    end

    test "snakecase" do
      refute CaseStyle.GraphQLCase.matches?("test_property")
    end

    test "kebabcase" do
      refute CaseStyle.GraphQLCase.matches?("test-property")
    end

    test "pascalcase" do
      refute CaseStyle.GraphQLCase.matches?("TestProperty")
    end

    test "not starting with number" do
      refute CaseStyle.GraphQLCase.matches?("1_testing")
    end
  end
end
