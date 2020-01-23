#!/bin/bash`'bash_l()
ifelse(getenv(PROJECT), `',,#COBALT -A getenv(PROJECT)
)ifelse(getenv(QUEUE), `',,#COBALT -q getenv(QUEUE)
)#COBALT -n getenv(NODES)
#COBALT -t getenv(WALLTIME)
#COBALT --cwd getenv(WORK_DIRECTORY)
#COBALT -o getenv(TURBINE_OUTPUT)/output.txt
#COBALT -e getenv(TURBINE_OUTPUT)/output.txt
#COBALT --jobname getenv(TURBINE_JOBNAME)
ifelse(getenv(MAIL_ARG), `',,#COBALT 'getenv(MAIL_ARG)'
)

# These COBALT directives have to stay right at the top of the file!
# No blank lines are allowed, making this look cluttered.

# Copyright 2013 University of Chicago and Argonne National Laboratory
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# TURBINE-THETA.SH

# Created: esyscmd(`date "+%Y-%m-%d %H:%M:%S"')

source /opt/modules/default/init/bash
module load modules
PATH=/opt/cray/elogin/eproxy/2.0.14-4.3/bin:$PATH # For aprun
module swap PrgEnv-intel/6.0.4 PrgEnv-gnu
module load alps

set -eu

# Get the time zone: for time stamps on log messages
export TZ=getenv(TZ)

COMMAND="getenv(COMMAND)"
PPN=getenv(PPN)
PROCS=getenv(PROCS)

TURBINE_HOME=getenv(TURBINE_HOME)
TURBINE_STATIC_EXEC=getenv(TURBINE_STATIC_EXEC)
EXEC_SCRIPT=getenv(EXEC_SCRIPT)

source ${TURBINE_HOME}/scripts/turbine-config.sh
if [[ ${?} != 0 ]]
then
  echo "Could not find Turbine settings!"
  exit 1
fi

LAUNCHER="getenv(TURBINE_LAUNCHER)"
VALGRIND="getenv(VALGRIND)"

export TURBINE_LOG=getenv(TURBINE_LOG)
export ADLB_PRINT_TIME=getenv(ADLB_PRINT_TIME)

echo "TURBINE SETTINGS"
echo "JOB_ID:  ${COBALT_JOBID}"
echo "DATE:    $(date)"
echo "TURBINE_HOME: ${TURBINE_HOME}"
echo "PROCS:   ${PROCS}"
echo "PPN:${PPN}"
echo

# Construct aprun-formatted user environment variable arguments
# # The dummy is needed for old GNU bash (4.3.48) under set -eu
USER_ENV_ARRAY=( getenv(USER_ENV_ARRAY) )
USER_ENV_COUNT=${#USER_ENV_ARRAY[@]}
USER_ENV_ARGS=( -e _dummy=x )
for (( i=0 ; i < USER_ENV_COUNT ; i+=2 ))
do
  K=${USER_ENV_ARRAY[i]}
  V=${USER_ENV_ARRAY[i+1]}
  USER_ENV_ARGS+=( -e $K="${V}" )
done

# This is the critical Cray fork() fix
USER_ENV_ARGS+=( -e MPICH_GNI_FORK_MODE=FULLCOPY )

TURBINE_LAUNCH_OPTIONS="getenv(TURBINE_LAUNCH_OPTIONS)"

# Run Turbine!
set -x
aprun -n ${PROCS} -N ${PPN} \
      ${TURBINE_LAUNCH_OPTIONS:-} \
      "${USER_ENV_ARGS[@]}" \
      ${TURBINE_INTERPOSER:-} \
      ${COMMAND}
CODE=${?}
set +x

echo
echo "Turbine Theta launcher done."
echo "CODE: ${CODE}"
echo "COMPLETE: $( date '+%Y-%m-%d %H:%M' )"

# Return exit code from launcher (aprun)
exit ${CODE}

# Local Variables:
# mode: m4
# End:
