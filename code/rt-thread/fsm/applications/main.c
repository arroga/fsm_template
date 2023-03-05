/*
 * Copyright (c) 2006-2023, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2023-03-03     RT-Thread    first version
 */

#include <rtthread.h>

#include "fsm_base.h"
#define DBG_TAG "main"
#define DBG_LVL DBG_LOG
#include <rtdbg.h>


typedef struct
{
    fsm_handle_base_t base;
}fsm_handle_base0_t;

int main(void)
{
    int count = 0;
    fsm_handle_base0_t x;
    fsm_state_t state = fsm_get_state(&x);
    while (count++)
    {
        LOG_D("Hello RT-Thread!");
        rt_thread_mdelay(1000);
    }

    return RT_EOK;
}
