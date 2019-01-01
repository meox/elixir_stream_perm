defmodule Perm do
  @moduledoc """
  see: https://mail.haskell.org/pipermail/haskell-cafe/2002-June/003122.html
  """
  def perm(str) when is_binary(str) do
    str
    |> String.split("", trim: true)
    |> perm()
  end

  def perm([]), do: []
  def perm([a]), do: [[a]]

  def perm(xs) do
    for {y, ys} <- selections(xs),
        zs <- perm(ys) do
      [y | zs]
    end
  end

  # SELCTIONS
  #
  # selections []     = []
  # selections (x:xs) = (x, xs) : [ (y, x:ys) | (y, ys) <- selections xs ]

  def selections([]), do: []

  def selections([x | xs]) do
    zs =
      for {y, ys} <- selections(xs) do
        {y, [x | ys]}
      end

    [{x, xs} | zs]
  end
end
