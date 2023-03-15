#ifndef APPLICATIONS_FSM_FSM_BASE_H_
#define APPLICATIONS_FSM_FSM_BASE_H_
#include <stdio.h>
#include <stdint.h>
// #include <rtdef.h>
#include "includes.h"
#define FSM_DEBUG
typedef uint8_t fsm_hr_t;
typedef uint8_t fsm_state_t;
typedef uint32_t fsm_sig_t;
typedef volatile uint8_t  fsm_lock_t;
typedef volatile uint8_t  fsm_exception_t;


#if RT_VERSION > 3
#include "rtthread.h"
typedef rt_mailbox_t fsm_eq_t;
typedef rt_err_t fsm_osq_err_t;
#endif

#ifdef OS_uCOS_II_H 
typedef OS_EVENT* fsm_eq_t;
typedef INT8U fsm_osq_err_t;
#endif



#define FSM_STRAN       (0x0U)
#define FSM_SHANDLED    (0x1U)
#define FSM_SUNHANDLED  (0x2U)
#define FSM_LOCK		(0x0U)
#define FSM_UNLOCK		(0x1U)
/*状态转变*/
#define FSM_TRAN(x)  	({fsm_get_handler(h) = (fsm_handler) x;FSM_STRAN;})

typedef enum
{
    FSM_EOK = 0x0U,
    FSM_ERROR = 0x1U,
    FSM_ETIMEOUT = 0x2U,
    FSM_EFULL = 0x3U,
    FSM_ENULL = 0x4U,
    FSM_EEMPTY = 0x5U,
    FSM_ETYPE = 0x6U,
	FSM_BUSY = 0x7U,
} fsm_err_t;


enum
{
    FSM_ENTRY_SIG = 0U,
    FSM_EXIT_SIG,
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


typedef fsm_hr_t (*fsm_handler)(void *const h , fsm_sig_base_t *const e);


typedef struct
{
    fsm_eq_t eq;                                /*消息队列*/
    fsm_state_t state;                          /*状态值*/
    fsm_handler handler;                        /*状态执行函数*/
    fsm_sig_base_t* sigs;                       /*信号数组*/
    fsm_lock_t lock;
    fsm_exception_t error;						/*记录当前异常*/
} fsm_handler_base_t;


fsm_err_t fsm_event_init_generic(fsm_handler_base_t* h, uint8_t* buffer ,uint16_t size);
fsm_err_t fsm_reinit_generic(fsm_eq_t queue);
fsm_err_t fsm_flush_generic(fsm_eq_t queue);
fsm_err_t fsm_send_generic(fsm_eq_t queue, const void *addr);
fsm_err_t fsm_recv_generic(fsm_eq_t queue, const void *addr, uint32_t timeout);
fsm_err_t fsm_urgent_generic(fsm_eq_t queue, const void *addr);
void fsm_dispatch_generic(fsm_handler_base_t* h, fsm_sig_base_t* e);
void fsm_start_generic(fsm_handler_base_t* h);

/*获取信号地址*/
#define  fsm_event_init(h, buffer,size)  fsm_event_init_generic((fsm_handler_base_t *) h, buffer,size)
/*获取信号地址*/
#define  fsm_get_sig_addr(x,sig)  (&((fsm_handler_base_t *) x)->sigs[sig])
/*获取状态处理函数*/
#define  fsm_get_handler(x)       (((fsm_handler_base_t *) x)->handler)
/*获取异常*/
#define  fsm_get_exception(x)       (((fsm_handler_base_t *) x)->exception)
/*获取队列指针*/
#define  fsm_get_eq(x)       (((fsm_handler_base_t *) x)->eq)
/*设置状态*/
#define  fsm_set_state(x,y)    (((fsm_handler_base_t *) x)->state = y)
/*获取状态*/
#define  fsm_get_state(x)    (((fsm_handler_base_t *) x)->state)
/*发送信号地址*/
#define  fsm_send(x, y)       fsm_send_generic(fsm_get_eq(x),y)
/*清除所有信号*/
#define  fsm_flush(x, y)      fsm_flush_generic(fsm_get_eq(x),y)       /*发送信号*/
/*接收信号*/
#define  fsm_recv(x, addr,timeout)    fsm_recv_generic(fsm_get_eq(x),addr, timeout)
/*发送信号,与fsm_send区别在于，fsm_send自定义信号*/
#define  fsm_send_sig(x,sig) fsm_send(x, (void *)fsm_get_sig_addr(x,sig))
/*获取锁值*/
#define  fsm_get_lock(x)     (((fsm_handler_base_t *) x)->lock)
/*获取锁值*/
#define  fsm_get_lock(x)     (((fsm_handler_base_t *) x)->lock)
/*设置异常值*/
#define fsm_set_exception(x, y) (((fsm_handler_base_t *) x)->exception = y)
/*开始状态机*/
#define fsm_start(h)		fsm_start_generic((fsm_handler_base_t *) h);

#define  fsm_dispatch(x, y)  fsm_dispatch_generic((fsm_handler_base_t *) x, (fsm_sig_base_t *) y)

#define fsm_lock(h)                                         			  \
                              do{                                         \
                                  if(fsm_get_lock(h) == FSM_LOCK)   	  \
                                  {                                       \
                                     return FSM_SUNHANDLED;               \
                                  }                                       \
                                  else                                    \
                                  {                                       \
                                	  fsm_get_lock(h) = HAL_LOCKED;       \
                                  }                                       \
                                }while (0U)

#define fsm_unlock(h)                                                     \
                                do{                                       \
                                	fsm_get_lock(h) = FSM_UNLOCK;         \
                                  }while (0U)

#endif /* APPLICATIONS_FSM_FSM_BASE_H_ */
