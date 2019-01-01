defmodule StreamPerm do
  def perm(xs) do
    Stream.resource(
      fn -> {:start, Enum.sort(xs)} end,
      fn
        {:start, xs} -> {[xs], xs}
        xs ->
          case next_perm(xs) do
            {true, v} -> {[v], v}
            {false, _} -> {:halt, []}
          end
      end,
      fn state -> state end
    )
  end

  ##### PRIVATE #####

  defp next_perm(xs) do
    j = Enum.count(xs) - 1
    i = find_max_index(xs, j)

    if i == false do
      {false, []}
    else
      j = swap_index(xs, i, j)

      p =
        xs
        |> swap(i - 1, j)
        |> reverse(i)

      {true, p}
    end
  end

  defp find_max_index(xs, i) do
    if Enum.at(xs, i - 1) >= Enum.at(xs, i) do
      if i - 1 == 0 do
        false
      else
        find_max_index(xs, i - 1)
      end
    else
      i
    end
  end

  defp swap_index(xs, i, j) do
    if j > i && Enum.at(xs, j) <= Enum.at(xs, i - 1) do
      swap_index(xs, i, j - 1)
    else
      j
    end
  end

  defp swap(xs, i, j) do
    a = Enum.at(xs, i)

    xs
    |> List.update_at(i, fn _c ->
      Enum.at(xs, j)
    end)
    |> List.update_at(j, fn _c ->
      a
    end)
  end

  defp reverse([], _i), do: []

  defp reverse(xs, i) do
    last = xs |> Enum.drop(i) |> Enum.reverse()
    begin = xs |> Enum.take(i)
    Enum.concat(begin, last)
  end
end
