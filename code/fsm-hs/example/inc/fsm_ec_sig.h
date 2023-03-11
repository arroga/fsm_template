
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
#define fsm_ec_init_entry_handler fsm_ec_init_reinit_handler
/**************entry�źź���******************/


/**************exit�źź���******************/
/*�˳�״̬�ź�*/


/**************exit�źź���******************/


/**************resv�źź���******************/
/*����*/


/**************resv�źź���******************/


/**************reinit�źź���******************/
/*��λ�ź�*/


/**************reinit�źź���******************/


/**************exception�źź���******************/
/*�쳣�ź�*/


/**************exception�źź���******************/


/**************init�źź���******************/
/*��ʼ���ź�*/


/**************init�źź���******************/


/**************ip�źź���******************/
/*init state to preop state*/


/**************ip�źź���******************/


/**************ps�źź���******************/
/*preop state to safeop state*/


/**************ps�źź���******************/


/**************pi�źź���******************/
/*preop state to init state*/


/**************pi�źź���******************/


/**************wsdo�źź���******************/
/*дSDO*/


/**************wsdo�źź���******************/


/**************rsdo�źź���******************/
/*��SDO*/


/**************rsdo�źź���******************/
#endif
