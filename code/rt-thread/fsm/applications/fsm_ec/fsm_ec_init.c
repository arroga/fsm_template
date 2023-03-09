/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2023-03-09     xujiahui       the first version
 */
#include "fsm_ec_signal.h"


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
