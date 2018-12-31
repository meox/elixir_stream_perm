defmodule Thunk do
  defmacro delay(expr) do
    quote do
      fn -> unquote(expr) end
    end
  end

  def force(thunk) when is_function(thunk) do
    thunk.()
  end

  def force(v), do: v
end
