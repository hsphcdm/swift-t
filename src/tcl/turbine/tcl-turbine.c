
/**
 * TCL extension for Turbine
 *
 * @author wozniak
 * */

#include <assert.h>

#include <tcl.h>

#include "src/turbine/turbine.h"

static int
Turbine_Init_Cmd(ClientData cdata, Tcl_Interp *interp,
                 int objc, Tcl_Obj *const objv[])
{
  Tcl_ObjSetVar2(interp, Tcl_NewStringObj("TURBINE_SUCCESS", -1), NULL,
                 Tcl_NewIntObj(TURBINE_SUCCESS), TCL_GLOBAL_ONLY);

  Tcl_SetObjResult(interp, Tcl_NewIntObj(TURBINE_SUCCESS));

  turbine_init();

  return TCL_OK;
}

static int
Turbine_Finalize_Cmd(ClientData cdata, Tcl_Interp *interp,
                     int objc, Tcl_Obj *const objv[])
{
  puts("Turbine finalizing...");
  turbine_finalize();
  return TCL_OK;
}

/**
   Called when Tcl loads this extension
 */
int DLLEXPORT
Tclturbine_Init(Tcl_Interp *interp)
{
  if (Tcl_InitStubs(interp, TCL_VERSION, 0) == NULL) {
    return TCL_ERROR;
  }
  /* changed this to check for an error - GPS */
  if (Tcl_PkgProvide(interp, "ADLB", "1.0") == TCL_ERROR) {
    return TCL_ERROR;
  }
  Tcl_CreateObjCommand(interp, "turbine_init", Turbine_Init_Cmd, NULL, NULL);
  Tcl_CreateObjCommand(interp, "turbine_finalize", Turbine_Finalize_Cmd, NULL, NULL);
  return TCL_OK;
}
