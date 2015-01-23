require "logger"
require "pty"
require "term/ansicolor"

module Paknife
  class Context
    attr_reader :logger, :index, :backend, :subcommand, :node, :knife_options

    def initialize(index, backend, subcommand, node, knife_options, options = {})
      @index = index
      @backend = backend
      @subcommand = subcommand
      @node = node
      @knife_options = knife_options
      @options = options

      setup_logger
    end

    def run
      logger.info command
      PTY.spawn(command) do |r, w, pid|
        w.close_write
        r.sync = true

        begin
          r.each do |line|
            next if line.nil? || line.empty?
            logger.info line
          end
        rescue Errno::EIO
        ensure
          ::Process.wait pid
        end
      end
    end

    def command
      [
        @options[:knife],
        backend,
        subcommand,
        node,
        knife_options,
      ].flatten.compact.join(" ")
    end

    private

      COLOR_CODES = (1..15).to_a

      def setup_logger
        color = COLOR_CODES[index % COLOR_CODES.length]
        colored_node = Term::ANSIColor.color(color, node)

        @logger = Logger.new(STDOUT)
        @logger.formatter = proc { |severity, datetime, progname, msg| "[#{colored_node}] #{msg.chomp}\n" }
        @logger.level =
          if @options[:log_level]
            Logger.const_get(@options[:log_level].upcase)
          else
            Logger::INFO
          end
      end
  end
end
