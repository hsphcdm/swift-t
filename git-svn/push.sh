#!/usr/bin/env bash
for subrepo in c-utils lb turbine stc dev
do
  echo Pushing $subrepo        
  pushd $subrepo > /dev/null
  git push --all --tags origin  
  popd > /dev/null
set -e

