#!/usr/bin/env ruby

start = Time.now

def fib(n)
  case n
  when (2..100) then fib(n-1) + fib(n-2)
  when 0,1 then n
  else
    raise "bad n: #{n}"
  end
end

n = ARGV.first or raise("provide n")
puts "fib(#{n}) #{fib(n.to_i)}"
secs = Time.now - start

mins = secs.to_i / 60
secs = secs % 60
print "self\t#{mins}m#{"%.3f" % secs}s"
