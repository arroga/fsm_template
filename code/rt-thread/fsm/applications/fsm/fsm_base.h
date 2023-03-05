#ifndef APPLICATIONS_FSM_FSM_BASE_H_
#define APPLICATIONS_FSM_FSM_BASE_H_
#include <stdio.h>
#include <rtdef.h>
#define FSM_DEBUG
typedef uint8_t fsm_state_t;
typedef uint32_t fsm_sig_t;
#if RT_VERSION > 3
#include "rtthread.h"
typedef rt_mailbox_t fsm_eq_t;
#endif


#define FSM_STRAN       (0)
#define FSM_SHANDLED    (1)
#define FSM_SUNHANDLED  (2)


typedef enum
{
    FSM_EOK = 0,
    FSM_ERROR = 0x1,
    FSM_ETIMEOUT = 0x2,
    FSM_EFULL = 0x3,
    FSM_ENULL = 0x4,
    FSM_EEMPTY = 0x5,

} fsm_err_t;


enum
{
    FSM_ENTRY_SIG = 0,
    FSM_EXIT_SIG,
    FSM_INIT_SIG,
    FSM_USER_SIG
};


typedef struct
{
    fsm_sig_t sig;
#ifdef FSM_DEBUG
    uint32_t send_c;
    uint32_t recv_c;
#endif
} fsm_sig_base_t;


typedef fsm_state_t (*fsm_handler)(void *const h , fsm_sig_base_t *const e);


typedef struct
{
    fsm_eq_t eq;                                /*消息队列*/
    fsm_state_t state;                          /*状态值*/
    fsm_handler handler;                        /*状态执行函数*/
    fsm_sig_base_t* sigs;                       /*信号数组*/
} fsm_handle_base_t;


fsm_eq_t fsm_event_init(uint8_t* buffer ,uint16_t size);
fsm_err_t fsm_reinit_generic(fsm_eq_t queue);
fsm_err_t fsm_flush_generic(fsm_eq_t queue);
fsm_err_t fsm_send_generic(fsm_eq_t queue, const void *addr);
fsm_err_t fsm_recv_generic(fsm_eq_t queue, const void *addr, uint32_t timeout);
fsm_err_t fsm_urgent_generic(fsm_eq_t queue, const void *addr);
void fsm_dispatch_generic(fsm_handle_base_t* h, fsm_sig_base_t* e);

#define  fsm_get_sig_addr(x,sig)  (&((fsm_handle_base_t *) x)->sigs[sig])
#define  fsm_get_eq(x)       (((fsm_handle_base_t *) x)->eq)
#define  fsm_set_state(x)    (((fsm_handle_base_t *) x)->state = x)                     /*设置状态*/
#define  fsm_get_state(x)    (((fsm_handle_base_t *) x)->state)                         /*获取状态*/
#define  fsm_send(x, y)      fsm_send_generic(fsm_get_eq(x),y)       /*发送信号*/
#define  fsm_recv(x, y,z)    fsm_recv_generic(fsm_get_eq(x),y, z)    /*接收信号*/
#define  fsm_send_sig(x,sig) fsm_send(x, (void *)fsm_get_sig_addrx,sig))
#define  fsm_dispatch(x, y)  fsm_dispatch_generic((fsm_handle_base_t *) x, (fsm_sig_base_t *) y)x

#endif /* APPLICATIONS_FSM_FSM_BASE_H_ */
