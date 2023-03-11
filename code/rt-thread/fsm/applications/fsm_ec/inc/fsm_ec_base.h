
#ifndef _FSM_EC_BASE_H_
#define _FSM_EC_BASE_H_
#include "fsm_base.h"

typedef struct
{

} fsm_ec_init_t;

typedef struct
{
    fsm_handler_base_t parent;
    fsm_ec_init_t init;
} fsm_ec_handler_t;
#endif
