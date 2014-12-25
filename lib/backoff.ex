defmodule Backoff do
  def until(f, g, n \\ 0) when is_function(f) and is_function(g) do
    val = f.()
    if val do
      val
    else
      g.(n) |> :timer.sleep
      until(f, g, n + 1)
    end
  end
  # 2^n
  def exp(n), do: :math.pow(2, n)
  # n^2
  def poly(n), do: :math.pow(n, 2)

  def fib(n) when is_integer(n) and n >= 2, do: fib(n-2) + fib(n-1)
  def fib(n) when is_integer(n) and n >= 0, do: n

  #def timestamp_ms do
  #  now = :erlang.now
  #  {_, {h, m, s}} = :calendar.now_to_local_time(now)
  #  "#{h}:#{m}:#{s}.#{elem(now, 2)}"
  #end

  def main(args) do
    start = :erlang.now
    {n,_} = args |> hd |> Integer.parse
    IO.puts fib(n)

    secs = elapsed_secs(start, :erlang.now)
    IO.puts "self\t#{div(secs, 60)}m#{rem(secs, 60)}s"
  end

  def elapsed_secs({g1, s1, c1}, {g2, s2, c2}) do
    (g2 - g1) * 1_000_000 +
    (s2 - s1) +
    (c2 - c1) / 1_000_000
  end
end
