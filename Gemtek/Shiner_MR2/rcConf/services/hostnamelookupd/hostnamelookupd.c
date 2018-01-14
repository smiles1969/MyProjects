/*
 * Services - hostnamelookupd
 *
 * Copyright 2006-2010, Gemtek Corporation
 * All Rights Reserved.
 * 
 * $Id$
 */

#include <rcConf_common.h>


int add_hostnamelookup_request_schedule(void){
    char add_cmd[256];
    memset(add_cmd, 0, sizeof(add_cmd));
//    sprintf(add_cmd, "echo \"*/5 * * * * killall -SIGALRM hostnamelookupd\" >> /tmp/etc/fcrontab");
//    sprintf(add_cmd, "echo \"* */8 * * *  hostnamelookup do_req\" >> /tmp/etc/fcrontab");
    sprintf(add_cmd, "echo \"*/3 * * * *  hostnamelookup do_req\" >> /tmp/etc/fcrontab");
    rcEvalSh(add_cmd);
    return 0;
}
int start_hostnamelookupd(void) 
{
	rcClearCtlFlag("start_hostnamelookupd");
	DBENTER();

	/* start function area */
    rcEvalBg("hostnamelookupd");

	DBLEAVE();
	return 0;
}

int stop_hostnamelookupd(void) 
{
	rcClearCtlFlag("stop_hostnamelookupd");
	DBENTER();

	/* stop function area */
	rcEvalSh("killall hostnamelookupd");

	DBLEAVE();
	return 0;
}

int restart_hostnamelookupd(void) 
{
	/* restart function area */
	stop_hostnamelookupd();
	start_hostnamelookupd();

	return 0;
}
