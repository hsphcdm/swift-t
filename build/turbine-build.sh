#!/usr/bin/env bash
set -e

THISDIR=`dirname $0`
source ${THISDIR}/exm-settings.sh

if (( MAKE_CLEAN )); then
  if [ -f Makefile ]; then
      # Disabled due to Turbine configure check
      #make clean
      :
  fi
fi

if (( SVN_UPDATE )); then
  svn update
fi

if (( RUN_AUTOTOOLS )); then
  ./setup.sh
fi

EXTRA_ARGS=
if (( EXM_OPT_BUILD )); then
    EXTRA_ARGS+=" --enable-fast"
fi

if (( ENABLE_MPE )); then
    EXTRA_ARGS+=" --with-mpe"
fi

if (( EXM_STATIC_BUILD )); then
  EXTRA_ARGS+=" --disable-shared"
fi

if (( EXM_CRAY )); then
  if (( EXM_STATIC_BUILD )); then
    export CC=cc
  else
    export CC=gcc
  fi
  EXTRA_ARGS+=" --enable-custom-mpi"
fi

if (( ENABLE_PYTHON )); then
  EXTRA_ARGS+=" --enable-python"
fi

if [ ! -z "$PYTHON_INSTALL" ]; then
  EXTRA_ARGS+=" --with-python=${PYTHON_INSTALL}"
fi

if (( ENABLE_R )); then
  EXTRA_ARGS+=" --enable-r"
fi
if [ ! -z "$R_INSTALL" ]; then
  EXTRA_ARGS+=" --with-r=${R_INSTALL}"
fi

if [ ! -z "$TCL_INSTALL" ]; then
  EXTRA_ARGS+=" --with-tcl=${TCL_INSTALL}"
fi

if [ ! -z "$TCL_VERSION" ]; then
  EXTRA_ARGS+=" --with-tcl-version=$TCL_VERSION"
fi

if [ ! -z "$TCLSH_LOCAL" ]; then
  EXTRA_ARGS+=" --with-tcl-local=${TCLSH_LOCAL}"
fi

if [ ! -z "$TCL_LIB_DIR" ]; then
  EXTRA_ARGS+=" --with-tcl-lib-dir=${TCL_LIB_DIR}"
fi

if [ ! -z "$TCL_INCLUDE_DIR" ]; then
  EXTRA_ARGS+=" --with-tcl-include=${TCL_INCLUDE_DIR}"
fi

if [ ! -z "$TCL_SYSLIB_DIR" ]; then
  EXTRA_ARGS+=" --with-tcl-syslib-dir=${TCL_SYSLIB_DIR}"
fi

if (( DISABLE_XPT )); then
    EXTRA_ARGS+=" --enable-checkpoint=no"
fi

if (( EXM_DEV )); then
  EXTRA_ARGS+=" --enable-dev"
fi

if (( DISABLE_STATIC )); then
  EXTRA_ARGS+=" --disable-static"
fi

if [ ! -z "$MPI_INSTALL" ]; then
  EXTRA_ARGS+=" --with-mpi=${MPI_INSTALL}"
fi

if (( EXM_CUSTOM_MPI )); then
  EXTRA_ARGS+=" --enable-custom-mpi"
fi

if [ ! -z "$MPI_INCLUDE" ]; then
  EXTRA_ARGS+=" --with-mpi-include=${MPI_INCLUDE}"
fi

if [ ! -z "$MPI_LIB_DIR" ]; then
  EXTRA_ARGS+=" --with-mpi-lib-dir=${MPI_LIB_DIR}"
fi

if [ ! -z "$MPI_LIB_NAME" ]; then
  EXTRA_ARGS+=" --with-mpi-lib-name=${MPI_LIB_NAME}"
fi

if (( DISABLE_ZLIB )); then
  EXTRA_ARGS+=" --disable-zlib"
fi

if [ ! -z "$ZLIB_INSTALL" ]; then
  EXTRA_ARGS+=" --with-zlib=$ZLIB_INSTALL"
fi

if (( ENABLE_MKSTATIC_CRC )); then
  EXTRA_ARGS+=" --enable-mkstatic-crc-check"
fi

if (( CONFIGURE )); then
  ./configure --with-adlb=${LB_INSTALL} \
              ${CRAY_ARGS} \
              --with-c-utils=${C_UTILS_INSTALL} \
              --prefix=${TURBINE_INSTALL} \
              ${EXTRA_ARGS}
#             --disable-log
fi

if (( MAKE_CLEAN )); then
  make clean
fi
make -j ${MAKE_PARALLELISM}
make install
