defmodule StreamPerm do
  def perm([]), do: []
  def perm([a]), do: [[a]]

  def selections([]) do
    []
  end

  def selections([x | xs]) do
    Stream.unfold(:start, fn
      :stop ->
        nil

      :start ->
        {{x, xs}, {:delay, fn -> selections(xs) end}}

      s ->
        next_val(s, x)
    end)
  end

  def selections(rs), do: rs |> Enum.to_list() |> selections()

  def next_val({:delay, thunk}, x) do
    thunk.()
    |> next_val(x)
  end

  def next_val(s, x) do
    case s |> Enum.take(1) do
      [{y, []}] ->
        {{y, [x]}, :stop}

      [{y, ys}] ->
        {{y, [x | ys]}, s |> Stream.drop(1)}

      _ ->
        nil
    end
  end
end
