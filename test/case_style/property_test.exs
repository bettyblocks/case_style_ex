defmodule CaseStyle.PropertyTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  @available_casings [
    snake: CaseStyle.SnakeCase,
    camel: CaseStyle.CamelCase,
    pascal: CaseStyle.PascalCase,
    kebab: CaseStyle.KebabCase,
    graphql: CaseStyle.GraphQLCase
  ]

  function_pairs =
    Enum.flat_map(@available_casings, fn {casing_from, module_from} ->
      Enum.flat_map(@available_casings, fn {casing_to, module_to} ->
        if casing_from == casing_to do
          []
        else
          [
            {:"#{casing_from}_to_#{casing_to}!", :"#{casing_to}_to_#{casing_from}!", module_from,
             module_to}
          ]
        end
      end)
    end)

  def generator(module) do
    bind_filter(
      string(Enum.concat([?a..?z, ?A..?Z, ?0..?9, [?-, ?_]]), min_length: 1),
      fn name ->
        if module.matches?(name) do
          {:cont, constant(name)}
        else
          :skip
        end
      end,
      10_000
    )
  end

  Enum.map(function_pairs, fn {convert_from, convert_back, module_from, module_to} ->
    property "#{convert_from} <-> #{convert_back}" do
      check all(name <- generator(unquote(module_from))) do
        one_way = CaseStyle.unquote(convert_from)(name)

        if unquote(module_to).matches?(one_way) do
          assert name == CaseStyle.unquote(convert_back)(one_way)
        end
      end
    end
  end)
end
