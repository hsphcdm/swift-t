package exm.stc.ic.opt;

import java.util.Set;

import exm.stc.common.lang.Types;
import exm.stc.common.lang.Var;
import exm.stc.common.lang.Types.Type;
import exm.stc.common.util.TernaryLogic.Ternary;

public class Semantics {
  /**
   * True if can pass to child task
   * @param t
   * @return
   */
  public static boolean canPassToChildTask(Type t) {
    if (t.assignableTo(Types.V_BLOB)) {
      return false;
    } else if (t.assignableTo(Types.V_FILE)) {
      return false;
    } else {
      return true;
    }        
  }
  


  /**
   * Check to see if we can get the mapping of an output var without
   * waiting
   * @param closedVars set of variables known to be closed
   * @param out
   * @return
   */
  public static boolean outputMappingAvail(Set<Var> closedVars, Var out) {
    // Two cases where we can get mapping right away:
    // - if it's definitely unmapped
    // - if the mapping has been assigned
    return out.isMapped() == Ternary.FALSE ||
            (out.mapping() != null && closedVars.contains(out.mapping()));
  }

}
