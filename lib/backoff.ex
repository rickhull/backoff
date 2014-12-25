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

  def fib(n) when is_integer(n) and n >= 2, do: fib(n-2) + fib(n-1)
  def fib(n) when is_integer(n) and n >= 0, do: n
end

defmodule Example do
  def foo(bar, baz) when is_integer(bar) and is_integer(baz) do
    IO.puts "Attempting a failure-prone remote operation..."; :timer.sleep 500
    if :random.uniform(bar) == baz do
      IO.puts "SUCCESS"
      {:ok, bar * baz}
    else
      IO.puts "FAILED"
      {:error, "System Unavailable"}
    end
  end

  # exponential backoff of foo/2
  def demo do
    Backoff.until(fn ->
                    case Example.foo(5, 2) do
                      {:ok, _val} -> true
                      {:error, _msg} -> false
                      _ -> raise("broken")
                    end
                  end,
                  &Backoff.exp/1)

  end
end

# used for a dumb benchmark thing
defmodule FibTimer do
  def main(args) do
    start = :erlang.now
    {n,_} = args |> hd |> Integer.parse
    IO.puts "fib(#{n}) #{Backoff.fib(n)}"

    secs = start |> elapsed_secs(:erlang.now)
    mins = secs |> trunc |> div(60)
    fracs = secs - trunc(secs)
    secs = ((secs |> trunc |> rem(60)) + fracs)
    |> Float.to_string([decimals: 3])
    IO.write "self\t#{mins}m#{secs}s"
  end

  def elapsed_secs({g1, s1, c1}, {g2, s2, c2}) do
    (g2 - g1) * 1_000_000 +
    (s2 - s1) +
    (c2 - c1) / 1_000_000
  end
end
