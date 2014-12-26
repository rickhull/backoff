defmodule Backoff do
  # write a function f that returns true or false
  # pass a function g like &exp(&1, 5) or &poly/1
  def until(f, g, n \\ 0) when is_function(f) and is_function(g) do
    val = f.()
    if val do
      val
    else
      (g.(n) * 100) |> round |> :timer.sleep
      until(f, g, n + 1)
    end
  end

  def exp(n, base \\ 2), do: :math.pow(base, n)  # 2^n
  def poly(n, exp \\ 2), do: :math.pow(n, exp)   # n^2
  def lin(n), do: n

  def fib(n) when is_integer(n) and n >= 0, do: fib(n, 0, 1)
  def fib(0, a, _), do: a
  def fib(n, a, b), do: fib(n - 1, b, a + b)
end
