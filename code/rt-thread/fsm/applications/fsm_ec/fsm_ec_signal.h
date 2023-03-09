/*
 */
#ifndef APPLICATIONS_EK9A_SIG_H_
#define APPLICATIONS_EK9A_SIG_H_
#include "fsm_ec_base.h"


/**************entry信号函数******************/
/*进入状态信号*/
fsm_hr_t fsm_ec_reinit_entry_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
fsm_hr_t fsm_ec_init_entry_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************entry信号函数******************/

/**************exit信号函数******************/
/*退出状态信号*/
fsm_hr_t fsm_ec_reinit_exit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
fsm_hr_t fsm_ec_init_exit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************exit信号函数******************/

/**************resv信号函数******************/
/*保留*/

/**************resv信号函数******************/

/**************reinit信号函数******************/
/*复位信号*/
fsm_hr_t fsm_ec_init_reinit_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************reinit信号函数******************/

/**************init信号函数******************/
/*初始化信号*/
fsm_hr_t fsm_ec_reinit_init_handler(fsm_ec_handler_t* const h, fsm_sig_base_t* const e);
/**************init信号函数******************/

/**************ip信号函数******************/
/*init state to preop state*/

/**************ip信号函数******************/

/**************ps信号函数******************/
/*preop state to safeop state*/

/**************ps信号函数******************/




#endif /* APPLICATIONS_EK9A_EK9A_SIG_H_ */
