
#ifndef APPLICATIONS_EC_STATE_H_
#define APPLICATIONS_EC_STATE_H_
#include "fsm_ec_base.h"
fsm_hr_t fsm_ec_reinit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
fsm_hr_t fsm_ec_init_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
#endif
