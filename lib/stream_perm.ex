defmodule StreamPerm do
  @doc ~S"""
  Create a stream permutation.

  ##  Examples

    iex> StreamPerm.perm([1, 2]) |> Enum.to_list()
    [[1, 2], [2, 1]]
    iex> StreamPerm.perm(["A", "B", "C"]) |> Enum.to_list()
    [
      ["A", "B", "C"],
      ["A", "C", "B"],
      ["B", "A", "C"],
      ["B", "C", "A"],
      ["C", "A", "B"],
      ["C", "B", "A"]
    ]
  """
  def perm(xs) do
    Stream.resource(
      fn -> {:start, Enum.sort(xs)} end,
      fn
        {:start, xs} ->
          {[xs], xs}

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
    last_idx = Enum.count(xs) - 1
    i = find_max_index(xs, last_idx)

    if i == false do
      {false, []}
    else
      j = get_swap_index(xs, i, last_idx)

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

  defp get_swap_index(xs, i, j) do
    if j > i && Enum.at(xs, j) <= Enum.at(xs, i - 1) do
      get_swap_index(xs, i, j - 1)
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
