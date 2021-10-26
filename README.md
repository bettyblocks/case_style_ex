# CaseStyle

Convert from and to different CaseStyles.

This library is different than the others, because you need to explicitly say from and to which case you want to convert.
This is nice because you can keep some context and this makes it possible to convert between cases without losing data (check the tests for the edge cases).

## Usage

### Manual method

```elixir
input = "testing_testing"
# we convert from SnakeCase
{:ok, casing} = CaseStyle.from_string(input, CaseStyle.SnakeCase)
# casing is a struct with a list of tokens
converted = CaseStyle.to_string(casing, CaseStyle.CamelCase)
# converted is "testingTesting"
```

In the above example the modules can be dynamically passed. If you know what you want upfront you can use the convenience functions:

### Convenient method

```elixir
{:ok, "testingTesting"} = CaseStyle.snake_to_camel("testing_testing")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `case_style` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:case_style, "~> 0.2.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/case_style](https://hexdocs.pm/case_style).
