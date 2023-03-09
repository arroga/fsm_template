
#include "fsm_ec_sig.h"
#include "fsm_ec_state.h"
fsm_hr_t fsm_ec_reinit_entry_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_reinit_exit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_reinit_init_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_reinit_exception_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_reinit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
    fsm_hr_t r = FSM_SHANDLED;
    switch(e->sig)
    {
    case FSM_EC_ENTRY_SIG:
        r = fsm_ec_reinit_entry_handler(h,e);
    case FSM_EC_EXIT_SIG:
        r = fsm_ec_reinit_exit_handler(h,e);
    case FSM_EC_INIT_SIG:
        r = fsm_ec_reinit_init_handler(h,e);
    case FSM_EC_EXCEPTION_SIG:
        r = fsm_ec_reinit_exception_handler(h,e);
    default:
        break;
    }
    return r;
}