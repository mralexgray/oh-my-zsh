
setopt extendedglob

# Loads Prezto modules.
function pmodload {

  local -a pmodules
  local pmodule
  local pfunction_glob='^([_.]*|prompt_*_setup|README*)(-.N:t)'

  # $argv is overridden in the anonymous function.
  pmodules=("$argv[@]")

  # Add functions to $fpath.
  fpath=(${pmodules:+${MACOSZ}/modules/${^pmodules}/functions(/FN)} $fpath)

  function {
    local pfunction

    # Extended globbing is needed for listing autoloadable function directories.
    setopt LOCAL_OPTIONS EXTENDED_GLOB

    # Load Prezto functions.
    for pfunction in ${MACOSZ}/modules/${^pmodules}/functions/$~pfunction_glob; do
      autoload -Uz "$pfunction"
    done
  }

  # Load Prezto modules.
  for pmodule in "$pmodules[@]"; do
    if zstyle -t ":prezto:module:$pmodule" loaded 'yes' 'no'; then
      continue
    elif [[ ! -d "${MACOSZ}/modules/$pmodule" ]]; then
      print "$0: no such module: $pmodule" >&2
      continue
    else
      if [[ -s "${MACOSZ}/modules/$pmodule/init.zsh" ]]; then
        source "${MACOSZ}/modules/$pmodule/init.zsh"
      fi

      if (( $? == 0 )); then
        zstyle ":prezto:module:$pmodule" loaded 'yes'
      else
        # Remove the $fpath entry.
        fpath[(r)${MACOSZ}/modules/${pmodule}/functions]=()

        function {
          local pfunction

          # Extended globbing is needed for listing autoloadable function
          # directories.
          setopt LOCAL_OPTIONS EXTENDED_GLOB

          # Unload Prezto functions.
          for pfunction in ${MACOSZ}/modules/$pmodule/functions/$~pfunction_glob; do
            unfunction "$pfunction"
          done
        }

        zstyle ":prezto:module:$pmodule" loaded 'no'
      fi
    fi
  done
}
# IFS='
# '

FILES=$(ls $(dirname $0)/^alex*)
eval "FILES=($FILES)"

# FILES=
for x in $FILES; { echo "sourcing ${x:t}."; source "$x"; }
# printf "files are %s" $FILES
# source $FILES
