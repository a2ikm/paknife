require "optparse"
require "parallel"
require "paraknife/context"

module Paraknife
  class Cli
    BACKENDS = %w(solo zero)
    SUBCOMMANDS = %w(bootstrap clean cook prepare)

    DEFAULT_KNIFE = "bundle exec knife"

    DEFAULT_OPTIONS = {
      knife: nil,
      quiet: false,
      threads: 2,
    }

    def self.run(argv)
      new(argv).run
    end

    attr_reader :contexts

    def initialize(argv)
      @options, backend, subcommand, nodes, knife_options = parse_argv(argv)
      @contexts = build_contexts(backend, subcommand, nodes, knife_options)
    end

    def run
      Parallel.each(contexts, in_threads: determine_threads) do |context|
        context.run
      end
    end

    private

      def parse_argv(argv)
        [parse_options(argv), *parse_knife_argv(argv)]
      end

      def parse_options(argv)
        opts = {}

        OptionParser.new do |op|
          op.banner = "Usage: #{op.program_name} [<options>] <backend> <subcommand> <nodes> [<knife_options>]"
          op.version = VERSION

          op.on("-k", "--knife VALUE") do |v|
            opts[:knife] = v
          end

          op.on("-q", "--[no-]quiet") do |v|
            opts[:quiet] = v
          end

          op.on("-t", "--threads VALUE") do |v|
            if v == "max"
              opts[:threads] = :max
            elsif v.to_i > 0
              opts[:threads] = v.to_i
            else
              abort "Invalid value for `--thread` option: #{v}"
            end
          end

          op.on_tail("-h", "--help") do
            puts op.help
            exit
          end

          op.on_tail("-v", "--version") do
            puts "#{op.program_name} #{op.version}"
            exit
          end
        end.order!

        DEFAULT_OPTIONS.merge(opts)
      end

      def parse_knife_argv(argv)
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

      def build_contexts(backend, subcommand, nodes, knife_options)
        opts = {
          log_level: determine_log_level,
          knife: determine_knife,
        }

        nodes.map.with_index do |node, index|
          Context.new(index, backend, subcommand, node, knife_options, opts)
        end
      end

      def determine_knife
        @options[:knife] || ENV["PARAKNIFE_KNIFE"] || DEFAULT_KNIFE
      end

      def determine_threads
        if @options[:threads] == :max
          @contexts.count
        else
          [@contexts.count, @options[:threads]].min
        end
      end

      def determine_log_level
        if @options[:quiet]
          :warn
        else
          :info
        end
      end
  end
end
