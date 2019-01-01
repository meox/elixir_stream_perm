# Perm

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `perm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:perm, "~> 0.1.0"}
  ]
end
```

## Examples

```elixir
"ABC" |> String.split("", trim: true) |> StreamPerm.perm() |> Enum.to_list()
```
