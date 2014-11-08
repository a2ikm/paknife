require "open3"
require "optparse"
require "parallel"
require "paraknife/context"

module Paraknife
  class Cli
    BACKENDS = %w(solo zero)
    SUBCOMMANDS = %w(bootstrap clean cook prepare)

    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @contexts = parse_argv(argv)
    end

    def run
      Parallel.each(@contexts, in_threads: @contexts.count) do |context|
        node = context.node
        command = context.command
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
    end

    private

      def parse_argv(argv)
        backend = argv.shift # solo or zero
        abort "Invalid backend: `#{backend}`" unless BACKENDS.include?(backend)

        subcommand = argv.shift
        abort "Invalid subcommand: `#{subcommand}`" unless SUBCOMMANDS.include?(subcommand)

        nodes = []
        knife_options = []
        knife_options_section = false

        argv.each do |arg|
          knife_options_section ||= arg.start_with?("-")
          if knife_options_section
            knife_options << arg
          else
            nodes << arg
          end
        end

        nodes.map do |node|
          Context.new(backend, subcommand, node, knife_options)
        end
      end
  end
end
