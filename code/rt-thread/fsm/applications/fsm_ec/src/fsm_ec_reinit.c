#include "fsm_ec_sig.h"
#include "fsm_ec_state.h"

fsm_hr_t fsm_ec_reinit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
    fsm_hr_t r = FSM_SHANDLED;
    switch (e->sig)
    {

    case FSM_EC_ENTRY_SIG:
        r = fsm_ec_reinit_entry_handler(h, e);
        break;

    default:
        break;
    }
    return r;
}
