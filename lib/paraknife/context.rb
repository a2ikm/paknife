module Paraknife
  class Context
    attr_reader :backend, :subcommand, :node, :options

    def initialize(backend, subcommand, node, options)
      @backend = backend
      @subcommand = subcommand
      @node = node
      @options = options
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
