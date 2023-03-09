#include "fsm_base.h"
#include <string.h>

static fsm_err_t toString(uint8_t num, uint8_t *s)
{
    uint8_t l = num % 10;
    uint8_t h = num / 10;
    s[0] = l + '0';
    s[1] = h + '0';
    return FSM_EOK;
}

static fsm_sig_base_t  common_sig[] = {{.sig=FSM_ENTRY_SIG}, {.sig = FSM_EXIT_SIG}, {.sig = FSM_INIT_SIG}};

#if RT_VERSION > 3

fsm_err_t from_rterr(rt_err_t sr)
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
    rt_err_t err = rt_mb_send(queue, (rt_base_t)addr);
    return from_rterr(err);
}

fsm_err_t fsm_recv_generic(fsm_eq_t queue, const void *addr, uint32_t timeout)
{

    rt_err_t err = rt_mb_recv(queue, (rt_ubase_t *)addr, timeout);
    return from_rterr(err);
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

