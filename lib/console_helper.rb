# :nocov:
module ConsoleHelper
  def reload!
    Dir["#{ROOT}/lib/*.rb"].each { |file| load file }
    true
  end

  def benchmark(&block)
    require "benchmark"

    duration = Benchmark.realtime do
      block.call
    end

    puts "--> #{(duration*1e3).round(3)}ms"

    duration
  end
end
# :nocov:
