# Turbine builtin assert functions for debugging

namespace eval turbine {

    # assert(cond, msg)
    # If cond is 0, then terminate program, printing msg
    proc assert { stack noresult inputs } {
        set cond [ lindex $inputs 0 ]
        set msg [ lindex $inputs 1 ]
        rule "assert-$cond-$msg" "$cond $msg" \
            $turbine::LOCAL "assert_body $cond $msg"
    }

    proc assert_body { cond msg } {
        set cond_value [ retrieve_integer $cond ]
        set msg_value [ retrieve_string $msg ]
        assert_impl $cond_value $msg_value
        read_refcount_decr $cond
        read_refcount_decr $msg
    }

    proc assert_impl { cond msg } {
        if { $cond == 0 } {
            error "Assertion failed!: $msg"
        } else {
            log "assert passed: $msg"
        }
    }

    # assert(arg1, arg2, msg)
    # if arg1 != arg2 according to TCL's comparison rules
    #  (e.g. "1" == 1 and 1 == 1)
    # then crash, printing the two values and the provided msg
    proc assertEqual { stack noresult inputs } {
        set arg1 [ lindex $inputs 0 ]
        set arg2 [ lindex $inputs 1 ]
        set msg [ lindex $inputs 2 ]
        rule "assertEqual-$arg1-$arg2-$msg" "$arg1 $arg2 $msg" \
            $turbine::LOCAL "assertEqual_body $arg1 $arg2 $msg"
    }

    proc assertEqual_body { arg1 arg2 msg } {
        set arg1_value [ retrieve $arg1 ]
        set arg2_value [ retrieve $arg2 ]
        set msg_value  [ retrieve_string $msg ]
        assertEqual_impl "$arg1_value" "$arg2_value" "$msg_value"
        read_refcount_decr $arg1
        read_refcount_decr $arg2
        read_refcount_decr $msg
    }

    proc assertEqual_impl { arg1 arg2 msg } {
        if { $arg1 != $arg2 } {
            error "Assertion failed $arg1 != $arg2: $msg"
        } else {
            log "assertEqual $arg1 $arg2 passed: $msg"
        }
    }

    # assertLT(arg1, arg2, msg)
    # if arg1 >= arg2 according to TCL's comparison rules
    # then crash, printing the two values and the provided msg
    proc assertLT { stack noresult inputs } {
        set arg1 [ lindex $inputs 0 ]
        set arg2 [ lindex $inputs 1 ]
        set msg [ lindex $inputs 2 ]
        rule "assertLT-$arg1-$arg2-$msg" "$arg1 $arg2 $msg" \
            $turbine::LOCAL "assertLT_body $arg1 $arg2 $msg"
    }

    proc assertLT_body { arg1 arg2 msg } {
        set arg1_value [ retrieve $arg1 ]
        set arg2_value [ retrieve $arg2 ]
        if { $arg1_value >= $arg2_value } {
            set msg_value [ retrieve $msg ]
            error "Assertion failed $arg1_value >= $arg2_value: $msg_value"
        } else {
            log "assertLT: $arg1_value $arg2_value"
        }
        read_refcount_decr $arg1
        read_refcount_decr $arg2
        read_refcount_decr $msg
    }

    # assertLTE(arg1, arg2, msg)
    # if arg1 >= arg2 according to TCL's comparison rules
    # then crash, printing the two values and the provided msg
    proc assertLTE { stack noresult inputs } {
        set arg1 [ lindex $inputs 0 ]
        set arg2 [ lindex $inputs 1 ]
        set msg [ lindex $inputs 2 ]
        rule "assertLTE-$arg1-$arg2-$msg" "$arg1 $arg2 $msg" \
            $turbine::LOCAL "assertLTE_body $arg1 $arg2 $msg"
    }

    proc assertLTE_body { arg1 arg2 msg } {
        set arg1_value [ retrieve $arg1 ]
        set arg2_value [ retrieve $arg2 ]
        if { $arg1_value > $arg2_value } {
            set msg_value [ retrieve $msg ]
            error "Assertion failed $arg1_value > $arg2_value: $msg_value"
        } else {
            log "assertLTE: $arg1_value $arg2_value"
        }
        read_refcount_decr $arg1
        read_refcount_decr $arg2
        read_refcount_decr $msg
    }
}
