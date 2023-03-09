
#ifndef APPLICATIONS_EC_SIG_H_
#define APPLICATIONS_EC_SIG_H_
#include "fsm_ec_base.h"

enum
{
    FSM_EC_ENTRY_SIG = FSM_ENTRY_SIG,
    FSM_EC_EXIT_SIG = FSM_EXIT_SIG,
    FSM_EC_USER_SIG = FSM_USER_SIG,
    FSM_EC_RESV_SIG,                    /*����*/
    FSM_EC_REINIT_SIG,                  /*��λ�ź�*/
    FSM_EC_EXCEPTION_SIG,               /*�쳣�ź�*/
    FSM_EC_INIT_SIG,                    /*��ʼ���ź�*/
    FSM_EC_IP_SIG,                      /*init state to preop state*/
    FSM_EC_PS_SIG,                      /*preop state to safeop state*/
    FSM_EC_PI_SIG,                      /*preop state to init state*/
    FSM_EC_WSDO_SIG,                    /*дSDO*/
    FSM_EC_RSDO_SIG,                    /*��SDO*/
};

/**************entry�źź���******************/
/*����״̬�ź�*/
fsm_hr_t fsm_ec_reinit_entry_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_init_entry_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_entry_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************entry�źź���******************/


/**************exit�źź���******************/
/*�˳�״̬�ź�*/
fsm_hr_t fsm_ec_reinit_exit_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_init_exit_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_exit_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************exit�źź���******************/


/**************resv�źź���******************/
/*����*/
/**************resv�źź���******************/


/**************reinit�źź���******************/
/*��λ�ź�*/
fsm_hr_t fsm_ec_init_reinit_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_reinit_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************reinit�źź���******************/


/**************exception�źź���******************/
/*�쳣�ź�*/
fsm_hr_t fsm_ec_reinit_exception_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_init_exception_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************exception�źź���******************/


/**************init�źź���******************/
/*��ʼ���ź�*/
fsm_hr_t fsm_ec_reinit_init_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);

fsm_hr_t fsm_ec_preop_init_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************init�źź���******************/


/**************ip�źź���******************/
/*init state to preop state*/
fsm_hr_t fsm_ec_init_ip_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************ip�źź���******************/


/**************ps�źź���******************/
/*preop state to safeop state*/
fsm_hr_t fsm_ec_preop_ps_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************ps�źź���******************/


/**************pi�źź���******************/
/*preop state to init state*/
fsm_hr_t fsm_ec_preop_pi_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************pi�źź���******************/


/**************wsdo�źź���******************/
/*дSDO*/
fsm_hr_t fsm_ec_preop_wsdo_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************wsdo�źź���******************/


/**************rsdo�źź���******************/
/*��SDO*/
fsm_hr_t fsm_ec_preop_rsdo_handler(fsm_ec_handler_t* const h,fsm_sig_base_t* const e);
/**************rsdo�źź���******************/
#endif
