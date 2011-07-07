#!/bin/zsh

# Generate rect-*.tcl, a tcl-turbine-adlb test case

TURBINE=$( cd $( dirname $0 )/.. ; /bin/pwd )

source ${TURBINE}/scripts/helpers.zsh

STEPS=$1
WIDTH=$2
DURATION=$3

checkvars STEPS WIDTH DURATION

OUTPUT="rect-${STEPS}-${WIDTH}-${DURATION}.tcl"

# Header
{
  print
  print "# Generated by mk-rect-sleep.zsh"
  print
  print "package require turbine 0.1"
  print "turbine_adlb_init"
  print
} > ${OUTPUT}

typeset -z COUNT=0
# Turbine data/rules section
{
  printf "proc noop { } { }\n\n"

  print "proc rules { } {"

  # Data declarations
  for (( i=0 ; i<STEPS*WIDTH ; i++ ))
  do
    print "\t turbine_file ${i} test/data/${i}.txt"
  done
  print

  # Task dependencies
  for (( i=0 ; i<STEPS ; i++ ))
   do
   printf "\t turbine_rule ${COUNT} ${COUNT} "
   printf     "{ } { ${COUNT} } { sleep ${DURATION} } \n"
   (( COUNT++ ))
  done

  for (( i=1 ; i<STEPS ; i++ ))
   do
   PREVROW=$( print {$(( (i-1)*WIDTH ))..$(( i*WIDTH-1 ))} )
   for (( j=0 ; j<WIDTH ; j++ ))
    do
    printf "\t turbine_rule ${COUNT} ${COUNT} "
    printf     "{ ${PREVROW} } { ${COUNT} } "
    printf     "{ tp: noop }\n"
    # printf     "{ sleep ${DURATION} }\n"
    (( COUNT++ ))
   done
  done
  print "}"
} >> ${OUTPUT}

# Footer
{
  print
  print "turbine_adlb rules"
  print
  print "turbine_finalize"
  print "adlb_finalize"
  print "puts OK"
} >> ${OUTPUT}

print "wrote: ${OUTPUT}"

return 0
