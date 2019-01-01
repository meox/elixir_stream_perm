defmodule Thunk do
  @type thunk :: (() -> any())
  @type stream :: {any(), thunk} | {}

  defmacro delay(expr) do
    quote do
      fn -> unquote(expr) end
    end
  end

  def force(thunk) when is_function(thunk) do
    thunk.()
  end

  def force(v), do: v

  @spec empty() :: stream
  def empty(), do: {}

  @spec to_stream([any()]) :: stream()
  def to_stream([]), do: empty()

  def to_stream([x | xs]) do
    {x, delay(to_stream(xs))}
  end

  def take(_s, 0), do: []
  def take({}, _n), do: []

  def take({v, thunk}, n) do
    [v | take(force(thunk), n - 1)]
  end
end
