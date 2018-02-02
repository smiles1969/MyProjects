
DIAG_CODE get_param_get_wifi_ssid(IO_DATA *pio_data, DIAG_RESULT *prst)
{
	DIAG_CODE ret = 0;
	DBGMSG("get parameters\n");

	return DONE;
}

DIAG_CODE run_get_wifi_ssid(IO_DATA *pio_data, DIAG_RESULT *prst)
{
	/* local variables */
	DIAG_CODE ret = 0;
	int local_ret = 0;

	/* get parameters if it is necessary */
	/* ex:
	int size = pio_data->u.xxx.yyy;
	*/
	
	timer_start(pio_data);
	do{
		/* test, tool body */
        // local_ret = run_test_tool();

		/* report the result */	
		/* The secondary parameter of diag_report() must be DONE or ERROR */
		if(local_ret == -1) {
			ret = diag_report(prst, ERROR, "Today is not your day, please contact the pitiful PL");
		}else if(local_ret == 0){
			ret = diag_report(prst, DONE, "");
		}else{
			// get unexpected ret
		}
	}while(diag_flow_control(ret, pio_data) == RUN);
	timer_stop(pio_data);

	return ret;
}

DIAG_CODE get_wifi_ssid_uid_handle(IO_DATA *pio_data, DIAG_RESULT *prst)
{
	int params_num = 2;
	DIAG_CODE ret = 0;
	int channel = 0;

	if((pio_data->argc == 4) && (strncmp(pio_data->argv[UID_IDX+1], "help", 4) == 0)) {
		printf("diagmon -c <uid string> <ssid> <channel>\n");
		printf("EX: diagmon -c bsc-wln-wln01 ssid_test 1\n");
	}else if(pio_data->argc == (3 + params_num)) {
		sscanf (pio_data->argv[UID_IDX+2] , "%d" , &channel);
		pio_data->u.wl.channel[0] = channel;

		strncpy(pio_data->u.wl.ssid[0], pio_data->argv[UID_IDX+1], 32);
		ret = run_get_wifi_ssid(pio_data, prst);
	}else {
		printf("Incorrect command!!\n");
	}

	return ret;
}
