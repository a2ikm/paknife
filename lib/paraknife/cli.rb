require "optparse"
require "parallel"

module Paraknife
  class Cli
    BACKENDS = %w(solo zero)
    SUBCOMMANDS = %w(bootstrap clean cook prepare)

    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @backend, @subcommand, @nodes, @knife_options = parse_argv(argv)
    end

    def run
      puts "backend: #{@backend}"
      puts "subcommand: #{@subcommand}"
      puts "nodes:"
      @nodes.each do |node|
        puts "\t#{node}"
      end
      puts "knife options: #{@knife_options.join(" ")}"

      Parallel.each(@nodes, in_threads: @nodes.count) do |node|
        command = ["knife", @backend, @subcommand, node, @knife_options, "2>&1"].flatten.compact.join(" ")
        puts "[#{node}] #{command}"
        IO.popen(command) do |io|
          io.each do |line|
            puts "[#{node}] #{line}"
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

        [backend, subcommand, nodes, knife_options]
      end
  end
end
