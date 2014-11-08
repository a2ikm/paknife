require "open3"

module Paraknife
  class Context
    attr_reader :backend, :subcommand, :node, :options

    def initialize(backend, subcommand, node, options)
      @backend = backend
      @subcommand = subcommand
      @node = node
      @options = options
    end

    def run
      puts "[#{node}] #{command}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        begin
          loop do
            IO.select([stdout, stderr]).flatten.compact.each do |io|
              io.each do |line|
                next if line.nil? || line.empty?

                if io == stdout
                  puts "[#{node}] #{line}"
                elsif io == stderr
                  puts "[#{node}] Error! #{line}"
                end
              end
            end
            break if stdout.closed? && stderr.closed?
          end
        rescue EOFError
        end
      end
    end

    def command
      [
        "knife",
        backend,
        subcommand,
        node,
        options,
      ].flatten.compact.join(" ")
    end
  end
end
