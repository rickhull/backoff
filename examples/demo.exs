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
                    end
                  end,
                  &Backoff.exp/1)

  end
end
