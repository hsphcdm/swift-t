#!/bin/bash

TESTS=$( dirname $0 )

set -x

THIS=$0
BIN=${THIS%.sh}.x
OUTPUT=${THIS%.sh}.out

${TESTS}/runbin.zsh ${BIN} >& ${OUTPUT}
[[ ${?} == 0 ]] || exit 1

grep -q "MPE OK" ${OUTPUT} || exit 1

exit 0
