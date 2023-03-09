
#ifndef APPLICATIONS_EC_SIG_H_
#define APPLICATIONS_EC_SIG_H_
#include "fsm_ec_base.h"

enum
{
    FSM_EC_USER_SIG = FSM_USER_SIG,
    FSM_EC_ENTRY_SIG,
    FSM_EC_EXIT_SIG,
    FSM_EC_RESV_SIG,
    FSM_EC_REINIT_SIG,
    FSM_EC_INIT_SIG,
    FSM_EC_IP_SIG,
    FSM_EC_PS_SIG,
    FSM_EC_PI_SIG,
    FSM_EC_WSDO_SIG,
    FSM_EC_RSDO_SIG,
}

/**************entry信号函数******************/
/*进入状态信号*/
fsm_hr_t fsm_ec_reinit_entry_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_init_entry_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_entry_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************entry信号函数******************/


/**************exit信号函数******************/
/*退出状态信号*/
fsm_hr_t fsm_ec_reinit_exit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_init_exit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_exit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************exit信号函数******************/


/**************resv信号函数******************/
/*保留*/
/**************resv信号函数******************/


/**************reinit信号函数******************/
/*复位信号*/
fsm_hr_t fsm_ec_init_reinit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_reinit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************reinit信号函数******************/


/**************init信号函数******************/
/*初始化信号*/
fsm_hr_t fsm_ec_reinit_init_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_init_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************init信号函数******************/


/**************ip信号函数******************/
/*init state to preop state*/
/**************ip信号函数******************/


/**************ps信号函数******************/
/*preop state to safeop state*/
fsm_hr_t fsm_ec_preop_ps_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************ps信号函数******************/


/**************pi信号函数******************/
/*preop state to init state*/
fsm_hr_t fsm_ec_preop_pi_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************pi信号函数******************/


/**************wsdo信号函数******************/
/*写SDO*/
fsm_hr_t fsm_ec_preop_wsdo_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************wsdo信号函数******************/


/**************rsdo信号函数******************/
/*读SDO*/
fsm_hr_t fsm_ec_preop_rsdo_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************rsdo信号函数******************/
#endif
