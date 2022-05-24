#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# The _log function is used for everything this script wants to log. It will
# always log errors and warnings, but can be silenced for other messages
# by setting JUPYTER_DOCKER_STACKS_QUIET environment variable.
_log () {
    if [[ "$*" == "ERROR:"* ]] || [[ "$*" == "WARNING:"* ]] || [[ "${JUPYTER_DOCKER_STACKS_QUIET}" == "" ]]; then
        echo "$@"
    fi
}
_log "Entered start.sh with args:" "$@"

# The run-hooks function looks for .sh scripts to source and executable files to
# run within a passed directory.
run-hooks () {
    if [[ ! -d "${1}" ]] ; then
        return
    fi
    _log "${0}: running hooks in ${1} as uid / gid: $(id -u) / $(id -g)"
    for f in "${1}/"*; do
        case "${f}" in
            *.sh)
                _log "${0}: running script ${f}"
                # shellcheck disable=SC1090
                source "${f}"
                ;;
            *)
                if [[ -x "${f}" ]] ; then
                    _log "${0}: running executable ${f}"
                    "${f}"
                else
                    _log "${0}: ignoring non-executable ${f}"
                fi
                ;;
        esac
    done
    _log "${0}: done running hooks in ${1}"
}

# A helper function to unset env vars listed in the value of the env var
# JUPYTER_ENV_VARS_TO_UNSET.
unset_explicit_env_vars () {
    if [ -n "${JUPYTER_ENV_VARS_TO_UNSET}" ]; then
        for env_var_to_unset in $(echo "${JUPYTER_ENV_VARS_TO_UNSET}" | tr ',' ' '); do
            echo "Unset ${env_var_to_unset} due to JUPYTER_ENV_VARS_TO_UNSET"
            unset "${env_var_to_unset}"
        done
        unset JUPYTER_ENV_VARS_TO_UNSET
    fi
}


# Default to starting bash if no command was specified
if [ $# -eq 0 ]; then
    cmd=( "bash" )
else
    cmd=( "$@" )
fi

# NOTE: This hook will run as the user the container was started with!
run-hooks /usr/local/bin/start-notebook.d

# NOTE: This hook is run as the root user!
run-hooks /usr/local/bin/before-notebook.d

_log "Executing the command:" "${cmd[@]}"
exec "${cmd[@]}"
