#compdef paknife

_knife() {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments \
    '(-k --knife)'{-k,--knife=}':knife: '\
    '(-q --quiet)'{-q,--quiet}''\
    '(-t --threads)'{-t,--threads=}':threads: '\
    '(-h --help)'{-h,--help}''\
    '(-v --version)'{-v,--version}''\
    '1: :->backend'\
    '2: :->subcommand'\
    '(-)*:nodes:->nodes'

  case $state in
    backend)
      compadd -Q "$@" solo zero
      ;;
    subcommand)
      compadd -Q "$@" bootstrap clean cook prepare
      ;;
    nodes)
      for node_file in $(ls -1 nodes/* | egrep "\.(rb|json)\$"); do
        compadd "$@" $(basename $node_file | sed 's/.json$//' | sed 's/.rb$//')
      done
      ;;
    *)
  esac
}

_knife "$@"
