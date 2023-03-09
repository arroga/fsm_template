
#include "fsm_ec_sig.h"
#include "fsm_ec_state.h"
fsm_hr_t fsm_ec_preop_entry_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_exit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_init_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_reinit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_ps_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_pi_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_rsdo_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_wsdo_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}

fsm_hr_t fsm_ec_preop_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e)
{
    fsm_hr_t r = FSM_SHANDLED;
    switch(e->sig)
    {
    case FSM_EC_ENTRY_SIG:
        r = fsm_ec_preop_entry_handler(h,e);
    case FSM_EC_EXIT_SIG:
        r = fsm_ec_preop_exit_handler(h,e);
    case FSM_EC_INIT_SIG:
        r = fsm_ec_preop_init_handler(h,e);
    case FSM_EC_REINIT_SIG:
        r = fsm_ec_preop_reinit_handler(h,e);
    case FSM_EC_PS_SIG:
        r = fsm_ec_preop_ps_handler(h,e);
    case FSM_EC_PI_SIG:
        r = fsm_ec_preop_pi_handler(h,e);
    case FSM_EC_RSDO_SIG:
        r = fsm_ec_preop_rsdo_handler(h,e);
    case FSM_EC_WSDO_SIG:
        r = fsm_ec_preop_wsdo_handler(h,e);
    default:
        break;
    }
    return r;
}