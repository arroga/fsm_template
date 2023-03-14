#include "fsm_base.h"
#include <string.h>



static fsm_sig_base_t  common_sig[] = {{.sig=FSM_ENTRY_SIG}, {.sig = FSM_EXIT_SIG}};

#if RT_VERSION > 3

static fsm_err_t toString(uint8_t num, uint8_t *s)
{
    uint8_t l = num % 10;
    uint8_t h = num / 10;
    s[0] = l + '0';
    s[1] = h + '0';
    return FSM_EOK;
}

fsm_err_t from_os_err(fsm_osq_err_t sr)
{
    fsm_err_t r;
    switch(sr)
    {
    case RT_EOK:
        r = FSM_EOK;
        break;
    case RT_ERROR:
        r = FSM_ERROR;
        break;
    case RT_ETIMEOUT:
        r = ETIMEDOUT;
        break;
    case RT_EFULL:
        r = FSM_EFULL;
        break;
    case RT_EEMPTY:
       r = FSM_EEMPTY;
       break;
    default:
        r = FSM_ERROR;
        break;
    }
    return r;
}

fsm_eq_t fsm_event_init(uint8_t* buffer ,uint16_t size)
{
    uint8_t name[6] = "fsm00";
    uint8_t temp[2];
    static uint8_t fsm_num = 0;
    toString(fsm_num, temp);
    fsm_num++;
    name[3] = temp[0];
    name[4] = temp[1];

    return rt_mb_create((char *)name, (rt_size_t)size, RT_IPC_FLAG_PRIO);
}

fsm_err_t fsm_send_generic(fsm_eq_t queue, const void *addr)
{
    fsm_osq_err_t err = rt_mb_send(queue, (rt_base_t)addr);
    return from_os_err(err);
}

fsm_err_t fsm_recv_generic(fsm_eq_t queue, const void *addr, uint32_t timeout)
{

    fsm_osq_err_t err = rt_mb_recv(queue, (rt_ubase_t *)addr, timeout);
    return from_os_err(err);
}

fsm_err_t fsm_flush_generic(fsm_eq_t queue)
{
    fsm_osq_err_t err = rt_mb_control(queue,RT_IPC_CMD_RESET,(void *) 0);
    return from_os_err(err);
}
// fsm_err_t fsm_urgent_generic(fsm_eq_t queue, const void *addr)
// {
//     fsm_osq_err_t err = rt_mb_send(queue, (rt_base_t)addr);
//     return from_os_err(err);
// }


#endif

#ifdef OS_uCOS_II_H
fsm_err_t from_os_err(fsm_osq_err_t sr)
{
    fsm_err_t r;
    switch(sr)
    {
    case OS_ERR_NONE:
        r = FSM_EOK;
        break;
    case OS_ERR_EVENT_TYPE:
        r = FSM_ETYPE;
        break;
    case OS_ERR_TIMEOUT:
        r = FSM_ETIMEOUT;
        break;
    case OS_ERR_Q_FULL:
        r = FSM_EFULL;
        break;
    case OS_ERR_Q_EMPTY:
       r = FSM_EEMPTY;
       break;
    default:
        r = FSM_ERROR;
        break;
    }
    return r;
}

fsm_eq_t fsm_event_init(uint8_t* buffer ,uint16_t size)
{
    return OSQCreate((void **) buffer, size);
}

fsm_err_t fsm_send_generic(fsm_eq_t queue, const void *addr)
{

    fsm_osq_err_t err  = OSQPost(queue, (void *)addr) ;
    return from_os_err(err);
}

fsm_err_t fsm_recv_generic(fsm_eq_t queue, const void *addr, uint32_t timeout)
{

    fsm_osq_err_t err;
    addr = OSQPend(queue, timeout, &err) ;
    return from_os_err(err);
}

fsm_err_t fsm_urgent_generic(fsm_eq_t queue, const void *addr)
{
    fsm_osq_err_t err  = OSQPostFront(queue, (void *)addr) ;
    return from_os_err(err);
}

fsm_err_t fsm_flush_generic(fsm_eq_t queue)
{
    fsm_osq_err_t err = OSQFlush(queue);
    return from_os_err(err);
}

#endif









void fsm_dispatch_generic(fsm_handler_base_t* h, fsm_sig_base_t* e)
{
    fsm_handler s =  h->handler;
    fsm_hr_t r = (*s)(h, e);
    if(r == FSM_STRAN)
    {
        (void)(*s)(h, &common_sig[FSM_EXIT_SIG]);
        (void)(h->handler)(h, &common_sig[FSM_ENTRY_SIG]);
    }
}

void fsm_start(fsm_handler_base_t* h)
{
    fsm_send_sig(h,FSM_ENTRY_SIG);
}
