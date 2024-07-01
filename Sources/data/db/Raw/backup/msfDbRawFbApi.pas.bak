/// <summary>
/// Разработчик (Developer): Владимир Козодой (Vladimir Kozodoi)
/// Хранилище (Repository): https://github.com/status-kvo/firebird_udr_common
/// Описание: API по работе с Firebird сервер посредством технологии UDR
/// Description: API for working with Firebird server using UDR technology
/// </summary>
unit msfDbRawFbApi;

{$IFDEF FPC}
{$MODE DELPHI}
{$OBJECTCHECKS OFF}
{$ENDIF}

interface

uses
  Classes, SysUtils;

//
// {$IFNDEF NO_FBCLIENT}
// function fb_get_master_interface : IMaster; cdecl; external 'fbclient';
// {$ENDIF}

const
  FB_UsedInYValve = FALSE;

const
  isc_facility = 20;
  isc_err_base = 335544320;
  isc_err_factor = 1;
  gds_facility = 20;
  gds_err_base = 335544320;
  gds_err_factor = 1;

  isc_arg_end = 0; (* end of argument list *)
  isc_arg_gds = 1; (* generic DSRI status value *)
  isc_arg_string = 2; (* string argument *)
  isc_arg_cstring = 3; (* count & string argument *)
  isc_arg_number = 4; (* numeric argument (long) *)
  isc_arg_interpreted = 5; (* interpreted status code (string) *)
  isc_arg_vms = 6; (* VAX/VMS status code (long) *)
  isc_arg_unix = 7; (* UNIX error code *)
  isc_arg_domain = 8; (* Apollo/Domain error code *)
  isc_arg_dos = 9; (* MSDOS/OS2 error code *)
  gds_arg_end = 0; (* end of argument list *)
  gds_arg_gds = 1; (* generic DSRI status value *)
  gds_arg_string = 2; (* string argument *)
  gds_arg_cstring = 3; (* count & string argument *)
  gds_arg_number = 4; (* numeric argument (long) *)
  gds_arg_interpreted = 5; (* interpreted status code (string) *)
  gds_arg_vms = 6; (* VAX/VMS status code (long) *)
  gds_arg_unix = 7; (* UNIX error code *)
  gds_arg_domain = 8; (* Apollo/Domain error code *)
  gds_arg_dos = 9; (* MSDOS/OS2 error code *)

type
  tms = record
    tms_utime: Int32;
    tms_stime: Int32;
    tms_cutime: Int32;
    tms_cstime: Int32;
  end;

  perf = record
    perf_fetches: Int32;
    perf_marks: Int32;
    perf_reads: Int32;
    perf_writes: Int32;
    perf_current_memory: Int32;
    perf_max_memory: Int32;
    perf_buffers: Int32;
    perf_page_size: Int32;
    perf_elapsed: Int32;
    perf_times: tms;
  end;

  (* Letter codes controlling printting of statistics:

    !f - fetches
    !m - marks
    !r - reads
    !w - writes
    !e - elapsed time (in seconds)
    !u - user times
    !s - system time
    !p - page size
    !b - number buffers
    !d - delta memory
    !c - current memory
    !x - max memory

  *)

  // (* Entry point definitions *)
  //
  // procedure perf_get_info (
  // in 	handle	: gds__handlse;
  // out	block	: perf
  // ); extern;
  //
  // procedure perf_format (
  // in	before	: perf;
  // in	after	: perf;
  // in	control	: UNIV string;
  // in{out}	buffer	: UNIV string;
  // in	buf_len	: integer
  // ); extern;
  //
  // procedure perf_report (
  // in	before	: perf;
  // in	after	: perf;
  // in{out}	buffer	: UNIV string;
  // in	buf_len	: integer
  // ); extern;

type
  ISC_DATE = Integer;
  ISC_TIME = Integer;
  ISC_QUAD = array [1 .. 2] of Integer;
  FB_DEC16 = array [1 .. 1] of Int64;
  FB_DEC34 = array [1 .. 2] of Int64;
  FB_I128 = array [1 .. 2] of Int64;

  isc_tr_handle = ^Integer;
  isc_stmt_handle = ^Integer;

  ISC_USHORT = word; { 16 bit unsigned }
  ISC_SHORT = smallint; { 16 bit signed }

  ISC_TIME_TZ = record
    utc_time: ISC_TIME;
    time_zone: ISC_USHORT;
  end;

  ISC_TIME_TZ_EX = record
    utc_time: ISC_TIME;
    time_zone: ISC_USHORT;
    ext_offset: ISC_SHORT;
  end;

  ISC_TIMESTAMP = record
    timestamp_date: ISC_DATE;
    timestamp_time: ISC_TIME;
  end;

  ISC_TIMESTAMP_TZ = record
    utc_timestamp: ISC_TIMESTAMP;
    time_zone: ISC_USHORT;
  end;

  ISC_TIMESTAMP_TZ_EX = record
    utc_timestamp: ISC_TIMESTAMP;
    time_zone: ISC_USHORT;
    ext_offset: ISC_SHORT;
  end;

  ntrace_relation_t = Integer;

  TraceCounts = Record
    trc_relation_id: ntrace_relation_t;
    trc_relation_name: PAnsiChar;
    trc_counters: ^Int64;
  end;

  TraceCountsPtr = ^TraceCounts;

  PerformanceInfo = Record
    pin_time: Int64;
    pin_counters: ^Int64;
    pin_count: NativeUInt;
    pin_tables: TraceCountsPtr;
    pin_records_fetched: Int64;
  end;

  Dsc = Record
    dsc_dtype, dsc_scale: Byte;
    dsc_length, dsc_sub_type, dsc_flags: Int16;
    dsc_address: ^Byte;
  end;

  // kvo
const
  SQLDA_VERSION1 = Byte(1);
  SQLDA_VERSION2 = Byte(2);
  SQL_DIALECT_V5 = Byte(1);
  SQL_DIALECT_V6_TRANSITION = Byte(2);
  SQL_DIALECT_V6 = Byte(3);
  SQL_DIALECT_CURRENT = SQL_DIALECT_V6;
  isc_info_db_SQL_dialect = Byte(62);

const
  isc_dpb_version1 = Byte(1);
  isc_dpb_version2 = Byte(2);
  isc_dpb_cdd_pathname = Byte(1);
  isc_dpb_allocation = Byte(2);
  isc_dpb_journal = Byte(3);
  isc_dpb_page_size = Byte(4);
  isc_dpb_num_buffers = Byte(5);
  isc_dpb_buffer_length = Byte(6);
  isc_dpb_debug = Byte(7);
  isc_dpb_garbage_collect = Byte(8);
  isc_dpb_verify = Byte(9);
  isc_dpb_sweep = Byte(10);
  isc_dpb_enable_journal = Byte(11);
  isc_dpb_disable_journal = Byte(12);
  isc_dpb_dbkey_scope = Byte(13);
  isc_dpb_number_of_users = Byte(14);
  isc_dpb_trace = Byte(15);
  isc_dpb_no_garbage_collect = Byte(16);
  isc_dpb_damaged = Byte(17);
  isc_dpb_license = Byte(18);
  isc_dpb_sys_user_name = Byte(19);
  isc_dpb_encrypt_key = Byte(20);
  isc_dpb_activate_shadow = Byte(21);
  isc_dpb_sweep_interval = Byte(22);
  isc_dpb_delete_shadow = Byte(23);
  isc_dpb_force_write = Byte(24);
  isc_dpb_begin_log = Byte(25);
  isc_dpb_quit_log = Byte(26);
  isc_dpb_no_reserve = Byte(27);
  isc_dpb_user_name = Byte(28);
  isc_dpb_password = Byte(29);
  isc_dpb_password_enc = Byte(30);
  isc_dpb_sys_user_name_enc = Byte(31);
  isc_dpb_interp = Byte(32);
  isc_dpb_online_dump = Byte(33);
  isc_dpb_old_file_size = Byte(34);
  isc_dpb_old_num_files = Byte(35);
  isc_dpb_old_file = Byte(36);
  isc_dpb_old_start_page = Byte(37);
  isc_dpb_old_start_seqno = Byte(38);
  isc_dpb_old_start_file = Byte(39);
  isc_dpb_drop_walfile = Byte(40);
  isc_dpb_old_dump_id = Byte(41);
  isc_dpb_wal_backup_dir = Byte(42);
  isc_dpb_wal_chkptlen = Byte(43);
  isc_dpb_wal_numbufs = Byte(44);
  isc_dpb_wal_bufsize = Byte(45);
  isc_dpb_wal_grp_cmt_wait = Byte(46);
  isc_dpb_lc_messages = Byte(47);
  isc_dpb_lc_ctype = Byte(48);
  isc_dpb_cache_manager = Byte(49);
  isc_dpb_shutdown = Byte(50);
  isc_dpb_online = Byte(51);
  isc_dpb_shutdown_delay = Byte(52);
  isc_dpb_reserved = Byte(53);
  isc_dpb_overwrite = Byte(54);
  isc_dpb_sec_attach = Byte(55);
  isc_dpb_disable_wal = Byte(56);
  isc_dpb_connect_timeout = Byte(57);
  isc_dpb_dummy_packet_interval = Byte(58);
  isc_dpb_gbak_attach = Byte(59);
  isc_dpb_sql_role_name = Byte(60);
  isc_dpb_set_page_buffers = Byte(61);
  isc_dpb_working_directory = Byte(62);
  isc_dpb_sql_dialect = Byte(63);
  isc_dpb_set_db_readonly = Byte(64);
  isc_dpb_set_db_sql_dialect = Byte(65);
  isc_dpb_gfix_attach = Byte(66);
  isc_dpb_gstat_attach = Byte(67);
  isc_dpb_set_db_charset = Byte(68);
  isc_dpb_gsec_attach = Byte(69);
  isc_dpb_address_path = Byte(70);
  isc_dpb_process_id = Byte(71);
  isc_dpb_no_db_triggers = Byte(72);
  isc_dpb_trusted_auth = Byte(73);
  isc_dpb_process_name = Byte(74);
  isc_dpb_trusted_role = Byte(75);
  isc_dpb_org_filename = Byte(76);
  isc_dpb_utf8_filename = Byte(77);
  isc_dpb_ext_call_depth = Byte(78);
  isc_dpb_auth_block = Byte(79);
  isc_dpb_client_version = Byte(80);
  isc_dpb_remote_protocol = Byte(81);
  isc_dpb_host_name = Byte(82);
  isc_dpb_os_user = Byte(83);
  isc_dpb_specific_auth_data = Byte(84);
  isc_dpb_auth_plugin_list = Byte(85);
  isc_dpb_auth_plugin_name = Byte(86);
  isc_dpb_config = Byte(87);
  isc_dpb_nolinger = Byte(88);
  isc_dpb_reset_icu = Byte(89);
  isc_dpb_map_attach = Byte(90);
  isc_dpb_address = Byte(1);
  isc_dpb_addr_protocol = Byte(1);
  isc_dpb_addr_endpoint = Byte(2);
  isc_dpb_addr_flags = Byte(3);
  isc_dpb_addr_flag_conn_compressed = $01;
  isc_dpb_addr_flag_conn_encrypted = $02;
  isc_dpb_pages = Byte(1);
  isc_dpb_records = Byte(2);
  isc_dpb_indices = Byte(4);
  isc_dpb_transactions = Byte(8);
  isc_dpb_no_update = Byte(16);
  isc_dpb_repair = Byte(32);
  isc_dpb_ignore = Byte(64);
  isc_dpb_shut_cache = $1;
  isc_dpb_shut_attachment = $2;
  isc_dpb_shut_transaction = $4;
  isc_dpb_shut_force = $8;
  isc_dpb_shut_mode_mask = $70;
  isc_dpb_shut_default = $0;
  isc_dpb_shut_normal = $10;
  isc_dpb_shut_multi = $20;
  isc_dpb_shut_single = $30;
  isc_dpb_shut_full = $40;
  RDB_system = Byte(1);
  RDB_id_assigned = Byte(2);
  isc_tpb_version1 = Byte(1);
  isc_tpb_version3 = Byte(3);
  isc_tpb_consistency = Byte(1);
  isc_tpb_concurrency = Byte(2);
  isc_tpb_shared = Byte(3);
  isc_tpb_protected = Byte(4);
  isc_tpb_exclusive = Byte(5);
  isc_tpb_wait = Byte(6);
  isc_tpb_nowait = Byte(7);
  isc_tpb_read = Byte(8);
  isc_tpb_write = Byte(9);
  isc_tpb_lock_read = Byte(10);
  isc_tpb_lock_write = Byte(11);
  isc_tpb_verb_time = Byte(12);
  isc_tpb_commit_time = Byte(13);
  isc_tpb_ignore_limbo = Byte(14);
  isc_tpb_read_committed = Byte(15);
  isc_tpb_autocommit = Byte(16);
  isc_tpb_rec_version = Byte(17);
  isc_tpb_no_rec_version = Byte(18);
  isc_tpb_restart_requests = Byte(19);
  isc_tpb_no_auto_undo = Byte(20);
  isc_tpb_lock_timeout = Byte(21);
  isc_bpb_version1 = Byte(1);
  isc_bpb_source_type = Byte(1);
  isc_bpb_target_type = Byte(2);
  isc_bpb_type = Byte(3);
  isc_bpb_source_interp = Byte(4);
  isc_bpb_target_interp = Byte(5);
  isc_bpb_filter_parameter = Byte(6);
  isc_bpb_storage = Byte(7);
  isc_bpb_type_segmented = $0;
  isc_bpb_type_stream = $1;
  isc_bpb_storage_main = $0;
  isc_bpb_storage_temp = $2;
  isc_spb_version1 = Byte(1);
  isc_spb_current_version = Byte(2);
  isc_spb_version3 = Byte(3);
  isc_spb_command_line = Byte(105);
  isc_spb_dbname = Byte(106);
  isc_spb_verbose = Byte(107);
  isc_spb_options = Byte(108);
  isc_spb_address_path = Byte(109);
  isc_spb_process_id = Byte(110);
  isc_spb_trusted_auth = Byte(111);
  isc_spb_process_name = Byte(112);
  isc_spb_trusted_role = Byte(113);
  isc_spb_verbint = Byte(114);
  isc_spb_auth_block = Byte(115);
  isc_spb_auth_plugin_name = Byte(116);
  isc_spb_auth_plugin_list = Byte(117);
  isc_spb_utf8_filename = Byte(118);
  isc_spb_client_version = Byte(119);
  isc_spb_remote_protocol = Byte(120);
  isc_spb_host_name = Byte(121);
  isc_spb_os_user = Byte(122);
  isc_spb_config = Byte(123);
  isc_spb_expected_db = Byte(124);
  isc_action_svc_backup = Byte(1);
  isc_action_svc_restore = Byte(2);
  isc_action_svc_repair = Byte(3);
  isc_action_svc_add_user = Byte(4);
  isc_action_svc_delete_user = Byte(5);
  isc_action_svc_modify_user = Byte(6);
  isc_action_svc_display_user = Byte(7);
  isc_action_svc_properties = Byte(8);
  isc_action_svc_add_license = Byte(9);
  isc_action_svc_remove_license = Byte(10);
  isc_action_svc_db_stats = Byte(11);
  isc_action_svc_get_ib_log = Byte(12);
  isc_action_svc_get_fb_log = Byte(12);
  isc_action_svc_nbak = Byte(20);
  isc_action_svc_nrest = Byte(21);
  isc_action_svc_trace_start = Byte(22);
  isc_action_svc_trace_stop = Byte(23);
  isc_action_svc_trace_suspend = Byte(24);
  isc_action_svc_trace_resume = Byte(25);
  isc_action_svc_trace_list = Byte(26);
  isc_action_svc_set_mapping = Byte(27);
  isc_action_svc_drop_mapping = Byte(28);
  isc_action_svc_display_user_adm = Byte(29);
  isc_action_svc_validate = Byte(30);
  isc_action_svc_last = Byte(31);
  isc_info_svc_svr_db_info = Byte(50);
  isc_info_svc_get_license = Byte(51);
  isc_info_svc_get_license_mask = Byte(52);
  isc_info_svc_get_config = Byte(53);
  isc_info_svc_version = Byte(54);
  isc_info_svc_server_version = Byte(55);
  isc_info_svc_implementation = Byte(56);
  isc_info_svc_capabilities = Byte(57);
  isc_info_svc_user_dbpath = Byte(58);
  isc_info_svc_get_env = Byte(59);
  isc_info_svc_get_env_lock = Byte(60);
  isc_info_svc_get_env_msg = Byte(61);
  isc_info_svc_line = Byte(62);
  isc_info_svc_to_eof = Byte(63);
  isc_info_svc_timeout = Byte(64);
  isc_info_svc_get_licensed_users = Byte(65);
  isc_info_svc_limbo_trans = Byte(66);
  isc_info_svc_running = Byte(67);
  isc_info_svc_get_users = Byte(68);
  isc_info_svc_auth_block = Byte(69);
  isc_info_svc_stdin = Byte(78);
  isc_spb_sec_userid = Byte(5);
  isc_spb_sec_groupid = Byte(6);
  isc_spb_sec_username = Byte(7);
  isc_spb_sec_password = Byte(8);
  isc_spb_sec_groupname = Byte(9);
  isc_spb_sec_firstname = Byte(10);
  isc_spb_sec_middlename = Byte(11);
  isc_spb_sec_lastname = Byte(12);
  isc_spb_sec_admin = Byte(13);
  isc_spb_lic_key = Byte(5);
  isc_spb_lic_id = Byte(6);
  isc_spb_lic_desc = Byte(7);
  isc_spb_bkp_file = Byte(5);
  isc_spb_bkp_factor = Byte(6);
  isc_spb_bkp_length = Byte(7);
  isc_spb_bkp_skip_data = Byte(8);
  isc_spb_bkp_stat = Byte(15);
  isc_spb_bkp_ignore_checksums = $01;
  isc_spb_bkp_ignore_limbo = $02;
  isc_spb_bkp_metadata_only = $04;
  isc_spb_bkp_no_garbage_collect = $08;
  isc_spb_bkp_old_descriptions = $10;
  isc_spb_bkp_non_transportable = $20;
  isc_spb_bkp_convert = $40;
  isc_spb_bkp_expand = $80;
  isc_spb_bkp_no_triggers = $8000;
  isc_spb_prp_page_buffers = Byte(5);
  isc_spb_prp_sweep_interval = Byte(6);
  isc_spb_prp_shutdown_db = Byte(7);
  isc_spb_prp_deny_new_attachments = Byte(9);
  isc_spb_prp_deny_new_transactions = Byte(10);
  isc_spb_prp_reserve_space = Byte(11);
  isc_spb_prp_write_mode = Byte(12);
  isc_spb_prp_access_mode = Byte(13);
  isc_spb_prp_set_sql_dialect = Byte(14);
  isc_spb_prp_activate = $0100;
  isc_spb_prp_db_online = $0200;
  isc_spb_prp_nolinger = $0400;
  isc_spb_prp_force_shutdown = Byte(41);
  isc_spb_prp_attachments_shutdown = Byte(42);
  isc_spb_prp_transactions_shutdown = Byte(43);
  isc_spb_prp_shutdown_mode = Byte(44);
  isc_spb_prp_online_mode = Byte(45);
  isc_spb_prp_sm_normal = Byte(0);
  isc_spb_prp_sm_multi = Byte(1);
  isc_spb_prp_sm_single = Byte(2);
  isc_spb_prp_sm_full = Byte(3);
  isc_spb_prp_res_use_full = Byte(35);
  isc_spb_prp_res = Byte(36);
  isc_spb_prp_wm_async = Byte(37);
  isc_spb_prp_wm_sync = Byte(38);
  isc_spb_prp_am_readonly = Byte(39);
  isc_spb_prp_am_readwrite = Byte(40);
  isc_spb_rpr_commit_trans = Byte(15);
  isc_spb_rpr_rollback_trans = Byte(34);
  isc_spb_rpr_recover_two_phase = Byte(17);
  isc_spb_tra_id = Byte(18);
  isc_spb_single_tra_id = Byte(19);
  isc_spb_multi_tra_id = Byte(20);
  isc_spb_tra_state = Byte(21);
  isc_spb_tra_state_limbo = Byte(22);
  isc_spb_tra_state_commit = Byte(23);
  isc_spb_tra_state_rollback = Byte(24);
  isc_spb_tra_state_unknown = Byte(25);
  isc_spb_tra_host_site = Byte(26);
  isc_spb_tra_remote_site = Byte(27);
  isc_spb_tra_db_path = Byte(28);
  isc_spb_tra_advise = Byte(29);
  isc_spb_tra_advise_commit = Byte(30);
  isc_spb_tra_advise_rollback = Byte(31);
  isc_spb_tra_advise_unknown = Byte(33);
  isc_spb_tra_id_64 = Byte(46);
  isc_spb_single_tra_id_64 = Byte(47);
  isc_spb_multi_tra_id_64 = Byte(48);
  isc_spb_rpr_commit_trans_64 = Byte(49);
  isc_spb_rpr_rollback_trans_64 = Byte(50);
  isc_spb_rpr_recover_two_phase_64 = Byte(51);
  isc_spb_rpr_validate_db = $01;
  isc_spb_rpr_sweep_db = $02;
  isc_spb_rpr_mend_db = $04;
  isc_spb_rpr_list_limbo_trans = $08;
  isc_spb_rpr_check_db = $10;
  isc_spb_rpr_ignore_checksum = $20;
  isc_spb_rpr_kill_shadows = $40;
  isc_spb_rpr_full = $80;
  isc_spb_rpr_icu = $0800;
  isc_spb_res_buffers = Byte(9);
  isc_spb_res_page_size = Byte(10);
  isc_spb_res_length = Byte(11);
  isc_spb_res_access_mode = Byte(12);
  isc_spb_res_fix_fss_data = Byte(13);
  isc_spb_res_fix_fss_metadata = Byte(14);
  isc_spb_res_deactivate_idx = $0100;
  isc_spb_res_no_shadow = $0200;
  isc_spb_res_no_validity = $0400;
  isc_spb_res_one_at_a_time = $0800;
  isc_spb_res_replace = $1000;
  isc_spb_res_create = $2000;
  isc_spb_res_use_all_space = $4000;
  isc_spb_val_tab_incl = Byte(1);
  isc_spb_val_tab_excl = Byte(2);
  isc_spb_val_idx_incl = Byte(3);
  isc_spb_val_idx_excl = Byte(4);
  isc_spb_val_lock_timeout = Byte(5);
  isc_spb_num_att = Byte(5);
  isc_spb_num_db = Byte(6);
  isc_spb_sts_table = Byte(64);
  isc_spb_sts_data_pages = $01;
  isc_spb_sts_db_log = $02;
  isc_spb_sts_hdr_pages = $04;
  isc_spb_sts_idx_pages = $08;
  isc_spb_sts_sys_relations = $10;
  isc_spb_sts_record_versions = $20;
  isc_spb_sts_nocreation = $80;
  isc_spb_sts_encryption = $100;
  isc_spb_nbk_level = Byte(5);
  isc_spb_nbk_file = Byte(6);
  isc_spb_nbk_direct = Byte(7);
  isc_spb_nbk_no_triggers = $01;
  isc_spb_trc_id = Byte(1);
  isc_spb_trc_name = Byte(2);
  isc_spb_trc_cfg = Byte(3);
  isc_sdl_version1 = Byte(1);
  isc_sdl_eoc = Byte(255);
  isc_sdl_relation = Byte(2);
  isc_sdl_rid = Byte(3);
  isc_sdl_field = Byte(4);
  isc_sdl_fid = Byte(5);
  isc_sdl_struct = Byte(6);
  isc_sdl_variable = Byte(7);
  isc_sdl_scalar = Byte(8);
  isc_sdl_tiny_integer = Byte(9);
  isc_sdl_short_integer = Byte(10);
  isc_sdl_long_integer = Byte(11);
  isc_sdl_add = Byte(13);
  isc_sdl_subtract = Byte(14);
  isc_sdl_multiply = Byte(15);
  isc_sdl_divide = Byte(16);
  isc_sdl_negate = Byte(17);
  isc_sdl_begin = Byte(31);
  isc_sdl_end = Byte(32);
  isc_sdl_do3 = Byte(33);
  isc_sdl_do2 = Byte(34);
  isc_sdl_do1 = Byte(35);
  isc_sdl_element = Byte(36);
  isc_blob_untyped = Byte(0);
  isc_blob_text = Byte(1);
  isc_blob_blr = Byte(2);
  isc_blob_acl = Byte(3);
  isc_blob_ranges = Byte(4);
  isc_blob_summary = Byte(5);
  isc_blob_format = Byte(6);
  isc_blob_tra = Byte(7);
  isc_blob_extfile = Byte(8);
  isc_blob_debug_info = Byte(9);
  isc_blob_max_predefined_subtype = Byte(10);
  fb_shut_confirmation = Byte(1);
  fb_shut_preproviders = Byte(2);
  fb_shut_postproviders = Byte(4);
  fb_shut_finish = Byte(8);
  fb_shut_exit = Byte(16);
  fb_cancel_disable = Byte(1);
  fb_cancel_enable = Byte(2);
  fb_cancel_raise = Byte(3);
  fb_cancel_abort = Byte(4);
  fb_dbg_version = Byte(1);
  fb_dbg_end = Byte(255);
  fb_dbg_map_src2blr = Byte(2);
  fb_dbg_map_varname = Byte(3);
  fb_dbg_map_argument = Byte(4);
  fb_dbg_subproc = Byte(5);
  fb_dbg_subfunc = Byte(6);
  fb_dbg_map_curname = Byte(7);
  fb_dbg_arg_input = Byte(0);
  fb_dbg_arg_output = Byte(1);
  isc_arith_except = 335544321;
  isc_bad_dbkey = 335544322;
  isc_bad_db_format = 335544323;
  isc_bad_db_handle = 335544324;
  isc_bad_dpb_content = 335544325;
  isc_bad_dpb_form = 335544326;
  isc_bad_req_handle = 335544327;
  isc_bad_segstr_handle = 335544328;
  isc_bad_segstr_id = 335544329;
  isc_bad_tpb_content = 335544330;
  isc_bad_tpb_form = 335544331;
  isc_bad_trans_handle = 335544332;
  isc_bug_check = 335544333;
  isc_convert_error = 335544334;
  isc_db_corrupt = 335544335;
  isc_deadlock = 335544336;
  isc_excess_trans = 335544337;
  isc_from_no_match = 335544338;
  isc_infinap = 335544339;
  isc_infona = 335544340;
  isc_infunk = 335544341;
  isc_integ_fail = 335544342;
  isc_invalid_blr = 335544343;
  isc_io_error = 335544344;
  isc_lock_conflict = 335544345;
  isc_metadata_corrupt = 335544346;
  isc_not_valid = 335544347;
  isc_no_cur_rec = 335544348;
  isc_no_dup = 335544349;
  isc_no_finish = 335544350;
  isc_no_meta_update = 335544351;
  isc_no_priv = 335544352;
  isc_no_recon = 335544353;
  isc_no_record = 335544354;
  isc_no_segstr_close = 335544355;
  isc_obsolete_metadata = 335544356;
  isc_open_trans = 335544357;
  isc_port_len = 335544358;
  isc_read_only_field = 335544359;
  isc_read_only_rel = 335544360;
  isc_read_only_trans = 335544361;
  isc_read_only_view = 335544362;
  isc_req_no_trans = 335544363;
  isc_req_sync = 335544364;
  isc_req_wrong_db = 335544365;
  isc_segment = 335544366;
  isc_segstr_eof = 335544367;
  isc_segstr_no_op = 335544368;
  isc_segstr_no_read = 335544369;
  isc_segstr_no_trans = 335544370;
  isc_segstr_no_write = 335544371;
  isc_segstr_wrong_db = 335544372;
  isc_sys_request = 335544373;
  isc_stream_eof = 335544374;
  isc_unavailable = 335544375;
  isc_unres_rel = 335544376;
  isc_uns_ext = 335544377;
  isc_wish_list = 335544378;
  isc_wrong_ods = 335544379;
  isc_wronumarg = 335544380;
  isc_imp_exc = 335544381;
  isc_random = 335544382;
  isc_fatal_conflict = 335544383;
  isc_badblk = 335544384;
  isc_invpoolcl = 335544385;
  isc_nopoolids = 335544386;
  isc_relbadblk = 335544387;
  isc_blktoobig = 335544388;
  isc_bufexh = 335544389;
  isc_syntaxerr = 335544390;
  isc_bufinuse = 335544391;
  isc_bdbincon = 335544392;
  isc_reqinuse = 335544393;
  isc_badodsver = 335544394;
  isc_relnotdef = 335544395;
  isc_fldnotdef = 335544396;
  isc_dirtypage = 335544397;
  isc_waifortra = 335544398;
  isc_doubleloc = 335544399;
  isc_nodnotfnd = 335544400;
  isc_dupnodfnd = 335544401;
  isc_locnotmar = 335544402;
  isc_badpagtyp = 335544403;
  isc_corrupt = 335544404;
  isc_badpage = 335544405;
  isc_badindex = 335544406;
  isc_dbbnotzer = 335544407;
  isc_tranotzer = 335544408;
  isc_trareqmis = 335544409;
  isc_badhndcnt = 335544410;
  isc_wrotpbver = 335544411;
  isc_wroblrver = 335544412;
  isc_wrodpbver = 335544413;
  isc_blobnotsup = 335544414;
  isc_badrelation = 335544415;
  isc_nodetach = 335544416;
  isc_notremote = 335544417;
  isc_trainlim = 335544418;
  isc_notinlim = 335544419;
  isc_traoutsta = 335544420;
  isc_connect_reject = 335544421;
  isc_dbfile = 335544422;
  isc_orphan = 335544423;
  isc_no_lock_mgr = 335544424;
  isc_ctxinuse = 335544425;
  isc_ctxnotdef = 335544426;
  isc_datnotsup = 335544427;
  isc_badmsgnum = 335544428;
  isc_badparnum = 335544429;
  isc_virmemexh = 335544430;
  isc_blocking_signal = 335544431;
  isc_lockmanerr = 335544432;
  isc_journerr = 335544433;
  isc_keytoobig = 335544434;
  isc_nullsegkey = 335544435;
  isc_sqlerr = 335544436;
  isc_wrodynver = 335544437;
  isc_funnotdef = 335544438;
  isc_funmismat = 335544439;
  isc_bad_msg_vec = 335544440;
  isc_bad_detach = 335544441;
  isc_noargacc_read = 335544442;
  isc_noargacc_write = 335544443;
  isc_read_only = 335544444;
  isc_ext_err = 335544445;
  isc_non_updatable = 335544446;
  isc_no_rollback = 335544447;
  isc_bad_sec_info = 335544448;
  isc_invalid_sec_info = 335544449;
  isc_misc_interpreted = 335544450;
  isc_update_conflict = 335544451;
  isc_unlicensed = 335544452;
  isc_obj_in_use = 335544453;
  isc_nofilter = 335544454;
  isc_shadow_accessed = 335544455;
  isc_invalid_sdl = 335544456;
  isc_out_of_bounds = 335544457;
  isc_invalid_dimension = 335544458;
  isc_rec_in_limbo = 335544459;
  isc_shadow_missing = 335544460;
  isc_cant_validate = 335544461;
  isc_cant_start_journal = 335544462;
  isc_gennotdef = 335544463;
  isc_cant_start_logging = 335544464;
  isc_bad_segstr_type = 335544465;
  isc_foreign_key = 335544466;
  isc_high_minor = 335544467;
  isc_tra_state = 335544468;
  isc_trans_invalid = 335544469;
  isc_buf_invalid = 335544470;
  isc_indexnotdefined = 335544471;
  isc_login = 335544472;
  isc_invalid_bookmark = 335544473;
  isc_bad_lock_level = 335544474;
  isc_relation_lock = 335544475;
  isc_record_lock = 335544476;
  isc_max_idx = 335544477;
  isc_jrn_enable = 335544478;
  isc_old_failure = 335544479;
  isc_old_in_progress = 335544480;
  isc_old_no_space = 335544481;
  isc_no_wal_no_jrn = 335544482;
  isc_num_old_files = 335544483;
  isc_wal_file_open = 335544484;
  isc_bad_stmt_handle = 335544485;
  isc_wal_failure = 335544486;
  isc_walw_err = 335544487;
  isc_logh_small = 335544488;
  isc_logh_inv_version = 335544489;
  isc_logh_open_flag = 335544490;
  isc_logh_open_flag2 = 335544491;
  isc_logh_diff_dbname = 335544492;
  isc_logf_unexpected_eof = 335544493;
  isc_logr_incomplete = 335544494;
  isc_logr_header_small = 335544495;
  isc_logb_small = 335544496;
  isc_wal_illegal_attach = 335544497;
  isc_wal_invalid_wpb = 335544498;
  isc_wal_err_rollover = 335544499;
  isc_no_wal = 335544500;
  isc_drop_wal = 335544501;
  isc_stream_not_defined = 335544502;
  isc_wal_subsys_error = 335544503;
  isc_wal_subsys_corrupt = 335544504;
  isc_no_archive = 335544505;
  isc_shutinprog = 335544506;
  isc_range_in_use = 335544507;
  isc_range_not_found = 335544508;
  isc_charset_not_found = 335544509;
  isc_lock_timeout = 335544510;
  isc_prcnotdef = 335544511;
  isc_prcmismat = 335544512;
  isc_wal_bugcheck = 335544513;
  isc_wal_cant_expand = 335544514;
  isc_codnotdef = 335544515;
  isc_xcpnotdef = 335544516;
  isc_except = 335544517;
  isc_cache_restart = 335544518;
  isc_bad_lock_handle = 335544519;
  isc_jrn_present = 335544520;
  isc_wal_err_rollover2 = 335544521;
  isc_wal_err_logwrite = 335544522;
  isc_wal_err_jrn_comm = 335544523;
  isc_wal_err_expansion = 335544524;
  isc_wal_err_setup = 335544525;
  isc_wal_err_ww_sync = 335544526;
  isc_wal_err_ww_start = 335544527;
  isc_shutdown = 335544528;
  isc_existing_priv_mod = 335544529;
  isc_primary_key_ref = 335544530;
  isc_primary_key_notnull = 335544531;
  isc_ref_cnstrnt_notfound = 335544532;
  isc_foreign_key_notfound = 335544533;
  isc_ref_cnstrnt_update = 335544534;
  isc_check_cnstrnt_update = 335544535;
  isc_check_cnstrnt_del = 335544536;
  isc_integ_index_seg_del = 335544537;
  isc_integ_index_seg_mod = 335544538;
  isc_integ_index_del = 335544539;
  isc_integ_index_mod = 335544540;
  isc_check_trig_del = 335544541;
  isc_check_trig_update = 335544542;
  isc_cnstrnt_fld_del = 335544543;
  isc_cnstrnt_fld_rename = 335544544;
  isc_rel_cnstrnt_update = 335544545;
  isc_constaint_on_view = 335544546;
  isc_invld_cnstrnt_type = 335544547;
  isc_primary_key_exists = 335544548;
  isc_systrig_update = 335544549;
  isc_not_rel_owner = 335544550;
  isc_grant_obj_notfound = 335544551;
  isc_grant_fld_notfound = 335544552;
  isc_grant_nopriv = 335544553;
  isc_nonsql_security_rel = 335544554;
  isc_nonsql_security_fld = 335544555;
  isc_wal_cache_err = 335544556;
  isc_shutfail = 335544557;
  isc_check_constraint = 335544558;
  isc_bad_svc_handle = 335544559;
  isc_shutwarn = 335544560;
  isc_wrospbver = 335544561;
  isc_bad_spb_form = 335544562;
  isc_svcnotdef = 335544563;
  isc_no_jrn = 335544564;
  isc_transliteration_failed = 335544565;
  isc_start_cm_for_wal = 335544566;
  isc_wal_ovflow_log_required = 335544567;
  isc_text_subtype = 335544568;
  isc_dsql_error = 335544569;
  isc_dsql_command_err = 335544570;
  isc_dsql_constant_err = 335544571;
  isc_dsql_cursor_err = 335544572;
  isc_dsql_datatype_err = 335544573;
  isc_dsql_decl_err = 335544574;
  isc_dsql_cursor_update_err = 335544575;
  isc_dsql_cursor_open_err = 335544576;
  isc_dsql_cursor_close_err = 335544577;
  isc_dsql_field_err = 335544578;
  isc_dsql_internal_err = 335544579;
  isc_dsql_relation_err = 335544580;
  isc_dsql_procedure_err = 335544581;
  isc_dsql_request_err = 335544582;
  isc_dsql_sqlda_err = 335544583;
  isc_dsql_var_count_err = 335544584;
  isc_dsql_stmt_handle = 335544585;
  isc_dsql_function_err = 335544586;
  isc_dsql_blob_err = 335544587;
  isc_collation_not_found = 335544588;
  isc_collation_not_for_charset = 335544589;
  isc_dsql_dup_option = 335544590;
  isc_dsql_tran_err = 335544591;
  isc_dsql_invalid_array = 335544592;
  isc_dsql_max_arr_dim_exceeded = 335544593;
  isc_dsql_arr_range_error = 335544594;
  isc_dsql_trigger_err = 335544595;
  isc_dsql_subselect_err = 335544596;
  isc_dsql_crdb_prepare_err = 335544597;
  isc_specify_field_err = 335544598;
  isc_num_field_err = 335544599;
  isc_col_name_err = 335544600;
  isc_where_err = 335544601;
  isc_table_view_err = 335544602;
  isc_distinct_err = 335544603;
  isc_key_field_count_err = 335544604;
  isc_subquery_err = 335544605;
  isc_expression_eval_err = 335544606;
  isc_node_err = 335544607;
  isc_command_end_err = 335544608;
  isc_index_name = 335544609;
  isc_exception_name = 335544610;
  isc_field_name = 335544611;
  isc_token_err = 335544612;
  isc_union_err = 335544613;
  isc_dsql_construct_err = 335544614;
  isc_field_aggregate_err = 335544615;
  isc_field_ref_err = 335544616;
  isc_order_by_err = 335544617;
  isc_return_mode_err = 335544618;
  isc_extern_func_err = 335544619;
  isc_alias_conflict_err = 335544620;
  isc_procedure_conflict_error = 335544621;
  isc_relation_conflict_err = 335544622;
  isc_dsql_domain_err = 335544623;
  isc_idx_seg_err = 335544624;
  isc_node_name_err = 335544625;
  isc_table_name = 335544626;
  isc_proc_name = 335544627;
  isc_idx_create_err = 335544628;
  isc_wal_shadow_err = 335544629;
  isc_dependency = 335544630;
  isc_idx_key_err = 335544631;
  isc_dsql_file_length_err = 335544632;
  isc_dsql_shadow_number_err = 335544633;
  isc_dsql_token_unk_err = 335544634;
  isc_dsql_no_relation_alias = 335544635;
  isc_indexname = 335544636;
  isc_no_stream_plan = 335544637;
  isc_stream_twice = 335544638;
  isc_stream_not_found = 335544639;
  isc_collation_requires_text = 335544640;
  isc_dsql_domain_not_found = 335544641;
  isc_index_unused = 335544642;
  isc_dsql_self_join = 335544643;
  isc_stream_bof = 335544644;
  isc_stream_crack = 335544645;
  isc_db_or_file_exists = 335544646;
  isc_invalid_operator = 335544647;
  isc_conn_lost = 335544648;
  isc_bad_checksum = 335544649;
  isc_page_type_err = 335544650;
  isc_ext_readonly_err = 335544651;
  isc_sing_select_err = 335544652;
  isc_psw_attach = 335544653;
  isc_psw_start_trans = 335544654;
  isc_invalid_direction = 335544655;
  isc_dsql_var_conflict = 335544656;
  isc_dsql_no_blob_array = 335544657;
  isc_dsql_base_table = 335544658;
  isc_duplicate_base_table = 335544659;
  isc_view_alias = 335544660;
  isc_index_root_page_full = 335544661;
  isc_dsql_blob_type_unknown = 335544662;
  isc_req_max_clones_exceeded = 335544663;
  isc_dsql_duplicate_spec = 335544664;
  isc_unique_key_violation = 335544665;
  isc_srvr_version_too_old = 335544666;
  isc_drdb_completed_with_errs = 335544667;
  isc_dsql_procedure_use_err = 335544668;
  isc_dsql_count_mismatch = 335544669;
  isc_blob_idx_err = 335544670;
  isc_array_idx_err = 335544671;
  isc_key_field_err = 335544672;
  isc_no_delete = 335544673;
  isc_del_last_field = 335544674;
  isc_sort_err = 335544675;
  isc_sort_mem_err = 335544676;
  isc_version_err = 335544677;
  isc_inval_key_posn = 335544678;
  isc_no_segments_err = 335544679;
  isc_crrp_data_err = 335544680;
  isc_rec_size_err = 335544681;
  isc_dsql_field_ref = 335544682;
  isc_req_depth_exceeded = 335544683;
  isc_no_field_access = 335544684;
  isc_no_dbkey = 335544685;
  isc_jrn_format_err = 335544686;
  isc_jrn_file_full = 335544687;
  isc_dsql_open_cursor_request = 335544688;
  isc_ib_error = 335544689;
  isc_cache_redef = 335544690;
  isc_cache_too_small = 335544691;
  isc_log_redef = 335544692;
  isc_log_too_small = 335544693;
  isc_partition_too_small = 335544694;
  isc_partition_not_supp = 335544695;
  isc_log_length_spec = 335544696;
  isc_precision_err = 335544697;
  isc_scale_nogt = 335544698;
  isc_expec_short = 335544699;
  isc_expec_long = 335544700;
  isc_expec_ushort = 335544701;
  isc_escape_invalid = 335544702;
  isc_svcnoexe = 335544703;
  isc_net_lookup_err = 335544704;
  isc_service_unknown = 335544705;
  isc_host_unknown = 335544706;
  isc_grant_nopriv_on_base = 335544707;
  isc_dyn_fld_ambiguous = 335544708;
  isc_dsql_agg_ref_err = 335544709;
  isc_complex_view = 335544710;
  isc_unprepared_stmt = 335544711;
  isc_expec_positive = 335544712;
  isc_dsql_sqlda_value_err = 335544713;
  isc_invalid_array_id = 335544714;
  isc_extfile_uns_op = 335544715;
  isc_svc_in_use = 335544716;
  isc_err_stack_limit = 335544717;
  isc_invalid_key = 335544718;
  isc_net_init_error = 335544719;
  isc_loadlib_failure = 335544720;
  isc_network_error = 335544721;
  isc_net_connect_err = 335544722;
  isc_net_connect_listen_err = 335544723;
  isc_net_event_connect_err = 335544724;
  isc_net_event_listen_err = 335544725;
  isc_net_read_err = 335544726;
  isc_net_write_err = 335544727;
  isc_integ_index_deactivate = 335544728;
  isc_integ_deactivate_primary = 335544729;
  isc_cse_not_supported = 335544730;
  isc_tra_must_sweep = 335544731;
  isc_unsupported_network_drive = 335544732;
  isc_io_create_err = 335544733;
  isc_io_open_err = 335544734;
  isc_io_close_err = 335544735;
  isc_io_read_err = 335544736;
  isc_io_write_err = 335544737;
  isc_io_delete_err = 335544738;
  isc_io_access_err = 335544739;
  isc_udf_exception = 335544740;
  isc_lost_db_connection = 335544741;
  isc_no_write_user_priv = 335544742;
  isc_token_too_long = 335544743;
  isc_max_att_exceeded = 335544744;
  isc_login_same_as_role_name = 335544745;
  isc_reftable_requires_pk = 335544746;
  isc_usrname_too_long = 335544747;
  isc_password_too_long = 335544748;
  isc_usrname_required = 335544749;
  isc_password_required = 335544750;
  isc_bad_protocol = 335544751;
  isc_dup_usrname_found = 335544752;
  isc_usrname_not_found = 335544753;
  isc_error_adding_sec_record = 335544754;
  isc_error_modifying_sec_record = 335544755;
  isc_error_deleting_sec_record = 335544756;
  isc_error_updating_sec_db = 335544757;
  isc_sort_rec_size_err = 335544758;
  isc_bad_default_value = 335544759;
  isc_invalid_clause = 335544760;
  isc_too_many_handles = 335544761;
  isc_optimizer_blk_exc = 335544762;
  isc_invalid_string_constant = 335544763;
  isc_transitional_date = 335544764;
  isc_read_only_database = 335544765;
  isc_must_be_dialect_2_and_up = 335544766;
  isc_blob_filter_exception = 335544767;
  isc_exception_access_violation = 335544768;
  isc_exception_datatype_missalignment = 335544769;
  isc_exception_array_bounds_exceeded = 335544770;
  isc_exception_float_denormal_operand = 335544771;
  isc_exception_float_divide_by_zero = 335544772;
  isc_exception_float_inexact_result = 335544773;
  isc_exception_float_invalid_operand = 335544774;
  isc_exception_float_overflow = 335544775;
  isc_exception_float_stack_check = 335544776;
  isc_exception_float_underflow = 335544777;
  isc_exception_integer_divide_by_zero = 335544778;
  isc_exception_integer_overflow = 335544779;
  isc_exception_unknown = 335544780;
  isc_exception_stack_overflow = 335544781;
  isc_exception_sigsegv = 335544782;
  isc_exception_sigill = 335544783;
  isc_exception_sigbus = 335544784;
  isc_exception_sigfpe = 335544785;
  isc_ext_file_delete = 335544786;
  isc_ext_file_modify = 335544787;
  isc_adm_task_denied = 335544788;
  isc_extract_input_mismatch = 335544789;
  isc_insufficient_svc_privileges = 335544790;
  isc_file_in_use = 335544791;
  isc_service_att_err = 335544792;
  isc_ddl_not_allowed_by_db_sql_dial = 335544793;
  isc_cancelled = 335544794;
  isc_unexp_spb_form = 335544795;
  isc_sql_dialect_datatype_unsupport = 335544796;
  isc_svcnouser = 335544797;
  isc_depend_on_uncommitted_rel = 335544798;
  isc_svc_name_missing = 335544799;
  isc_too_many_contexts = 335544800;
  isc_datype_notsup = 335544801;
  isc_dialect_reset_warning = 335544802;
  isc_dialect_not_changed = 335544803;
  isc_database_create_failed = 335544804;
  isc_inv_dialect_specified = 335544805;
  isc_valid_db_dialects = 335544806;
  isc_sqlwarn = 335544807;
  isc_dtype_renamed = 335544808;
  isc_extern_func_dir_error = 335544809;
  isc_date_range_exceeded = 335544810;
  isc_inv_client_dialect_specified = 335544811;
  isc_valid_client_dialects = 335544812;
  isc_optimizer_between_err = 335544813;
  isc_service_not_supported = 335544814;
  isc_generator_name = 335544815;
  isc_udf_name = 335544816;
  isc_bad_limit_param = 335544817;
  isc_bad_skip_param = 335544818;
  isc_io_32bit_exceeded_err = 335544819;
  isc_invalid_savepoint = 335544820;
  isc_dsql_column_pos_err = 335544821;
  isc_dsql_agg_where_err = 335544822;
  isc_dsql_agg_group_err = 335544823;
  isc_dsql_agg_column_err = 335544824;
  isc_dsql_agg_having_err = 335544825;
  isc_dsql_agg_nested_err = 335544826;
  isc_exec_sql_invalid_arg = 335544827;
  isc_exec_sql_invalid_req = 335544828;
  isc_exec_sql_invalid_var = 335544829;
  isc_exec_sql_max_call_exceeded = 335544830;
  isc_conf_access_denied = 335544831;
  isc_wrong_backup_state = 335544832;
  isc_wal_backup_err = 335544833;
  isc_cursor_not_open = 335544834;
  isc_bad_shutdown_mode = 335544835;
  isc_concat_overflow = 335544836;
  isc_bad_substring_offset = 335544837;
  isc_foreign_key_target_doesnt_exist = 335544838;
  isc_foreign_key_references_present = 335544839;
  isc_no_update = 335544840;
  isc_cursor_already_open = 335544841;
  isc_stack_trace = 335544842;
  isc_ctx_var_not_found = 335544843;
  isc_ctx_namespace_invalid = 335544844;
  isc_ctx_too_big = 335544845;
  isc_ctx_bad_argument = 335544846;
  isc_identifier_too_long = 335544847;
  isc_except2 = 335544848;
  isc_malformed_string = 335544849;
  isc_prc_out_param_mismatch = 335544850;
  isc_command_end_err2 = 335544851;
  isc_partner_idx_incompat_type = 335544852;
  isc_bad_substring_length = 335544853;
  isc_charset_not_installed = 335544854;
  isc_collation_not_installed = 335544855;
  isc_att_shutdown = 335544856;
  isc_blobtoobig = 335544857;
  isc_must_have_phys_field = 335544858;
  isc_invalid_time_precision = 335544859;
  isc_blob_convert_error = 335544860;
  isc_array_convert_error = 335544861;
  isc_record_lock_not_supp = 335544862;
  isc_partner_idx_not_found = 335544863;
  isc_tra_num_exc = 335544864;
  isc_field_disappeared = 335544865;
  isc_met_wrong_gtt_scope = 335544866;
  isc_subtype_for_internal_use = 335544867;
  isc_illegal_prc_type = 335544868;
  isc_invalid_sort_datatype = 335544869;
  isc_collation_name = 335544870;
  isc_domain_name = 335544871;
  isc_domnotdef = 335544872;
  isc_array_max_dimensions = 335544873;
  isc_max_db_per_trans_allowed = 335544874;
  isc_bad_debug_format = 335544875;
  isc_bad_proc_BLR = 335544876;
  isc_key_too_big = 335544877;
  isc_concurrent_transaction = 335544878;
  isc_not_valid_for_var = 335544879;
  isc_not_valid_for = 335544880;
  isc_need_difference = 335544881;
  isc_long_login = 335544882;
  isc_fldnotdef2 = 335544883;
  isc_invalid_similar_pattern = 335544884;
  isc_bad_teb_form = 335544885;
  isc_tpb_multiple_txn_isolation = 335544886;
  isc_tpb_reserv_before_table = 335544887;
  isc_tpb_multiple_spec = 335544888;
  isc_tpb_option_without_rc = 335544889;
  isc_tpb_conflicting_options = 335544890;
  isc_tpb_reserv_missing_tlen = 335544891;
  isc_tpb_reserv_long_tlen = 335544892;
  isc_tpb_reserv_missing_tname = 335544893;
  isc_tpb_reserv_corrup_tlen = 335544894;
  isc_tpb_reserv_null_tlen = 335544895;
  isc_tpb_reserv_relnotfound = 335544896;
  isc_tpb_reserv_baserelnotfound = 335544897;
  isc_tpb_missing_len = 335544898;
  isc_tpb_missing_value = 335544899;
  isc_tpb_corrupt_len = 335544900;
  isc_tpb_null_len = 335544901;
  isc_tpb_overflow_len = 335544902;
  isc_tpb_invalid_value = 335544903;
  isc_tpb_reserv_stronger_wng = 335544904;
  isc_tpb_reserv_stronger = 335544905;
  isc_tpb_reserv_max_recursion = 335544906;
  isc_tpb_reserv_virtualtbl = 335544907;
  isc_tpb_reserv_systbl = 335544908;
  isc_tpb_reserv_temptbl = 335544909;
  isc_tpb_readtxn_after_writelock = 335544910;
  isc_tpb_writelock_after_readtxn = 335544911;
  isc_time_range_exceeded = 335544912;
  isc_datetime_range_exceeded = 335544913;
  isc_string_truncation = 335544914;
  isc_blob_truncation = 335544915;
  isc_numeric_out_of_range = 335544916;
  isc_shutdown_timeout = 335544917;
  isc_att_handle_busy = 335544918;
  isc_bad_udf_freeit = 335544919;
  isc_eds_provider_not_found = 335544920;
  isc_eds_connection = 335544921;
  isc_eds_preprocess = 335544922;
  isc_eds_stmt_expected = 335544923;
  isc_eds_prm_name_expected = 335544924;
  isc_eds_unclosed_comment = 335544925;
  isc_eds_statement = 335544926;
  isc_eds_input_prm_mismatch = 335544927;
  isc_eds_output_prm_mismatch = 335544928;
  isc_eds_input_prm_not_set = 335544929;
  isc_too_big_blr = 335544930;
  isc_montabexh = 335544931;
  isc_modnotfound = 335544932;
  isc_nothing_to_cancel = 335544933;
  isc_ibutil_not_loaded = 335544934;
  isc_circular_computed = 335544935;
  isc_psw_db_error = 335544936;
  isc_invalid_type_datetime_op = 335544937;
  isc_onlycan_add_timetodate = 335544938;
  isc_onlycan_add_datetotime = 335544939;
  isc_onlycansub_tstampfromtstamp = 335544940;
  isc_onlyoneop_mustbe_tstamp = 335544941;
  isc_invalid_extractpart_time = 335544942;
  isc_invalid_extractpart_date = 335544943;
  isc_invalidarg_extract = 335544944;
  isc_sysf_argmustbe_exact = 335544945;
  isc_sysf_argmustbe_exact_or_fp = 335544946;
  isc_sysf_argviolates_uuidtype = 335544947;
  isc_sysf_argviolates_uuidlen = 335544948;
  isc_sysf_argviolates_uuidfmt = 335544949;
  isc_sysf_argviolates_guidigits = 335544950;
  isc_sysf_invalid_addpart_time = 335544951;
  isc_sysf_invalid_add_datetime = 335544952;
  isc_sysf_invalid_addpart_dtime = 335544953;
  isc_sysf_invalid_add_dtime_rc = 335544954;
  isc_sysf_invalid_diff_dtime = 335544955;
  isc_sysf_invalid_timediff = 335544956;
  isc_sysf_invalid_tstamptimediff = 335544957;
  isc_sysf_invalid_datetimediff = 335544958;
  isc_sysf_invalid_diffpart = 335544959;
  isc_sysf_argmustbe_positive = 335544960;
  isc_sysf_basemustbe_positive = 335544961;
  isc_sysf_argnmustbe_nonneg = 335544962;
  isc_sysf_argnmustbe_positive = 335544963;
  isc_sysf_invalid_zeropowneg = 335544964;
  isc_sysf_invalid_negpowfp = 335544965;
  isc_sysf_invalid_scale = 335544966;
  isc_sysf_argmustbe_nonneg = 335544967;
  isc_sysf_binuuid_mustbe_str = 335544968;
  isc_sysf_binuuid_wrongsize = 335544969;
  isc_missing_required_spb = 335544970;
  isc_net_server_shutdown = 335544971;
  isc_bad_conn_str = 335544972;
  isc_bad_epb_form = 335544973;
  isc_no_threads = 335544974;
  isc_net_event_connect_timeout = 335544975;
  isc_sysf_argmustbe_nonzero = 335544976;
  isc_sysf_argmustbe_range_inc1_1 = 335544977;
  isc_sysf_argmustbe_gteq_one = 335544978;
  isc_sysf_argmustbe_range_exc1_1 = 335544979;
  isc_internal_rejected_params = 335544980;
  isc_sysf_fp_overflow = 335544981;
  isc_udf_fp_overflow = 335544982;
  isc_udf_fp_nan = 335544983;
  isc_instance_conflict = 335544984;
  isc_out_of_temp_space = 335544985;
  isc_eds_expl_tran_ctrl = 335544986;
  isc_no_trusted_spb = 335544987;
  isc_package_name = 335544988;
  isc_cannot_make_not_null = 335544989;
  isc_feature_removed = 335544990;
  isc_view_name = 335544991;
  isc_lock_dir_access = 335544992;
  isc_invalid_fetch_option = 335544993;
  isc_bad_fun_BLR = 335544994;
  isc_func_pack_not_implemented = 335544995;
  isc_proc_pack_not_implemented = 335544996;
  isc_eem_func_not_returned = 335544997;
  isc_eem_proc_not_returned = 335544998;
  isc_eem_trig_not_returned = 335544999;
  isc_eem_bad_plugin_ver = 335545000;
  isc_eem_engine_notfound = 335545001;
  isc_attachment_in_use = 335545002;
  isc_transaction_in_use = 335545003;
  isc_pman_cannot_load_plugin = 335545004;
  isc_pman_module_notfound = 335545005;
  isc_pman_entrypoint_notfound = 335545006;
  isc_pman_module_bad = 335545007;
  isc_pman_plugin_notfound = 335545008;
  isc_sysf_invalid_trig_namespace = 335545009;
  isc_unexpected_null = 335545010;
  isc_type_notcompat_blob = 335545011;
  isc_invalid_date_val = 335545012;
  isc_invalid_time_val = 335545013;
  isc_invalid_timestamp_val = 335545014;
  isc_invalid_index_val = 335545015;
  isc_formatted_exception = 335545016;
  isc_async_active = 335545017;
  isc_private_function = 335545018;
  isc_private_procedure = 335545019;
  isc_request_outdated = 335545020;
  isc_bad_events_handle = 335545021;
  isc_cannot_copy_stmt = 335545022;
  isc_invalid_boolean_usage = 335545023;
  isc_sysf_argscant_both_be_zero = 335545024;
  isc_spb_no_id = 335545025;
  isc_ee_blr_mismatch_null = 335545026;
  isc_ee_blr_mismatch_length = 335545027;
  isc_ss_out_of_bounds = 335545028;
  isc_missing_data_structures = 335545029;
  isc_protect_sys_tab = 335545030;
  isc_libtommath_generic = 335545031;
  isc_wroblrver2 = 335545032;
  isc_trunc_limits = 335545033;
  isc_info_access = 335545034;
  isc_svc_no_stdin = 335545035;
  isc_svc_start_failed = 335545036;
  isc_svc_no_switches = 335545037;
  isc_svc_bad_size = 335545038;
  isc_no_crypt_plugin = 335545039;
  isc_cp_name_too_long = 335545040;
  isc_cp_process_active = 335545041;
  isc_cp_already_crypted = 335545042;
  isc_decrypt_error = 335545043;
  isc_no_providers = 335545044;
  isc_null_spb = 335545045;
  isc_max_args_exceeded = 335545046;
  isc_ee_blr_mismatch_names_count = 335545047;
  isc_ee_blr_mismatch_name_not_found = 335545048;
  isc_bad_result_set = 335545049;
  isc_wrong_message_length = 335545050;
  isc_no_output_format = 335545051;
  isc_item_finish = 335545052;
  isc_miss_config = 335545053;
  isc_conf_line = 335545054;
  isc_conf_include = 335545055;
  isc_include_depth = 335545056;
  isc_include_miss = 335545057;
  isc_protect_ownership = 335545058;
  isc_badvarnum = 335545059;
  isc_sec_context = 335545060;
  isc_multi_segment = 335545061;
  isc_login_changed = 335545062;
  isc_auth_handshake_limit = 335545063;
  isc_wirecrypt_incompatible = 335545064;
  isc_miss_wirecrypt = 335545065;
  isc_wirecrypt_key = 335545066;
  isc_wirecrypt_plugin = 335545067;
  isc_secdb_name = 335545068;
  isc_auth_data = 335545069;
  isc_auth_datalength = 335545070;
  isc_info_unprepared_stmt = 335545071;
  isc_idx_key_value = 335545072;
  isc_forupdate_virtualtbl = 335545073;
  isc_forupdate_systbl = 335545074;
  isc_forupdate_temptbl = 335545075;
  isc_cant_modify_sysobj = 335545076;
  isc_server_misconfigured = 335545077;
  isc_alter_role = 335545078;
  isc_map_already_exists = 335545079;
  isc_map_not_exists = 335545080;
  isc_map_load = 335545081;
  isc_map_aster = 335545082;
  isc_map_multi = 335545083;
  isc_map_undefined = 335545084;
  isc_baddpb_damaged_mode = 335545085;
  isc_baddpb_buffers_range = 335545086;
  isc_baddpb_temp_buffers = 335545087;
  isc_map_nodb = 335545088;
  isc_map_notable = 335545089;
  isc_miss_trusted_role = 335545090;
  isc_set_invalid_role = 335545091;
  isc_cursor_not_positioned = 335545092;
  isc_dup_attribute = 335545093;
  isc_dyn_no_priv = 335545094;
  isc_dsql_cant_grant_option = 335545095;
  isc_read_conflict = 335545096;
  isc_crdb_load = 335545097;
  isc_crdb_nodb = 335545098;
  isc_crdb_notable = 335545099;
  isc_interface_version_too_old = 335545100;
  isc_fun_param_mismatch = 335545101;
  isc_savepoint_backout_err = 335545102;
  isc_domain_primary_key_notnull = 335545103;
  isc_invalid_attachment_charset = 335545104;
  isc_map_down = 335545105;
  isc_login_error = 335545106;
  isc_already_opened = 335545107;
  isc_bad_crypt_key = 335545108;
  isc_encrypt_error = 335545109;
  isc_gfix_db_name = 335740929;
  isc_gfix_invalid_sw = 335740930;
  isc_gfix_incmp_sw = 335740932;
  isc_gfix_replay_req = 335740933;
  isc_gfix_pgbuf_req = 335740934;
  isc_gfix_val_req = 335740935;
  isc_gfix_pval_req = 335740936;
  isc_gfix_trn_req = 335740937;
  isc_gfix_full_req = 335740940;
  isc_gfix_usrname_req = 335740941;
  isc_gfix_pass_req = 335740942;
  isc_gfix_subs_name = 335740943;
  isc_gfix_wal_req = 335740944;
  isc_gfix_sec_req = 335740945;
  isc_gfix_nval_req = 335740946;
  isc_gfix_type_shut = 335740947;
  isc_gfix_retry = 335740948;
  isc_gfix_retry_db = 335740951;
  isc_gfix_exceed_max = 335740991;
  isc_gfix_corrupt_pool = 335740992;
  isc_gfix_mem_exhausted = 335740993;
  isc_gfix_bad_pool = 335740994;
  isc_gfix_trn_not_valid = 335740995;
  isc_gfix_unexp_eoi = 335741012;
  isc_gfix_recon_fail = 335741018;
  isc_gfix_trn_unknown = 335741036;
  isc_gfix_mode_req = 335741038;
  isc_gfix_pzval_req = 335741042;
  isc_dsql_dbkey_from_non_table = 336003074;
  isc_dsql_transitional_numeric = 336003075;
  isc_dsql_dialect_warning_expr = 336003076;
  isc_sql_db_dialect_dtype_unsupport = 336003077;
  isc_sql_dialect_conflict_num = 336003079;
  isc_dsql_warning_number_ambiguous = 336003080;
  isc_dsql_warning_number_ambiguous1 = 336003081;
  isc_dsql_warn_precision_ambiguous = 336003082;
  isc_dsql_warn_precision_ambiguous1 = 336003083;
  isc_dsql_warn_precision_ambiguous2 = 336003084;
  isc_dsql_ambiguous_field_name = 336003085;
  isc_dsql_udf_return_pos_err = 336003086;
  isc_dsql_invalid_label = 336003087;
  isc_dsql_datatypes_not_comparable = 336003088;
  isc_dsql_cursor_invalid = 336003089;
  isc_dsql_cursor_redefined = 336003090;
  isc_dsql_cursor_not_found = 336003091;
  isc_dsql_cursor_exists = 336003092;
  isc_dsql_cursor_rel_ambiguous = 336003093;
  isc_dsql_cursor_rel_not_found = 336003094;
  isc_dsql_cursor_not_open = 336003095;
  isc_dsql_type_not_supp_ext_tab = 336003096;
  isc_dsql_feature_not_supported_ods = 336003097;
  isc_primary_key_required = 336003098;
  isc_upd_ins_doesnt_match_pk = 336003099;
  isc_upd_ins_doesnt_match_matching = 336003100;
  isc_upd_ins_with_complex_view = 336003101;
  isc_dsql_incompatible_trigger_type = 336003102;
  isc_dsql_db_trigger_type_cant_change = 336003103;
  isc_dsql_record_version_table = 336003104;
  isc_dsql_invalid_sqlda_version = 336003105;
  isc_dsql_sqlvar_index = 336003106;
  isc_dsql_no_sqlind = 336003107;
  isc_dsql_no_sqldata = 336003108;
  isc_dsql_no_input_sqlda = 336003109;
  isc_dsql_no_output_sqlda = 336003110;
  isc_dsql_wrong_param_num = 336003111;
  isc_dyn_filter_not_found = 336068645;
  isc_dyn_func_not_found = 336068649;
  isc_dyn_index_not_found = 336068656;
  isc_dyn_view_not_found = 336068662;
  isc_dyn_domain_not_found = 336068697;
  isc_dyn_cant_modify_auto_trig = 336068717;
  isc_dyn_dup_table = 336068740;
  isc_dyn_proc_not_found = 336068748;
  isc_dyn_exception_not_found = 336068752;
  isc_dyn_proc_param_not_found = 336068754;
  isc_dyn_trig_not_found = 336068755;
  isc_dyn_charset_not_found = 336068759;
  isc_dyn_collation_not_found = 336068760;
  isc_dyn_role_not_found = 336068763;
  isc_dyn_name_longer = 336068767;
  isc_dyn_column_does_not_exist = 336068784;
  isc_dyn_role_does_not_exist = 336068796;
  isc_dyn_no_grant_admin_opt = 336068797;
  isc_dyn_user_not_role_member = 336068798;
  isc_dyn_delete_role_failed = 336068799;
  isc_dyn_grant_role_to_user = 336068800;
  isc_dyn_inv_sql_role_name = 336068801;
  isc_dyn_dup_sql_role = 336068802;
  isc_dyn_kywd_spec_for_role = 336068803;
  isc_dyn_roles_not_supported = 336068804;
  isc_dyn_domain_name_exists = 336068812;
  isc_dyn_field_name_exists = 336068813;
  isc_dyn_dependency_exists = 336068814;
  isc_dyn_dtype_invalid = 336068815;
  isc_dyn_char_fld_too_small = 336068816;
  isc_dyn_invalid_dtype_conversion = 336068817;
  isc_dyn_dtype_conv_invalid = 336068818;
  isc_dyn_zero_len_id = 336068820;
  isc_dyn_gen_not_found = 336068822;
  isc_max_coll_per_charset = 336068829;
  isc_invalid_coll_attr = 336068830;
  isc_dyn_wrong_gtt_scope = 336068840;
  isc_dyn_coll_used_table = 336068843;
  isc_dyn_coll_used_domain = 336068844;
  isc_dyn_cannot_del_syscoll = 336068845;
  isc_dyn_cannot_del_def_coll = 336068846;
  isc_dyn_table_not_found = 336068849;
  isc_dyn_coll_used_procedure = 336068851;
  isc_dyn_scale_too_big = 336068852;
  isc_dyn_precision_too_small = 336068853;
  isc_dyn_miss_priv_warning = 336068855;
  isc_dyn_ods_not_supp_feature = 336068856;
  isc_dyn_cannot_addrem_computed = 336068857;
  isc_dyn_no_empty_pw = 336068858;
  isc_dyn_dup_index = 336068859;
  isc_dyn_package_not_found = 336068864;
  isc_dyn_schema_not_found = 336068865;
  isc_dyn_cannot_mod_sysproc = 336068866;
  isc_dyn_cannot_mod_systrig = 336068867;
  isc_dyn_cannot_mod_sysfunc = 336068868;
  isc_dyn_invalid_ddl_proc = 336068869;
  isc_dyn_invalid_ddl_trig = 336068870;
  isc_dyn_funcnotdef_package = 336068871;
  isc_dyn_procnotdef_package = 336068872;
  isc_dyn_funcsignat_package = 336068873;
  isc_dyn_procsignat_package = 336068874;
  isc_dyn_defvaldecl_package_proc = 336068875;
  isc_dyn_package_body_exists = 336068877;
  isc_dyn_invalid_ddl_func = 336068878;
  isc_dyn_newfc_oldsyntax = 336068879;
  isc_dyn_func_param_not_found = 336068886;
  isc_dyn_routine_param_not_found = 336068887;
  isc_dyn_routine_param_ambiguous = 336068888;
  isc_dyn_coll_used_function = 336068889;
  isc_dyn_domain_used_function = 336068890;
  isc_dyn_alter_user_no_clause = 336068891;
  isc_dyn_duplicate_package_item = 336068894;
  isc_dyn_cant_modify_sysobj = 336068895;
  isc_dyn_cant_use_zero_increment = 336068896;
  isc_dyn_cant_use_in_foreignkey = 336068897;
  isc_dyn_defvaldecl_package_func = 336068898;
  isc_gbak_unknown_switch = 336330753;
  isc_gbak_page_size_missing = 336330754;
  isc_gbak_page_size_toobig = 336330755;
  isc_gbak_redir_ouput_missing = 336330756;
  isc_gbak_switches_conflict = 336330757;
  isc_gbak_unknown_device = 336330758;
  isc_gbak_no_protection = 336330759;
  isc_gbak_page_size_not_allowed = 336330760;
  isc_gbak_multi_source_dest = 336330761;
  isc_gbak_filename_missing = 336330762;
  isc_gbak_dup_inout_names = 336330763;
  isc_gbak_inv_page_size = 336330764;
  isc_gbak_db_specified = 336330765;
  isc_gbak_db_exists = 336330766;
  isc_gbak_unk_device = 336330767;
  isc_gbak_blob_info_failed = 336330772;
  isc_gbak_unk_blob_item = 336330773;
  isc_gbak_get_seg_failed = 336330774;
  isc_gbak_close_blob_failed = 336330775;
  isc_gbak_open_blob_failed = 336330776;
  isc_gbak_put_blr_gen_id_failed = 336330777;
  isc_gbak_unk_type = 336330778;
  isc_gbak_comp_req_failed = 336330779;
  isc_gbak_start_req_failed = 336330780;
  isc_gbak_rec_failed = 336330781;
  isc_gbak_rel_req_failed = 336330782;
  isc_gbak_db_info_failed = 336330783;
  isc_gbak_no_db_desc = 336330784;
  isc_gbak_db_create_failed = 336330785;
  isc_gbak_decomp_len_error = 336330786;
  isc_gbak_tbl_missing = 336330787;
  isc_gbak_blob_col_missing = 336330788;
  isc_gbak_create_blob_failed = 336330789;
  isc_gbak_put_seg_failed = 336330790;
  isc_gbak_rec_len_exp = 336330791;
  isc_gbak_inv_rec_len = 336330792;
  isc_gbak_exp_data_type = 336330793;
  isc_gbak_gen_id_failed = 336330794;
  isc_gbak_unk_rec_type = 336330795;
  isc_gbak_inv_bkup_ver = 336330796;
  isc_gbak_missing_bkup_desc = 336330797;
  isc_gbak_string_trunc = 336330798;
  isc_gbak_cant_rest_record = 336330799;
  isc_gbak_send_failed = 336330800;
  isc_gbak_no_tbl_name = 336330801;
  isc_gbak_unexp_eof = 336330802;
  isc_gbak_db_format_too_old = 336330803;
  isc_gbak_inv_array_dim = 336330804;
  isc_gbak_xdr_len_expected = 336330807;
  isc_gbak_open_bkup_error = 336330817;
  isc_gbak_open_error = 336330818;
  isc_gbak_missing_block_fac = 336330934;
  isc_gbak_inv_block_fac = 336330935;
  isc_gbak_block_fac_specified = 336330936;
  isc_gbak_missing_username = 336330940;
  isc_gbak_missing_password = 336330941;
  isc_gbak_missing_skipped_bytes = 336330952;
  isc_gbak_inv_skipped_bytes = 336330953;
  isc_gbak_err_restore_charset = 336330965;
  isc_gbak_err_restore_collation = 336330967;
  isc_gbak_read_error = 336330972;
  isc_gbak_write_error = 336330973;
  isc_gbak_db_in_use = 336330985;
  isc_gbak_sysmemex = 336330990;
  isc_gbak_restore_role_failed = 336331002;
  isc_gbak_role_op_missing = 336331005;
  isc_gbak_page_buffers_missing = 336331010;
  isc_gbak_page_buffers_wrong_param = 336331011;
  isc_gbak_page_buffers_restore = 336331012;
  isc_gbak_inv_size = 336331014;
  isc_gbak_file_outof_sequence = 336331015;
  isc_gbak_join_file_missing = 336331016;
  isc_gbak_stdin_not_supptd = 336331017;
  isc_gbak_stdout_not_supptd = 336331018;
  isc_gbak_bkup_corrupt = 336331019;
  isc_gbak_unk_db_file_spec = 336331020;
  isc_gbak_hdr_write_failed = 336331021;
  isc_gbak_disk_space_ex = 336331022;
  isc_gbak_size_lt_min = 336331023;
  isc_gbak_svc_name_missing = 336331025;
  isc_gbak_not_ownr = 336331026;
  isc_gbak_mode_req = 336331031;
  isc_gbak_just_data = 336331033;
  isc_gbak_data_only = 336331034;
  isc_gbak_missing_interval = 336331078;
  isc_gbak_wrong_interval = 336331079;
  isc_gbak_verify_verbint = 336331081;
  isc_gbak_option_only_restore = 336331082;
  isc_gbak_option_only_backup = 336331083;
  isc_gbak_option_conflict = 336331084;
  isc_gbak_param_conflict = 336331085;
  isc_gbak_option_repeated = 336331086;
  isc_gbak_max_dbkey_recursion = 336331091;
  isc_gbak_max_dbkey_length = 336331092;
  isc_gbak_invalid_metadata = 336331093;
  isc_gbak_invalid_data = 336331094;
  isc_gbak_inv_bkup_ver2 = 336331096;
  isc_gbak_db_format_too_old2 = 336331100;
  isc_dsql_too_old_ods = 336397205;
  isc_dsql_table_not_found = 336397206;
  isc_dsql_view_not_found = 336397207;
  isc_dsql_line_col_error = 336397208;
  isc_dsql_unknown_pos = 336397209;
  isc_dsql_no_dup_name = 336397210;
  isc_dsql_too_many_values = 336397211;
  isc_dsql_no_array_computed = 336397212;
  isc_dsql_implicit_domain_name = 336397213;
  isc_dsql_only_can_subscript_array = 336397214;
  isc_dsql_max_sort_items = 336397215;
  isc_dsql_max_group_items = 336397216;
  isc_dsql_conflicting_sort_field = 336397217;
  isc_dsql_derived_table_more_columns = 336397218;
  isc_dsql_derived_table_less_columns = 336397219;
  isc_dsql_derived_field_unnamed = 336397220;
  isc_dsql_derived_field_dup_name = 336397221;
  isc_dsql_derived_alias_select = 336397222;
  isc_dsql_derived_alias_field = 336397223;
  isc_dsql_auto_field_bad_pos = 336397224;
  isc_dsql_cte_wrong_reference = 336397225;
  isc_dsql_cte_cycle = 336397226;
  isc_dsql_cte_outer_join = 336397227;
  isc_dsql_cte_mult_references = 336397228;
  isc_dsql_cte_not_a_union = 336397229;
  isc_dsql_cte_nonrecurs_after_recurs = 336397230;
  isc_dsql_cte_wrong_clause = 336397231;
  isc_dsql_cte_union_all = 336397232;
  isc_dsql_cte_miss_nonrecursive = 336397233;
  isc_dsql_cte_nested_with = 336397234;
  isc_dsql_col_more_than_once_using = 336397235;
  isc_dsql_unsupp_feature_dialect = 336397236;
  isc_dsql_cte_not_used = 336397237;
  isc_dsql_col_more_than_once_view = 336397238;
  isc_dsql_unsupported_in_auto_trans = 336397239;
  isc_dsql_eval_unknode = 336397240;
  isc_dsql_agg_wrongarg = 336397241;
  isc_dsql_agg2_wrongarg = 336397242;
  isc_dsql_nodateortime_pm_string = 336397243;
  isc_dsql_invalid_datetime_subtract = 336397244;
  isc_dsql_invalid_dateortime_add = 336397245;
  isc_dsql_invalid_type_minus_date = 336397246;
  isc_dsql_nostring_addsub_dial3 = 336397247;
  isc_dsql_invalid_type_addsub_dial3 = 336397248;
  isc_dsql_invalid_type_multip_dial1 = 336397249;
  isc_dsql_nostring_multip_dial3 = 336397250;
  isc_dsql_invalid_type_multip_dial3 = 336397251;
  isc_dsql_mustuse_numeric_div_dial1 = 336397252;
  isc_dsql_nostring_div_dial3 = 336397253;
  isc_dsql_invalid_type_div_dial3 = 336397254;
  isc_dsql_nostring_neg_dial3 = 336397255;
  isc_dsql_invalid_type_neg = 336397256;
  isc_dsql_max_distinct_items = 336397257;
  isc_dsql_alter_charset_failed = 336397258;
  isc_dsql_comment_on_failed = 336397259;
  isc_dsql_create_func_failed = 336397260;
  isc_dsql_alter_func_failed = 336397261;
  isc_dsql_create_alter_func_failed = 336397262;
  isc_dsql_drop_func_failed = 336397263;
  isc_dsql_recreate_func_failed = 336397264;
  isc_dsql_create_proc_failed = 336397265;
  isc_dsql_alter_proc_failed = 336397266;
  isc_dsql_create_alter_proc_failed = 336397267;
  isc_dsql_drop_proc_failed = 336397268;
  isc_dsql_recreate_proc_failed = 336397269;
  isc_dsql_create_trigger_failed = 336397270;
  isc_dsql_alter_trigger_failed = 336397271;
  isc_dsql_create_alter_trigger_failed = 336397272;
  isc_dsql_drop_trigger_failed = 336397273;
  isc_dsql_recreate_trigger_failed = 336397274;
  isc_dsql_create_collation_failed = 336397275;
  isc_dsql_drop_collation_failed = 336397276;
  isc_dsql_create_domain_failed = 336397277;
  isc_dsql_alter_domain_failed = 336397278;
  isc_dsql_drop_domain_failed = 336397279;
  isc_dsql_create_except_failed = 336397280;
  isc_dsql_alter_except_failed = 336397281;
  isc_dsql_create_alter_except_failed = 336397282;
  isc_dsql_recreate_except_failed = 336397283;
  isc_dsql_drop_except_failed = 336397284;
  isc_dsql_create_sequence_failed = 336397285;
  isc_dsql_create_table_failed = 336397286;
  isc_dsql_alter_table_failed = 336397287;
  isc_dsql_drop_table_failed = 336397288;
  isc_dsql_recreate_table_failed = 336397289;
  isc_dsql_create_pack_failed = 336397290;
  isc_dsql_alter_pack_failed = 336397291;
  isc_dsql_create_alter_pack_failed = 336397292;
  isc_dsql_drop_pack_failed = 336397293;
  isc_dsql_recreate_pack_failed = 336397294;
  isc_dsql_create_pack_body_failed = 336397295;
  isc_dsql_drop_pack_body_failed = 336397296;
  isc_dsql_recreate_pack_body_failed = 336397297;
  isc_dsql_create_view_failed = 336397298;
  isc_dsql_alter_view_failed = 336397299;
  isc_dsql_create_alter_view_failed = 336397300;
  isc_dsql_recreate_view_failed = 336397301;
  isc_dsql_drop_view_failed = 336397302;
  isc_dsql_drop_sequence_failed = 336397303;
  isc_dsql_recreate_sequence_failed = 336397304;
  isc_dsql_drop_index_failed = 336397305;
  isc_dsql_drop_filter_failed = 336397306;
  isc_dsql_drop_shadow_failed = 336397307;
  isc_dsql_drop_role_failed = 336397308;
  isc_dsql_drop_user_failed = 336397309;
  isc_dsql_create_role_failed = 336397310;
  isc_dsql_alter_role_failed = 336397311;
  isc_dsql_alter_index_failed = 336397312;
  isc_dsql_alter_database_failed = 336397313;
  isc_dsql_create_shadow_failed = 336397314;
  isc_dsql_create_filter_failed = 336397315;
  isc_dsql_create_index_failed = 336397316;
  isc_dsql_create_user_failed = 336397317;
  isc_dsql_alter_user_failed = 336397318;
  isc_dsql_grant_failed = 336397319;
  isc_dsql_revoke_failed = 336397320;
  isc_dsql_cte_recursive_aggregate = 336397321;
  isc_dsql_mapping_failed = 336397322;
  isc_dsql_alter_sequence_failed = 336397323;
  isc_dsql_create_generator_failed = 336397324;
  isc_dsql_set_generator_failed = 336397325;
  isc_dsql_wlock_simple = 336397326;
  isc_dsql_firstskip_rows = 336397327;
  isc_dsql_wlock_aggregates = 336397328;
  isc_dsql_wlock_conflict = 336397329;
  isc_dsql_max_exception_arguments = 336397330;
  isc_dsql_string_byte_length = 336397331;
  isc_dsql_string_char_length = 336397332;
  isc_dsql_max_nesting = 336397333;
  isc_gsec_cant_open_db = 336723983;
  isc_gsec_switches_error = 336723984;
  isc_gsec_no_op_spec = 336723985;
  isc_gsec_no_usr_name = 336723986;
  isc_gsec_err_add = 336723987;
  isc_gsec_err_modify = 336723988;
  isc_gsec_err_find_mod = 336723989;
  isc_gsec_err_rec_not_found = 336723990;
  isc_gsec_err_delete = 336723991;
  isc_gsec_err_find_del = 336723992;
  isc_gsec_err_find_disp = 336723996;
  isc_gsec_inv_param = 336723997;
  isc_gsec_op_specified = 336723998;
  isc_gsec_pw_specified = 336723999;
  isc_gsec_uid_specified = 336724000;
  isc_gsec_gid_specified = 336724001;
  isc_gsec_proj_specified = 336724002;
  isc_gsec_org_specified = 336724003;
  isc_gsec_fname_specified = 336724004;
  isc_gsec_mname_specified = 336724005;
  isc_gsec_lname_specified = 336724006;
  isc_gsec_inv_switch = 336724008;
  isc_gsec_amb_switch = 336724009;
  isc_gsec_no_op_specified = 336724010;
  isc_gsec_params_not_allowed = 336724011;
  isc_gsec_incompat_switch = 336724012;
  isc_gsec_inv_username = 336724044;
  isc_gsec_inv_pw_length = 336724045;
  isc_gsec_db_specified = 336724046;
  isc_gsec_db_admin_specified = 336724047;
  isc_gsec_db_admin_pw_specified = 336724048;
  isc_gsec_sql_role_specified = 336724049;
  isc_gstat_unknown_switch = 336920577;
  isc_gstat_retry = 336920578;
  isc_gstat_wrong_ods = 336920579;
  isc_gstat_unexpected_eof = 336920580;
  isc_gstat_open_err = 336920605;
  isc_gstat_read_err = 336920606;
  isc_gstat_sysmemex = 336920607;
  isc_fbsvcmgr_bad_am = 336986113;
  isc_fbsvcmgr_bad_wm = 336986114;
  isc_fbsvcmgr_bad_rs = 336986115;
  isc_fbsvcmgr_info_err = 336986116;
  isc_fbsvcmgr_query_err = 336986117;
  isc_fbsvcmgr_switch_unknown = 336986118;
  isc_fbsvcmgr_bad_sm = 336986159;
  isc_fbsvcmgr_fp_open = 336986160;
  isc_fbsvcmgr_fp_read = 336986161;
  isc_fbsvcmgr_fp_empty = 336986162;
  isc_fbsvcmgr_bad_arg = 336986164;
  isc_fbsvcmgr_info_limbo = 336986170;
  isc_fbsvcmgr_limbo_state = 336986171;
  isc_fbsvcmgr_limbo_advise = 336986172;
  isc_utl_trusted_switch = 337051649;
  isc_nbackup_missing_param = 337117213;
  isc_nbackup_allowed_switches = 337117214;
  isc_nbackup_unknown_param = 337117215;
  isc_nbackup_unknown_switch = 337117216;
  isc_nbackup_nofetchpw_svc = 337117217;
  isc_nbackup_pwfile_error = 337117218;
  isc_nbackup_size_with_lock = 337117219;
  isc_nbackup_no_switch = 337117220;
  isc_nbackup_err_read = 337117223;
  isc_nbackup_err_write = 337117224;
  isc_nbackup_err_seek = 337117225;
  isc_nbackup_err_opendb = 337117226;
  isc_nbackup_err_fadvice = 337117227;
  isc_nbackup_err_createdb = 337117228;
  isc_nbackup_err_openbk = 337117229;
  isc_nbackup_err_createbk = 337117230;
  isc_nbackup_err_eofdb = 337117231;
  isc_nbackup_fixup_wrongstate = 337117232;
  isc_nbackup_err_db = 337117233;
  isc_nbackup_userpw_toolong = 337117234;
  isc_nbackup_lostrec_db = 337117235;
  isc_nbackup_lostguid_db = 337117236;
  isc_nbackup_err_eofhdrdb = 337117237;
  isc_nbackup_db_notlock = 337117238;
  isc_nbackup_lostguid_bk = 337117239;
  isc_nbackup_page_changed = 337117240;
  isc_nbackup_dbsize_inconsistent = 337117241;
  isc_nbackup_failed_lzbk = 337117242;
  isc_nbackup_err_eofhdrbk = 337117243;
  isc_nbackup_invalid_incbk = 337117244;
  isc_nbackup_unsupvers_incbk = 337117245;
  isc_nbackup_invlevel_incbk = 337117246;
  isc_nbackup_wrong_orderbk = 337117247;
  isc_nbackup_err_eofbk = 337117248;
  isc_nbackup_err_copy = 337117249;
  isc_nbackup_err_eofhdr_restdb = 337117250;
  isc_nbackup_lostguid_l0bk = 337117251;
  isc_nbackup_switchd_parameter = 337117255;
  isc_nbackup_user_stop = 337117257;
  isc_nbackup_deco_parse = 337117259;
  isc_trace_conflict_acts = 337182750;
  isc_trace_act_notfound = 337182751;
  isc_trace_switch_once = 337182752;
  isc_trace_param_val_miss = 337182753;
  isc_trace_param_invalid = 337182754;
  isc_trace_switch_unknown = 337182755;
  isc_trace_switch_svc_only = 337182756;
  isc_trace_switch_user_only = 337182757;
  isc_trace_switch_param_miss = 337182758;
  isc_trace_param_act_notcompat = 337182759;
  isc_trace_mandatory_switch_miss = 337182760;

type
{$IFNDEF FPC}
  QWord = UInt64;
{$ENDIF}
  Versioned = class;
  ReferenceCounted = class;
  Disposable = class;
  Status = class;
  Master = class;
  PluginBase = class;
  PluginSet = class;
  ConfigEntry = class;
  Config = class;
  FirebirdConf = class;
  PluginConfig = class;
  PluginFactory = class;
  PluginModule = class;
  PluginManager = class;
  CryptKey = class;
  ConfigManager = class;
  EventCallback = class;
  Blob = class;
  Transaction = class;
  MessageMetadata = class;
  MetadataBuilder = class;
  ResultSet = class;
  Statement = class;
  Batch = class;
  BatchCompletionState = class;
  Replicator = class;
  Request = class;
  Events = class;
  Attachment = class;
  Service = class;
  Provider = class;
  DtcStart = class;
  Dtc = class;
  Auth = class;
  Writer = class;
  ServerBlock = class;
  ClientBlock = class;
  Server = class;
  Client = class;
  UserField = class;
  CharUserField = class;
  IntUserField = class;
  User = class;
  ListUsers = class;
  LogonInfo = class;
  Management = class;
  AuthBlock = class;
  WireCryptPlugin = class;
  CryptKeyCallback = class;
  KeyHolderPlugin = class;
  DbCryptInfo = class;
  DbCryptPlugin = class;
  ExternalContext = class;
  ExternalResultSet = class;
  ExternalFunction = class;
  ExternalProcedure = class;
  ExternalTrigger = class;
  RoutineMetadata = class;
  ExternalEngine = class;
  Timer = class;
  TimerControl = class;
  VersionCallback = class;
  Util = class;
  OffsetsCallback = class;
  XpbBuilder = class;
  TraceConnection = class;
  TraceDatabaseConnection = class;
  TraceTransaction = class;
  TraceParams = class;
  TraceStatement = class;
  TraceSQLStatement = class;
  TraceBLRStatement = class;
  TraceDYNRequest = class;
  TraceContextVariable = class;
  TraceProcedure = class;
  TraceFunction = class;
  TraceTrigger = class;
  TraceServiceConnection = class;
  TraceStatusVector = class;
  TraceSweepInfo = class;
  TraceLogWriter = class;
  TraceInitInfo = class;
  TracePlugin = class;
  TraceFactory = class;
  UdrFunctionFactory = class;
  UdrProcedureFactory = class;
  UdrTriggerFactory = class;
  UdrPlugin = class;
  DecFloat16 = class;
  DecFloat34 = class;
  Int128 = class;
  ReplicatedField = class;
  ReplicatedRecord = class;
  ReplicatedTransaction = class;
  ReplicatedSession = class;
  ProfilerPlugin = class;
  ProfilerSession = class;
  ProfilerStats = class;

  BooleanPtr = ^Boolean;
  BytePtr = ^Byte;
  CardinalPtr = ^Cardinal;
  FB_DEC16Ptr = ^FB_DEC16;
  FB_DEC34Ptr = ^FB_DEC34;
  FB_I128Ptr = ^FB_I128;
  ISC_QUADPtr = ^ISC_QUAD;
  ISC_TIMESTAMP_TZPtr = ^ISC_TIMESTAMP_TZ;
  ISC_TIMESTAMP_TZ_EXPtr = ^ISC_TIMESTAMP_TZ_EX;
  ISC_TIME_TZPtr = ^ISC_TIME_TZ;
  ISC_TIME_TZ_EXPtr = ^ISC_TIME_TZ_EX;
  Int64Ptr = ^Int64;
  IntegerPtr = ^Integer;
  KeyHolderPluginPtr = ^KeyHolderPlugin;
  NativeIntPtr = ^NativeInt;
  PerformanceInfoPtr = ^PerformanceInfo;
  dscPtr = ^Dsc;

  FbException = class(Exception)
   public
    constructor create(Status: Status); virtual;
    destructor Destroy(); override;

    function getStatus: Status;

    class procedure checkException(Status: Status);
    class procedure catchException(Status: Status; e: Exception);
    class procedure setVersionError(Status: Status; interfaceName: AnsiString; currentVersion, expectedVersion: NativeInt);

   private
    Status: Status;
   public
    Code: Cardinal;
  end;

  ReferenceCounted_addRefPtr = procedure(this: ReferenceCounted); cdecl;
  ReferenceCounted_releasePtr = function(this: ReferenceCounted): Integer; cdecl;
  Disposable_disposePtr = procedure(this: Disposable); cdecl;
  Status_initPtr = procedure(this: Status); cdecl;
  Status_getStatePtr = function(this: Status): Cardinal; cdecl;
  Status_setErrors2Ptr = procedure(this: Status; length: Cardinal; value: NativeIntPtr); cdecl;
  Status_setWarnings2Ptr = procedure(this: Status; length: Cardinal; value: NativeIntPtr); cdecl;
  Status_setErrorsPtr = procedure(this: Status; value: NativeIntPtr); cdecl;
  Status_setWarningsPtr = procedure(this: Status; value: NativeIntPtr); cdecl;
  Status_getErrorsPtr = function(this: Status): NativeIntPtr; cdecl;
  Status_getWarningsPtr = function(this: Status): NativeIntPtr; cdecl;
  Status_clonePtr = function(this: Status): Status; cdecl;
  Master_getStatusPtr = function(this: Master): Status; cdecl;
  Master_getDispatcherPtr = function(this: Master): Provider; cdecl;
  Master_getPluginManagerPtr = function(this: Master): PluginManager; cdecl;
  Master_getTimerControlPtr = function(this: Master): TimerControl; cdecl;
  Master_getDtcPtr = function(this: Master): Dtc; cdecl;
  Master_registerAttachmentPtr = function(this: Master; Provider: Provider; Attachment: Attachment): Attachment; cdecl;
  Master_registerTransactionPtr = function(this: Master; Attachment: Attachment; Transaction: Transaction): Transaction; cdecl;
  Master_getMetadataBuilderPtr = function(this: Master; Status: Status; fieldCount: Cardinal): MetadataBuilder; cdecl;
  Master_serverModePtr = function(this: Master; mode: Integer): Integer; cdecl;
  Master_getUtilInterfacePtr = function(this: Master): Util; cdecl;
  Master_getConfigManagerPtr = function(this: Master): ConfigManager; cdecl;
  Master_getProcessExitingPtr = function(this: Master): Boolean; cdecl;
  PluginBase_setOwnerPtr = procedure(this: PluginBase; r: ReferenceCounted); cdecl;
  PluginBase_getOwnerPtr = function(this: PluginBase): ReferenceCounted; cdecl;
  PluginSet_getNamePtr = function(this: PluginSet): PAnsiChar; cdecl;
  PluginSet_getModuleNamePtr = function(this: PluginSet): PAnsiChar; cdecl;
  PluginSet_getPluginPtr = function(this: PluginSet; Status: Status): PluginBase; cdecl;
  PluginSet_nextPtr = procedure(this: PluginSet; Status: Status); cdecl;
  PluginSet_set_Ptr = procedure(this: PluginSet; Status: Status; s: PAnsiChar); cdecl;
  ConfigEntry_getNamePtr = function(this: ConfigEntry): PAnsiChar; cdecl;
  ConfigEntry_getValuePtr = function(this: ConfigEntry): PAnsiChar; cdecl;
  ConfigEntry_getIntValuePtr = function(this: ConfigEntry): Int64; cdecl;
  ConfigEntry_getBoolValuePtr = function(this: ConfigEntry): Boolean; cdecl;
  ConfigEntry_getSubConfigPtr = function(this: ConfigEntry; Status: Status): Config; cdecl;
  Config_findPtr = function(this: Config; Status: Status; name: PAnsiChar): ConfigEntry; cdecl;
  Config_findValuePtr = function(this: Config; Status: Status; name: PAnsiChar; value: PAnsiChar): ConfigEntry; cdecl;
  Config_findPosPtr = function(this: Config; Status: Status; name: PAnsiChar; pos: Cardinal): ConfigEntry; cdecl;
  FirebirdConf_getKeyPtr = function(this: FirebirdConf; name: PAnsiChar): Cardinal; cdecl;
  FirebirdConf_asIntegerPtr = function(this: FirebirdConf; key: Cardinal): Int64; cdecl;
  FirebirdConf_asStringPtr = function(this: FirebirdConf; key: Cardinal): PAnsiChar; cdecl;
  FirebirdConf_asBooleanPtr = function(this: FirebirdConf; key: Cardinal): Boolean; cdecl;
  FirebirdConf_getVersionPtr = function(this: FirebirdConf; Status: Status): Cardinal; cdecl;
  PluginConfig_getConfigFileNamePtr = function(this: PluginConfig): PAnsiChar; cdecl;
  PluginConfig_getDefaultConfigPtr = function(this: PluginConfig; Status: Status): Config; cdecl;
  PluginConfig_getFirebirdConfPtr = function(this: PluginConfig; Status: Status): FirebirdConf; cdecl;
  PluginConfig_setReleaseDelayPtr = procedure(this: PluginConfig; Status: Status; microSeconds: QWord); cdecl;
  PluginFactory_createPluginPtr = function(this: PluginFactory; Status: Status; factoryParameter: PluginConfig): PluginBase; cdecl;
  PluginModule_doCleanPtr = procedure(this: PluginModule); cdecl;
  PluginModule_threadDetachPtr = procedure(this: PluginModule); cdecl;
  PluginManager_registerPluginFactoryPtr = procedure(this: PluginManager; pluginType: Cardinal; defaultName: PAnsiChar;
    factory: PluginFactory); cdecl;
  PluginManager_registerModulePtr = procedure(this: PluginManager; cleanup: PluginModule); cdecl;
  PluginManager_unregisterModulePtr = procedure(this: PluginManager; cleanup: PluginModule); cdecl;
  PluginManager_getPluginsPtr = function(this: PluginManager; Status: Status; pluginType: Cardinal; namesList: PAnsiChar; FirebirdConf: FirebirdConf)
    : PluginSet; cdecl;
  PluginManager_getConfigPtr = function(this: PluginManager; Status: Status; filename: PAnsiChar): Config; cdecl;
  PluginManager_releasePluginPtr = procedure(this: PluginManager; plugin: PluginBase); cdecl;
  CryptKey_setSymmetricPtr = procedure(this: CryptKey; Status: Status; type_: PAnsiChar; keyLength: Cardinal; key: Pointer); cdecl;
  CryptKey_setAsymmetricPtr = procedure(this: CryptKey; Status: Status; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer;
    decryptKeyLength: Cardinal; decryptKey: Pointer); cdecl;
  CryptKey_getEncryptKeyPtr = function(this: CryptKey; length: CardinalPtr): Pointer; cdecl;
  CryptKey_getDecryptKeyPtr = function(this: CryptKey; length: CardinalPtr): Pointer; cdecl;
  ConfigManager_getDirectoryPtr = function(this: ConfigManager; code: Cardinal): PAnsiChar; cdecl;
  ConfigManager_getFirebirdConfPtr = function(this: ConfigManager): FirebirdConf; cdecl;
  ConfigManager_getDatabaseConfPtr = function(this: ConfigManager; dbName: PAnsiChar): FirebirdConf; cdecl;
  ConfigManager_getPluginConfigPtr = function(this: ConfigManager; configuredPlugin: PAnsiChar): Config; cdecl;
  ConfigManager_getInstallDirectoryPtr = function(this: ConfigManager): PAnsiChar; cdecl;
  ConfigManager_getRootDirectoryPtr = function(this: ConfigManager): PAnsiChar; cdecl;
  ConfigManager_getDefaultSecurityDbPtr = function(this: ConfigManager): PAnsiChar; cdecl;
  EventCallback_eventCallbackFunctionPtr = procedure(this: EventCallback; length: Cardinal; Events: BytePtr); cdecl;
  Blob_getInfoPtr = procedure(this: Blob; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); cdecl;
  Blob_getSegmentPtr = function(this: Blob; Status: Status; bufferLength: Cardinal; buffer: Pointer; segmentLength: CardinalPtr): Integer; cdecl;
  Blob_putSegmentPtr = procedure(this: Blob; Status: Status; length: Cardinal; buffer: Pointer); cdecl;
  Blob_deprecatedCancelPtr = procedure(this: Blob; Status: Status); cdecl;
  Blob_deprecatedClosePtr = procedure(this: Blob; Status: Status); cdecl;
  Blob_seekPtr = function(this: Blob; Status: Status; mode: Integer; offset: Integer): Integer; cdecl;
  Blob_cancelPtr = procedure(this: Blob; Status: Status); cdecl;
  Blob_closePtr = procedure(this: Blob; Status: Status); cdecl;
  Transaction_getInfoPtr = procedure(this: Transaction; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  Transaction_preparePtr = procedure(this: Transaction; Status: Status; msgLength: Cardinal; message: BytePtr); cdecl;
  Transaction_deprecatedCommitPtr = procedure(this: Transaction; Status: Status); cdecl;
  Transaction_commitRetainingPtr = procedure(this: Transaction; Status: Status); cdecl;
  Transaction_deprecatedRollbackPtr = procedure(this: Transaction; Status: Status); cdecl;
  Transaction_rollbackRetainingPtr = procedure(this: Transaction; Status: Status); cdecl;
  Transaction_deprecatedDisconnectPtr = procedure(this: Transaction; Status: Status); cdecl;
  Transaction_joinPtr = function(this: Transaction; Status: Status; Transaction: Transaction): Transaction; cdecl;
  Transaction_validatePtr = function(this: Transaction; Status: Status; Attachment: Attachment): Transaction; cdecl;
  Transaction_enterDtcPtr = function(this: Transaction; Status: Status): Transaction; cdecl;
  Transaction_commitPtr = procedure(this: Transaction; Status: Status); cdecl;
  Transaction_rollbackPtr = procedure(this: Transaction; Status: Status); cdecl;
  Transaction_disconnectPtr = procedure(this: Transaction; Status: Status); cdecl;
  MessageMetadata_getCountPtr = function(this: MessageMetadata; Status: Status): Cardinal; cdecl;
  MessageMetadata_getFieldPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
  MessageMetadata_getRelationPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
  MessageMetadata_getOwnerPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
  MessageMetadata_getAliasPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
  MessageMetadata_getTypePtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
  MessageMetadata_isNullablePtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Boolean; cdecl;
  MessageMetadata_getSubTypePtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Integer; cdecl;
  MessageMetadata_getLengthPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
  MessageMetadata_getScalePtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Integer; cdecl;
  MessageMetadata_getCharSetPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
  MessageMetadata_getOffsetPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
  MessageMetadata_getNullOffsetPtr = function(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
  MessageMetadata_getBuilderPtr = function(this: MessageMetadata; Status: Status): MetadataBuilder; cdecl;
  MessageMetadata_getMessageLengthPtr = function(this: MessageMetadata; Status: Status): Cardinal; cdecl;
  MessageMetadata_getAlignmentPtr = function(this: MessageMetadata; Status: Status): Cardinal; cdecl;
  MessageMetadata_getAlignedLengthPtr = function(this: MessageMetadata; Status: Status): Cardinal; cdecl;
  MetadataBuilder_setTypePtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; type_: Cardinal); cdecl;
  MetadataBuilder_setSubTypePtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; subType: Integer); cdecl;
  MetadataBuilder_setLengthPtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; length: Cardinal); cdecl;
  MetadataBuilder_setCharSetPtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; charSet: Cardinal); cdecl;
  MetadataBuilder_setScalePtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; scale: Integer); cdecl;
  MetadataBuilder_truncatePtr = procedure(this: MetadataBuilder; Status: Status; count: Cardinal); cdecl;
  MetadataBuilder_moveNameToIndexPtr = procedure(this: MetadataBuilder; Status: Status; name: PAnsiChar; index: Cardinal); cdecl;
  MetadataBuilder_removePtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal); cdecl;
  MetadataBuilder_addFieldPtr = function(this: MetadataBuilder; Status: Status): Cardinal; cdecl;
  MetadataBuilder_getMetadataPtr = function(this: MetadataBuilder; Status: Status): MessageMetadata; cdecl;
  MetadataBuilder_setFieldPtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; field: PAnsiChar); cdecl;
  MetadataBuilder_setRelationPtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; relation: PAnsiChar); cdecl;
  MetadataBuilder_setOwnerPtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; owner: PAnsiChar); cdecl;
  MetadataBuilder_setAliasPtr = procedure(this: MetadataBuilder; Status: Status; index: Cardinal; alias: PAnsiChar); cdecl;
  ResultSet_fetchNextPtr = function(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
  ResultSet_fetchPriorPtr = function(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
  ResultSet_fetchFirstPtr = function(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
  ResultSet_fetchLastPtr = function(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
  ResultSet_fetchAbsolutePtr = function(this: ResultSet; Status: Status; position: Integer; message: Pointer): Integer; cdecl;
  ResultSet_fetchRelativePtr = function(this: ResultSet; Status: Status; offset: Integer; message: Pointer): Integer; cdecl;
  ResultSet_isEofPtr = function(this: ResultSet; Status: Status): Boolean; cdecl;
  ResultSet_isBofPtr = function(this: ResultSet; Status: Status): Boolean; cdecl;
  ResultSet_getMetadataPtr = function(this: ResultSet; Status: Status): MessageMetadata; cdecl;
  ResultSet_deprecatedClosePtr = procedure(this: ResultSet; Status: Status); cdecl;
  ResultSet_setDelayedOutputFormatPtr = procedure(this: ResultSet; Status: Status; format: MessageMetadata); cdecl;
  ResultSet_closePtr = procedure(this: ResultSet; Status: Status); cdecl;
  ResultSet_getInfoPtr = procedure(this: ResultSet; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  Statement_getInfoPtr = procedure(this: Statement; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  Statement_getTypePtr = function(this: Statement; Status: Status): Cardinal; cdecl;
  Statement_getPlanPtr = function(this: Statement; Status: Status; detailed: Boolean): PAnsiChar; cdecl;
  Statement_getAffectedRecordsPtr = function(this: Statement; Status: Status): QWord; cdecl;
  Statement_getInputMetadataPtr = function(this: Statement; Status: Status): MessageMetadata; cdecl;
  Statement_getOutputMetadataPtr = function(this: Statement; Status: Status): MessageMetadata; cdecl;
  Statement_executePtr = function(this: Statement; Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer;
    outMetadata: MessageMetadata; outBuffer: Pointer): Transaction; cdecl;
  Statement_openCursorPtr = function(this: Statement; Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer;
    outMetadata: MessageMetadata; flags: Cardinal): ResultSet; cdecl;
  Statement_setCursorNamePtr = procedure(this: Statement; Status: Status; name: PAnsiChar); cdecl;
  Statement_deprecatedFreePtr = procedure(this: Statement; Status: Status); cdecl;
  Statement_getFlagsPtr = function(this: Statement; Status: Status): Cardinal; cdecl;
  Statement_getTimeoutPtr = function(this: Statement; Status: Status): Cardinal; cdecl;
  Statement_setTimeoutPtr = procedure(this: Statement; Status: Status; timeOut: Cardinal); cdecl;
  Statement_createBatchPtr = function(this: Statement; Status: Status; inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch; cdecl;
  Statement_freePtr = procedure(this: Statement; Status: Status); cdecl;
  Batch_addPtr = procedure(this: Batch; Status: Status; count: Cardinal; inBuffer: Pointer); cdecl;
  Batch_addBlobPtr = procedure(this: Batch; Status: Status; length: Cardinal; inBuffer: Pointer; blobId: ISC_QUADPtr; parLength: Cardinal;
    par: BytePtr); cdecl;
  Batch_appendBlobDataPtr = procedure(this: Batch; Status: Status; length: Cardinal; inBuffer: Pointer); cdecl;
  Batch_addBlobStreamPtr = procedure(this: Batch; Status: Status; length: Cardinal; inBuffer: Pointer); cdecl;
  Batch_registerBlobPtr = procedure(this: Batch; Status: Status; existingBlob: ISC_QUADPtr; blobId: ISC_QUADPtr); cdecl;
  Batch_executePtr = function(this: Batch; Status: Status; Transaction: Transaction): BatchCompletionState; cdecl;
  Batch_cancelPtr = procedure(this: Batch; Status: Status); cdecl;
  Batch_getBlobAlignmentPtr = function(this: Batch; Status: Status): Cardinal; cdecl;
  Batch_getMetadataPtr = function(this: Batch; Status: Status): MessageMetadata; cdecl;
  Batch_setDefaultBpbPtr = procedure(this: Batch; Status: Status; parLength: Cardinal; par: BytePtr); cdecl;
  Batch_deprecatedClosePtr = procedure(this: Batch; Status: Status); cdecl;
  Batch_closePtr = procedure(this: Batch; Status: Status); cdecl;
  Batch_getInfoPtr = procedure(this: Batch; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); cdecl;
  BatchCompletionState_getSizePtr = function(this: BatchCompletionState; Status: Status): Cardinal; cdecl;
  BatchCompletionState_getStatePtr = function(this: BatchCompletionState; Status: Status; pos: Cardinal): Integer; cdecl;
  BatchCompletionState_findErrorPtr = function(this: BatchCompletionState; Status: Status; pos: Cardinal): Cardinal; cdecl;
  BatchCompletionState_getStatusPtr = procedure(this: BatchCompletionState; Status: Status; to_: Status; pos: Cardinal); cdecl;
  Replicator_processPtr = procedure(this: Replicator; Status: Status; length: Cardinal; data: BytePtr); cdecl;
  Replicator_deprecatedClosePtr = procedure(this: Replicator; Status: Status); cdecl;
  Replicator_closePtr = procedure(this: Replicator; Status: Status); cdecl;
  Request_receivePtr = procedure(this: Request; Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer); cdecl;
  Request_sendPtr = procedure(this: Request; Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer); cdecl;
  Request_getInfoPtr = procedure(this: Request; Status: Status; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  Request_startPtr = procedure(this: Request; Status: Status; tra: Transaction; level: Integer); cdecl;
  Request_startAndSendPtr = procedure(this: Request; Status: Status; tra: Transaction; level: Integer; msgType: Cardinal; length: Cardinal;
    message: Pointer); cdecl;
  Request_unwindPtr = procedure(this: Request; Status: Status; level: Integer); cdecl;
  Request_deprecatedFreePtr = procedure(this: Request; Status: Status); cdecl;
  Request_freePtr = procedure(this: Request; Status: Status); cdecl;
  Events_deprecatedCancelPtr = procedure(this: Events; Status: Status); cdecl;
  Events_cancelPtr = procedure(this: Events; Status: Status); cdecl;
  Attachment_getInfoPtr = procedure(this: Attachment; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  Attachment_startTransactionPtr = function(this: Attachment; Status: Status; tpbLength: Cardinal; tpb: BytePtr): Transaction; cdecl;
  Attachment_reconnectTransactionPtr = function(this: Attachment; Status: Status; length: Cardinal; id: BytePtr): Transaction; cdecl;
  Attachment_compileRequestPtr = function(this: Attachment; Status: Status; blrLength: Cardinal; blr: BytePtr): Request; cdecl;
  Attachment_transactRequestPtr = procedure(this: Attachment; Status: Status; Transaction: Transaction; blrLength: Cardinal; blr: BytePtr;
    inMsgLength: Cardinal; inMsg: BytePtr; outMsgLength: Cardinal; outMsg: BytePtr); cdecl;
  Attachment_createBlobPtr = function(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr)
    : Blob; cdecl;
  Attachment_openBlobPtr = function(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr)
    : Blob; cdecl;
  Attachment_getSlicePtr = function(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr;
    paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer; cdecl;
  Attachment_putSlicePtr = procedure(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr;
    paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr); cdecl;
  Attachment_executeDynPtr = procedure(this: Attachment; Status: Status; Transaction: Transaction; length: Cardinal; dyn: BytePtr); cdecl;
  Attachment_preparePtr = function(this: Attachment; Status: Status; tra: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
    flags: Cardinal): Statement; cdecl;
  Attachment_executePtr = function(this: Attachment; Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
    dialect: Cardinal; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; outBuffer: Pointer): Transaction; cdecl;
  Attachment_openCursorPtr = function(this: Attachment; Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
    dialect: Cardinal; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal)
    : ResultSet; cdecl;
  Attachment_queEventsPtr = function(this: Attachment; Status: Status; callback: EventCallback; length: Cardinal; Events: BytePtr): Events; cdecl;
  Attachment_cancelOperationPtr = procedure(this: Attachment; Status: Status; option: Integer); cdecl;
  Attachment_pingPtr = procedure(this: Attachment; Status: Status); cdecl;
  Attachment_deprecatedDetachPtr = procedure(this: Attachment; Status: Status); cdecl;
  Attachment_deprecatedDropDatabasePtr = procedure(this: Attachment; Status: Status); cdecl;
  Attachment_getIdleTimeoutPtr = function(this: Attachment; Status: Status): Cardinal; cdecl;
  Attachment_setIdleTimeoutPtr = procedure(this: Attachment; Status: Status; timeOut: Cardinal); cdecl;
  Attachment_getStatementTimeoutPtr = function(this: Attachment; Status: Status): Cardinal; cdecl;
  Attachment_setStatementTimeoutPtr = procedure(this: Attachment; Status: Status; timeOut: Cardinal); cdecl;
  Attachment_createBatchPtr = function(this: Attachment; Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
    dialect: Cardinal; inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch; cdecl;
  Attachment_createReplicatorPtr = function(this: Attachment; Status: Status): Replicator; cdecl;
  Attachment_detachPtr = procedure(this: Attachment; Status: Status); cdecl;
  Attachment_dropDatabasePtr = procedure(this: Attachment; Status: Status); cdecl;
  Service_deprecatedDetachPtr = procedure(this: Service; Status: Status); cdecl;
  Service_queryPtr = procedure(this: Service; Status: Status; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal;
    receiveItems: BytePtr; bufferLength: Cardinal; buffer: BytePtr); cdecl;
  Service_startPtr = procedure(this: Service; Status: Status; spbLength: Cardinal; spb: BytePtr); cdecl;
  Service_detachPtr = procedure(this: Service; Status: Status); cdecl;
  Service_cancelPtr = procedure(this: Service; Status: Status); cdecl;
  Provider_attachDatabasePtr = function(this: Provider; Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment; cdecl;
  Provider_createDatabasePtr = function(this: Provider; Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment; cdecl;
  Provider_attachServiceManagerPtr = function(this: Provider; Status: Status; Service: PAnsiChar; spbLength: Cardinal; spb: BytePtr): Service; cdecl;
  Provider_shutdownPtr = procedure(this: Provider; Status: Status; timeOut: Cardinal; reason: Integer); cdecl;
  Provider_setDbCryptCallbackPtr = procedure(this: Provider; Status: Status; cryptCallback: CryptKeyCallback); cdecl;
  DtcStart_addAttachmentPtr = procedure(this: DtcStart; Status: Status; att: Attachment); cdecl;
  DtcStart_addWithTpbPtr = procedure(this: DtcStart; Status: Status; att: Attachment; length: Cardinal; tpb: BytePtr); cdecl;
  DtcStart_startPtr = function(this: DtcStart; Status: Status): Transaction; cdecl;
  Dtc_joinPtr = function(this: Dtc; Status: Status; one: Transaction; two: Transaction): Transaction; cdecl;
  Dtc_startBuilderPtr = function(this: Dtc; Status: Status): DtcStart; cdecl;
  Writer_resetPtr = procedure(this: Writer); cdecl;
  Writer_addPtr = procedure(this: Writer; Status: Status; name: PAnsiChar); cdecl;
  Writer_setTypePtr = procedure(this: Writer; Status: Status; value: PAnsiChar); cdecl;
  Writer_setDbPtr = procedure(this: Writer; Status: Status; value: PAnsiChar); cdecl;
  ServerBlock_getLoginPtr = function(this: ServerBlock): PAnsiChar; cdecl;
  ServerBlock_getDataPtr = function(this: ServerBlock; length: CardinalPtr): BytePtr; cdecl;
  ServerBlock_putDataPtr = procedure(this: ServerBlock; Status: Status; length: Cardinal; data: Pointer); cdecl;
  ServerBlock_newKeyPtr = function(this: ServerBlock; Status: Status): CryptKey; cdecl;
  ClientBlock_getLoginPtr = function(this: ClientBlock): PAnsiChar; cdecl;
  ClientBlock_getPasswordPtr = function(this: ClientBlock): PAnsiChar; cdecl;
  ClientBlock_getDataPtr = function(this: ClientBlock; length: CardinalPtr): BytePtr; cdecl;
  ClientBlock_putDataPtr = procedure(this: ClientBlock; Status: Status; length: Cardinal; data: Pointer); cdecl;
  ClientBlock_newKeyPtr = function(this: ClientBlock; Status: Status): CryptKey; cdecl;
  ClientBlock_getAuthBlockPtr = function(this: ClientBlock; Status: Status): AuthBlock; cdecl;
  Server_authenticatePtr = function(this: Server; Status: Status; sBlock: ServerBlock; writerInterface: Writer): Integer; cdecl;
  Server_setDbCryptCallbackPtr = procedure(this: Server; Status: Status; cryptCallback: CryptKeyCallback); cdecl;
  Client_authenticatePtr = function(this: Client; Status: Status; cBlock: ClientBlock): Integer; cdecl;
  UserField_enteredPtr = function(this: UserField): Integer; cdecl;
  UserField_specifiedPtr = function(this: UserField): Integer; cdecl;
  UserField_setEnteredPtr = procedure(this: UserField; Status: Status; newValue: Integer); cdecl;
  CharUserField_getPtr = function(this: CharUserField): PAnsiChar; cdecl;
  CharUserField_set_Ptr = procedure(this: CharUserField; Status: Status; newValue: PAnsiChar); cdecl;
  IntUserField_getPtr = function(this: IntUserField): Integer; cdecl;
  IntUserField_set_Ptr = procedure(this: IntUserField; Status: Status; newValue: Integer); cdecl;
  User_operationPtr = function(this: User): Cardinal; cdecl;
  User_userNamePtr = function(this: User): CharUserField; cdecl;
  User_passwordPtr = function(this: User): CharUserField; cdecl;
  User_firstNamePtr = function(this: User): CharUserField; cdecl;
  User_lastNamePtr = function(this: User): CharUserField; cdecl;
  User_middleNamePtr = function(this: User): CharUserField; cdecl;
  User_commentPtr = function(this: User): CharUserField; cdecl;
  User_attributesPtr = function(this: User): CharUserField; cdecl;
  User_activePtr = function(this: User): IntUserField; cdecl;
  User_adminPtr = function(this: User): IntUserField; cdecl;
  User_clearPtr = procedure(this: User; Status: Status); cdecl;
  ListUsers_listPtr = procedure(this: ListUsers; Status: Status; User: User); cdecl;
  LogonInfo_namePtr = function(this: LogonInfo): PAnsiChar; cdecl;
  LogonInfo_rolePtr = function(this: LogonInfo): PAnsiChar; cdecl;
  LogonInfo_networkProtocolPtr = function(this: LogonInfo): PAnsiChar; cdecl;
  LogonInfo_remoteAddressPtr = function(this: LogonInfo): PAnsiChar; cdecl;
  LogonInfo_authBlockPtr = function(this: LogonInfo; length: CardinalPtr): BytePtr; cdecl;
  LogonInfo_attachmentPtr = function(this: LogonInfo; Status: Status): Attachment; cdecl;
  LogonInfo_transactionPtr = function(this: LogonInfo; Status: Status): Transaction; cdecl;
  Management_startPtr = procedure(this: Management; Status: Status; LogonInfo: LogonInfo); cdecl;
  Management_executePtr = function(this: Management; Status: Status; User: User; callback: ListUsers): Integer; cdecl;
  Management_commitPtr = procedure(this: Management; Status: Status); cdecl;
  Management_rollbackPtr = procedure(this: Management; Status: Status); cdecl;
  AuthBlock_getTypePtr = function(this: AuthBlock): PAnsiChar; cdecl;
  AuthBlock_getNamePtr = function(this: AuthBlock): PAnsiChar; cdecl;
  AuthBlock_getPluginPtr = function(this: AuthBlock): PAnsiChar; cdecl;
  AuthBlock_getSecurityDbPtr = function(this: AuthBlock): PAnsiChar; cdecl;
  AuthBlock_getOriginalPluginPtr = function(this: AuthBlock): PAnsiChar; cdecl;
  AuthBlock_nextPtr = function(this: AuthBlock; Status: Status): Boolean; cdecl;
  AuthBlock_firstPtr = function(this: AuthBlock; Status: Status): Boolean; cdecl;
  WireCryptPlugin_getKnownTypesPtr = function(this: WireCryptPlugin; Status: Status): PAnsiChar; cdecl;
  WireCryptPlugin_setKeyPtr = procedure(this: WireCryptPlugin; Status: Status; key: CryptKey); cdecl;
  WireCryptPlugin_encryptPtr = procedure(this: WireCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  WireCryptPlugin_decryptPtr = procedure(this: WireCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  WireCryptPlugin_getSpecificDataPtr = function(this: WireCryptPlugin; Status: Status; keyType: PAnsiChar; length: CardinalPtr): BytePtr; cdecl;
  WireCryptPlugin_setSpecificDataPtr = procedure(this: WireCryptPlugin; Status: Status; keyType: PAnsiChar; length: Cardinal; data: BytePtr); cdecl;
  CryptKeyCallback_callbackPtr = function(this: CryptKeyCallback; dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer)
    : Cardinal; cdecl;
  CryptKeyCallback_afterAttachPtr = function(this: CryptKeyCallback; Status: Status; dbName: PAnsiChar; attStatus: Status): Cardinal; cdecl;
  CryptKeyCallback_disposePtr = procedure(this: CryptKeyCallback); cdecl;
  KeyHolderPlugin_keyCallbackPtr = function(this: KeyHolderPlugin; Status: Status; callback: CryptKeyCallback): Integer; cdecl;
  KeyHolderPlugin_keyHandlePtr = function(this: KeyHolderPlugin; Status: Status; keyName: PAnsiChar): CryptKeyCallback; cdecl;
  KeyHolderPlugin_useOnlyOwnKeysPtr = function(this: KeyHolderPlugin; Status: Status): Boolean; cdecl;
  KeyHolderPlugin_chainHandlePtr = function(this: KeyHolderPlugin; Status: Status): CryptKeyCallback; cdecl;
  DbCryptInfo_getDatabaseFullPathPtr = function(this: DbCryptInfo; Status: Status): PAnsiChar; cdecl;
  DbCryptPlugin_setKeyPtr = procedure(this: DbCryptPlugin; Status: Status; length: Cardinal; sources: KeyHolderPluginPtr; keyName: PAnsiChar); cdecl;
  DbCryptPlugin_encryptPtr = procedure(this: DbCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  DbCryptPlugin_decryptPtr = procedure(this: DbCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  DbCryptPlugin_setInfoPtr = procedure(this: DbCryptPlugin; Status: Status; info: DbCryptInfo); cdecl;
  ExternalContext_getMasterPtr = function(this: ExternalContext): Master; cdecl;
  ExternalContext_getEnginePtr = function(this: ExternalContext; Status: Status): ExternalEngine; cdecl;
  ExternalContext_getAttachmentPtr = function(this: ExternalContext; Status: Status): Attachment; cdecl;
  ExternalContext_getTransactionPtr = function(this: ExternalContext; Status: Status): Transaction; cdecl;
  ExternalContext_getUserNamePtr = function(this: ExternalContext): PAnsiChar; cdecl;
  ExternalContext_getDatabaseNamePtr = function(this: ExternalContext): PAnsiChar; cdecl;
  ExternalContext_getClientCharSetPtr = function(this: ExternalContext): PAnsiChar; cdecl;
  ExternalContext_obtainInfoCodePtr = function(this: ExternalContext): Integer; cdecl;
  ExternalContext_getInfoPtr = function(this: ExternalContext; code: Integer): Pointer; cdecl;
  ExternalContext_setInfoPtr = function(this: ExternalContext; code: Integer; value: Pointer): Pointer; cdecl;
  ExternalResultSet_fetchPtr = function(this: ExternalResultSet; Status: Status): Boolean; cdecl;
  ExternalFunction_getCharSetPtr = procedure(this: ExternalFunction; Status: Status; context: ExternalContext; name: PAnsiChar;
    nameSize: Cardinal); cdecl;
  ExternalFunction_executePtr = procedure(this: ExternalFunction; Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer); cdecl;
  ExternalProcedure_getCharSetPtr = procedure(this: ExternalProcedure; Status: Status; context: ExternalContext; name: PAnsiChar;
    nameSize: Cardinal); cdecl;
  ExternalProcedure_openPtr = function(this: ExternalProcedure; Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer)
    : ExternalResultSet; cdecl;
  ExternalTrigger_getCharSetPtr = procedure(this: ExternalTrigger; Status: Status; context: ExternalContext; name: PAnsiChar;
    nameSize: Cardinal); cdecl;
  ExternalTrigger_executePtr = procedure(this: ExternalTrigger; Status: Status; context: ExternalContext; action: Cardinal; oldMsg: Pointer;
    newMsg: Pointer); cdecl;
  RoutineMetadata_getPackagePtr = function(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
  RoutineMetadata_getNamePtr = function(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
  RoutineMetadata_getEntryPointPtr = function(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
  RoutineMetadata_getBodyPtr = function(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
  RoutineMetadata_getInputMetadataPtr = function(this: RoutineMetadata; Status: Status): MessageMetadata; cdecl;
  RoutineMetadata_getOutputMetadataPtr = function(this: RoutineMetadata; Status: Status): MessageMetadata; cdecl;
  RoutineMetadata_getTriggerMetadataPtr = function(this: RoutineMetadata; Status: Status): MessageMetadata; cdecl;
  RoutineMetadata_getTriggerTablePtr = function(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
  RoutineMetadata_getTriggerTypePtr = function(this: RoutineMetadata; Status: Status): Cardinal; cdecl;
  ExternalEngine_openPtr = procedure(this: ExternalEngine; Status: Status; context: ExternalContext; charSet: PAnsiChar;
    charSetSize: Cardinal); cdecl;
  ExternalEngine_openAttachmentPtr = procedure(this: ExternalEngine; Status: Status; context: ExternalContext); cdecl;
  ExternalEngine_closeAttachmentPtr = procedure(this: ExternalEngine; Status: Status; context: ExternalContext); cdecl;
  ExternalEngine_makeFunctionPtr = function(this: ExternalEngine; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
    inBuilder: MetadataBuilder; outBuilder: MetadataBuilder): ExternalFunction; cdecl;
  ExternalEngine_makeProcedurePtr = function(this: ExternalEngine; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
    inBuilder: MetadataBuilder; outBuilder: MetadataBuilder): ExternalProcedure; cdecl;
  ExternalEngine_makeTriggerPtr = function(this: ExternalEngine; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
    fieldsBuilder: MetadataBuilder): ExternalTrigger; cdecl;
  Timer_handlerPtr = procedure(this: Timer); cdecl;
  TimerControl_startPtr = procedure(this: TimerControl; Status: Status; Timer: Timer; microSeconds: QWord); cdecl;
  TimerControl_stopPtr = procedure(this: TimerControl; Status: Status; Timer: Timer); cdecl;
  VersionCallback_callbackPtr = procedure(this: VersionCallback; Status: Status; text: PAnsiChar); cdecl;
  Util_getFbVersionPtr = procedure(this: Util; Status: Status; att: Attachment; callback: VersionCallback); cdecl;
  Util_loadBlobPtr = procedure(this: Util; Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar;
    txt: Boolean); cdecl;
  Util_dumpBlobPtr = procedure(this: Util; Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar;
    txt: Boolean); cdecl;
  Util_getPerfCountersPtr = procedure(this: Util; Status: Status; att: Attachment; countersSet: PAnsiChar; counters: Int64Ptr); cdecl;
  Util_executeCreateDatabasePtr = function(this: Util; Status: Status; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal;
    stmtIsCreateDb: BooleanPtr): Attachment; cdecl;
  Util_decodeDatePtr = procedure(this: Util; date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr); cdecl;
  Util_decodeTimePtr = procedure(this: Util; time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
    fractions: CardinalPtr); cdecl;
  Util_encodeDatePtr = function(this: Util; year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE; cdecl;
  Util_encodeTimePtr = function(this: Util; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME; cdecl;
  Util_formatStatusPtr = function(this: Util; buffer: PAnsiChar; bufferSize: Cardinal; Status: Status): Cardinal; cdecl;
  Util_getClientVersionPtr = function(this: Util): Cardinal; cdecl;
  Util_getXpbBuilderPtr = function(this: Util; Status: Status; kind: Cardinal; buf: BytePtr; len: Cardinal): XpbBuilder; cdecl;
  Util_setOffsetsPtr = function(this: Util; Status: Status; metadata: MessageMetadata; callback: OffsetsCallback): Cardinal; cdecl;
  Util_getDecFloat16Ptr = function(this: Util; Status: Status): DecFloat16; cdecl;
  Util_getDecFloat34Ptr = function(this: Util; Status: Status): DecFloat34; cdecl;
  Util_decodeTimeTzPtr = procedure(this: Util; Status: Status; timeTz: ISC_TIME_TZPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
    fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar); cdecl;
  Util_decodeTimeStampTzPtr = procedure(this: Util; Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: CardinalPtr; month: CardinalPtr;
    day: CardinalPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal;
    timeZoneBuffer: PAnsiChar); cdecl;
  Util_encodeTimeTzPtr = procedure(this: Util; Status: Status; timeTz: ISC_TIME_TZPtr; hours: Cardinal; minutes: Cardinal; seconds: Cardinal;
    fractions: Cardinal; timeZone: PAnsiChar); cdecl;
  Util_encodeTimeStampTzPtr = procedure(this: Util; Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: Cardinal; month: Cardinal; day: Cardinal;
    hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal; timeZone: PAnsiChar); cdecl;
  Util_getInt128Ptr = function(this: Util; Status: Status): Int128; cdecl;
  Util_decodeTimeTzExPtr = procedure(this: Util; Status: Status; timeTz: ISC_TIME_TZ_EXPtr; hours: CardinalPtr; minutes: CardinalPtr;
    seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar); cdecl;
  Util_decodeTimeStampTzExPtr = procedure(this: Util; Status: Status; timeStampTz: ISC_TIMESTAMP_TZ_EXPtr; year: CardinalPtr; month: CardinalPtr;
    day: CardinalPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal;
    timeZoneBuffer: PAnsiChar); cdecl;
  OffsetsCallback_setOffsetPtr = procedure(this: OffsetsCallback; Status: Status; index: Cardinal; offset: Cardinal; nullOffset: Cardinal); cdecl;
  XpbBuilder_clearPtr = procedure(this: XpbBuilder; Status: Status); cdecl;
  XpbBuilder_removeCurrentPtr = procedure(this: XpbBuilder; Status: Status); cdecl;
  XpbBuilder_insertIntPtr = procedure(this: XpbBuilder; Status: Status; tag: Byte; value: Integer); cdecl;
  XpbBuilder_insertBigIntPtr = procedure(this: XpbBuilder; Status: Status; tag: Byte; value: Int64); cdecl;
  XpbBuilder_insertBytesPtr = procedure(this: XpbBuilder; Status: Status; tag: Byte; bytes: Pointer; length: Cardinal); cdecl;
  XpbBuilder_insertStringPtr = procedure(this: XpbBuilder; Status: Status; tag: Byte; str: PAnsiChar); cdecl;
  XpbBuilder_insertTagPtr = procedure(this: XpbBuilder; Status: Status; tag: Byte); cdecl;
  XpbBuilder_isEofPtr = function(this: XpbBuilder; Status: Status): Boolean; cdecl;
  XpbBuilder_moveNextPtr = procedure(this: XpbBuilder; Status: Status); cdecl;
  XpbBuilder_rewindPtr = procedure(this: XpbBuilder; Status: Status); cdecl;
  XpbBuilder_findFirstPtr = function(this: XpbBuilder; Status: Status; tag: Byte): Boolean; cdecl;
  XpbBuilder_findNextPtr = function(this: XpbBuilder; Status: Status): Boolean; cdecl;
  XpbBuilder_getTagPtr = function(this: XpbBuilder; Status: Status): Byte; cdecl;
  XpbBuilder_getLengthPtr = function(this: XpbBuilder; Status: Status): Cardinal; cdecl;
  XpbBuilder_getIntPtr = function(this: XpbBuilder; Status: Status): Integer; cdecl;
  XpbBuilder_getBigIntPtr = function(this: XpbBuilder; Status: Status): Int64; cdecl;
  XpbBuilder_getStringPtr = function(this: XpbBuilder; Status: Status): PAnsiChar; cdecl;
  XpbBuilder_getBytesPtr = function(this: XpbBuilder; Status: Status): BytePtr; cdecl;
  XpbBuilder_getBufferLengthPtr = function(this: XpbBuilder; Status: Status): Cardinal; cdecl;
  XpbBuilder_getBufferPtr = function(this: XpbBuilder; Status: Status): BytePtr; cdecl;
  TraceConnection_getKindPtr = function(this: TraceConnection): Cardinal; cdecl;
  TraceConnection_getProcessIDPtr = function(this: TraceConnection): Integer; cdecl;
  TraceConnection_getUserNamePtr = function(this: TraceConnection): PAnsiChar; cdecl;
  TraceConnection_getRoleNamePtr = function(this: TraceConnection): PAnsiChar; cdecl;
  TraceConnection_getCharSetPtr = function(this: TraceConnection): PAnsiChar; cdecl;
  TraceConnection_getRemoteProtocolPtr = function(this: TraceConnection): PAnsiChar; cdecl;
  TraceConnection_getRemoteAddressPtr = function(this: TraceConnection): PAnsiChar; cdecl;
  TraceConnection_getRemoteProcessIDPtr = function(this: TraceConnection): Integer; cdecl;
  TraceConnection_getRemoteProcessNamePtr = function(this: TraceConnection): PAnsiChar; cdecl;
  TraceDatabaseConnection_getConnectionIDPtr = function(this: TraceDatabaseConnection): Int64; cdecl;
  TraceDatabaseConnection_getDatabaseNamePtr = function(this: TraceDatabaseConnection): PAnsiChar; cdecl;
  TraceTransaction_getTransactionIDPtr = function(this: TraceTransaction): Int64; cdecl;
  TraceTransaction_getReadOnlyPtr = function(this: TraceTransaction): Boolean; cdecl;
  TraceTransaction_getWaitPtr = function(this: TraceTransaction): Integer; cdecl;
  TraceTransaction_getIsolationPtr = function(this: TraceTransaction): Cardinal; cdecl;
  TraceTransaction_getPerfPtr = function(this: TraceTransaction): PerformanceInfoPtr; cdecl;
  TraceTransaction_getInitialIDPtr = function(this: TraceTransaction): Int64; cdecl;
  TraceTransaction_getPreviousIDPtr = function(this: TraceTransaction): Int64; cdecl;
  TraceParams_getCountPtr = function(this: TraceParams): Cardinal; cdecl;
  TraceParams_getParamPtr = function(this: TraceParams; idx: Cardinal): dscPtr; cdecl;
  TraceParams_getTextUTF8Ptr = function(this: TraceParams; Status: Status; idx: Cardinal): PAnsiChar; cdecl;
  TraceStatement_getStmtIDPtr = function(this: TraceStatement): Int64; cdecl;
  TraceStatement_getPerfPtr = function(this: TraceStatement): PerformanceInfoPtr; cdecl;
  TraceSQLStatement_getTextPtr = function(this: TraceSQLStatement): PAnsiChar; cdecl;
  TraceSQLStatement_getPlanPtr = function(this: TraceSQLStatement): PAnsiChar; cdecl;
  TraceSQLStatement_getInputsPtr = function(this: TraceSQLStatement): TraceParams; cdecl;
  TraceSQLStatement_getTextUTF8Ptr = function(this: TraceSQLStatement): PAnsiChar; cdecl;
  TraceSQLStatement_getExplainedPlanPtr = function(this: TraceSQLStatement): PAnsiChar; cdecl;
  TraceBLRStatement_getDataPtr = function(this: TraceBLRStatement): BytePtr; cdecl;
  TraceBLRStatement_getDataLengthPtr = function(this: TraceBLRStatement): Cardinal; cdecl;
  TraceBLRStatement_getTextPtr = function(this: TraceBLRStatement): PAnsiChar; cdecl;
  TraceDYNRequest_getDataPtr = function(this: TraceDYNRequest): BytePtr; cdecl;
  TraceDYNRequest_getDataLengthPtr = function(this: TraceDYNRequest): Cardinal; cdecl;
  TraceDYNRequest_getTextPtr = function(this: TraceDYNRequest): PAnsiChar; cdecl;
  TraceContextVariable_getNameSpacePtr = function(this: TraceContextVariable): PAnsiChar; cdecl;
  TraceContextVariable_getVarNamePtr = function(this: TraceContextVariable): PAnsiChar; cdecl;
  TraceContextVariable_getVarValuePtr = function(this: TraceContextVariable): PAnsiChar; cdecl;
  TraceProcedure_getProcNamePtr = function(this: TraceProcedure): PAnsiChar; cdecl;
  TraceProcedure_getInputsPtr = function(this: TraceProcedure): TraceParams; cdecl;
  TraceProcedure_getPerfPtr = function(this: TraceProcedure): PerformanceInfoPtr; cdecl;
  TraceProcedure_getStmtIDPtr = function(this: TraceProcedure): Int64; cdecl;
  TraceProcedure_getPlanPtr = function(this: TraceProcedure): PAnsiChar; cdecl;
  TraceProcedure_getExplainedPlanPtr = function(this: TraceProcedure): PAnsiChar; cdecl;
  TraceFunction_getFuncNamePtr = function(this: TraceFunction): PAnsiChar; cdecl;
  TraceFunction_getInputsPtr = function(this: TraceFunction): TraceParams; cdecl;
  TraceFunction_getResultPtr = function(this: TraceFunction): TraceParams; cdecl;
  TraceFunction_getPerfPtr = function(this: TraceFunction): PerformanceInfoPtr; cdecl;
  TraceFunction_getStmtIDPtr = function(this: TraceFunction): Int64; cdecl;
  TraceFunction_getPlanPtr = function(this: TraceFunction): PAnsiChar; cdecl;
  TraceFunction_getExplainedPlanPtr = function(this: TraceFunction): PAnsiChar; cdecl;
  TraceTrigger_getTriggerNamePtr = function(this: TraceTrigger): PAnsiChar; cdecl;
  TraceTrigger_getRelationNamePtr = function(this: TraceTrigger): PAnsiChar; cdecl;
  TraceTrigger_getActionPtr = function(this: TraceTrigger): Integer; cdecl;
  TraceTrigger_getWhichPtr = function(this: TraceTrigger): Integer; cdecl;
  TraceTrigger_getPerfPtr = function(this: TraceTrigger): PerformanceInfoPtr; cdecl;
  TraceTrigger_getStmtIDPtr = function(this: TraceTrigger): Int64; cdecl;
  TraceTrigger_getPlanPtr = function(this: TraceTrigger): PAnsiChar; cdecl;
  TraceTrigger_getExplainedPlanPtr = function(this: TraceTrigger): PAnsiChar; cdecl;
  TraceServiceConnection_getServiceIDPtr = function(this: TraceServiceConnection): Pointer; cdecl;
  TraceServiceConnection_getServiceMgrPtr = function(this: TraceServiceConnection): PAnsiChar; cdecl;
  TraceServiceConnection_getServiceNamePtr = function(this: TraceServiceConnection): PAnsiChar; cdecl;
  TraceStatusVector_hasErrorPtr = function(this: TraceStatusVector): Boolean; cdecl;
  TraceStatusVector_hasWarningPtr = function(this: TraceStatusVector): Boolean; cdecl;
  TraceStatusVector_getStatusPtr = function(this: TraceStatusVector): Status; cdecl;
  TraceStatusVector_getTextPtr = function(this: TraceStatusVector): PAnsiChar; cdecl;
  TraceSweepInfo_getOITPtr = function(this: TraceSweepInfo): Int64; cdecl;
  TraceSweepInfo_getOSTPtr = function(this: TraceSweepInfo): Int64; cdecl;
  TraceSweepInfo_getOATPtr = function(this: TraceSweepInfo): Int64; cdecl;
  TraceSweepInfo_getNextPtr = function(this: TraceSweepInfo): Int64; cdecl;
  TraceSweepInfo_getPerfPtr = function(this: TraceSweepInfo): PerformanceInfoPtr; cdecl;
  TraceLogWriter_writePtr = function(this: TraceLogWriter; buf: Pointer; size: Cardinal): Cardinal; cdecl;
  TraceLogWriter_write_sPtr = function(this: TraceLogWriter; Status: Status; buf: Pointer; size: Cardinal): Cardinal; cdecl;
  TraceInitInfo_getConfigTextPtr = function(this: TraceInitInfo): PAnsiChar; cdecl;
  TraceInitInfo_getTraceSessionIDPtr = function(this: TraceInitInfo): Integer; cdecl;
  TraceInitInfo_getTraceSessionNamePtr = function(this: TraceInitInfo): PAnsiChar; cdecl;
  TraceInitInfo_getFirebirdRootDirectoryPtr = function(this: TraceInitInfo): PAnsiChar; cdecl;
  TraceInitInfo_getDatabaseNamePtr = function(this: TraceInitInfo): PAnsiChar; cdecl;
  TraceInitInfo_getConnectionPtr = function(this: TraceInitInfo): TraceDatabaseConnection; cdecl;
  TraceInitInfo_getLogWriterPtr = function(this: TraceInitInfo): TraceLogWriter; cdecl;
  TracePlugin_trace_get_errorPtr = function(this: TracePlugin): PAnsiChar; cdecl;
  TracePlugin_trace_attachPtr = function(this: TracePlugin; connection: TraceDatabaseConnection; create_db: Boolean; att_result: Cardinal)
    : Boolean; cdecl;
  TracePlugin_trace_detachPtr = function(this: TracePlugin; connection: TraceDatabaseConnection; drop_db: Boolean): Boolean; cdecl;
  TracePlugin_trace_transaction_startPtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    tpb_length: Cardinal; tpb: BytePtr; tra_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_transaction_endPtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    commit: Boolean; retain_context: Boolean; tra_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_proc_executePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    procedure_: TraceProcedure; started: Boolean; proc_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_trigger_executePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    trigger: TraceTrigger; started: Boolean; trig_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_set_contextPtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    variable: TraceContextVariable): Boolean; cdecl;
  TracePlugin_trace_dsql_preparePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    Statement: TraceSQLStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_dsql_freePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Statement: TraceSQLStatement; option: Cardinal)
    : Boolean; cdecl;
  TracePlugin_trace_dsql_executePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    Statement: TraceSQLStatement; started: Boolean; req_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_blr_compilePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    Statement: TraceBLRStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_blr_executePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    Statement: TraceBLRStatement; req_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_dyn_executePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    Request: TraceDYNRequest; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_service_attachPtr = function(this: TracePlugin; Service: TraceServiceConnection; att_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_service_startPtr = function(this: TracePlugin; Service: TraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar;
    start_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_service_queryPtr = function(this: TracePlugin; Service: TraceServiceConnection; send_item_length: Cardinal; send_items: BytePtr;
    recv_item_length: Cardinal; recv_items: BytePtr; query_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_service_detachPtr = function(this: TracePlugin; Service: TraceServiceConnection; detach_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_event_errorPtr = function(this: TracePlugin; connection: TraceConnection; Status: TraceStatusVector; function_: PAnsiChar)
    : Boolean; cdecl;
  TracePlugin_trace_event_sweepPtr = function(this: TracePlugin; connection: TraceDatabaseConnection; sweep: TraceSweepInfo; sweep_state: Cardinal)
    : Boolean; cdecl;
  TracePlugin_trace_func_executePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    function_: TraceFunction; started: Boolean; func_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_dsql_restartPtr = function(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
    Statement: TraceSQLStatement; number: Cardinal): Boolean; cdecl;
  TracePlugin_trace_proc_compilePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; procedure_: TraceProcedure; time_millis: Int64;
    proc_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_func_compilePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; function_: TraceFunction; time_millis: Int64;
    func_result: Cardinal): Boolean; cdecl;
  TracePlugin_trace_trigger_compilePtr = function(this: TracePlugin; connection: TraceDatabaseConnection; trigger: TraceTrigger; time_millis: Int64;
    trig_result: Cardinal): Boolean; cdecl;
  TraceFactory_trace_needsPtr = function(this: TraceFactory): QWord; cdecl;
  TraceFactory_trace_createPtr = function(this: TraceFactory; Status: Status; init_info: TraceInitInfo): TracePlugin; cdecl;
  UdrFunctionFactory_setupPtr = procedure(this: UdrFunctionFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
    inBuilder: MetadataBuilder; outBuilder: MetadataBuilder); cdecl;
  UdrFunctionFactory_newItemPtr = function(this: UdrFunctionFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata)
    : ExternalFunction; cdecl;
  UdrProcedureFactory_setupPtr = procedure(this: UdrProcedureFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
    inBuilder: MetadataBuilder; outBuilder: MetadataBuilder); cdecl;
  UdrProcedureFactory_newItemPtr = function(this: UdrProcedureFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata)
    : ExternalProcedure; cdecl;
  UdrTriggerFactory_setupPtr = procedure(this: UdrTriggerFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
    fieldsBuilder: MetadataBuilder); cdecl;
  UdrTriggerFactory_newItemPtr = function(this: UdrTriggerFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata)
    : ExternalTrigger; cdecl;
  UdrPlugin_getMasterPtr = function(this: UdrPlugin): Master; cdecl;
  UdrPlugin_registerFunctionPtr = procedure(this: UdrPlugin; Status: Status; name: PAnsiChar; factory: UdrFunctionFactory); cdecl;
  UdrPlugin_registerProcedurePtr = procedure(this: UdrPlugin; Status: Status; name: PAnsiChar; factory: UdrProcedureFactory); cdecl;
  UdrPlugin_registerTriggerPtr = procedure(this: UdrPlugin; Status: Status; name: PAnsiChar; factory: UdrTriggerFactory); cdecl;
  DecFloat16_toBcdPtr = procedure(this: DecFloat16; from: FB_DEC16Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr); cdecl;
  DecFloat16_toStringPtr = procedure(this: DecFloat16; Status: Status; from: FB_DEC16Ptr; bufferLength: Cardinal; buffer: PAnsiChar); cdecl;
  DecFloat16_fromBcdPtr = procedure(this: DecFloat16; sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC16Ptr); cdecl;
  DecFloat16_fromStringPtr = procedure(this: DecFloat16; Status: Status; from: PAnsiChar; to_: FB_DEC16Ptr); cdecl;
  DecFloat34_toBcdPtr = procedure(this: DecFloat34; from: FB_DEC34Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr); cdecl;
  DecFloat34_toStringPtr = procedure(this: DecFloat34; Status: Status; from: FB_DEC34Ptr; bufferLength: Cardinal; buffer: PAnsiChar); cdecl;
  DecFloat34_fromBcdPtr = procedure(this: DecFloat34; sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC34Ptr); cdecl;
  DecFloat34_fromStringPtr = procedure(this: DecFloat34; Status: Status; from: PAnsiChar; to_: FB_DEC34Ptr); cdecl;
  Int128_toStringPtr = procedure(this: Int128; Status: Status; from: FB_I128Ptr; scale: Integer; bufferLength: Cardinal; buffer: PAnsiChar); cdecl;
  Int128_fromStringPtr = procedure(this: Int128; Status: Status; scale: Integer; from: PAnsiChar; to_: FB_I128Ptr); cdecl;
  ReplicatedField_getNamePtr = function(this: ReplicatedField): PAnsiChar; cdecl;
  ReplicatedField_getTypePtr = function(this: ReplicatedField): Cardinal; cdecl;
  ReplicatedField_getSubTypePtr = function(this: ReplicatedField): Integer; cdecl;
  ReplicatedField_getScalePtr = function(this: ReplicatedField): Integer; cdecl;
  ReplicatedField_getLengthPtr = function(this: ReplicatedField): Cardinal; cdecl;
  ReplicatedField_getCharSetPtr = function(this: ReplicatedField): Cardinal; cdecl;
  ReplicatedField_getDataPtr = function(this: ReplicatedField): Pointer; cdecl;
  ReplicatedRecord_getCountPtr = function(this: ReplicatedRecord): Cardinal; cdecl;
  ReplicatedRecord_getFieldPtr = function(this: ReplicatedRecord; index: Cardinal): ReplicatedField; cdecl;
  ReplicatedRecord_getRawLengthPtr = function(this: ReplicatedRecord): Cardinal; cdecl;
  ReplicatedRecord_getRawDataPtr = function(this: ReplicatedRecord): BytePtr; cdecl;
  ReplicatedTransaction_preparePtr = procedure(this: ReplicatedTransaction; Status: Status); cdecl;
  ReplicatedTransaction_commitPtr = procedure(this: ReplicatedTransaction; Status: Status); cdecl;
  ReplicatedTransaction_rollbackPtr = procedure(this: ReplicatedTransaction; Status: Status); cdecl;
  ReplicatedTransaction_startSavepointPtr = procedure(this: ReplicatedTransaction; Status: Status); cdecl;
  ReplicatedTransaction_releaseSavepointPtr = procedure(this: ReplicatedTransaction; Status: Status); cdecl;
  ReplicatedTransaction_rollbackSavepointPtr = procedure(this: ReplicatedTransaction; Status: Status); cdecl;
  ReplicatedTransaction_insertRecordPtr = procedure(this: ReplicatedTransaction; Status: Status; name: PAnsiChar; record_: ReplicatedRecord); cdecl;
  ReplicatedTransaction_updateRecordPtr = procedure(this: ReplicatedTransaction; Status: Status; name: PAnsiChar; orgRecord: ReplicatedRecord;
    newRecord: ReplicatedRecord); cdecl;
  ReplicatedTransaction_deleteRecordPtr = procedure(this: ReplicatedTransaction; Status: Status; name: PAnsiChar; record_: ReplicatedRecord); cdecl;
  ReplicatedTransaction_executeSqlPtr = procedure(this: ReplicatedTransaction; Status: Status; sql: PAnsiChar); cdecl;
  ReplicatedTransaction_executeSqlIntlPtr = procedure(this: ReplicatedTransaction; Status: Status; charSet: Cardinal; sql: PAnsiChar); cdecl;
  ReplicatedSession_initPtr = function(this: ReplicatedSession; Status: Status; Attachment: Attachment): Boolean; cdecl;
  ReplicatedSession_startTransactionPtr = function(this: ReplicatedSession; Status: Status; Transaction: Transaction; number: Int64)
    : ReplicatedTransaction; cdecl;
  ReplicatedSession_cleanupTransactionPtr = procedure(this: ReplicatedSession; Status: Status; number: Int64); cdecl;
  ReplicatedSession_setSequencePtr = procedure(this: ReplicatedSession; Status: Status; name: PAnsiChar; value: Int64); cdecl;
  ProfilerPlugin_initPtr = procedure(this: ProfilerPlugin; Status: Status; Attachment: Attachment; ticksFrequency: QWord); cdecl;
  ProfilerPlugin_startSessionPtr = function(this: ProfilerPlugin; Status: Status; description: PAnsiChar; options: PAnsiChar;
    timestamp: ISC_TIMESTAMP_TZ): ProfilerSession; cdecl;
  ProfilerPlugin_flushPtr = procedure(this: ProfilerPlugin; Status: Status); cdecl;
  ProfilerSession_getIdPtr = function(this: ProfilerSession): Int64; cdecl;
  ProfilerSession_getFlagsPtr = function(this: ProfilerSession): Cardinal; cdecl;
  ProfilerSession_cancelPtr = procedure(this: ProfilerSession; Status: Status); cdecl;
  ProfilerSession_finishPtr = procedure(this: ProfilerSession; Status: Status; timestamp: ISC_TIMESTAMP_TZ); cdecl;
  ProfilerSession_defineStatementPtr = procedure(this: ProfilerSession; Status: Status; statementId: Int64; parentStatementId: Int64;
    type_: PAnsiChar; packageName: PAnsiChar; routineName: PAnsiChar; sqlText: PAnsiChar); cdecl;
  ProfilerSession_defineCursorPtr = procedure(this: ProfilerSession; statementId: Int64; cursorId: Cardinal; name: PAnsiChar; line: Cardinal;
    column: Cardinal); cdecl;
  ProfilerSession_defineRecordSourcePtr = procedure(this: ProfilerSession; statementId: Int64; cursorId: Cardinal; recSourceId: Cardinal;
    level: Cardinal; accessPath: PAnsiChar; parentRecSourceId: Cardinal); cdecl;
  ProfilerSession_onRequestStartPtr = procedure(this: ProfilerSession; Status: Status; statementId: Int64; requestId: Int64; callerStatementId: Int64;
    callerRequestId: Int64; timestamp: ISC_TIMESTAMP_TZ); cdecl;
  ProfilerSession_onRequestFinishPtr = procedure(this: ProfilerSession; Status: Status; statementId: Int64; requestId: Int64;
    timestamp: ISC_TIMESTAMP_TZ; stats: ProfilerStats); cdecl;
  ProfilerSession_beforePsqlLineColumnPtr = procedure(this: ProfilerSession; statementId: Int64; requestId: Int64; line: Cardinal;
    column: Cardinal); cdecl;
  ProfilerSession_afterPsqlLineColumnPtr = procedure(this: ProfilerSession; statementId: Int64; requestId: Int64; line: Cardinal; column: Cardinal;
    stats: ProfilerStats); cdecl;
  ProfilerSession_beforeRecordSourceOpenPtr = procedure(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
    recSourceId: Cardinal); cdecl;
  ProfilerSession_afterRecordSourceOpenPtr = procedure(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
    recSourceId: Cardinal; stats: ProfilerStats); cdecl;
  ProfilerSession_beforeRecordSourceGetRecordPtr = procedure(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
    recSourceId: Cardinal); cdecl;
  ProfilerSession_afterRecordSourceGetRecordPtr = procedure(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
    recSourceId: Cardinal; stats: ProfilerStats); cdecl;
  ProfilerStats_getElapsedTicksPtr = function(this: ProfilerStats): QWord; cdecl;

  VersionedVTable = class
    version: NativeInt;
  end;

  Versioned = class
    vTable: VersionedVTable;

  const
    version = 1;

  end;

  VersionedImpl = class(Versioned)
    constructor create;

  end;

  ReferenceCountedVTable = class(VersionedVTable)
    addRef: ReferenceCounted_addRefPtr;
    release: ReferenceCounted_releasePtr;
  end;

  ReferenceCounted = class(Versioned)
  const
    version = 2;

    procedure addRef();
    function release(): Integer;
  end;

  ReferenceCountedImpl = class(ReferenceCounted)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
  end;

  DisposableVTable = class(VersionedVTable)
    dispose: Disposable_disposePtr;
  end;

  Disposable = class(Versioned)
  const
    version = 2;

    procedure dispose();
  end;

  DisposableImpl = class(Disposable)
    constructor create;

    procedure dispose(); virtual; abstract;
  end;

  StatusVTable = class(DisposableVTable)
    init: Status_initPtr;
    getState: Status_getStatePtr;
    setErrors2: Status_setErrors2Ptr;
    setWarnings2: Status_setWarnings2Ptr;
    setErrors: Status_setErrorsPtr;
    setWarnings: Status_setWarningsPtr;
    getErrors: Status_getErrorsPtr;
    getWarnings: Status_getWarningsPtr;
    clone: Status_clonePtr;
  end;

  Status = class(Disposable)
  const
    version = 3;

  const
    STATE_WARNINGS = Cardinal($1);

  const
    STATE_ERRORS = Cardinal($2);

  const
    RESULT_ERROR = Integer(-1);

  const
    RESULT_OK = Integer(0);

  const
    RESULT_NO_DATA = Integer(1);

  const
    RESULT_SEGMENT = Integer(2);

    procedure init();
    function getState(): Cardinal;
    procedure setErrors2(length: Cardinal; value: NativeIntPtr);
    procedure setWarnings2(length: Cardinal; value: NativeIntPtr);
    procedure setErrors(value: NativeIntPtr);
    procedure setWarnings(value: NativeIntPtr);
    function getErrors(): NativeIntPtr;
    function getWarnings(): NativeIntPtr;
    function clone(): Status;
  end;

  StatusImpl = class(Status)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure init(); virtual; abstract;
    function getState(): Cardinal; virtual; abstract;
    procedure setErrors2(length: Cardinal; value: NativeIntPtr); virtual; abstract;
    procedure setWarnings2(length: Cardinal; value: NativeIntPtr); virtual; abstract;
    procedure setErrors(value: NativeIntPtr); virtual; abstract;
    procedure setWarnings(value: NativeIntPtr); virtual; abstract;
    function getErrors(): NativeIntPtr; virtual; abstract;
    function getWarnings(): NativeIntPtr; virtual; abstract;
    function clone(): Status; virtual; abstract;
  end;

  MasterVTable = class(VersionedVTable)
    getStatus: Master_getStatusPtr;
    getDispatcher: Master_getDispatcherPtr;
    getPluginManager: Master_getPluginManagerPtr;
    getTimerControl: Master_getTimerControlPtr;
    getDtc: Master_getDtcPtr;
    registerAttachment: Master_registerAttachmentPtr;
    registerTransaction: Master_registerTransactionPtr;
    getMetadataBuilder: Master_getMetadataBuilderPtr;
    serverMode: Master_serverModePtr;
    getUtilInterface: Master_getUtilInterfacePtr;
    getConfigManager: Master_getConfigManagerPtr;
    getProcessExiting: Master_getProcessExitingPtr;
  end;

  Master = class(Versioned)
  const
    version = 2;

    function getStatus(): Status;
    function getDispatcher(): Provider;
    function getPluginManager(): PluginManager;
    function getTimerControl(): TimerControl;
    function getDtc(): Dtc;
    function registerAttachment(Provider: Provider; Attachment: Attachment): Attachment;
    function registerTransaction(Attachment: Attachment; Transaction: Transaction): Transaction;
    function getMetadataBuilder(Status: Status; fieldCount: Cardinal): MetadataBuilder;
    function serverMode(mode: Integer): Integer;
    function getUtilInterface(): Util;
    function getConfigManager(): ConfigManager;
    function getProcessExiting(): Boolean;
  end;

  MasterImpl = class(Master)
    constructor create;

    function getStatus(): Status; virtual; abstract;
    function getDispatcher(): Provider; virtual; abstract;
    function getPluginManager(): PluginManager; virtual; abstract;
    function getTimerControl(): TimerControl; virtual; abstract;
    function getDtc(): Dtc; virtual; abstract;
    function registerAttachment(Provider: Provider; Attachment: Attachment): Attachment; virtual; abstract;
    function registerTransaction(Attachment: Attachment; Transaction: Transaction): Transaction; virtual; abstract;
    function getMetadataBuilder(Status: Status; fieldCount: Cardinal): MetadataBuilder; virtual; abstract;
    function serverMode(mode: Integer): Integer; virtual; abstract;
    function getUtilInterface(): Util; virtual; abstract;
    function getConfigManager(): ConfigManager; virtual; abstract;
    function getProcessExiting(): Boolean; virtual; abstract;
  end;

  PluginBaseVTable = class(ReferenceCountedVTable)
    setOwner: PluginBase_setOwnerPtr;
    getOwner: PluginBase_getOwnerPtr;
  end;

  PluginBase = class(ReferenceCounted)
  const
    version = 3;

    procedure setOwner(r: ReferenceCounted);
    function getOwner(): ReferenceCounted;
  end;

  PluginBaseImpl = class(PluginBase)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
  end;

  PluginSetVTable = class(ReferenceCountedVTable)
    getName: PluginSet_getNamePtr;
    getModuleName: PluginSet_getModuleNamePtr;
    getPlugin: PluginSet_getPluginPtr;
    next: PluginSet_nextPtr;
    set_: PluginSet_set_Ptr;
  end;

  PluginSet = class(ReferenceCounted)
  const
    version = 3;

    function getName(): PAnsiChar;
    function getModuleName(): PAnsiChar;
    function getPlugin(Status: Status): PluginBase;
    procedure next(Status: Status);
    procedure set_(Status: Status; s: PAnsiChar);
  end;

  PluginSetImpl = class(PluginSet)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getName(): PAnsiChar; virtual; abstract;
    function getModuleName(): PAnsiChar; virtual; abstract;
    function getPlugin(Status: Status): PluginBase; virtual; abstract;
    procedure next(Status: Status); virtual; abstract;
    procedure set_(Status: Status; s: PAnsiChar); virtual; abstract;
  end;

  ConfigEntryVTable = class(ReferenceCountedVTable)
    getName: ConfigEntry_getNamePtr;
    getValue: ConfigEntry_getValuePtr;
    getIntValue: ConfigEntry_getIntValuePtr;
    getBoolValue: ConfigEntry_getBoolValuePtr;
    getSubConfig: ConfigEntry_getSubConfigPtr;
  end;

  ConfigEntry = class(ReferenceCounted)
  const
    version = 3;

    function getName(): PAnsiChar;
    function getValue(): PAnsiChar;
    function getIntValue(): Int64;
    function getBoolValue(): Boolean;
    function getSubConfig(Status: Status): Config;
  end;

  ConfigEntryImpl = class(ConfigEntry)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getName(): PAnsiChar; virtual; abstract;
    function getValue(): PAnsiChar; virtual; abstract;
    function getIntValue(): Int64; virtual; abstract;
    function getBoolValue(): Boolean; virtual; abstract;
    function getSubConfig(Status: Status): Config; virtual; abstract;
  end;

  ConfigVTable = class(ReferenceCountedVTable)
    find: Config_findPtr;
    findValue: Config_findValuePtr;
    findPos: Config_findPosPtr;
  end;

  Config = class(ReferenceCounted)
  const
    version = 3;

    function find(Status: Status; name: PAnsiChar): ConfigEntry;
    function findValue(Status: Status; name: PAnsiChar; value: PAnsiChar): ConfigEntry;
    function findPos(Status: Status; name: PAnsiChar; pos: Cardinal): ConfigEntry;
  end;

  ConfigImpl = class(Config)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function find(Status: Status; name: PAnsiChar): ConfigEntry; virtual; abstract;
    function findValue(Status: Status; name: PAnsiChar; value: PAnsiChar): ConfigEntry; virtual; abstract;
    function findPos(Status: Status; name: PAnsiChar; pos: Cardinal): ConfigEntry; virtual; abstract;
  end;

  FirebirdConfVTable = class(ReferenceCountedVTable)
    getKey: FirebirdConf_getKeyPtr;
    asInteger: FirebirdConf_asIntegerPtr;
    asString: FirebirdConf_asStringPtr;
    asBoolean: FirebirdConf_asBooleanPtr;
    getVersion: FirebirdConf_getVersionPtr;
  end;

  FirebirdConf = class(ReferenceCounted)
  const
    version = 4;

    function getKey(name: PAnsiChar): Cardinal;
    function asInteger(key: Cardinal): Int64;
    function asString(key: Cardinal): PAnsiChar;
    function asBoolean(key: Cardinal): Boolean;
    function getVersion(Status: Status): Cardinal;
  end;

  FirebirdConfImpl = class(FirebirdConf)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getKey(name: PAnsiChar): Cardinal; virtual; abstract;
    function asInteger(key: Cardinal): Int64; virtual; abstract;
    function asString(key: Cardinal): PAnsiChar; virtual; abstract;
    function asBoolean(key: Cardinal): Boolean; virtual; abstract;
    function getVersion(Status: Status): Cardinal; virtual; abstract;
  end;

  PluginConfigVTable = class(ReferenceCountedVTable)
    getConfigFileName: PluginConfig_getConfigFileNamePtr;
    getDefaultConfig: PluginConfig_getDefaultConfigPtr;
    getFirebirdConf: PluginConfig_getFirebirdConfPtr;
    setReleaseDelay: PluginConfig_setReleaseDelayPtr;
  end;

  PluginConfig = class(ReferenceCounted)
  const
    version = 3;

    function getConfigFileName(): PAnsiChar;
    function getDefaultConfig(Status: Status): Config;
    function getFirebirdConf(Status: Status): FirebirdConf;
    procedure setReleaseDelay(Status: Status; microSeconds: QWord);
  end;

  PluginConfigImpl = class(PluginConfig)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getConfigFileName(): PAnsiChar; virtual; abstract;
    function getDefaultConfig(Status: Status): Config; virtual; abstract;
    function getFirebirdConf(Status: Status): FirebirdConf; virtual; abstract;
    procedure setReleaseDelay(Status: Status; microSeconds: QWord); virtual; abstract;
  end;

  PluginFactoryVTable = class(VersionedVTable)
    createPlugin: PluginFactory_createPluginPtr;
  end;

  PluginFactory = class(Versioned)
  const
    version = 2;

    function createPlugin(Status: Status; factoryParameter: PluginConfig): PluginBase;
  end;

  PluginFactoryImpl = class(PluginFactory)
    constructor create;

    function createPlugin(Status: Status; factoryParameter: PluginConfig): PluginBase; virtual; abstract;
  end;

  PluginModuleVTable = class(VersionedVTable)
    doClean: PluginModule_doCleanPtr;
    threadDetach: PluginModule_threadDetachPtr;
  end;

  PluginModule = class(Versioned)
  const
    version = 3;

    procedure doClean();
    procedure threadDetach();
  end;

  PluginModuleImpl = class(PluginModule)
    constructor create;

    procedure doClean(); virtual; abstract;
    procedure threadDetach(); virtual; abstract;
  end;

  PluginManagerVTable = class(VersionedVTable)
    registerPluginFactory: PluginManager_registerPluginFactoryPtr;
    registerModule: PluginManager_registerModulePtr;
    unregisterModule: PluginManager_unregisterModulePtr;
    getPlugins: PluginManager_getPluginsPtr;
    getConfig: PluginManager_getConfigPtr;
    releasePlugin: PluginManager_releasePluginPtr;
  end;

  PluginManager = class(Versioned)
  const
    version = 2;

  const
    TYPE_PROVIDER = Cardinal(1);

  const
    TYPE_FIRST_NON_LIB = Cardinal(2);

  const
    TYPE_AUTH_SERVER = Cardinal(3);

  const
    TYPE_AUTH_CLIENT = Cardinal(4);

  const
    TYPE_AUTH_USER_MANAGEMENT = Cardinal(5);

  const
    TYPE_EXTERNAL_ENGINE = Cardinal(6);

  const
    TYPE_TRACE = Cardinal(7);

  const
    TYPE_WIRE_CRYPT = Cardinal(8);

  const
    TYPE_DB_CRYPT = Cardinal(9);

  const
    TYPE_KEY_HOLDER = Cardinal(10);

  const
    TYPE_REPLICATOR = Cardinal(11);

  const
    TYPE_PROFILER = Cardinal(12);

  const
    TYPE_COUNT = Cardinal(13);

    procedure registerPluginFactory(pluginType: Cardinal; defaultName: PAnsiChar; factory: PluginFactory);
    procedure registerModule(cleanup: PluginModule);
    procedure unregisterModule(cleanup: PluginModule);
    function getPlugins(Status: Status; pluginType: Cardinal; namesList: PAnsiChar; FirebirdConf: FirebirdConf): PluginSet;
    function getConfig(Status: Status; filename: PAnsiChar): Config;
    procedure releasePlugin(plugin: PluginBase);
  end;

  PluginManagerImpl = class(PluginManager)
    constructor create;

    procedure registerPluginFactory(pluginType: Cardinal; defaultName: PAnsiChar; factory: PluginFactory); virtual; abstract;
    procedure registerModule(cleanup: PluginModule); virtual; abstract;
    procedure unregisterModule(cleanup: PluginModule); virtual; abstract;
    function getPlugins(Status: Status; pluginType: Cardinal; namesList: PAnsiChar; FirebirdConf: FirebirdConf): PluginSet; virtual; abstract;
    function getConfig(Status: Status; filename: PAnsiChar): Config; virtual; abstract;
    procedure releasePlugin(plugin: PluginBase); virtual; abstract;
  end;

  CryptKeyVTable = class(VersionedVTable)
    setSymmetric: CryptKey_setSymmetricPtr;
    setAsymmetric: CryptKey_setAsymmetricPtr;
    getEncryptKey: CryptKey_getEncryptKeyPtr;
    getDecryptKey: CryptKey_getDecryptKeyPtr;
  end;

  CryptKey = class(Versioned)
  const
    version = 2;

    procedure setSymmetric(Status: Status; type_: PAnsiChar; keyLength: Cardinal; key: Pointer);
    procedure setAsymmetric(Status: Status; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer; decryptKeyLength: Cardinal;
      decryptKey: Pointer);
    function getEncryptKey(length: CardinalPtr): Pointer;
    function getDecryptKey(length: CardinalPtr): Pointer;
  end;

  CryptKeyImpl = class(CryptKey)
    constructor create;

    procedure setSymmetric(Status: Status; type_: PAnsiChar; keyLength: Cardinal; key: Pointer); virtual; abstract;
    procedure setAsymmetric(Status: Status; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer; decryptKeyLength: Cardinal;
      decryptKey: Pointer); virtual; abstract;
    function getEncryptKey(length: CardinalPtr): Pointer; virtual; abstract;
    function getDecryptKey(length: CardinalPtr): Pointer; virtual; abstract;
  end;

  ConfigManagerVTable = class(VersionedVTable)
    getDirectory: ConfigManager_getDirectoryPtr;
    getFirebirdConf: ConfigManager_getFirebirdConfPtr;
    getDatabaseConf: ConfigManager_getDatabaseConfPtr;
    getPluginConfig: ConfigManager_getPluginConfigPtr;
    getInstallDirectory: ConfigManager_getInstallDirectoryPtr;
    getRootDirectory: ConfigManager_getRootDirectoryPtr;
    getDefaultSecurityDb: ConfigManager_getDefaultSecurityDbPtr;
  end;

  ConfigManager = class(Versioned)
  const
    version = 3;

  const
    DIR_BIN = Cardinal(0);

  const
    DIR_SBIN = Cardinal(1);

  const
    DIR_CONF = Cardinal(2);

  const
    DIR_LIB = Cardinal(3);

  const
    DIR_INC = Cardinal(4);

  const
    DIR_DOC = Cardinal(5);

  const
    DIR_UDF = Cardinal(6);

  const
    DIR_SAMPLE = Cardinal(7);

  const
    DIR_SAMPLEDB = Cardinal(8);

  const
    DIR_HELP = Cardinal(9);

  const
    DIR_INTL = Cardinal(10);

  const
    DIR_MISC = Cardinal(11);

  const
    DIR_SECDB = Cardinal(12);

  const
    DIR_MSG = Cardinal(13);

  const
    DIR_LOG = Cardinal(14);

  const
    DIR_GUARD = Cardinal(15);

  const
    DIR_PLUGINS = Cardinal(16);

  const
    DIR_TZDATA = Cardinal(17);

  const
    DIR_COUNT = Cardinal(18);

    function getDirectory(code: Cardinal): PAnsiChar;
    function getFirebirdConf(): FirebirdConf;
    function getDatabaseConf(dbName: PAnsiChar): FirebirdConf;
    function getPluginConfig(configuredPlugin: PAnsiChar): Config;
    function getInstallDirectory(): PAnsiChar;
    function getRootDirectory(): PAnsiChar;
    function getDefaultSecurityDb(): PAnsiChar;
  end;

  ConfigManagerImpl = class(ConfigManager)
    constructor create;

    function getDirectory(code: Cardinal): PAnsiChar; virtual; abstract;
    function getFirebirdConf(): FirebirdConf; virtual; abstract;
    function getDatabaseConf(dbName: PAnsiChar): FirebirdConf; virtual; abstract;
    function getPluginConfig(configuredPlugin: PAnsiChar): Config; virtual; abstract;
    function getInstallDirectory(): PAnsiChar; virtual; abstract;
    function getRootDirectory(): PAnsiChar; virtual; abstract;
    function getDefaultSecurityDb(): PAnsiChar; virtual; abstract;
  end;

  EventCallbackVTable = class(ReferenceCountedVTable)
    eventCallbackFunction: EventCallback_eventCallbackFunctionPtr;
  end;

  EventCallback = class(ReferenceCounted)
  const
    version = 3;

    procedure eventCallbackFunction(length: Cardinal; Events: BytePtr);
  end;

  EventCallbackImpl = class(EventCallback)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure eventCallbackFunction(length: Cardinal; Events: BytePtr); virtual; abstract;
  end;

  BlobVTable = class(ReferenceCountedVTable)
    getInfo: Blob_getInfoPtr;
    getSegment: Blob_getSegmentPtr;
    putSegment: Blob_putSegmentPtr;
    deprecatedCancel: Blob_deprecatedCancelPtr;
    deprecatedClose: Blob_deprecatedClosePtr;
    seek: Blob_seekPtr;
    cancel: Blob_cancelPtr;
    close: Blob_closePtr;
  end;

  Blob = class(ReferenceCounted)
  const
    version = 4;

    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    function getSegment(Status: Status; bufferLength: Cardinal; buffer: Pointer; segmentLength: CardinalPtr): Integer;
    procedure putSegment(Status: Status; length: Cardinal; buffer: Pointer);
    procedure deprecatedCancel(Status: Status);
    procedure deprecatedClose(Status: Status);
    function seek(Status: Status; mode: Integer; offset: Integer): Integer;
    procedure cancel(Status: Status);
    procedure close(Status: Status);
  end;

  BlobImpl = class(Blob)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    function getSegment(Status: Status; bufferLength: Cardinal; buffer: Pointer; segmentLength: CardinalPtr): Integer; virtual; abstract;
    procedure putSegment(Status: Status; length: Cardinal; buffer: Pointer); virtual; abstract;
    procedure deprecatedCancel(Status: Status); virtual; abstract;
    procedure deprecatedClose(Status: Status); virtual; abstract;
    function seek(Status: Status; mode: Integer; offset: Integer): Integer; virtual; abstract;
    procedure cancel(Status: Status); virtual; abstract;
    procedure close(Status: Status); virtual; abstract;
  end;

  TransactionVTable = class(ReferenceCountedVTable)
    getInfo: Transaction_getInfoPtr;
    prepare: Transaction_preparePtr;
    deprecatedCommit: Transaction_deprecatedCommitPtr;
    commitRetaining: Transaction_commitRetainingPtr;
    deprecatedRollback: Transaction_deprecatedRollbackPtr;
    rollbackRetaining: Transaction_rollbackRetainingPtr;
    deprecatedDisconnect: Transaction_deprecatedDisconnectPtr;
    join: Transaction_joinPtr;
    validate: Transaction_validatePtr;
    enterDtc: Transaction_enterDtcPtr;
    commit: Transaction_commitPtr;
    rollback: Transaction_rollbackPtr;
    disconnect: Transaction_disconnectPtr;
  end;

  Transaction = class(ReferenceCounted)
  const
    version = 4;

    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    procedure prepare(Status: Status; msgLength: Cardinal; message: BytePtr);
    procedure deprecatedCommit(Status: Status);
    procedure commitRetaining(Status: Status);
    procedure deprecatedRollback(Status: Status);
    procedure rollbackRetaining(Status: Status);
    procedure deprecatedDisconnect(Status: Status);
    function join(Status: Status; Transaction: Transaction): Transaction;
    function validate(Status: Status; Attachment: Attachment): Transaction;
    function enterDtc(Status: Status): Transaction;
    procedure commit(Status: Status);
    procedure rollback(Status: Status);
    procedure disconnect(Status: Status);
  end;

  TransactionImpl = class(Transaction)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    procedure prepare(Status: Status; msgLength: Cardinal; message: BytePtr); virtual; abstract;
    procedure deprecatedCommit(Status: Status); virtual; abstract;
    procedure commitRetaining(Status: Status); virtual; abstract;
    procedure deprecatedRollback(Status: Status); virtual; abstract;
    procedure rollbackRetaining(Status: Status); virtual; abstract;
    procedure deprecatedDisconnect(Status: Status); virtual; abstract;
    function join(Status: Status; Transaction: Transaction): Transaction; virtual; abstract;
    function validate(Status: Status; Attachment: Attachment): Transaction; virtual; abstract;
    function enterDtc(Status: Status): Transaction; virtual; abstract;
    procedure commit(Status: Status); virtual; abstract;
    procedure rollback(Status: Status); virtual; abstract;
    procedure disconnect(Status: Status); virtual; abstract;
  end;

  MessageMetadataVTable = class(ReferenceCountedVTable)
    getCount: MessageMetadata_getCountPtr;
    getField: MessageMetadata_getFieldPtr;
    getRelation: MessageMetadata_getRelationPtr;
    getOwner: MessageMetadata_getOwnerPtr;
    getAlias: MessageMetadata_getAliasPtr;
    getType: MessageMetadata_getTypePtr;
    isNullable: MessageMetadata_isNullablePtr;
    getSubType: MessageMetadata_getSubTypePtr;
    getLength: MessageMetadata_getLengthPtr;
    getScale: MessageMetadata_getScalePtr;
    getCharSet: MessageMetadata_getCharSetPtr;
    getOffset: MessageMetadata_getOffsetPtr;
    getNullOffset: MessageMetadata_getNullOffsetPtr;
    getBuilder: MessageMetadata_getBuilderPtr;
    getMessageLength: MessageMetadata_getMessageLengthPtr;
    getAlignment: MessageMetadata_getAlignmentPtr;
    getAlignedLength: MessageMetadata_getAlignedLengthPtr;
  end;

  MessageMetadata = class(ReferenceCounted)
  const
    version = 4;

    function getCount(Status: Status): Cardinal;
    function getField(Status: Status; index: Cardinal): PAnsiChar;
    function getRelation(Status: Status; index: Cardinal): PAnsiChar;
    function getOwner(Status: Status; index: Cardinal): PAnsiChar;
    function getAlias(Status: Status; index: Cardinal): PAnsiChar;
    function getType(Status: Status; index: Cardinal): Cardinal;
    function isNullable(Status: Status; index: Cardinal): Boolean;
    function getSubType(Status: Status; index: Cardinal): Integer;
    function getLength(Status: Status; index: Cardinal): Cardinal;
    function getScale(Status: Status; index: Cardinal): Integer;
    function getCharSet(Status: Status; index: Cardinal): Cardinal;
    function getOffset(Status: Status; index: Cardinal): Cardinal;
    function getNullOffset(Status: Status; index: Cardinal): Cardinal;
    function getBuilder(Status: Status): MetadataBuilder;
    function getMessageLength(Status: Status): Cardinal;
    function getAlignment(Status: Status): Cardinal;
    function getAlignedLength(Status: Status): Cardinal;
  end;

  MessageMetadataImpl = class(MessageMetadata)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getCount(Status: Status): Cardinal; virtual; abstract;
    function getField(Status: Status; index: Cardinal): PAnsiChar; virtual; abstract;
    function getRelation(Status: Status; index: Cardinal): PAnsiChar; virtual; abstract;
    function getOwner(Status: Status; index: Cardinal): PAnsiChar; virtual; abstract;
    function getAlias(Status: Status; index: Cardinal): PAnsiChar; virtual; abstract;
    function getType(Status: Status; index: Cardinal): Cardinal; virtual; abstract;
    function isNullable(Status: Status; index: Cardinal): Boolean; virtual; abstract;
    function getSubType(Status: Status; index: Cardinal): Integer; virtual; abstract;
    function getLength(Status: Status; index: Cardinal): Cardinal; virtual; abstract;
    function getScale(Status: Status; index: Cardinal): Integer; virtual; abstract;
    function getCharSet(Status: Status; index: Cardinal): Cardinal; virtual; abstract;
    function getOffset(Status: Status; index: Cardinal): Cardinal; virtual; abstract;
    function getNullOffset(Status: Status; index: Cardinal): Cardinal; virtual; abstract;
    function getBuilder(Status: Status): MetadataBuilder; virtual; abstract;
    function getMessageLength(Status: Status): Cardinal; virtual; abstract;
    function getAlignment(Status: Status): Cardinal; virtual; abstract;
    function getAlignedLength(Status: Status): Cardinal; virtual; abstract;
  end;

  MetadataBuilderVTable = class(ReferenceCountedVTable)
    setType: MetadataBuilder_setTypePtr;
    setSubType: MetadataBuilder_setSubTypePtr;
    setLength: MetadataBuilder_setLengthPtr;
    setCharSet: MetadataBuilder_setCharSetPtr;
    setScale: MetadataBuilder_setScalePtr;
    truncate: MetadataBuilder_truncatePtr;
    moveNameToIndex: MetadataBuilder_moveNameToIndexPtr;
    remove: MetadataBuilder_removePtr;
    addField: MetadataBuilder_addFieldPtr;
    getMetadata: MetadataBuilder_getMetadataPtr;
    setField: MetadataBuilder_setFieldPtr;
    setRelation: MetadataBuilder_setRelationPtr;
    setOwner: MetadataBuilder_setOwnerPtr;
    setAlias: MetadataBuilder_setAliasPtr;
  end;

  MetadataBuilder = class(ReferenceCounted)
  const
    version = 4;

    procedure setType(Status: Status; index: Cardinal; type_: Cardinal);
    procedure setSubType(Status: Status; index: Cardinal; subType: Integer);
    procedure setLength(Status: Status; index: Cardinal; length: Cardinal);
    procedure setCharSet(Status: Status; index: Cardinal; charSet: Cardinal);
    procedure setScale(Status: Status; index: Cardinal; scale: Integer);
    procedure truncate(Status: Status; count: Cardinal);
    procedure moveNameToIndex(Status: Status; name: PAnsiChar; index: Cardinal);
    procedure remove(Status: Status; index: Cardinal);
    function addField(Status: Status): Cardinal;
    function getMetadata(Status: Status): MessageMetadata;
    procedure setField(Status: Status; index: Cardinal; field: PAnsiChar);
    procedure setRelation(Status: Status; index: Cardinal; relation: PAnsiChar);
    procedure setOwner(Status: Status; index: Cardinal; owner: PAnsiChar);
    procedure setAlias(Status: Status; index: Cardinal; alias: PAnsiChar);
  end;

  MetadataBuilderImpl = class(MetadataBuilder)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setType(Status: Status; index: Cardinal; type_: Cardinal); virtual; abstract;
    procedure setSubType(Status: Status; index: Cardinal; subType: Integer); virtual; abstract;
    procedure setLength(Status: Status; index: Cardinal; length: Cardinal); virtual; abstract;
    procedure setCharSet(Status: Status; index: Cardinal; charSet: Cardinal); virtual; abstract;
    procedure setScale(Status: Status; index: Cardinal; scale: Integer); virtual; abstract;
    procedure truncate(Status: Status; count: Cardinal); virtual; abstract;
    procedure moveNameToIndex(Status: Status; name: PAnsiChar; index: Cardinal); virtual; abstract;
    procedure remove(Status: Status; index: Cardinal); virtual; abstract;
    function addField(Status: Status): Cardinal; virtual; abstract;
    function getMetadata(Status: Status): MessageMetadata; virtual; abstract;
    procedure setField(Status: Status; index: Cardinal; field: PAnsiChar); virtual; abstract;
    procedure setRelation(Status: Status; index: Cardinal; relation: PAnsiChar); virtual; abstract;
    procedure setOwner(Status: Status; index: Cardinal; owner: PAnsiChar); virtual; abstract;
    procedure setAlias(Status: Status; index: Cardinal; alias: PAnsiChar); virtual; abstract;
  end;

  ResultSetVTable = class(ReferenceCountedVTable)
    fetchNext: ResultSet_fetchNextPtr;
    fetchPrior: ResultSet_fetchPriorPtr;
    fetchFirst: ResultSet_fetchFirstPtr;
    fetchLast: ResultSet_fetchLastPtr;
    fetchAbsolute: ResultSet_fetchAbsolutePtr;
    fetchRelative: ResultSet_fetchRelativePtr;
    isEof: ResultSet_isEofPtr;
    isBof: ResultSet_isBofPtr;
    getMetadata: ResultSet_getMetadataPtr;
    deprecatedClose: ResultSet_deprecatedClosePtr;
    setDelayedOutputFormat: ResultSet_setDelayedOutputFormatPtr;
    close: ResultSet_closePtr;
    getInfo: ResultSet_getInfoPtr;
  end;

  ResultSet = class(ReferenceCounted)
  const
    version = 5;

  const
    INF_RECORD_COUNT = Byte(10);

    function fetchNext(Status: Status; message: Pointer): Integer;
    function fetchPrior(Status: Status; message: Pointer): Integer;
    function fetchFirst(Status: Status; message: Pointer): Integer;
    function fetchLast(Status: Status; message: Pointer): Integer;
    function fetchAbsolute(Status: Status; position: Integer; message: Pointer): Integer;
    function fetchRelative(Status: Status; offset: Integer; message: Pointer): Integer;
    function isEof(Status: Status): Boolean;
    function isBof(Status: Status): Boolean;
    function getMetadata(Status: Status): MessageMetadata;
    procedure deprecatedClose(Status: Status);
    procedure setDelayedOutputFormat(Status: Status; format: MessageMetadata);
    procedure close(Status: Status);
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
  end;

  ResultSetImpl = class(ResultSet)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function fetchNext(Status: Status; message: Pointer): Integer; virtual; abstract;
    function fetchPrior(Status: Status; message: Pointer): Integer; virtual; abstract;
    function fetchFirst(Status: Status; message: Pointer): Integer; virtual; abstract;
    function fetchLast(Status: Status; message: Pointer): Integer; virtual; abstract;
    function fetchAbsolute(Status: Status; position: Integer; message: Pointer): Integer; virtual; abstract;
    function fetchRelative(Status: Status; offset: Integer; message: Pointer): Integer; virtual; abstract;
    function isEof(Status: Status): Boolean; virtual; abstract;
    function isBof(Status: Status): Boolean; virtual; abstract;
    function getMetadata(Status: Status): MessageMetadata; virtual; abstract;
    procedure deprecatedClose(Status: Status); virtual; abstract;
    procedure setDelayedOutputFormat(Status: Status; format: MessageMetadata); virtual; abstract;
    procedure close(Status: Status); virtual; abstract;
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
  end;

  StatementVTable = class(ReferenceCountedVTable)
    getInfo: Statement_getInfoPtr;
    getType: Statement_getTypePtr;
    getPlan: Statement_getPlanPtr;
    getAffectedRecords: Statement_getAffectedRecordsPtr;
    getInputMetadata: Statement_getInputMetadataPtr;
    getOutputMetadata: Statement_getOutputMetadataPtr;
    execute: Statement_executePtr;
    openCursor: Statement_openCursorPtr;
    setCursorName: Statement_setCursorNamePtr;
    deprecatedFree: Statement_deprecatedFreePtr;
    getFlags: Statement_getFlagsPtr;
    getTimeout: Statement_getTimeoutPtr;
    setTimeout: Statement_setTimeoutPtr;
    createBatch: Statement_createBatchPtr;
    free: Statement_freePtr;
  end;

  Statement = class(ReferenceCounted)
  const
    version = 5;

  const
    PREPARE_PREFETCH_NONE = Cardinal($0);

  const
    PREPARE_PREFETCH_TYPE = Cardinal($1);

  const
    PREPARE_PREFETCH_INPUT_PARAMETERS = Cardinal($2);

  const
    PREPARE_PREFETCH_OUTPUT_PARAMETERS = Cardinal($4);

  const
    PREPARE_PREFETCH_LEGACY_PLAN = Cardinal($8);

  const
    PREPARE_PREFETCH_DETAILED_PLAN = Cardinal($10);

  const
    PREPARE_PREFETCH_AFFECTED_RECORDS = Cardinal($20);

  const
    PREPARE_PREFETCH_FLAGS = Cardinal($40);

  const
    PREPARE_REQUIRE_SEMICOLON = Cardinal($80);

  const
    PREPARE_PREFETCH_METADATA = Cardinal(Statement.PREPARE_PREFETCH_TYPE or Statement.PREPARE_PREFETCH_FLAGS or
      Statement.PREPARE_PREFETCH_INPUT_PARAMETERS or Statement.PREPARE_PREFETCH_OUTPUT_PARAMETERS);

  const
    PREPARE_PREFETCH_ALL = Cardinal(Statement.PREPARE_PREFETCH_METADATA or Statement.PREPARE_PREFETCH_LEGACY_PLAN or
      Statement.PREPARE_PREFETCH_DETAILED_PLAN or Statement.PREPARE_PREFETCH_AFFECTED_RECORDS);

  const
    FLAG_HAS_CURSOR = Cardinal($1);

  const
    FLAG_REPEAT_EXECUTE = Cardinal($2);

  const
    CURSOR_TYPE_SCROLLABLE = Cardinal($1);

    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    function getType(Status: Status): Cardinal;
    function getPlan(Status: Status; detailed: Boolean): PAnsiChar;
    function getAffectedRecords(Status: Status): QWord;
    function getInputMetadata(Status: Status): MessageMetadata;
    function getOutputMetadata(Status: Status): MessageMetadata;
    function execute(Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata;
      outBuffer: Pointer): Transaction;
    function openCursor(Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata;
      flags: Cardinal): ResultSet;
    procedure setCursorName(Status: Status; name: PAnsiChar);
    procedure deprecatedFree(Status: Status);
    function getFlags(Status: Status): Cardinal;
    function getTimeout(Status: Status): Cardinal;
    procedure setTimeout(Status: Status; timeOut: Cardinal);
    function createBatch(Status: Status; inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch;
    procedure free(Status: Status);
  end;

  StatementImpl = class(Statement)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    function getType(Status: Status): Cardinal; virtual; abstract;
    function getPlan(Status: Status; detailed: Boolean): PAnsiChar; virtual; abstract;
    function getAffectedRecords(Status: Status): QWord; virtual; abstract;
    function getInputMetadata(Status: Status): MessageMetadata; virtual; abstract;
    function getOutputMetadata(Status: Status): MessageMetadata; virtual; abstract;
    function execute(Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata;
      outBuffer: Pointer): Transaction; virtual; abstract;
    function openCursor(Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata;
      flags: Cardinal): ResultSet; virtual; abstract;
    procedure setCursorName(Status: Status; name: PAnsiChar); virtual; abstract;
    procedure deprecatedFree(Status: Status); virtual; abstract;
    function getFlags(Status: Status): Cardinal; virtual; abstract;
    function getTimeout(Status: Status): Cardinal; virtual; abstract;
    procedure setTimeout(Status: Status; timeOut: Cardinal); virtual; abstract;
    function createBatch(Status: Status; inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch; virtual; abstract;
    procedure free(Status: Status); virtual; abstract;
  end;

  BatchVTable = class(ReferenceCountedVTable)
    add: Batch_addPtr;
    addBlob: Batch_addBlobPtr;
    appendBlobData: Batch_appendBlobDataPtr;
    addBlobStream: Batch_addBlobStreamPtr;
    registerBlob: Batch_registerBlobPtr;
    execute: Batch_executePtr;
    cancel: Batch_cancelPtr;
    getBlobAlignment: Batch_getBlobAlignmentPtr;
    getMetadata: Batch_getMetadataPtr;
    setDefaultBpb: Batch_setDefaultBpbPtr;
    deprecatedClose: Batch_deprecatedClosePtr;
    close: Batch_closePtr;
    getInfo: Batch_getInfoPtr;
  end;

  Batch = class(ReferenceCounted)
  const
    version = 4;

  const
    VERSION1 = Byte(1);

  const
    CURRENT_VERSION = Byte(Batch.VERSION1);

  const
    TAG_MULTIERROR = Byte(1);

  const
    TAG_RECORD_COUNTS = Byte(2);

  const
    TAG_BUFFER_BYTES_SIZE = Byte(3);

  const
    TAG_BLOB_POLICY = Byte(4);

  const
    TAG_DETAILED_ERRORS = Byte(5);

  const
    INF_BUFFER_BYTES_SIZE = Byte(10);

  const
    INF_DATA_BYTES_SIZE = Byte(11);

  const
    INF_BLOBS_BYTES_SIZE = Byte(12);

  const
    INF_BLOB_ALIGNMENT = Byte(13);

  const
    INF_BLOB_HEADER = Byte(14);

  const
    BLOB_NONE = Byte(0);

  const
    BLOB_ID_ENGINE = Byte(1);

  const
    BLOB_ID_USER = Byte(2);

  const
    BLOB_STREAM = Byte(3);

  const
    BLOB_SEGHDR_ALIGN = Cardinal(2);

    procedure add(Status: Status; count: Cardinal; inBuffer: Pointer);
    procedure addBlob(Status: Status; length: Cardinal; inBuffer: Pointer; blobId: ISC_QUADPtr; parLength: Cardinal; par: BytePtr);
    procedure appendBlobData(Status: Status; length: Cardinal; inBuffer: Pointer);
    procedure addBlobStream(Status: Status; length: Cardinal; inBuffer: Pointer);
    procedure registerBlob(Status: Status; existingBlob: ISC_QUADPtr; blobId: ISC_QUADPtr);
    function execute(Status: Status; Transaction: Transaction): BatchCompletionState;
    procedure cancel(Status: Status);
    function getBlobAlignment(Status: Status): Cardinal;
    function getMetadata(Status: Status): MessageMetadata;
    procedure setDefaultBpb(Status: Status; parLength: Cardinal; par: BytePtr);
    procedure deprecatedClose(Status: Status);
    procedure close(Status: Status);
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
  end;

  BatchImpl = class(Batch)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure add(Status: Status; count: Cardinal; inBuffer: Pointer); virtual; abstract;
    procedure addBlob(Status: Status; length: Cardinal; inBuffer: Pointer; blobId: ISC_QUADPtr; parLength: Cardinal; par: BytePtr); virtual; abstract;
    procedure appendBlobData(Status: Status; length: Cardinal; inBuffer: Pointer); virtual; abstract;
    procedure addBlobStream(Status: Status; length: Cardinal; inBuffer: Pointer); virtual; abstract;
    procedure registerBlob(Status: Status; existingBlob: ISC_QUADPtr; blobId: ISC_QUADPtr); virtual; abstract;
    function execute(Status: Status; Transaction: Transaction): BatchCompletionState; virtual; abstract;
    procedure cancel(Status: Status); virtual; abstract;
    function getBlobAlignment(Status: Status): Cardinal; virtual; abstract;
    function getMetadata(Status: Status): MessageMetadata; virtual; abstract;
    procedure setDefaultBpb(Status: Status; parLength: Cardinal; par: BytePtr); virtual; abstract;
    procedure deprecatedClose(Status: Status); virtual; abstract;
    procedure close(Status: Status); virtual; abstract;
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
  end;

  BatchCompletionStateVTable = class(DisposableVTable)
    getSize: BatchCompletionState_getSizePtr;
    getState: BatchCompletionState_getStatePtr;
    findError: BatchCompletionState_findErrorPtr;
    getStatus: BatchCompletionState_getStatusPtr;
  end;

  BatchCompletionState = class(Disposable)
  const
    version = 3;

  const
    EXECUTE_FAILED = Integer(-1);

  const
    SUCCESS_NO_INFO = Integer(-2);

  const
    NO_MORE_ERRORS = Cardinal($FFFFFFFF);

    function getSize(Status: Status): Cardinal;
    function getState(Status: Status; pos: Cardinal): Integer;
    function findError(Status: Status; pos: Cardinal): Cardinal;
    procedure getStatus(Status: Status; to_: Status; pos: Cardinal);
  end;

  BatchCompletionStateImpl = class(BatchCompletionState)
    constructor create;

    procedure dispose(); virtual; abstract;
    function getSize(Status: Status): Cardinal; virtual; abstract;
    function getState(Status: Status; pos: Cardinal): Integer; virtual; abstract;
    function findError(Status: Status; pos: Cardinal): Cardinal; virtual; abstract;
    procedure getStatus(Status: Status; to_: Status; pos: Cardinal); virtual; abstract;
  end;

  ReplicatorVTable = class(ReferenceCountedVTable)
    process: Replicator_processPtr;
    deprecatedClose: Replicator_deprecatedClosePtr;
    close: Replicator_closePtr;
  end;

  Replicator = class(ReferenceCounted)
  const
    version = 4;

    procedure process(Status: Status; length: Cardinal; data: BytePtr);
    procedure deprecatedClose(Status: Status);
    procedure close(Status: Status);
  end;

  ReplicatorImpl = class(Replicator)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure process(Status: Status; length: Cardinal; data: BytePtr); virtual; abstract;
    procedure deprecatedClose(Status: Status); virtual; abstract;
    procedure close(Status: Status); virtual; abstract;
  end;

  RequestVTable = class(ReferenceCountedVTable)
    receive: Request_receivePtr;
    send: Request_sendPtr;
    getInfo: Request_getInfoPtr;
    start: Request_startPtr;
    startAndSend: Request_startAndSendPtr;
    unwind: Request_unwindPtr;
    deprecatedFree: Request_deprecatedFreePtr;
    free: Request_freePtr;
  end;

  Request = class(ReferenceCounted)
  const
    version = 4;

    procedure receive(Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer);
    procedure send(Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer);
    procedure getInfo(Status: Status; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    procedure start(Status: Status; tra: Transaction; level: Integer);
    procedure startAndSend(Status: Status; tra: Transaction; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer);
    procedure unwind(Status: Status; level: Integer);
    procedure deprecatedFree(Status: Status);
    procedure free(Status: Status);
  end;

  RequestImpl = class(Request)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure receive(Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer); virtual; abstract;
    procedure send(Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer); virtual; abstract;
    procedure getInfo(Status: Status; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
      virtual; abstract;
    procedure start(Status: Status; tra: Transaction; level: Integer); virtual; abstract;
    procedure startAndSend(Status: Status; tra: Transaction; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer); virtual;
      abstract;
    procedure unwind(Status: Status; level: Integer); virtual; abstract;
    procedure deprecatedFree(Status: Status); virtual; abstract;
    procedure free(Status: Status); virtual; abstract;
  end;

  EventsVTable = class(ReferenceCountedVTable)
    deprecatedCancel: Events_deprecatedCancelPtr;
    cancel: Events_cancelPtr;
  end;

  Events = class(ReferenceCounted)
  const
    version = 4;

    procedure deprecatedCancel(Status: Status);
    procedure cancel(Status: Status);
  end;

  EventsImpl = class(Events)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure deprecatedCancel(Status: Status); virtual; abstract;
    procedure cancel(Status: Status); virtual; abstract;
  end;

  AttachmentVTable = class(ReferenceCountedVTable)
    getInfo: Attachment_getInfoPtr;
    startTransaction: Attachment_startTransactionPtr;
    reconnectTransaction: Attachment_reconnectTransactionPtr;
    compileRequest: Attachment_compileRequestPtr;
    transactRequest: Attachment_transactRequestPtr;
    createBlob: Attachment_createBlobPtr;
    openBlob: Attachment_openBlobPtr;
    getSlice: Attachment_getSlicePtr;
    putSlice: Attachment_putSlicePtr;
    executeDyn: Attachment_executeDynPtr;
    prepare: Attachment_preparePtr;
    execute: Attachment_executePtr;
    openCursor: Attachment_openCursorPtr;
    queEvents: Attachment_queEventsPtr;
    cancelOperation: Attachment_cancelOperationPtr;
    ping: Attachment_pingPtr;
    deprecatedDetach: Attachment_deprecatedDetachPtr;
    deprecatedDropDatabase: Attachment_deprecatedDropDatabasePtr;
    getIdleTimeout: Attachment_getIdleTimeoutPtr;
    setIdleTimeout: Attachment_setIdleTimeoutPtr;
    getStatementTimeout: Attachment_getStatementTimeoutPtr;
    setStatementTimeout: Attachment_setStatementTimeoutPtr;
    createBatch: Attachment_createBatchPtr;
    createReplicator: Attachment_createReplicatorPtr;
    detach: Attachment_detachPtr;
    dropDatabase: Attachment_dropDatabasePtr;
  end;

  Attachment = class(ReferenceCounted)
  const
    version = 5;

    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    function startTransaction(Status: Status; tpbLength: Cardinal; tpb: BytePtr): Transaction;
    function reconnectTransaction(Status: Status; length: Cardinal; id: BytePtr): Transaction;
    function compileRequest(Status: Status; blrLength: Cardinal; blr: BytePtr): Request;
    procedure transactRequest(Status: Status; Transaction: Transaction; blrLength: Cardinal; blr: BytePtr; inMsgLength: Cardinal; inMsg: BytePtr;
      outMsgLength: Cardinal; outMsg: BytePtr);
    function createBlob(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): Blob;
    function openBlob(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): Blob;
    function getSlice(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer;
    procedure putSlice(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr);
    procedure executeDyn(Status: Status; Transaction: Transaction; length: Cardinal; dyn: BytePtr);
    function prepare(Status: Status; tra: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal; flags: Cardinal): Statement;
    function execute(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; outBuffer: Pointer): Transaction;
    function openCursor(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal): ResultSet;
    function queEvents(Status: Status; callback: EventCallback; length: Cardinal; Events: BytePtr): Events;
    procedure cancelOperation(Status: Status; option: Integer);
    procedure ping(Status: Status);
    procedure deprecatedDetach(Status: Status);
    procedure deprecatedDropDatabase(Status: Status);
    function getIdleTimeout(Status: Status): Cardinal;
    procedure setIdleTimeout(Status: Status; timeOut: Cardinal);
    function getStatementTimeout(Status: Status): Cardinal;
    procedure setStatementTimeout(Status: Status; timeOut: Cardinal);
    function createBatch(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch;
    function createReplicator(Status: Status): Replicator;
    procedure detach(Status: Status);
    procedure dropDatabase(Status: Status);
  end;

  AttachmentImpl = class(Attachment)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    function startTransaction(Status: Status; tpbLength: Cardinal; tpb: BytePtr): Transaction; virtual; abstract;
    function reconnectTransaction(Status: Status; length: Cardinal; id: BytePtr): Transaction; virtual; abstract;
    function compileRequest(Status: Status; blrLength: Cardinal; blr: BytePtr): Request; virtual; abstract;
    procedure transactRequest(Status: Status; Transaction: Transaction; blrLength: Cardinal; blr: BytePtr; inMsgLength: Cardinal; inMsg: BytePtr;
      outMsgLength: Cardinal; outMsg: BytePtr); virtual; abstract;
    function createBlob(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): Blob; virtual; abstract;
    function openBlob(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): Blob; virtual; abstract;
    function getSlice(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer; virtual; abstract;
    procedure putSlice(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr); virtual; abstract;
    procedure executeDyn(Status: Status; Transaction: Transaction; length: Cardinal; dyn: BytePtr); virtual; abstract;
    function prepare(Status: Status; tra: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal; flags: Cardinal): Statement;
      virtual; abstract;
    function execute(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; outBuffer: Pointer): Transaction; virtual; abstract;
    function openCursor(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal): ResultSet;
      virtual; abstract;
    function queEvents(Status: Status; callback: EventCallback; length: Cardinal; Events: BytePtr): Events; virtual; abstract;
    procedure cancelOperation(Status: Status; option: Integer); virtual; abstract;
    procedure ping(Status: Status); virtual; abstract;
    procedure deprecatedDetach(Status: Status); virtual; abstract;
    procedure deprecatedDropDatabase(Status: Status); virtual; abstract;
    function getIdleTimeout(Status: Status): Cardinal; virtual; abstract;
    procedure setIdleTimeout(Status: Status; timeOut: Cardinal); virtual; abstract;
    function getStatementTimeout(Status: Status): Cardinal; virtual; abstract;
    procedure setStatementTimeout(Status: Status; timeOut: Cardinal); virtual; abstract;
    function createBatch(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch; virtual; abstract;
    function createReplicator(Status: Status): Replicator; virtual; abstract;
    procedure detach(Status: Status); virtual; abstract;
    procedure dropDatabase(Status: Status); virtual; abstract;
  end;

  ServiceVTable = class(ReferenceCountedVTable)
    deprecatedDetach: Service_deprecatedDetachPtr;
    query: Service_queryPtr;
    start: Service_startPtr;
    detach: Service_detachPtr;
    cancel: Service_cancelPtr;
  end;

  Service = class(ReferenceCounted)
  const
    version = 5;

    procedure deprecatedDetach(Status: Status);
    procedure query(Status: Status; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal; receiveItems: BytePtr; bufferLength: Cardinal;
      buffer: BytePtr);
    procedure start(Status: Status; spbLength: Cardinal; spb: BytePtr);
    procedure detach(Status: Status);
    procedure cancel(Status: Status);
  end;

  ServiceImpl = class(Service)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure deprecatedDetach(Status: Status); virtual; abstract;
    procedure query(Status: Status; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal; receiveItems: BytePtr; bufferLength: Cardinal;
      buffer: BytePtr); virtual; abstract;
    procedure start(Status: Status; spbLength: Cardinal; spb: BytePtr); virtual; abstract;
    procedure detach(Status: Status); virtual; abstract;
    procedure cancel(Status: Status); virtual; abstract;
  end;

  ProviderVTable = class(PluginBaseVTable)
    attachDatabase: Provider_attachDatabasePtr;
    createDatabase: Provider_createDatabasePtr;
    attachServiceManager: Provider_attachServiceManagerPtr;
    shutdown: Provider_shutdownPtr;
    setDbCryptCallback: Provider_setDbCryptCallbackPtr;
  end;

  Provider = class(PluginBase)
  const
    version = 4;

    function attachDatabase(Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment;
    function createDatabase(Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment;
    function attachServiceManager(Status: Status; Service: PAnsiChar; spbLength: Cardinal; spb: BytePtr): Service;
    procedure shutdown(Status: Status; timeOut: Cardinal; reason: Integer);
    procedure setDbCryptCallback(Status: Status; cryptCallback: CryptKeyCallback);
  end;

  ProviderImpl = class(Provider)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    function attachDatabase(Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment; virtual; abstract;
    function createDatabase(Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment; virtual; abstract;
    function attachServiceManager(Status: Status; Service: PAnsiChar; spbLength: Cardinal; spb: BytePtr): Service; virtual; abstract;
    procedure shutdown(Status: Status; timeOut: Cardinal; reason: Integer); virtual; abstract;
    procedure setDbCryptCallback(Status: Status; cryptCallback: CryptKeyCallback); virtual; abstract;
  end;

  DtcStartVTable = class(DisposableVTable)
    addAttachment: DtcStart_addAttachmentPtr;
    addWithTpb: DtcStart_addWithTpbPtr;
    start: DtcStart_startPtr;
  end;

  DtcStart = class(Disposable)
  const
    version = 3;

    procedure addAttachment(Status: Status; att: Attachment);
    procedure addWithTpb(Status: Status; att: Attachment; length: Cardinal; tpb: BytePtr);
    function start(Status: Status): Transaction;
  end;

  DtcStartImpl = class(DtcStart)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure addAttachment(Status: Status; att: Attachment); virtual; abstract;
    procedure addWithTpb(Status: Status; att: Attachment; length: Cardinal; tpb: BytePtr); virtual; abstract;
    function start(Status: Status): Transaction; virtual; abstract;
  end;

  DtcVTable = class(VersionedVTable)
    join: Dtc_joinPtr;
    startBuilder: Dtc_startBuilderPtr;
  end;

  Dtc = class(Versioned)
  const
    version = 2;

    function join(Status: Status; one: Transaction; two: Transaction): Transaction;
    function startBuilder(Status: Status): DtcStart;
  end;

  DtcImpl = class(Dtc)
    constructor create;

    function join(Status: Status; one: Transaction; two: Transaction): Transaction; virtual; abstract;
    function startBuilder(Status: Status): DtcStart; virtual; abstract;
  end;

  AuthVTable = class(PluginBaseVTable)
  end;

  Auth = class(PluginBase)
  const
    version = 4;

  const
    AUTH_FAILED = Integer(-1);

  const
    AUTH_SUCCESS = Integer(0);

  const
    AUTH_MORE_DATA = Integer(1);

  const
    AUTH_CONTINUE = Integer(2);

  end;

  AuthImpl = class(Auth)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
  end;

  WriterVTable = class(VersionedVTable)
    reset: Writer_resetPtr;
    add: Writer_addPtr;
    setType: Writer_setTypePtr;
    setDb: Writer_setDbPtr;
  end;

  Writer = class(Versioned)
  const
    version = 2;

    procedure reset();
    procedure add(Status: Status; name: PAnsiChar);
    procedure setType(Status: Status; value: PAnsiChar);
    procedure setDb(Status: Status; value: PAnsiChar);
  end;

  WriterImpl = class(Writer)
    constructor create;

    procedure reset(); virtual; abstract;
    procedure add(Status: Status; name: PAnsiChar); virtual; abstract;
    procedure setType(Status: Status; value: PAnsiChar); virtual; abstract;
    procedure setDb(Status: Status; value: PAnsiChar); virtual; abstract;
  end;

  ServerBlockVTable = class(VersionedVTable)
    getLogin: ServerBlock_getLoginPtr;
    getData: ServerBlock_getDataPtr;
    putData: ServerBlock_putDataPtr;
    newKey: ServerBlock_newKeyPtr;
  end;

  ServerBlock = class(Versioned)
  const
    version = 2;

    function getLogin(): PAnsiChar;
    function getData(length: CardinalPtr): BytePtr;
    procedure putData(Status: Status; length: Cardinal; data: Pointer);
    function newKey(Status: Status): CryptKey;
  end;

  ServerBlockImpl = class(ServerBlock)
    constructor create;

    function getLogin(): PAnsiChar; virtual; abstract;
    function getData(length: CardinalPtr): BytePtr; virtual; abstract;
    procedure putData(Status: Status; length: Cardinal; data: Pointer); virtual; abstract;
    function newKey(Status: Status): CryptKey; virtual; abstract;
  end;

  ClientBlockVTable = class(ReferenceCountedVTable)
    getLogin: ClientBlock_getLoginPtr;
    getPassword: ClientBlock_getPasswordPtr;
    getData: ClientBlock_getDataPtr;
    putData: ClientBlock_putDataPtr;
    newKey: ClientBlock_newKeyPtr;
    getAuthBlock: ClientBlock_getAuthBlockPtr;
  end;

  ClientBlock = class(ReferenceCounted)
  const
    version = 4;

    function getLogin(): PAnsiChar;
    function getPassword(): PAnsiChar;
    function getData(length: CardinalPtr): BytePtr;
    procedure putData(Status: Status; length: Cardinal; data: Pointer);
    function newKey(Status: Status): CryptKey;
    function getAuthBlock(Status: Status): AuthBlock;
  end;

  ClientBlockImpl = class(ClientBlock)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getLogin(): PAnsiChar; virtual; abstract;
    function getPassword(): PAnsiChar; virtual; abstract;
    function getData(length: CardinalPtr): BytePtr; virtual; abstract;
    procedure putData(Status: Status; length: Cardinal; data: Pointer); virtual; abstract;
    function newKey(Status: Status): CryptKey; virtual; abstract;
    function getAuthBlock(Status: Status): AuthBlock; virtual; abstract;
  end;

  ServerVTable = class(AuthVTable)
    authenticate: Server_authenticatePtr;
    setDbCryptCallback: Server_setDbCryptCallbackPtr;
  end;

  Server = class(Auth)
  const
    version = 6;

    function authenticate(Status: Status; sBlock: ServerBlock; writerInterface: Writer): Integer;
    procedure setDbCryptCallback(Status: Status; cryptCallback: CryptKeyCallback);
  end;

  ServerImpl = class(Server)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    function authenticate(Status: Status; sBlock: ServerBlock; writerInterface: Writer): Integer; virtual; abstract;
    procedure setDbCryptCallback(Status: Status; cryptCallback: CryptKeyCallback); virtual; abstract;
  end;

  ClientVTable = class(AuthVTable)
    authenticate: Client_authenticatePtr;
  end;

  Client = class(Auth)
  const
    version = 5;

    function authenticate(Status: Status; cBlock: ClientBlock): Integer;
  end;

  ClientImpl = class(Client)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    function authenticate(Status: Status; cBlock: ClientBlock): Integer; virtual; abstract;
  end;

  UserFieldVTable = class(VersionedVTable)
    entered: UserField_enteredPtr;
    specified: UserField_specifiedPtr;
    setEntered: UserField_setEnteredPtr;
  end;

  UserField = class(Versioned)
  const
    version = 2;

    function entered(): Integer;
    function specified(): Integer;
    procedure setEntered(Status: Status; newValue: Integer);
  end;

  UserFieldImpl = class(UserField)
    constructor create;

    function entered(): Integer; virtual; abstract;
    function specified(): Integer; virtual; abstract;
    procedure setEntered(Status: Status; newValue: Integer); virtual; abstract;
  end;

  CharUserFieldVTable = class(UserFieldVTable)
    get: CharUserField_getPtr;
    set_: CharUserField_set_Ptr;
  end;

  CharUserField = class(UserField)
  const
    version = 3;

    function get(): PAnsiChar;
    procedure set_(Status: Status; newValue: PAnsiChar);
  end;

  CharUserFieldImpl = class(CharUserField)
    constructor create;

    function entered(): Integer; virtual; abstract;
    function specified(): Integer; virtual; abstract;
    procedure setEntered(Status: Status; newValue: Integer); virtual; abstract;
    function get(): PAnsiChar; virtual; abstract;
    procedure set_(Status: Status; newValue: PAnsiChar); virtual; abstract;
  end;

  IntUserFieldVTable = class(UserFieldVTable)
    get: IntUserField_getPtr;
    set_: IntUserField_set_Ptr;
  end;

  IntUserField = class(UserField)
  const
    version = 3;

    function get(): Integer;
    procedure set_(Status: Status; newValue: Integer);
  end;

  IntUserFieldImpl = class(IntUserField)
    constructor create;

    function entered(): Integer; virtual; abstract;
    function specified(): Integer; virtual; abstract;
    procedure setEntered(Status: Status; newValue: Integer); virtual; abstract;
    function get(): Integer; virtual; abstract;
    procedure set_(Status: Status; newValue: Integer); virtual; abstract;
  end;

  UserVTable = class(VersionedVTable)
    operation: User_operationPtr;
    userName: User_userNamePtr;
    password: User_passwordPtr;
    firstName: User_firstNamePtr;
    lastName: User_lastNamePtr;
    middleName: User_middleNamePtr;
    comment: User_commentPtr;
    attributes: User_attributesPtr;
    active: User_activePtr;
    admin: User_adminPtr;
    clear: User_clearPtr;
  end;

  User = class(Versioned)
  const
    version = 2;

  const
    OP_USER_ADD = Cardinal(1);

  const
    OP_USER_MODIFY = Cardinal(2);

  const
    OP_USER_DELETE = Cardinal(3);

  const
    OP_USER_DISPLAY = Cardinal(4);

  const
    OP_USER_SET_MAP = Cardinal(5);

  const
    OP_USER_DROP_MAP = Cardinal(6);

    function operation(): Cardinal;
    function userName(): CharUserField;
    function password(): CharUserField;
    function firstName(): CharUserField;
    function lastName(): CharUserField;
    function middleName(): CharUserField;
    function comment(): CharUserField;
    function attributes(): CharUserField;
    function active(): IntUserField;
    function admin(): IntUserField;
    procedure clear(Status: Status);
  end;

  UserImpl = class(User)
    constructor create;

    function operation(): Cardinal; virtual; abstract;
    function userName(): CharUserField; virtual; abstract;
    function password(): CharUserField; virtual; abstract;
    function firstName(): CharUserField; virtual; abstract;
    function lastName(): CharUserField; virtual; abstract;
    function middleName(): CharUserField; virtual; abstract;
    function comment(): CharUserField; virtual; abstract;
    function attributes(): CharUserField; virtual; abstract;
    function active(): IntUserField; virtual; abstract;
    function admin(): IntUserField; virtual; abstract;
    procedure clear(Status: Status); virtual; abstract;
  end;

  ListUsersVTable = class(VersionedVTable)
    list: ListUsers_listPtr;
  end;

  ListUsers = class(Versioned)
  const
    version = 2;

    procedure list(Status: Status; User: User);
  end;

  ListUsersImpl = class(ListUsers)
    constructor create;

    procedure list(Status: Status; User: User); virtual; abstract;
  end;

  LogonInfoVTable = class(VersionedVTable)
    name: LogonInfo_namePtr;
    role: LogonInfo_rolePtr;
    networkProtocol: LogonInfo_networkProtocolPtr;
    remoteAddress: LogonInfo_remoteAddressPtr;
    AuthBlock: LogonInfo_authBlockPtr;
    Attachment: LogonInfo_attachmentPtr;
    Transaction: LogonInfo_transactionPtr;
  end;

  LogonInfo = class(Versioned)
  const
    version = 3;

    function name(): PAnsiChar;
    function role(): PAnsiChar;
    function networkProtocol(): PAnsiChar;
    function remoteAddress(): PAnsiChar;
    function AuthBlock(length: CardinalPtr): BytePtr;
    function Attachment(Status: Status): Attachment;
    function Transaction(Status: Status): Transaction;
  end;

  LogonInfoImpl = class(LogonInfo)
    constructor create;

    function name(): PAnsiChar; virtual; abstract;
    function role(): PAnsiChar; virtual; abstract;
    function networkProtocol(): PAnsiChar; virtual; abstract;
    function remoteAddress(): PAnsiChar; virtual; abstract;
    function AuthBlock(length: CardinalPtr): BytePtr; virtual; abstract;
    function Attachment(Status: Status): Attachment; virtual; abstract;
    function Transaction(Status: Status): Transaction; virtual; abstract;
  end;

  ManagementVTable = class(PluginBaseVTable)
    start: Management_startPtr;
    execute: Management_executePtr;
    commit: Management_commitPtr;
    rollback: Management_rollbackPtr;
  end;

  Management = class(PluginBase)
  const
    version = 4;

    procedure start(Status: Status; LogonInfo: LogonInfo);
    function execute(Status: Status; User: User; callback: ListUsers): Integer;
    procedure commit(Status: Status);
    procedure rollback(Status: Status);
  end;

  ManagementImpl = class(Management)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    procedure start(Status: Status; LogonInfo: LogonInfo); virtual; abstract;
    function execute(Status: Status; User: User; callback: ListUsers): Integer; virtual; abstract;
    procedure commit(Status: Status); virtual; abstract;
    procedure rollback(Status: Status); virtual; abstract;
  end;

  AuthBlockVTable = class(VersionedVTable)
    getType: AuthBlock_getTypePtr;
    getName: AuthBlock_getNamePtr;
    getPlugin: AuthBlock_getPluginPtr;
    getSecurityDb: AuthBlock_getSecurityDbPtr;
    getOriginalPlugin: AuthBlock_getOriginalPluginPtr;
    next: AuthBlock_nextPtr;
    first: AuthBlock_firstPtr;
  end;

  AuthBlock = class(Versioned)
  const
    version = 2;

    function getType(): PAnsiChar;
    function getName(): PAnsiChar;
    function getPlugin(): PAnsiChar;
    function getSecurityDb(): PAnsiChar;
    function getOriginalPlugin(): PAnsiChar;
    function next(Status: Status): Boolean;
    function first(Status: Status): Boolean;
  end;

  AuthBlockImpl = class(AuthBlock)
    constructor create;

    function getType(): PAnsiChar; virtual; abstract;
    function getName(): PAnsiChar; virtual; abstract;
    function getPlugin(): PAnsiChar; virtual; abstract;
    function getSecurityDb(): PAnsiChar; virtual; abstract;
    function getOriginalPlugin(): PAnsiChar; virtual; abstract;
    function next(Status: Status): Boolean; virtual; abstract;
    function first(Status: Status): Boolean; virtual; abstract;
  end;

  WireCryptPluginVTable = class(PluginBaseVTable)
    getKnownTypes: WireCryptPlugin_getKnownTypesPtr;
    setKey: WireCryptPlugin_setKeyPtr;
    encrypt: WireCryptPlugin_encryptPtr;
    decrypt: WireCryptPlugin_decryptPtr;
    getSpecificData: WireCryptPlugin_getSpecificDataPtr;
    setSpecificData: WireCryptPlugin_setSpecificDataPtr;
  end;

  WireCryptPlugin = class(PluginBase)
  const
    version = 5;

    function getKnownTypes(Status: Status): PAnsiChar;
    procedure setKey(Status: Status; key: CryptKey);
    procedure encrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
    procedure decrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
    function getSpecificData(Status: Status; keyType: PAnsiChar; length: CardinalPtr): BytePtr;
    procedure setSpecificData(Status: Status; keyType: PAnsiChar; length: Cardinal; data: BytePtr);
  end;

  WireCryptPluginImpl = class(WireCryptPlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    function getKnownTypes(Status: Status): PAnsiChar; virtual; abstract;
    procedure setKey(Status: Status; key: CryptKey); virtual; abstract;
    procedure encrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
    procedure decrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
    function getSpecificData(Status: Status; keyType: PAnsiChar; length: CardinalPtr): BytePtr; virtual; abstract;
    procedure setSpecificData(Status: Status; keyType: PAnsiChar; length: Cardinal; data: BytePtr); virtual; abstract;
  end;

  CryptKeyCallbackVTable = class(VersionedVTable)
    callback: CryptKeyCallback_callbackPtr;
    afterAttach: CryptKeyCallback_afterAttachPtr;
    dispose: CryptKeyCallback_disposePtr;
  end;

  CryptKeyCallback = class(Versioned)
  const
    version = 3;

  const
    NO_RETRY = Cardinal(0);

  const
    DO_RETRY = Cardinal(1);

    function callback(dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer): Cardinal;
    function afterAttach(Status: Status; dbName: PAnsiChar; attStatus: Status): Cardinal;
    procedure dispose();
  end;

  CryptKeyCallbackImpl = class(CryptKeyCallback)
    constructor create;

    function callback(dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer): Cardinal; virtual; abstract;
    function afterAttach(Status: Status; dbName: PAnsiChar; attStatus: Status): Cardinal; virtual;
    procedure dispose(); virtual;
  end;

  KeyHolderPluginVTable = class(PluginBaseVTable)
    keyCallback: KeyHolderPlugin_keyCallbackPtr;
    keyHandle: KeyHolderPlugin_keyHandlePtr;
    useOnlyOwnKeys: KeyHolderPlugin_useOnlyOwnKeysPtr;
    chainHandle: KeyHolderPlugin_chainHandlePtr;
  end;

  KeyHolderPlugin = class(PluginBase)
  const
    version = 5;

    function keyCallback(Status: Status; callback: CryptKeyCallback): Integer;
    function keyHandle(Status: Status; keyName: PAnsiChar): CryptKeyCallback;
    function useOnlyOwnKeys(Status: Status): Boolean;
    function chainHandle(Status: Status): CryptKeyCallback;
  end;

  KeyHolderPluginImpl = class(KeyHolderPlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    function keyCallback(Status: Status; callback: CryptKeyCallback): Integer; virtual; abstract;
    function keyHandle(Status: Status; keyName: PAnsiChar): CryptKeyCallback; virtual; abstract;
    function useOnlyOwnKeys(Status: Status): Boolean; virtual; abstract;
    function chainHandle(Status: Status): CryptKeyCallback; virtual; abstract;
  end;

  DbCryptInfoVTable = class(ReferenceCountedVTable)
    getDatabaseFullPath: DbCryptInfo_getDatabaseFullPathPtr;
  end;

  DbCryptInfo = class(ReferenceCounted)
  const
    version = 3;

    function getDatabaseFullPath(Status: Status): PAnsiChar;
  end;

  DbCryptInfoImpl = class(DbCryptInfo)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getDatabaseFullPath(Status: Status): PAnsiChar; virtual; abstract;
  end;

  DbCryptPluginVTable = class(PluginBaseVTable)
    setKey: DbCryptPlugin_setKeyPtr;
    encrypt: DbCryptPlugin_encryptPtr;
    decrypt: DbCryptPlugin_decryptPtr;
    setInfo: DbCryptPlugin_setInfoPtr;
  end;

  DbCryptPlugin = class(PluginBase)
  const
    version = 5;

    procedure setKey(Status: Status; length: Cardinal; sources: KeyHolderPluginPtr; keyName: PAnsiChar);
    procedure encrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
    procedure decrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
    procedure setInfo(Status: Status; info: DbCryptInfo);
  end;

  DbCryptPluginImpl = class(DbCryptPlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    procedure setKey(Status: Status; length: Cardinal; sources: KeyHolderPluginPtr; keyName: PAnsiChar); virtual; abstract;
    procedure encrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
    procedure decrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
    procedure setInfo(Status: Status; info: DbCryptInfo); virtual; abstract;
  end;

  ExternalContextVTable = class(VersionedVTable)
    getMaster: ExternalContext_getMasterPtr;
    getEngine: ExternalContext_getEnginePtr;
    getAttachment: ExternalContext_getAttachmentPtr;
    getTransaction: ExternalContext_getTransactionPtr;
    getUserName: ExternalContext_getUserNamePtr;
    getDatabaseName: ExternalContext_getDatabaseNamePtr;
    getClientCharSet: ExternalContext_getClientCharSetPtr;
    obtainInfoCode: ExternalContext_obtainInfoCodePtr;
    getInfo: ExternalContext_getInfoPtr;
    setInfo: ExternalContext_setInfoPtr;
  end;

  ExternalContext = class(Versioned)
  const
    version = 2;

    function getMaster(): Master;
    function getEngine(Status: Status): ExternalEngine;
    function getAttachment(Status: Status): Attachment;
    function getTransaction(Status: Status): Transaction;
    function getUserName(): PAnsiChar;
    function getDatabaseName(): PAnsiChar;
    function getClientCharSet(): PAnsiChar;
    function obtainInfoCode(): Integer;
    function getInfo(code: Integer): Pointer;
    function setInfo(code: Integer; value: Pointer): Pointer;
  end;

  ExternalContextImpl = class(ExternalContext)
    constructor create;

    function getMaster(): Master; virtual; abstract;
    function getEngine(Status: Status): ExternalEngine; virtual; abstract;
    function getAttachment(Status: Status): Attachment; virtual; abstract;
    function getTransaction(Status: Status): Transaction; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getDatabaseName(): PAnsiChar; virtual; abstract;
    function getClientCharSet(): PAnsiChar; virtual; abstract;
    function obtainInfoCode(): Integer; virtual; abstract;
    function getInfo(code: Integer): Pointer; virtual; abstract;
    function setInfo(code: Integer; value: Pointer): Pointer; virtual; abstract;
  end;

  ExternalResultSetVTable = class(DisposableVTable)
    fetch: ExternalResultSet_fetchPtr;
  end;

  ExternalResultSet = class(Disposable)
  const
    version = 3;

    function fetch(Status: Status): Boolean;
  end;

  ExternalResultSetImpl = class(ExternalResultSet)
    constructor create;

    procedure dispose(); virtual; abstract;
    function fetch(Status: Status): Boolean; virtual; abstract;
  end;

  ExternalFunctionVTable = class(DisposableVTable)
    getCharSet: ExternalFunction_getCharSetPtr;
    execute: ExternalFunction_executePtr;
  end;

  ExternalFunction = class(Disposable)
  const
    version = 3;

    procedure getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal);
    procedure execute(Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer);
  end;

  ExternalFunctionImpl = class(ExternalFunction)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal); virtual; abstract;
    procedure execute(Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer); virtual; abstract;
  end;

  ExternalProcedureVTable = class(DisposableVTable)
    getCharSet: ExternalProcedure_getCharSetPtr;
    open: ExternalProcedure_openPtr;
  end;

  ExternalProcedure = class(Disposable)
  const
    version = 3;

    procedure getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal);
    function open(Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer): ExternalResultSet;
  end;

  ExternalProcedureImpl = class(ExternalProcedure)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal); virtual; abstract;
    function open(Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer): ExternalResultSet; virtual; abstract;
  end;

  ExternalTriggerVTable = class(DisposableVTable)
    getCharSet: ExternalTrigger_getCharSetPtr;
    execute: ExternalTrigger_executePtr;
  end;

  ExternalTrigger = class(Disposable)
  const
    version = 3;

  const
    TYPE_BEFORE = Cardinal(1);

  const
    TYPE_AFTER = Cardinal(2);

  const
    TYPE_DATABASE = Cardinal(3);

  const
    ACTION_INSERT = Cardinal(1);

  const
    ACTION_UPDATE = Cardinal(2);

  const
    ACTION_DELETE = Cardinal(3);

  const
    ACTION_CONNECT = Cardinal(4);

  const
    ACTION_DISCONNECT = Cardinal(5);

  const
    ACTION_TRANS_START = Cardinal(6);

  const
    ACTION_TRANS_COMMIT = Cardinal(7);

  const
    ACTION_TRANS_ROLLBACK = Cardinal(8);

  const
    ACTION_DDL = Cardinal(9);

    procedure getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal);
    procedure execute(Status: Status; context: ExternalContext; action: Cardinal; oldMsg: Pointer; newMsg: Pointer);
  end;

  ExternalTriggerImpl = class(ExternalTrigger)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal); virtual; abstract;
    procedure execute(Status: Status; context: ExternalContext; action: Cardinal; oldMsg: Pointer; newMsg: Pointer); virtual; abstract;
  end;

  RoutineMetadataVTable = class(VersionedVTable)
    getPackage: RoutineMetadata_getPackagePtr;
    getName: RoutineMetadata_getNamePtr;
    getEntryPoint: RoutineMetadata_getEntryPointPtr;
    getBody: RoutineMetadata_getBodyPtr;
    getInputMetadata: RoutineMetadata_getInputMetadataPtr;
    getOutputMetadata: RoutineMetadata_getOutputMetadataPtr;
    getTriggerMetadata: RoutineMetadata_getTriggerMetadataPtr;
    getTriggerTable: RoutineMetadata_getTriggerTablePtr;
    getTriggerType: RoutineMetadata_getTriggerTypePtr;
  end;

  RoutineMetadata = class(Versioned)
  const
    version = 2;

    function getPackage(Status: Status): PAnsiChar;
    function getName(Status: Status): PAnsiChar;
    function getEntryPoint(Status: Status): PAnsiChar;
    function getBody(Status: Status): PAnsiChar;
    function getInputMetadata(Status: Status): MessageMetadata;
    function getOutputMetadata(Status: Status): MessageMetadata;
    function getTriggerMetadata(Status: Status): MessageMetadata;
    function getTriggerTable(Status: Status): PAnsiChar;
    function getTriggerType(Status: Status): Cardinal;
  end;

  RoutineMetadataImpl = class(RoutineMetadata)
    constructor create;

    function getPackage(Status: Status): PAnsiChar; virtual; abstract;
    function getName(Status: Status): PAnsiChar; virtual; abstract;
    function getEntryPoint(Status: Status): PAnsiChar; virtual; abstract;
    function getBody(Status: Status): PAnsiChar; virtual; abstract;
    function getInputMetadata(Status: Status): MessageMetadata; virtual; abstract;
    function getOutputMetadata(Status: Status): MessageMetadata; virtual; abstract;
    function getTriggerMetadata(Status: Status): MessageMetadata; virtual; abstract;
    function getTriggerTable(Status: Status): PAnsiChar; virtual; abstract;
    function getTriggerType(Status: Status): Cardinal; virtual; abstract;
  end;

  ExternalEngineVTable = class(PluginBaseVTable)
    open: ExternalEngine_openPtr;
    openAttachment: ExternalEngine_openAttachmentPtr;
    closeAttachment: ExternalEngine_closeAttachmentPtr;
    makeFunction: ExternalEngine_makeFunctionPtr;
    makeProcedure: ExternalEngine_makeProcedurePtr;
    makeTrigger: ExternalEngine_makeTriggerPtr;
  end;

  ExternalEngine = class(PluginBase)
  const
    version = 4;

    procedure open(Status: Status; context: ExternalContext; charSet: PAnsiChar; charSetSize: Cardinal);
    procedure openAttachment(Status: Status; context: ExternalContext);
    procedure closeAttachment(Status: Status; context: ExternalContext);
    function makeFunction(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
      outBuilder: MetadataBuilder): ExternalFunction;
    function makeProcedure(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
      outBuilder: MetadataBuilder): ExternalProcedure;
    function makeTrigger(Status: Status; context: ExternalContext; metadata: RoutineMetadata; fieldsBuilder: MetadataBuilder): ExternalTrigger;
  end;

  ExternalEngineImpl = class(ExternalEngine)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    procedure open(Status: Status; context: ExternalContext; charSet: PAnsiChar; charSetSize: Cardinal); virtual; abstract;
    procedure openAttachment(Status: Status; context: ExternalContext); virtual; abstract;
    procedure closeAttachment(Status: Status; context: ExternalContext); virtual; abstract;
    function makeFunction(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
      outBuilder: MetadataBuilder): ExternalFunction; virtual; abstract;
    function makeProcedure(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
      outBuilder: MetadataBuilder): ExternalProcedure; virtual; abstract;
    function makeTrigger(Status: Status; context: ExternalContext; metadata: RoutineMetadata; fieldsBuilder: MetadataBuilder): ExternalTrigger;
      virtual; abstract;
  end;

  TimerVTable = class(ReferenceCountedVTable)
    handler: Timer_handlerPtr;
  end;

  Timer = class(ReferenceCounted)
  const
    version = 3;

    procedure handler();
  end;

  TimerImpl = class(Timer)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure handler(); virtual; abstract;
  end;

  TimerControlVTable = class(VersionedVTable)
    start: TimerControl_startPtr;
    stop: TimerControl_stopPtr;
  end;

  TimerControl = class(Versioned)
  const
    version = 2;

    procedure start(Status: Status; Timer: Timer; microSeconds: QWord);
    procedure stop(Status: Status; Timer: Timer);
  end;

  TimerControlImpl = class(TimerControl)
    constructor create;

    procedure start(Status: Status; Timer: Timer; microSeconds: QWord); virtual; abstract;
    procedure stop(Status: Status; Timer: Timer); virtual; abstract;
  end;

  VersionCallbackVTable = class(VersionedVTable)
    callback: VersionCallback_callbackPtr;
  end;

  VersionCallback = class(Versioned)
  const
    version = 2;

    procedure callback(Status: Status; text: PAnsiChar);
  end;

  VersionCallbackImpl = class(VersionCallback)
    constructor create;

    procedure callback(Status: Status; text: PAnsiChar); virtual; abstract;
  end;

  UtilVTable = class(VersionedVTable)
    getFbVersion: Util_getFbVersionPtr;
    loadBlob: Util_loadBlobPtr;
    dumpBlob: Util_dumpBlobPtr;
    getPerfCounters: Util_getPerfCountersPtr;
    executeCreateDatabase: Util_executeCreateDatabasePtr;
    decodeDate: Util_decodeDatePtr;
    decodeTime: Util_decodeTimePtr;
    encodeDate: Util_encodeDatePtr;
    encodeTime: Util_encodeTimePtr;
    formatStatus: Util_formatStatusPtr;
    getClientVersion: Util_getClientVersionPtr;
    getXpbBuilder: Util_getXpbBuilderPtr;
    setOffsets: Util_setOffsetsPtr;
    getDecFloat16: Util_getDecFloat16Ptr;
    getDecFloat34: Util_getDecFloat34Ptr;
    decodeTimeTz: Util_decodeTimeTzPtr;
    decodeTimeStampTz: Util_decodeTimeStampTzPtr;
    encodeTimeTz: Util_encodeTimeTzPtr;
    encodeTimeStampTz: Util_encodeTimeStampTzPtr;
    getInt128: Util_getInt128Ptr;
    decodeTimeTzEx: Util_decodeTimeTzExPtr;
    decodeTimeStampTzEx: Util_decodeTimeStampTzExPtr;
  end;

  Util = class(Versioned)
  const
    version = 4;

    procedure getFbVersion(Status: Status; att: Attachment; callback: VersionCallback);
    procedure loadBlob(Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar; txt: Boolean);
    procedure dumpBlob(Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar; txt: Boolean);
    procedure getPerfCounters(Status: Status; att: Attachment; countersSet: PAnsiChar; counters: Int64Ptr);
    function executeCreateDatabase(Status: Status; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal; stmtIsCreateDb: BooleanPtr)
      : Attachment;
    procedure decodeDate(date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr);
    procedure decodeTime(time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr);
    function encodeDate(year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE;
    function encodeTime(hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME;
    function formatStatus(buffer: PAnsiChar; bufferSize: Cardinal; Status: Status): Cardinal;
    function getClientVersion(): Cardinal;
    function getXpbBuilder(Status: Status; kind: Cardinal; buf: BytePtr; len: Cardinal): XpbBuilder;
    function setOffsets(Status: Status; metadata: MessageMetadata; callback: OffsetsCallback): Cardinal;
    function getDecFloat16(Status: Status): DecFloat16;
    function getDecFloat34(Status: Status): DecFloat34;
    procedure decodeTimeTz(Status: Status; timeTz: ISC_TIME_TZPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
      fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar);
    procedure decodeTimeStampTz(Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr;
      hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal;
      timeZoneBuffer: PAnsiChar);
    procedure encodeTimeTz(Status: Status; timeTz: ISC_TIME_TZPtr; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal;
      timeZone: PAnsiChar);
    procedure encodeTimeStampTz(Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: Cardinal; month: Cardinal; day: Cardinal; hours: Cardinal;
      minutes: Cardinal; seconds: Cardinal; fractions: Cardinal; timeZone: PAnsiChar);
    function getInt128(Status: Status): Int128;
    procedure decodeTimeTzEx(Status: Status; timeTz: ISC_TIME_TZ_EXPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
      fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar);
    procedure decodeTimeStampTzEx(Status: Status; timeStampTz: ISC_TIMESTAMP_TZ_EXPtr; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr;
      hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal;
      timeZoneBuffer: PAnsiChar);
  end;

  UtilImpl = class(Util)
    constructor create;

    procedure getFbVersion(Status: Status; att: Attachment; callback: VersionCallback); virtual; abstract;
    procedure loadBlob(Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar; txt: Boolean); virtual; abstract;
    procedure dumpBlob(Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar; txt: Boolean); virtual; abstract;
    procedure getPerfCounters(Status: Status; att: Attachment; countersSet: PAnsiChar; counters: Int64Ptr); virtual; abstract;
    function executeCreateDatabase(Status: Status; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal; stmtIsCreateDb: BooleanPtr)
      : Attachment; virtual; abstract;
    procedure decodeDate(date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr); virtual; abstract;
    procedure decodeTime(time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr); virtual; abstract;
    function encodeDate(year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE; virtual; abstract;
    function encodeTime(hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME; virtual; abstract;
    function formatStatus(buffer: PAnsiChar; bufferSize: Cardinal; Status: Status): Cardinal; virtual; abstract;
    function getClientVersion(): Cardinal; virtual; abstract;
    function getXpbBuilder(Status: Status; kind: Cardinal; buf: BytePtr; len: Cardinal): XpbBuilder; virtual; abstract;
    function setOffsets(Status: Status; metadata: MessageMetadata; callback: OffsetsCallback): Cardinal; virtual; abstract;
    function getDecFloat16(Status: Status): DecFloat16; virtual; abstract;
    function getDecFloat34(Status: Status): DecFloat34; virtual; abstract;
    procedure decodeTimeTz(Status: Status; timeTz: ISC_TIME_TZPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
      fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar); virtual; abstract;
    procedure decodeTimeStampTz(Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr;
      hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal;
      timeZoneBuffer: PAnsiChar); virtual; abstract;
    procedure encodeTimeTz(Status: Status; timeTz: ISC_TIME_TZPtr; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal;
      timeZone: PAnsiChar); virtual; abstract;
    procedure encodeTimeStampTz(Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: Cardinal; month: Cardinal; day: Cardinal; hours: Cardinal;
      minutes: Cardinal; seconds: Cardinal; fractions: Cardinal; timeZone: PAnsiChar); virtual; abstract;
    function getInt128(Status: Status): Int128; virtual; abstract;
    procedure decodeTimeTzEx(Status: Status; timeTz: ISC_TIME_TZ_EXPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
      fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar); virtual; abstract;
    procedure decodeTimeStampTzEx(Status: Status; timeStampTz: ISC_TIMESTAMP_TZ_EXPtr; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr;
      hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal;
      timeZoneBuffer: PAnsiChar); virtual; abstract;
  end;

  OffsetsCallbackVTable = class(VersionedVTable)
    setOffset: OffsetsCallback_setOffsetPtr;
  end;

  OffsetsCallback = class(Versioned)
  const
    version = 2;

    procedure setOffset(Status: Status; index: Cardinal; offset: Cardinal; nullOffset: Cardinal);
  end;

  OffsetsCallbackImpl = class(OffsetsCallback)
    constructor create;

    procedure setOffset(Status: Status; index: Cardinal; offset: Cardinal; nullOffset: Cardinal); virtual; abstract;
  end;

  XpbBuilderVTable = class(DisposableVTable)
    clear: XpbBuilder_clearPtr;
    removeCurrent: XpbBuilder_removeCurrentPtr;
    insertInt: XpbBuilder_insertIntPtr;
    insertBigInt: XpbBuilder_insertBigIntPtr;
    insertBytes: XpbBuilder_insertBytesPtr;
    insertString: XpbBuilder_insertStringPtr;
    insertTag: XpbBuilder_insertTagPtr;
    isEof: XpbBuilder_isEofPtr;
    moveNext: XpbBuilder_moveNextPtr;
    rewind: XpbBuilder_rewindPtr;
    findFirst: XpbBuilder_findFirstPtr;
    findNext: XpbBuilder_findNextPtr;
    getTag: XpbBuilder_getTagPtr;
    getLength: XpbBuilder_getLengthPtr;
    getInt: XpbBuilder_getIntPtr;
    getBigInt: XpbBuilder_getBigIntPtr;
    getString: XpbBuilder_getStringPtr;
    getBytes: XpbBuilder_getBytesPtr;
    getBufferLength: XpbBuilder_getBufferLengthPtr;
    getBuffer: XpbBuilder_getBufferPtr;
  end;

  XpbBuilder = class(Disposable)
  const
    version = 3;

  const
    dpb = Cardinal(1);

  const
    SPB_ATTACH = Cardinal(2);

  const
    SPB_START = Cardinal(3);

  const
    tpb = Cardinal(4);

  const
    Batch = Cardinal(5);

  const
    bpb = Cardinal(6);

  const
    SPB_SEND = Cardinal(7);

  const
    SPB_RECEIVE = Cardinal(8);

  const
    SPB_RESPONSE = Cardinal(9);

  const
    INFO_SEND = Cardinal(10);

  const
    INFO_RESPONSE = Cardinal(11);

    procedure clear(Status: Status);
    procedure removeCurrent(Status: Status);
    procedure insertInt(Status: Status; tag: Byte; value: Integer);
    procedure insertBigInt(Status: Status; tag: Byte; value: Int64);
    procedure insertBytes(Status: Status; tag: Byte; bytes: Pointer; length: Cardinal);
    procedure insertString(Status: Status; tag: Byte; str: PAnsiChar);
    procedure insertTag(Status: Status; tag: Byte);
    function isEof(Status: Status): Boolean;
    procedure moveNext(Status: Status);
    procedure rewind(Status: Status);
    function findFirst(Status: Status; tag: Byte): Boolean;
    function findNext(Status: Status): Boolean;
    function getTag(Status: Status): Byte;
    function getLength(Status: Status): Cardinal;
    function getInt(Status: Status): Integer;
    function getBigInt(Status: Status): Int64;
    function getString(Status: Status): PAnsiChar;
    function getBytes(Status: Status): BytePtr;
    function getBufferLength(Status: Status): Cardinal;
    function getBuffer(Status: Status): BytePtr;
  end;

  XpbBuilderImpl = class(XpbBuilder)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure clear(Status: Status); virtual; abstract;
    procedure removeCurrent(Status: Status); virtual; abstract;
    procedure insertInt(Status: Status; tag: Byte; value: Integer); virtual; abstract;
    procedure insertBigInt(Status: Status; tag: Byte; value: Int64); virtual; abstract;
    procedure insertBytes(Status: Status; tag: Byte; bytes: Pointer; length: Cardinal); virtual; abstract;
    procedure insertString(Status: Status; tag: Byte; str: PAnsiChar); virtual; abstract;
    procedure insertTag(Status: Status; tag: Byte); virtual; abstract;
    function isEof(Status: Status): Boolean; virtual; abstract;
    procedure moveNext(Status: Status); virtual; abstract;
    procedure rewind(Status: Status); virtual; abstract;
    function findFirst(Status: Status; tag: Byte): Boolean; virtual; abstract;
    function findNext(Status: Status): Boolean; virtual; abstract;
    function getTag(Status: Status): Byte; virtual; abstract;
    function getLength(Status: Status): Cardinal; virtual; abstract;
    function getInt(Status: Status): Integer; virtual; abstract;
    function getBigInt(Status: Status): Int64; virtual; abstract;
    function getString(Status: Status): PAnsiChar; virtual; abstract;
    function getBytes(Status: Status): BytePtr; virtual; abstract;
    function getBufferLength(Status: Status): Cardinal; virtual; abstract;
    function getBuffer(Status: Status): BytePtr; virtual; abstract;
  end;

  TraceConnectionVTable = class(VersionedVTable)
    getKind: TraceConnection_getKindPtr;
    getProcessID: TraceConnection_getProcessIDPtr;
    getUserName: TraceConnection_getUserNamePtr;
    getRoleName: TraceConnection_getRoleNamePtr;
    getCharSet: TraceConnection_getCharSetPtr;
    getRemoteProtocol: TraceConnection_getRemoteProtocolPtr;
    getRemoteAddress: TraceConnection_getRemoteAddressPtr;
    getRemoteProcessID: TraceConnection_getRemoteProcessIDPtr;
    getRemoteProcessName: TraceConnection_getRemoteProcessNamePtr;
  end;

  TraceConnection = class(Versioned)
  const
    version = 2;

  const
    KIND_DATABASE = Cardinal(1);

  const
    KIND_SERVICE = Cardinal(2);

    function getKind(): Cardinal;
    function getProcessID(): Integer;
    function getUserName(): PAnsiChar;
    function getRoleName(): PAnsiChar;
    function getCharSet(): PAnsiChar;
    function getRemoteProtocol(): PAnsiChar;
    function getRemoteAddress(): PAnsiChar;
    function getRemoteProcessID(): Integer;
    function getRemoteProcessName(): PAnsiChar;
  end;

  TraceConnectionImpl = class(TraceConnection)
    constructor create;

    function getKind(): Cardinal; virtual; abstract;
    function getProcessID(): Integer; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getRoleName(): PAnsiChar; virtual; abstract;
    function getCharSet(): PAnsiChar; virtual; abstract;
    function getRemoteProtocol(): PAnsiChar; virtual; abstract;
    function getRemoteAddress(): PAnsiChar; virtual; abstract;
    function getRemoteProcessID(): Integer; virtual; abstract;
    function getRemoteProcessName(): PAnsiChar; virtual; abstract;
  end;

  TraceDatabaseConnectionVTable = class(TraceConnectionVTable)
    getConnectionID: TraceDatabaseConnection_getConnectionIDPtr;
    getDatabaseName: TraceDatabaseConnection_getDatabaseNamePtr;
  end;

  TraceDatabaseConnection = class(TraceConnection)
  const
    version = 3;

    function getConnectionID(): Int64;
    function getDatabaseName(): PAnsiChar;
  end;

  TraceDatabaseConnectionImpl = class(TraceDatabaseConnection)
    constructor create;

    function getKind(): Cardinal; virtual; abstract;
    function getProcessID(): Integer; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getRoleName(): PAnsiChar; virtual; abstract;
    function getCharSet(): PAnsiChar; virtual; abstract;
    function getRemoteProtocol(): PAnsiChar; virtual; abstract;
    function getRemoteAddress(): PAnsiChar; virtual; abstract;
    function getRemoteProcessID(): Integer; virtual; abstract;
    function getRemoteProcessName(): PAnsiChar; virtual; abstract;
    function getConnectionID(): Int64; virtual; abstract;
    function getDatabaseName(): PAnsiChar; virtual; abstract;
  end;

  TraceTransactionVTable = class(VersionedVTable)
    getTransactionID: TraceTransaction_getTransactionIDPtr;
    getReadOnly: TraceTransaction_getReadOnlyPtr;
    getWait: TraceTransaction_getWaitPtr;
    getIsolation: TraceTransaction_getIsolationPtr;
    getPerf: TraceTransaction_getPerfPtr;
    getInitialID: TraceTransaction_getInitialIDPtr;
    getPreviousID: TraceTransaction_getPreviousIDPtr;
  end;

  TraceTransaction = class(Versioned)
  const
    version = 3;

  const
    ISOLATION_CONSISTENCY = Cardinal(1);

  const
    ISOLATION_CONCURRENCY = Cardinal(2);

  const
    ISOLATION_READ_COMMITTED_RECVER = Cardinal(3);

  const
    ISOLATION_READ_COMMITTED_NORECVER = Cardinal(4);

  const
    ISOLATION_READ_COMMITTED_READ_CONSISTENCY = Cardinal(5);

    function getTransactionID(): Int64;
    function getReadOnly(): Boolean;
    function getWait(): Integer;
    function getIsolation(): Cardinal;
    function getPerf(): PerformanceInfoPtr;
    function getInitialID(): Int64;
    function getPreviousID(): Int64;
  end;

  TraceTransactionImpl = class(TraceTransaction)
    constructor create;

    function getTransactionID(): Int64; virtual; abstract;
    function getReadOnly(): Boolean; virtual; abstract;
    function getWait(): Integer; virtual; abstract;
    function getIsolation(): Cardinal; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getInitialID(): Int64; virtual; abstract;
    function getPreviousID(): Int64; virtual; abstract;
  end;

  TraceParamsVTable = class(VersionedVTable)
    getCount: TraceParams_getCountPtr;
    getParam: TraceParams_getParamPtr;
    getTextUTF8: TraceParams_getTextUTF8Ptr;
  end;

  TraceParams = class(Versioned)
  const
    version = 3;

    function getCount(): Cardinal;
    function getParam(idx: Cardinal): dscPtr;
    function getTextUTF8(Status: Status; idx: Cardinal): PAnsiChar;
  end;

  TraceParamsImpl = class(TraceParams)
    constructor create;

    function getCount(): Cardinal; virtual; abstract;
    function getParam(idx: Cardinal): dscPtr; virtual; abstract;
    function getTextUTF8(Status: Status; idx: Cardinal): PAnsiChar; virtual; abstract;
  end;

  TraceStatementVTable = class(VersionedVTable)
    getStmtID: TraceStatement_getStmtIDPtr;
    getPerf: TraceStatement_getPerfPtr;
  end;

  TraceStatement = class(Versioned)
  const
    version = 2;

    function getStmtID(): Int64;
    function getPerf(): PerformanceInfoPtr;
  end;

  TraceStatementImpl = class(TraceStatement)
    constructor create;

    function getStmtID(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
  end;

  TraceSQLStatementVTable = class(TraceStatementVTable)
    getText: TraceSQLStatement_getTextPtr;
    getPlan: TraceSQLStatement_getPlanPtr;
    getInputs: TraceSQLStatement_getInputsPtr;
    getTextUTF8: TraceSQLStatement_getTextUTF8Ptr;
    getExplainedPlan: TraceSQLStatement_getExplainedPlanPtr;
  end;

  TraceSQLStatement = class(TraceStatement)
  const
    version = 3;

    function getText(): PAnsiChar;
    function getPlan(): PAnsiChar;
    function getInputs(): TraceParams;
    function getTextUTF8(): PAnsiChar;
    function getExplainedPlan(): PAnsiChar;
  end;

  TraceSQLStatementImpl = class(TraceSQLStatement)
    constructor create;

    function getStmtID(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
    function getPlan(): PAnsiChar; virtual; abstract;
    function getInputs(): TraceParams; virtual; abstract;
    function getTextUTF8(): PAnsiChar; virtual; abstract;
    function getExplainedPlan(): PAnsiChar; virtual; abstract;
  end;

  TraceBLRStatementVTable = class(TraceStatementVTable)
    getData: TraceBLRStatement_getDataPtr;
    getDataLength: TraceBLRStatement_getDataLengthPtr;
    getText: TraceBLRStatement_getTextPtr;
  end;

  TraceBLRStatement = class(TraceStatement)
  const
    version = 3;

    function getData(): BytePtr;
    function getDataLength(): Cardinal;
    function getText(): PAnsiChar;
  end;

  TraceBLRStatementImpl = class(TraceBLRStatement)
    constructor create;

    function getStmtID(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getData(): BytePtr; virtual; abstract;
    function getDataLength(): Cardinal; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
  end;

  TraceDYNRequestVTable = class(VersionedVTable)
    getData: TraceDYNRequest_getDataPtr;
    getDataLength: TraceDYNRequest_getDataLengthPtr;
    getText: TraceDYNRequest_getTextPtr;
  end;

  TraceDYNRequest = class(Versioned)
  const
    version = 2;

    function getData(): BytePtr;
    function getDataLength(): Cardinal;
    function getText(): PAnsiChar;
  end;

  TraceDYNRequestImpl = class(TraceDYNRequest)
    constructor create;

    function getData(): BytePtr; virtual; abstract;
    function getDataLength(): Cardinal; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
  end;

  TraceContextVariableVTable = class(VersionedVTable)
    getNameSpace: TraceContextVariable_getNameSpacePtr;
    getVarName: TraceContextVariable_getVarNamePtr;
    getVarValue: TraceContextVariable_getVarValuePtr;
  end;

  TraceContextVariable = class(Versioned)
  const
    version = 2;

    function getNameSpace(): PAnsiChar;
    function getVarName(): PAnsiChar;
    function getVarValue(): PAnsiChar;
  end;

  TraceContextVariableImpl = class(TraceContextVariable)
    constructor create;

    function getNameSpace(): PAnsiChar; virtual; abstract;
    function getVarName(): PAnsiChar; virtual; abstract;
    function getVarValue(): PAnsiChar; virtual; abstract;
  end;

  TraceProcedureVTable = class(VersionedVTable)
    getProcName: TraceProcedure_getProcNamePtr;
    getInputs: TraceProcedure_getInputsPtr;
    getPerf: TraceProcedure_getPerfPtr;
    getStmtID: TraceProcedure_getStmtIDPtr;
    getPlan: TraceProcedure_getPlanPtr;
    getExplainedPlan: TraceProcedure_getExplainedPlanPtr;
  end;

  TraceProcedure = class(Versioned)
  const
    version = 3;

    function getProcName(): PAnsiChar;
    function getInputs(): TraceParams;
    function getPerf(): PerformanceInfoPtr;
    function getStmtID(): Int64;
    function getPlan(): PAnsiChar;
    function getExplainedPlan(): PAnsiChar;
  end;

  TraceProcedureImpl = class(TraceProcedure)
    constructor create;

    function getProcName(): PAnsiChar; virtual; abstract;
    function getInputs(): TraceParams; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getStmtID(): Int64; virtual; abstract;
    function getPlan(): PAnsiChar; virtual; abstract;
    function getExplainedPlan(): PAnsiChar; virtual; abstract;
  end;

  TraceFunctionVTable = class(VersionedVTable)
    getFuncName: TraceFunction_getFuncNamePtr;
    getInputs: TraceFunction_getInputsPtr;
    getResult: TraceFunction_getResultPtr;
    getPerf: TraceFunction_getPerfPtr;
    getStmtID: TraceFunction_getStmtIDPtr;
    getPlan: TraceFunction_getPlanPtr;
    getExplainedPlan: TraceFunction_getExplainedPlanPtr;
  end;

  TraceFunction = class(Versioned)
  const
    version = 3;

    function getFuncName(): PAnsiChar;
    function getInputs(): TraceParams;
    function getResult(): TraceParams;
    function getPerf(): PerformanceInfoPtr;
    function getStmtID(): Int64;
    function getPlan(): PAnsiChar;
    function getExplainedPlan(): PAnsiChar;
  end;

  TraceFunctionImpl = class(TraceFunction)
    constructor create;

    function getFuncName(): PAnsiChar; virtual; abstract;
    function getInputs(): TraceParams; virtual; abstract;
    function getResult(): TraceParams; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getStmtID(): Int64; virtual; abstract;
    function getPlan(): PAnsiChar; virtual; abstract;
    function getExplainedPlan(): PAnsiChar; virtual; abstract;
  end;

  TraceTriggerVTable = class(VersionedVTable)
    getTriggerName: TraceTrigger_getTriggerNamePtr;
    getRelationName: TraceTrigger_getRelationNamePtr;
    getAction: TraceTrigger_getActionPtr;
    getWhich: TraceTrigger_getWhichPtr;
    getPerf: TraceTrigger_getPerfPtr;
    getStmtID: TraceTrigger_getStmtIDPtr;
    getPlan: TraceTrigger_getPlanPtr;
    getExplainedPlan: TraceTrigger_getExplainedPlanPtr;
  end;

  TraceTrigger = class(Versioned)
  const
    version = 3;

  const
    TYPE_ALL = Cardinal(0);

  const
    TYPE_BEFORE = Cardinal(1);

  const
    TYPE_AFTER = Cardinal(2);

    function getTriggerName(): PAnsiChar;
    function getRelationName(): PAnsiChar;
    function getAction(): Integer;
    function getWhich(): Integer;
    function getPerf(): PerformanceInfoPtr;
    function getStmtID(): Int64;
    function getPlan(): PAnsiChar;
    function getExplainedPlan(): PAnsiChar;
  end;

  TraceTriggerImpl = class(TraceTrigger)
    constructor create;

    function getTriggerName(): PAnsiChar; virtual; abstract;
    function getRelationName(): PAnsiChar; virtual; abstract;
    function getAction(): Integer; virtual; abstract;
    function getWhich(): Integer; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getStmtID(): Int64; virtual; abstract;
    function getPlan(): PAnsiChar; virtual; abstract;
    function getExplainedPlan(): PAnsiChar; virtual; abstract;
  end;

  TraceServiceConnectionVTable = class(TraceConnectionVTable)
    getServiceID: TraceServiceConnection_getServiceIDPtr;
    getServiceMgr: TraceServiceConnection_getServiceMgrPtr;
    getServiceName: TraceServiceConnection_getServiceNamePtr;
  end;

  TraceServiceConnection = class(TraceConnection)
  const
    version = 3;

    function getServiceID(): Pointer;
    function getServiceMgr(): PAnsiChar;
    function getServiceName(): PAnsiChar;
  end;

  TraceServiceConnectionImpl = class(TraceServiceConnection)
    constructor create;

    function getKind(): Cardinal; virtual; abstract;
    function getProcessID(): Integer; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getRoleName(): PAnsiChar; virtual; abstract;
    function getCharSet(): PAnsiChar; virtual; abstract;
    function getRemoteProtocol(): PAnsiChar; virtual; abstract;
    function getRemoteAddress(): PAnsiChar; virtual; abstract;
    function getRemoteProcessID(): Integer; virtual; abstract;
    function getRemoteProcessName(): PAnsiChar; virtual; abstract;
    function getServiceID(): Pointer; virtual; abstract;
    function getServiceMgr(): PAnsiChar; virtual; abstract;
    function getServiceName(): PAnsiChar; virtual; abstract;
  end;

  TraceStatusVectorVTable = class(VersionedVTable)
    hasError: TraceStatusVector_hasErrorPtr;
    hasWarning: TraceStatusVector_hasWarningPtr;
    getStatus: TraceStatusVector_getStatusPtr;
    getText: TraceStatusVector_getTextPtr;
  end;

  TraceStatusVector = class(Versioned)
  const
    version = 2;

    function hasError(): Boolean;
    function hasWarning(): Boolean;
    function getStatus(): Status;
    function getText(): PAnsiChar;
  end;

  TraceStatusVectorImpl = class(TraceStatusVector)
    constructor create;

    function hasError(): Boolean; virtual; abstract;
    function hasWarning(): Boolean; virtual; abstract;
    function getStatus(): Status; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
  end;

  TraceSweepInfoVTable = class(VersionedVTable)
    getOIT: TraceSweepInfo_getOITPtr;
    getOST: TraceSweepInfo_getOSTPtr;
    getOAT: TraceSweepInfo_getOATPtr;
    getNext: TraceSweepInfo_getNextPtr;
    getPerf: TraceSweepInfo_getPerfPtr;
  end;

  TraceSweepInfo = class(Versioned)
  const
    version = 2;

    function getOIT(): Int64;
    function getOST(): Int64;
    function getOAT(): Int64;
    function getNext(): Int64;
    function getPerf(): PerformanceInfoPtr;
  end;

  TraceSweepInfoImpl = class(TraceSweepInfo)
    constructor create;

    function getOIT(): Int64; virtual; abstract;
    function getOST(): Int64; virtual; abstract;
    function getOAT(): Int64; virtual; abstract;
    function getNext(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
  end;

  TraceLogWriterVTable = class(ReferenceCountedVTable)
    write: TraceLogWriter_writePtr;
    write_s: TraceLogWriter_write_sPtr;
  end;

  TraceLogWriter = class(ReferenceCounted)
  const
    version = 4;

    function write(buf: Pointer; size: Cardinal): Cardinal;
    function write_s(Status: Status; buf: Pointer; size: Cardinal): Cardinal;
  end;

  TraceLogWriterImpl = class(TraceLogWriter)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function write(buf: Pointer; size: Cardinal): Cardinal; virtual; abstract;
    function write_s(Status: Status; buf: Pointer; size: Cardinal): Cardinal; virtual; abstract;
  end;

  TraceInitInfoVTable = class(VersionedVTable)
    getConfigText: TraceInitInfo_getConfigTextPtr;
    getTraceSessionID: TraceInitInfo_getTraceSessionIDPtr;
    getTraceSessionName: TraceInitInfo_getTraceSessionNamePtr;
    getFirebirdRootDirectory: TraceInitInfo_getFirebirdRootDirectoryPtr;
    getDatabaseName: TraceInitInfo_getDatabaseNamePtr;
    getConnection: TraceInitInfo_getConnectionPtr;
    getLogWriter: TraceInitInfo_getLogWriterPtr;
  end;

  TraceInitInfo = class(Versioned)
  const
    version = 2;

    function getConfigText(): PAnsiChar;
    function getTraceSessionID(): Integer;
    function getTraceSessionName(): PAnsiChar;
    function getFirebirdRootDirectory(): PAnsiChar;
    function getDatabaseName(): PAnsiChar;
    function getConnection(): TraceDatabaseConnection;
    function getLogWriter(): TraceLogWriter;
  end;

  TraceInitInfoImpl = class(TraceInitInfo)
    constructor create;

    function getConfigText(): PAnsiChar; virtual; abstract;
    function getTraceSessionID(): Integer; virtual; abstract;
    function getTraceSessionName(): PAnsiChar; virtual; abstract;
    function getFirebirdRootDirectory(): PAnsiChar; virtual; abstract;
    function getDatabaseName(): PAnsiChar; virtual; abstract;
    function getConnection(): TraceDatabaseConnection; virtual; abstract;
    function getLogWriter(): TraceLogWriter; virtual; abstract;
  end;

  TracePluginVTable = class(ReferenceCountedVTable)
    trace_get_error: TracePlugin_trace_get_errorPtr;
    trace_attach: TracePlugin_trace_attachPtr;
    trace_detach: TracePlugin_trace_detachPtr;
    trace_transaction_start: TracePlugin_trace_transaction_startPtr;
    trace_transaction_end: TracePlugin_trace_transaction_endPtr;
    trace_proc_execute: TracePlugin_trace_proc_executePtr;
    trace_trigger_execute: TracePlugin_trace_trigger_executePtr;
    trace_set_context: TracePlugin_trace_set_contextPtr;
    trace_dsql_prepare: TracePlugin_trace_dsql_preparePtr;
    trace_dsql_free: TracePlugin_trace_dsql_freePtr;
    trace_dsql_execute: TracePlugin_trace_dsql_executePtr;
    trace_blr_compile: TracePlugin_trace_blr_compilePtr;
    trace_blr_execute: TracePlugin_trace_blr_executePtr;
    trace_dyn_execute: TracePlugin_trace_dyn_executePtr;
    trace_service_attach: TracePlugin_trace_service_attachPtr;
    trace_service_start: TracePlugin_trace_service_startPtr;
    trace_service_query: TracePlugin_trace_service_queryPtr;
    trace_service_detach: TracePlugin_trace_service_detachPtr;
    trace_event_error: TracePlugin_trace_event_errorPtr;
    trace_event_sweep: TracePlugin_trace_event_sweepPtr;
    trace_func_execute: TracePlugin_trace_func_executePtr;
    trace_dsql_restart: TracePlugin_trace_dsql_restartPtr;
    trace_proc_compile: TracePlugin_trace_proc_compilePtr;
    trace_func_compile: TracePlugin_trace_func_compilePtr;
    trace_trigger_compile: TracePlugin_trace_trigger_compilePtr;
  end;

  TracePlugin = class(ReferenceCounted)
  const
    version = 5;

  const
    RESULT_SUCCESS = Cardinal(0);

  const
    RESULT_FAILED = Cardinal(1);

  const
    RESULT_UNAUTHORIZED = Cardinal(2);

  const
    SWEEP_STATE_STARTED = Cardinal(1);

  const
    SWEEP_STATE_FINISHED = Cardinal(2);

  const
    SWEEP_STATE_FAILED = Cardinal(3);

  const
    SWEEP_STATE_PROGRESS = Cardinal(4);

    function trace_get_error(): PAnsiChar;
    function trace_attach(connection: TraceDatabaseConnection; create_db: Boolean; att_result: Cardinal): Boolean;
    function trace_detach(connection: TraceDatabaseConnection; drop_db: Boolean): Boolean;
    function trace_transaction_start(connection: TraceDatabaseConnection; Transaction: TraceTransaction; tpb_length: Cardinal; tpb: BytePtr;
      tra_result: Cardinal): Boolean;
    function trace_transaction_end(connection: TraceDatabaseConnection; Transaction: TraceTransaction; commit: Boolean; retain_context: Boolean;
      tra_result: Cardinal): Boolean;
    function trace_proc_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; procedure_: TraceProcedure; started: Boolean;
      proc_result: Cardinal): Boolean;
    function trace_trigger_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; trigger: TraceTrigger; started: Boolean;
      trig_result: Cardinal): Boolean;
    function trace_set_context(connection: TraceDatabaseConnection; Transaction: TraceTransaction; variable: TraceContextVariable): Boolean;
    function trace_dsql_prepare(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement; time_millis: Int64;
      req_result: Cardinal): Boolean;
    function trace_dsql_free(connection: TraceDatabaseConnection; Statement: TraceSQLStatement; option: Cardinal): Boolean;
    function trace_dsql_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement; started: Boolean;
      req_result: Cardinal): Boolean;
    function trace_blr_compile(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceBLRStatement; time_millis: Int64;
      req_result: Cardinal): Boolean;
    function trace_blr_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceBLRStatement;
      req_result: Cardinal): Boolean;
    function trace_dyn_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Request: TraceDYNRequest; time_millis: Int64;
      req_result: Cardinal): Boolean;
    function trace_service_attach(Service: TraceServiceConnection; att_result: Cardinal): Boolean;
    function trace_service_start(Service: TraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar; start_result: Cardinal): Boolean;
    function trace_service_query(Service: TraceServiceConnection; send_item_length: Cardinal; send_items: BytePtr; recv_item_length: Cardinal;
      recv_items: BytePtr; query_result: Cardinal): Boolean;
    function trace_service_detach(Service: TraceServiceConnection; detach_result: Cardinal): Boolean;
    function trace_event_error(connection: TraceConnection; Status: TraceStatusVector; function_: PAnsiChar): Boolean;
    function trace_event_sweep(connection: TraceDatabaseConnection; sweep: TraceSweepInfo; sweep_state: Cardinal): Boolean;
    function trace_func_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; function_: TraceFunction; started: Boolean;
      func_result: Cardinal): Boolean;
    function trace_dsql_restart(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement;
      number: Cardinal): Boolean;
    function trace_proc_compile(connection: TraceDatabaseConnection; procedure_: TraceProcedure; time_millis: Int64; proc_result: Cardinal): Boolean;
    function trace_func_compile(connection: TraceDatabaseConnection; function_: TraceFunction; time_millis: Int64; func_result: Cardinal): Boolean;
    function trace_trigger_compile(connection: TraceDatabaseConnection; trigger: TraceTrigger; time_millis: Int64; trig_result: Cardinal): Boolean;
  end;

  TracePluginImpl = class(TracePlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function trace_get_error(): PAnsiChar; virtual; abstract;
    function trace_attach(connection: TraceDatabaseConnection; create_db: Boolean; att_result: Cardinal): Boolean; virtual; abstract;
    function trace_detach(connection: TraceDatabaseConnection; drop_db: Boolean): Boolean; virtual; abstract;
    function trace_transaction_start(connection: TraceDatabaseConnection; Transaction: TraceTransaction; tpb_length: Cardinal; tpb: BytePtr;
      tra_result: Cardinal): Boolean; virtual; abstract;
    function trace_transaction_end(connection: TraceDatabaseConnection; Transaction: TraceTransaction; commit: Boolean; retain_context: Boolean;
      tra_result: Cardinal): Boolean; virtual; abstract;
    function trace_proc_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; procedure_: TraceProcedure; started: Boolean;
      proc_result: Cardinal): Boolean; virtual; abstract;
    function trace_trigger_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; trigger: TraceTrigger; started: Boolean;
      trig_result: Cardinal): Boolean; virtual; abstract;
    function trace_set_context(connection: TraceDatabaseConnection; Transaction: TraceTransaction; variable: TraceContextVariable): Boolean;
      virtual; abstract;
    function trace_dsql_prepare(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement; time_millis: Int64;
      req_result: Cardinal): Boolean; virtual; abstract;
    function trace_dsql_free(connection: TraceDatabaseConnection; Statement: TraceSQLStatement; option: Cardinal): Boolean; virtual; abstract;
    function trace_dsql_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement; started: Boolean;
      req_result: Cardinal): Boolean; virtual; abstract;
    function trace_blr_compile(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceBLRStatement; time_millis: Int64;
      req_result: Cardinal): Boolean; virtual; abstract;
    function trace_blr_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceBLRStatement; req_result: Cardinal)
      : Boolean; virtual; abstract;
    function trace_dyn_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Request: TraceDYNRequest; time_millis: Int64;
      req_result: Cardinal): Boolean; virtual; abstract;
    function trace_service_attach(Service: TraceServiceConnection; att_result: Cardinal): Boolean; virtual; abstract;
    function trace_service_start(Service: TraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar; start_result: Cardinal): Boolean;
      virtual; abstract;
    function trace_service_query(Service: TraceServiceConnection; send_item_length: Cardinal; send_items: BytePtr; recv_item_length: Cardinal;
      recv_items: BytePtr; query_result: Cardinal): Boolean; virtual; abstract;
    function trace_service_detach(Service: TraceServiceConnection; detach_result: Cardinal): Boolean; virtual; abstract;
    function trace_event_error(connection: TraceConnection; Status: TraceStatusVector; function_: PAnsiChar): Boolean; virtual; abstract;
    function trace_event_sweep(connection: TraceDatabaseConnection; sweep: TraceSweepInfo; sweep_state: Cardinal): Boolean; virtual; abstract;
    function trace_func_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; function_: TraceFunction; started: Boolean;
      func_result: Cardinal): Boolean; virtual; abstract;
    function trace_dsql_restart(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement; number: Cardinal)
      : Boolean; virtual; abstract;
    function trace_proc_compile(connection: TraceDatabaseConnection; procedure_: TraceProcedure; time_millis: Int64; proc_result: Cardinal): Boolean;
      virtual; abstract;
    function trace_func_compile(connection: TraceDatabaseConnection; function_: TraceFunction; time_millis: Int64; func_result: Cardinal): Boolean;
      virtual; abstract;
    function trace_trigger_compile(connection: TraceDatabaseConnection; trigger: TraceTrigger; time_millis: Int64; trig_result: Cardinal): Boolean;
      virtual; abstract;
  end;

  TraceFactoryVTable = class(PluginBaseVTable)
    trace_needs: TraceFactory_trace_needsPtr;
    trace_create: TraceFactory_trace_createPtr;
  end;

  TraceFactory = class(PluginBase)
  const
    version = 4;

  const
    TRACE_EVENT_ATTACH = Cardinal(0);

  const
    TRACE_EVENT_DETACH = Cardinal(1);

  const
    TRACE_EVENT_TRANSACTION_START = Cardinal(2);

  const
    TRACE_EVENT_TRANSACTION_END = Cardinal(3);

  const
    TRACE_EVENT_SET_CONTEXT = Cardinal(4);

  const
    TRACE_EVENT_PROC_EXECUTE = Cardinal(5);

  const
    TRACE_EVENT_TRIGGER_EXECUTE = Cardinal(6);

  const
    TRACE_EVENT_DSQL_PREPARE = Cardinal(7);

  const
    TRACE_EVENT_DSQL_FREE = Cardinal(8);

  const
    TRACE_EVENT_DSQL_EXECUTE = Cardinal(9);

  const
    TRACE_EVENT_BLR_COMPILE = Cardinal(10);

  const
    TRACE_EVENT_BLR_EXECUTE = Cardinal(11);

  const
    TRACE_EVENT_DYN_EXECUTE = Cardinal(12);

  const
    TRACE_EVENT_SERVICE_ATTACH = Cardinal(13);

  const
    TRACE_EVENT_SERVICE_START = Cardinal(14);

  const
    TRACE_EVENT_SERVICE_QUERY = Cardinal(15);

  const
    TRACE_EVENT_SERVICE_DETACH = Cardinal(16);

  const
    trace_event_error = Cardinal(17);

  const
    trace_event_sweep = Cardinal(18);

  const
    TRACE_EVENT_FUNC_EXECUTE = Cardinal(19);

  const
    TRACE_EVENT_PROC_COMPILE = Cardinal(20);

  const
    TRACE_EVENT_FUNC_COMPILE = Cardinal(21);

  const
    TRACE_EVENT_TRIGGER_COMPILE = Cardinal(22);

  const
    TRACE_EVENT_MAX = Cardinal(23);

    function trace_needs(): QWord;
    function trace_create(Status: Status; init_info: TraceInitInfo): TracePlugin;
  end;

  TraceFactoryImpl = class(TraceFactory)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    function trace_needs(): QWord; virtual; abstract;
    function trace_create(Status: Status; init_info: TraceInitInfo): TracePlugin; virtual; abstract;
  end;

  UdrFunctionFactoryVTable = class(DisposableVTable)
    setup: UdrFunctionFactory_setupPtr;
    newItem: UdrFunctionFactory_newItemPtr;
  end;

  UdrFunctionFactory = class(Disposable)
  const
    version = 3;

    procedure setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder; outBuilder: MetadataBuilder);
    function newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalFunction;
  end;

  UdrFunctionFactoryImpl = class(UdrFunctionFactory)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder; outBuilder: MetadataBuilder);
      virtual; abstract;
    function newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalFunction; virtual; abstract;
  end;

  UdrProcedureFactoryVTable = class(DisposableVTable)
    setup: UdrProcedureFactory_setupPtr;
    newItem: UdrProcedureFactory_newItemPtr;
  end;

  UdrProcedureFactory = class(Disposable)
  const
    version = 3;

    procedure setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder; outBuilder: MetadataBuilder);
    function newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalProcedure;
  end;

  UdrProcedureFactoryImpl = class(UdrProcedureFactory)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder; outBuilder: MetadataBuilder);
      virtual; abstract;
    function newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalProcedure; virtual; abstract;
  end;

  UdrTriggerFactoryVTable = class(DisposableVTable)
    setup: UdrTriggerFactory_setupPtr;
    newItem: UdrTriggerFactory_newItemPtr;
  end;

  UdrTriggerFactory = class(Disposable)
  const
    version = 3;

    procedure setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; fieldsBuilder: MetadataBuilder);
    function newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalTrigger;
  end;

  UdrTriggerFactoryImpl = class(UdrTriggerFactory)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; fieldsBuilder: MetadataBuilder); virtual; abstract;
    function newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalTrigger; virtual; abstract;
  end;

  UdrPluginVTable = class(VersionedVTable)
    getMaster: UdrPlugin_getMasterPtr;
    registerFunction: UdrPlugin_registerFunctionPtr;
    registerProcedure: UdrPlugin_registerProcedurePtr;
    registerTrigger: UdrPlugin_registerTriggerPtr;
  end;

  UdrPlugin = class(Versioned)
  const
    version = 2;

    function getMaster(): Master;
    procedure registerFunction(Status: Status; name: PAnsiChar; factory: UdrFunctionFactory);
    procedure registerProcedure(Status: Status; name: PAnsiChar; factory: UdrProcedureFactory);
    procedure registerTrigger(Status: Status; name: PAnsiChar; factory: UdrTriggerFactory);
  end;

  UdrPluginImpl = class(UdrPlugin)
    constructor create;

    function getMaster(): Master; virtual; abstract;
    procedure registerFunction(Status: Status; name: PAnsiChar; factory: UdrFunctionFactory); virtual; abstract;
    procedure registerProcedure(Status: Status; name: PAnsiChar; factory: UdrProcedureFactory); virtual; abstract;
    procedure registerTrigger(Status: Status; name: PAnsiChar; factory: UdrTriggerFactory); virtual; abstract;
  end;

  DecFloat16VTable = class(VersionedVTable)
    toBcd: DecFloat16_toBcdPtr;
    toString: DecFloat16_toStringPtr;
    fromBcd: DecFloat16_fromBcdPtr;
    fromString: DecFloat16_fromStringPtr;
  end;

  DecFloat16 = class(Versioned)
  const
    version = 2;

  const
    BCD_SIZE = Cardinal(16);

  const
    STRING_SIZE = Cardinal(24);

    procedure toBcd(from: FB_DEC16Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr);
    procedure toString(Status: Status; from: FB_DEC16Ptr; bufferLength: Cardinal; buffer: PAnsiChar); reintroduce;
    procedure fromBcd(sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC16Ptr);
    procedure fromString(Status: Status; from: PAnsiChar; to_: FB_DEC16Ptr);
  end;

  DecFloat16Impl = class(DecFloat16)
    constructor create;

    procedure toBcd(from: FB_DEC16Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr); virtual; abstract;
    procedure toString(Status: Status; from: FB_DEC16Ptr; bufferLength: Cardinal; buffer: PAnsiChar); virtual; abstract;
    procedure fromBcd(sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC16Ptr); virtual; abstract;
    procedure fromString(Status: Status; from: PAnsiChar; to_: FB_DEC16Ptr); virtual; abstract;
  end;

  DecFloat34VTable = class(VersionedVTable)
    toBcd: DecFloat34_toBcdPtr;
    toString: DecFloat34_toStringPtr;
    fromBcd: DecFloat34_fromBcdPtr;
    fromString: DecFloat34_fromStringPtr;
  end;

  DecFloat34 = class(Versioned)
  const
    version = 2;

  const
    BCD_SIZE = Cardinal(34);

  const
    STRING_SIZE = Cardinal(43);

    procedure toBcd(from: FB_DEC34Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr);
    procedure toString(Status: Status; from: FB_DEC34Ptr; bufferLength: Cardinal; buffer: PAnsiChar); reintroduce;
    procedure fromBcd(sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC34Ptr);
    procedure fromString(Status: Status; from: PAnsiChar; to_: FB_DEC34Ptr);
  end;

  DecFloat34Impl = class(DecFloat34)
    constructor create;

    procedure toBcd(from: FB_DEC34Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr); virtual; abstract;
    procedure toString(Status: Status; from: FB_DEC34Ptr; bufferLength: Cardinal; buffer: PAnsiChar); virtual; abstract;
    procedure fromBcd(sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC34Ptr); virtual; abstract;
    procedure fromString(Status: Status; from: PAnsiChar; to_: FB_DEC34Ptr); virtual; abstract;
  end;

  Int128VTable = class(VersionedVTable)
    toString: Int128_toStringPtr;
    fromString: Int128_fromStringPtr;
  end;

  Int128 = class(Versioned)
  const
    version = 2;

  const
    STRING_SIZE = Cardinal(46);

    procedure toString(Status: Status; from: FB_I128Ptr; scale: Integer; bufferLength: Cardinal; buffer: PAnsiChar); reintroduce;
    procedure fromString(Status: Status; scale: Integer; from: PAnsiChar; to_: FB_I128Ptr);
  end;

  Int128Impl = class(Int128)
    constructor create;

    procedure toString(Status: Status; from: FB_I128Ptr; scale: Integer; bufferLength: Cardinal; buffer: PAnsiChar); virtual; abstract;
    procedure fromString(Status: Status; scale: Integer; from: PAnsiChar; to_: FB_I128Ptr); virtual; abstract;
  end;

  ReplicatedFieldVTable = class(VersionedVTable)
    getName: ReplicatedField_getNamePtr;
    getType: ReplicatedField_getTypePtr;
    getSubType: ReplicatedField_getSubTypePtr;
    getScale: ReplicatedField_getScalePtr;
    getLength: ReplicatedField_getLengthPtr;
    getCharSet: ReplicatedField_getCharSetPtr;
    getData: ReplicatedField_getDataPtr;
  end;

  ReplicatedField = class(Versioned)
  const
    version = 2;

    function getName(): PAnsiChar;
    function getType(): Cardinal;
    function getSubType(): Integer;
    function getScale(): Integer;
    function getLength(): Cardinal;
    function getCharSet(): Cardinal;
    function getData(): Pointer;
  end;

  ReplicatedFieldImpl = class(ReplicatedField)
    constructor create;

    function getName(): PAnsiChar; virtual; abstract;
    function getType(): Cardinal; virtual; abstract;
    function getSubType(): Integer; virtual; abstract;
    function getScale(): Integer; virtual; abstract;
    function getLength(): Cardinal; virtual; abstract;
    function getCharSet(): Cardinal; virtual; abstract;
    function getData(): Pointer; virtual; abstract;
  end;

  ReplicatedRecordVTable = class(VersionedVTable)
    getCount: ReplicatedRecord_getCountPtr;
    getField: ReplicatedRecord_getFieldPtr;
    getRawLength: ReplicatedRecord_getRawLengthPtr;
    getRawData: ReplicatedRecord_getRawDataPtr;
  end;

  ReplicatedRecord = class(Versioned)
  const
    version = 2;

    function getCount(): Cardinal;
    function getField(index: Cardinal): ReplicatedField;
    function getRawLength(): Cardinal;
    function getRawData(): BytePtr;
  end;

  ReplicatedRecordImpl = class(ReplicatedRecord)
    constructor create;

    function getCount(): Cardinal; virtual; abstract;
    function getField(index: Cardinal): ReplicatedField; virtual; abstract;
    function getRawLength(): Cardinal; virtual; abstract;
    function getRawData(): BytePtr; virtual; abstract;
  end;

  ReplicatedTransactionVTable = class(DisposableVTable)
    prepare: ReplicatedTransaction_preparePtr;
    commit: ReplicatedTransaction_commitPtr;
    rollback: ReplicatedTransaction_rollbackPtr;
    startSavepoint: ReplicatedTransaction_startSavepointPtr;
    releaseSavepoint: ReplicatedTransaction_releaseSavepointPtr;
    rollbackSavepoint: ReplicatedTransaction_rollbackSavepointPtr;
    insertRecord: ReplicatedTransaction_insertRecordPtr;
    updateRecord: ReplicatedTransaction_updateRecordPtr;
    deleteRecord: ReplicatedTransaction_deleteRecordPtr;
    executeSql: ReplicatedTransaction_executeSqlPtr;
    executeSqlIntl: ReplicatedTransaction_executeSqlIntlPtr;
  end;

  ReplicatedTransaction = class(Disposable)
  const
    version = 3;

    procedure prepare(Status: Status);
    procedure commit(Status: Status);
    procedure rollback(Status: Status);
    procedure startSavepoint(Status: Status);
    procedure releaseSavepoint(Status: Status);
    procedure rollbackSavepoint(Status: Status);
    procedure insertRecord(Status: Status; name: PAnsiChar; record_: ReplicatedRecord);
    procedure updateRecord(Status: Status; name: PAnsiChar; orgRecord: ReplicatedRecord; newRecord: ReplicatedRecord);
    procedure deleteRecord(Status: Status; name: PAnsiChar; record_: ReplicatedRecord);
    procedure executeSql(Status: Status; sql: PAnsiChar);
    procedure executeSqlIntl(Status: Status; charSet: Cardinal; sql: PAnsiChar);
  end;

  ReplicatedTransactionImpl = class(ReplicatedTransaction)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure prepare(Status: Status); virtual; abstract;
    procedure commit(Status: Status); virtual; abstract;
    procedure rollback(Status: Status); virtual; abstract;
    procedure startSavepoint(Status: Status); virtual; abstract;
    procedure releaseSavepoint(Status: Status); virtual; abstract;
    procedure rollbackSavepoint(Status: Status); virtual; abstract;
    procedure insertRecord(Status: Status; name: PAnsiChar; record_: ReplicatedRecord); virtual; abstract;
    procedure updateRecord(Status: Status; name: PAnsiChar; orgRecord: ReplicatedRecord; newRecord: ReplicatedRecord); virtual; abstract;
    procedure deleteRecord(Status: Status; name: PAnsiChar; record_: ReplicatedRecord); virtual; abstract;
    procedure executeSql(Status: Status; sql: PAnsiChar); virtual; abstract;
    procedure executeSqlIntl(Status: Status; charSet: Cardinal; sql: PAnsiChar); virtual; abstract;
  end;

  ReplicatedSessionVTable = class(PluginBaseVTable)
    init: ReplicatedSession_initPtr;
    startTransaction: ReplicatedSession_startTransactionPtr;
    cleanupTransaction: ReplicatedSession_cleanupTransactionPtr;
    setSequence: ReplicatedSession_setSequencePtr;
  end;

  ReplicatedSession = class(PluginBase)
  const
    version = 4;

    function init(Status: Status; Attachment: Attachment): Boolean;
    function startTransaction(Status: Status; Transaction: Transaction; number: Int64): ReplicatedTransaction;
    procedure cleanupTransaction(Status: Status; number: Int64);
    procedure setSequence(Status: Status; name: PAnsiChar; value: Int64);
  end;

  ReplicatedSessionImpl = class(ReplicatedSession)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    function init(Status: Status; Attachment: Attachment): Boolean; virtual; abstract;
    function startTransaction(Status: Status; Transaction: Transaction; number: Int64): ReplicatedTransaction; virtual; abstract;
    procedure cleanupTransaction(Status: Status; number: Int64); virtual; abstract;
    procedure setSequence(Status: Status; name: PAnsiChar; value: Int64); virtual; abstract;
  end;

  ProfilerPluginVTable = class(PluginBaseVTable)
    init: ProfilerPlugin_initPtr;
    startSession: ProfilerPlugin_startSessionPtr;
    flush: ProfilerPlugin_flushPtr;
  end;

  ProfilerPlugin = class(PluginBase)
  const
    version = 4;

    procedure init(Status: Status; Attachment: Attachment; ticksFrequency: QWord);
    function startSession(Status: Status; description: PAnsiChar; options: PAnsiChar; timestamp: ISC_TIMESTAMP_TZ): ProfilerSession;
    procedure flush(Status: Status);
  end;

  ProfilerPluginImpl = class(ProfilerPlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: ReferenceCounted); virtual; abstract;
    function getOwner(): ReferenceCounted; virtual; abstract;
    procedure init(Status: Status; Attachment: Attachment; ticksFrequency: QWord); virtual; abstract;
    function startSession(Status: Status; description: PAnsiChar; options: PAnsiChar; timestamp: ISC_TIMESTAMP_TZ): ProfilerSession; virtual;
      abstract;
    procedure flush(Status: Status); virtual; abstract;
  end;

  ProfilerSessionVTable = class(DisposableVTable)
    getId: ProfilerSession_getIdPtr;
    getFlags: ProfilerSession_getFlagsPtr;
    cancel: ProfilerSession_cancelPtr;
    finish: ProfilerSession_finishPtr;
    defineStatement: ProfilerSession_defineStatementPtr;
    defineCursor: ProfilerSession_defineCursorPtr;
    defineRecordSource: ProfilerSession_defineRecordSourcePtr;
    onRequestStart: ProfilerSession_onRequestStartPtr;
    onRequestFinish: ProfilerSession_onRequestFinishPtr;
    beforePsqlLineColumn: ProfilerSession_beforePsqlLineColumnPtr;
    afterPsqlLineColumn: ProfilerSession_afterPsqlLineColumnPtr;
    beforeRecordSourceOpen: ProfilerSession_beforeRecordSourceOpenPtr;
    afterRecordSourceOpen: ProfilerSession_afterRecordSourceOpenPtr;
    beforeRecordSourceGetRecord: ProfilerSession_beforeRecordSourceGetRecordPtr;
    afterRecordSourceGetRecord: ProfilerSession_afterRecordSourceGetRecordPtr;
  end;

  ProfilerSession = class(Disposable)
  const
    version = 3;

  const
    FLAG_BEFORE_EVENTS = Cardinal($1);

  const
    FLAG_AFTER_EVENTS = Cardinal($2);

    function getId(): Int64;
    function getFlags(): Cardinal;
    procedure cancel(Status: Status);
    procedure finish(Status: Status; timestamp: ISC_TIMESTAMP_TZ);
    procedure defineStatement(Status: Status; statementId: Int64; parentStatementId: Int64; type_: PAnsiChar; packageName: PAnsiChar;
      routineName: PAnsiChar; sqlText: PAnsiChar);
    procedure defineCursor(statementId: Int64; cursorId: Cardinal; name: PAnsiChar; line: Cardinal; column: Cardinal);
    procedure defineRecordSource(statementId: Int64; cursorId: Cardinal; recSourceId: Cardinal; level: Cardinal; accessPath: PAnsiChar;
      parentRecSourceId: Cardinal);
    procedure onRequestStart(Status: Status; statementId: Int64; requestId: Int64; callerStatementId: Int64; callerRequestId: Int64;
      timestamp: ISC_TIMESTAMP_TZ);
    procedure onRequestFinish(Status: Status; statementId: Int64; requestId: Int64; timestamp: ISC_TIMESTAMP_TZ; stats: ProfilerStats);
    procedure beforePsqlLineColumn(statementId: Int64; requestId: Int64; line: Cardinal; column: Cardinal);
    procedure afterPsqlLineColumn(statementId: Int64; requestId: Int64; line: Cardinal; column: Cardinal; stats: ProfilerStats);
    procedure beforeRecordSourceOpen(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal);
    procedure afterRecordSourceOpen(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal; stats: ProfilerStats);
    procedure beforeRecordSourceGetRecord(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal);
    procedure afterRecordSourceGetRecord(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal; stats: ProfilerStats);
  end;

  ProfilerSessionImpl = class(ProfilerSession)
    constructor create;

    procedure dispose(); virtual; abstract;
    function getId(): Int64; virtual; abstract;
    function getFlags(): Cardinal; virtual; abstract;
    procedure cancel(Status: Status); virtual; abstract;
    procedure finish(Status: Status; timestamp: ISC_TIMESTAMP_TZ); virtual; abstract;
    procedure defineStatement(Status: Status; statementId: Int64; parentStatementId: Int64; type_: PAnsiChar; packageName: PAnsiChar;
      routineName: PAnsiChar; sqlText: PAnsiChar); virtual; abstract;
    procedure defineCursor(statementId: Int64; cursorId: Cardinal; name: PAnsiChar; line: Cardinal; column: Cardinal); virtual; abstract;
    procedure defineRecordSource(statementId: Int64; cursorId: Cardinal; recSourceId: Cardinal; level: Cardinal; accessPath: PAnsiChar;
      parentRecSourceId: Cardinal); virtual; abstract;
    procedure onRequestStart(Status: Status; statementId: Int64; requestId: Int64; callerStatementId: Int64; callerRequestId: Int64;
      timestamp: ISC_TIMESTAMP_TZ); virtual; abstract;
    procedure onRequestFinish(Status: Status; statementId: Int64; requestId: Int64; timestamp: ISC_TIMESTAMP_TZ; stats: ProfilerStats);
      virtual; abstract;
    procedure beforePsqlLineColumn(statementId: Int64; requestId: Int64; line: Cardinal; column: Cardinal); virtual; abstract;
    procedure afterPsqlLineColumn(statementId: Int64; requestId: Int64; line: Cardinal; column: Cardinal; stats: ProfilerStats); virtual; abstract;
    procedure beforeRecordSourceOpen(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal); virtual; abstract;
    procedure afterRecordSourceOpen(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal; stats: ProfilerStats);
      virtual; abstract;
    procedure beforeRecordSourceGetRecord(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal); virtual; abstract;
    procedure afterRecordSourceGetRecord(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal; stats: ProfilerStats);
      virtual; abstract;
  end;

  ProfilerStatsVTable = class(VersionedVTable)
    getElapsedTicks: ProfilerStats_getElapsedTicksPtr;
  end;

  ProfilerStats = class(Versioned)
  const
    version = 2;

    function getElapsedTicks(): QWord;
  end;

  ProfilerStatsImpl = class(ProfilerStats)
    constructor create;

    function getElapsedTicks(): QWord; virtual; abstract;
  end;

implementation

procedure ReferenceCounted.addRef();
begin
  ReferenceCountedVTable(vTable).addRef(Self);
end;

function ReferenceCounted.release(): Integer;
begin
  Result := ReferenceCountedVTable(vTable).release(Self);
end;

procedure Disposable.dispose();
begin
  DisposableVTable(vTable).dispose(Self);
end;

procedure Status.init();
begin
  StatusVTable(vTable).init(Self);
end;

function Status.getState(): Cardinal;
begin
  Result := StatusVTable(vTable).getState(Self);
end;

procedure Status.setErrors2(length: Cardinal; value: NativeIntPtr);
begin
  StatusVTable(vTable).setErrors2(Self, length, value);
end;

procedure Status.setWarnings2(length: Cardinal; value: NativeIntPtr);
begin
  StatusVTable(vTable).setWarnings2(Self, length, value);
end;

procedure Status.setErrors(value: NativeIntPtr);
begin
  StatusVTable(vTable).setErrors(Self, value);
end;

procedure Status.setWarnings(value: NativeIntPtr);
begin
  StatusVTable(vTable).setWarnings(Self, value);
end;

function Status.getErrors(): NativeIntPtr;
begin
  Result := StatusVTable(vTable).getErrors(Self);
end;

function Status.getWarnings(): NativeIntPtr;
begin
  Result := StatusVTable(vTable).getWarnings(Self);
end;

function Status.clone(): Status;
begin
  Result := StatusVTable(vTable).clone(Self);
end;

function Master.getStatus(): Status;
begin
  Result := MasterVTable(vTable).getStatus(Self);
end;

function Master.getDispatcher(): Provider;
begin
  Result := MasterVTable(vTable).getDispatcher(Self);
end;

function Master.getPluginManager(): PluginManager;
begin
  Result := MasterVTable(vTable).getPluginManager(Self);
end;

function Master.getTimerControl(): TimerControl;
begin
  Result := MasterVTable(vTable).getTimerControl(Self);
end;

function Master.getDtc(): Dtc;
begin
  Result := MasterVTable(vTable).getDtc(Self);
end;

function Master.registerAttachment(Provider: Provider; Attachment: Attachment): Attachment;
begin
  Result := MasterVTable(vTable).registerAttachment(Self, Provider, Attachment);
end;

function Master.registerTransaction(Attachment: Attachment; Transaction: Transaction): Transaction;
begin
  Result := MasterVTable(vTable).registerTransaction(Self, Attachment, Transaction);
end;

function Master.getMetadataBuilder(Status: Status; fieldCount: Cardinal): MetadataBuilder;
begin
  Result := MasterVTable(vTable).getMetadataBuilder(Self, Status, fieldCount);
end;

function Master.serverMode(mode: Integer): Integer;
begin
  Result := MasterVTable(vTable).serverMode(Self, mode);
end;

function Master.getUtilInterface(): Util;
begin
  Result := MasterVTable(vTable).getUtilInterface(Self);
end;

function Master.getConfigManager(): ConfigManager;
begin
  Result := MasterVTable(vTable).getConfigManager(Self);
end;

function Master.getProcessExiting(): Boolean;
begin
  Result := MasterVTable(vTable).getProcessExiting(Self);
end;

procedure PluginBase.setOwner(r: ReferenceCounted);
begin
  PluginBaseVTable(vTable).setOwner(Self, r);
end;

function PluginBase.getOwner(): ReferenceCounted;
begin
  Result := PluginBaseVTable(vTable).getOwner(Self);
end;

function PluginSet.getName(): PAnsiChar;
begin
  Result := PluginSetVTable(vTable).getName(Self);
end;

function PluginSet.getModuleName(): PAnsiChar;
begin
  Result := PluginSetVTable(vTable).getModuleName(Self);
end;

function PluginSet.getPlugin(Status: Status): PluginBase;
begin
  Result := PluginSetVTable(vTable).getPlugin(Self, Status);
end;

procedure PluginSet.next(Status: Status);
begin
  PluginSetVTable(vTable).next(Self, Status);
end;

procedure PluginSet.set_(Status: Status; s: PAnsiChar);
begin
  PluginSetVTable(vTable).set_(Self, Status, s);
end;

function ConfigEntry.getName(): PAnsiChar;
begin
  Result := ConfigEntryVTable(vTable).getName(Self);
end;

function ConfigEntry.getValue(): PAnsiChar;
begin
  Result := ConfigEntryVTable(vTable).getValue(Self);
end;

function ConfigEntry.getIntValue(): Int64;
begin
  Result := ConfigEntryVTable(vTable).getIntValue(Self);
end;

function ConfigEntry.getBoolValue(): Boolean;
begin
  Result := ConfigEntryVTable(vTable).getBoolValue(Self);
end;

function ConfigEntry.getSubConfig(Status: Status): Config;
begin
  Result := ConfigEntryVTable(vTable).getSubConfig(Self, Status);
end;

function Config.find(Status: Status; name: PAnsiChar): ConfigEntry;
begin
  Result := ConfigVTable(vTable).find(Self, Status, name);
end;

function Config.findValue(Status: Status; name: PAnsiChar; value: PAnsiChar): ConfigEntry;
begin
  Result := ConfigVTable(vTable).findValue(Self, Status, name, value);
end;

function Config.findPos(Status: Status; name: PAnsiChar; pos: Cardinal): ConfigEntry;
begin
  Result := ConfigVTable(vTable).findPos(Self, Status, name, pos);
end;

function FirebirdConf.getKey(name: PAnsiChar): Cardinal;
begin
  Result := FirebirdConfVTable(vTable).getKey(Self, name);
end;

function FirebirdConf.asInteger(key: Cardinal): Int64;
begin
  Result := FirebirdConfVTable(vTable).asInteger(Self, key);
end;

function FirebirdConf.asString(key: Cardinal): PAnsiChar;
begin
  Result := FirebirdConfVTable(vTable).asString(Self, key);
end;

function FirebirdConf.asBoolean(key: Cardinal): Boolean;
begin
  Result := FirebirdConfVTable(vTable).asBoolean(Self, key);
end;

function FirebirdConf.getVersion(Status: Status): Cardinal;
begin
  if (vTable.version < 4) then
  begin
    Result := 0;
  end
  else
  begin
    Result := FirebirdConfVTable(vTable).getVersion(Self, Status);
  end;
end;

function PluginConfig.getConfigFileName(): PAnsiChar;
begin
  Result := PluginConfigVTable(vTable).getConfigFileName(Self);
end;

function PluginConfig.getDefaultConfig(Status: Status): Config;
begin
  Result := PluginConfigVTable(vTable).getDefaultConfig(Self, Status);
end;

function PluginConfig.getFirebirdConf(Status: Status): FirebirdConf;
begin
  Result := PluginConfigVTable(vTable).getFirebirdConf(Self, Status);
end;

procedure PluginConfig.setReleaseDelay(Status: Status; microSeconds: QWord);
begin
  PluginConfigVTable(vTable).setReleaseDelay(Self, Status, microSeconds);
end;

function PluginFactory.createPlugin(Status: Status; factoryParameter: PluginConfig): PluginBase;
begin
  Result := PluginFactoryVTable(vTable).createPlugin(Self, Status, factoryParameter);
end;

procedure PluginModule.doClean();
begin
  PluginModuleVTable(vTable).doClean(Self);
end;

procedure PluginModule.threadDetach();
begin
  if (vTable.version < 3) then
  begin
  end
  else
  begin
    PluginModuleVTable(vTable).threadDetach(Self);
  end;
end;

procedure PluginManager.registerPluginFactory(pluginType: Cardinal; defaultName: PAnsiChar; factory: PluginFactory);
begin
  PluginManagerVTable(vTable).registerPluginFactory(Self, pluginType, defaultName, factory);
end;

procedure PluginManager.registerModule(cleanup: PluginModule);
begin
  PluginManagerVTable(vTable).registerModule(Self, cleanup);
end;

procedure PluginManager.unregisterModule(cleanup: PluginModule);
begin
  PluginManagerVTable(vTable).unregisterModule(Self, cleanup);
end;

function PluginManager.getPlugins(Status: Status; pluginType: Cardinal; namesList: PAnsiChar; FirebirdConf: FirebirdConf): PluginSet;
begin
  Result := PluginManagerVTable(vTable).getPlugins(Self, Status, pluginType, namesList, FirebirdConf);
end;

function PluginManager.getConfig(Status: Status; filename: PAnsiChar): Config;
begin
  Result := PluginManagerVTable(vTable).getConfig(Self, Status, filename);
end;

procedure PluginManager.releasePlugin(plugin: PluginBase);
begin
  PluginManagerVTable(vTable).releasePlugin(Self, plugin);
end;

procedure CryptKey.setSymmetric(Status: Status; type_: PAnsiChar; keyLength: Cardinal; key: Pointer);
begin
  CryptKeyVTable(vTable).setSymmetric(Self, Status, type_, keyLength, key);
end;

procedure CryptKey.setAsymmetric(Status: Status; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer; decryptKeyLength: Cardinal;
  decryptKey: Pointer);
begin
  CryptKeyVTable(vTable).setAsymmetric(Self, Status, type_, encryptKeyLength, encryptKey, decryptKeyLength, decryptKey);
end;

function CryptKey.getEncryptKey(length: CardinalPtr): Pointer;
begin
  Result := CryptKeyVTable(vTable).getEncryptKey(Self, length);
end;

function CryptKey.getDecryptKey(length: CardinalPtr): Pointer;
begin
  Result := CryptKeyVTable(vTable).getDecryptKey(Self, length);
end;

function ConfigManager.getDirectory(code: Cardinal): PAnsiChar;
begin
  Result := ConfigManagerVTable(vTable).getDirectory(Self, code);
end;

function ConfigManager.getFirebirdConf(): FirebirdConf;
begin
  Result := ConfigManagerVTable(vTable).getFirebirdConf(Self);
end;

function ConfigManager.getDatabaseConf(dbName: PAnsiChar): FirebirdConf;
begin
  Result := ConfigManagerVTable(vTable).getDatabaseConf(Self, dbName);
end;

function ConfigManager.getPluginConfig(configuredPlugin: PAnsiChar): Config;
begin
  Result := ConfigManagerVTable(vTable).getPluginConfig(Self, configuredPlugin);
end;

function ConfigManager.getInstallDirectory(): PAnsiChar;
begin
  Result := ConfigManagerVTable(vTable).getInstallDirectory(Self);
end;

function ConfigManager.getRootDirectory(): PAnsiChar;
begin
  Result := ConfigManagerVTable(vTable).getRootDirectory(Self);
end;

function ConfigManager.getDefaultSecurityDb(): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := ConfigManagerVTable(vTable).getDefaultSecurityDb(Self);
  end;
end;

procedure EventCallback.eventCallbackFunction(length: Cardinal; Events: BytePtr);
begin
  EventCallbackVTable(vTable).eventCallbackFunction(Self, length, Events);
end;

procedure Blob.getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  BlobVTable(vTable).getInfo(Self, Status, itemsLength, items, bufferLength, buffer);
end;

function Blob.getSegment(Status: Status; bufferLength: Cardinal; buffer: Pointer; segmentLength: CardinalPtr): Integer;
begin
  Result := BlobVTable(vTable).getSegment(Self, Status, bufferLength, buffer, segmentLength);
end;

procedure Blob.putSegment(Status: Status; length: Cardinal; buffer: Pointer);
begin
  BlobVTable(vTable).putSegment(Self, Status, length, buffer);
end;

procedure Blob.deprecatedCancel(Status: Status);
begin
  BlobVTable(vTable).deprecatedCancel(Self, Status);
end;

procedure Blob.deprecatedClose(Status: Status);
begin
  BlobVTable(vTable).deprecatedClose(Self, Status);
end;

function Blob.seek(Status: Status; mode: Integer; offset: Integer): Integer;
begin
  Result := BlobVTable(vTable).seek(Self, Status, mode, offset);
end;

procedure Blob.cancel(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedCancel(Status);
    end
  end
  else
  begin
    BlobVTable(vTable).cancel(Self, Status);
  end;
end;

procedure Blob.close(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedClose(Status);
    end
  end
  else
  begin
    BlobVTable(vTable).close(Self, Status);
  end;
end;

procedure Transaction.getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  TransactionVTable(vTable).getInfo(Self, Status, itemsLength, items, bufferLength, buffer);
end;

procedure Transaction.prepare(Status: Status; msgLength: Cardinal; message: BytePtr);
begin
  TransactionVTable(vTable).prepare(Self, Status, msgLength, message);
end;

procedure Transaction.deprecatedCommit(Status: Status);
begin
  TransactionVTable(vTable).deprecatedCommit(Self, Status);
end;

procedure Transaction.commitRetaining(Status: Status);
begin
  TransactionVTable(vTable).commitRetaining(Self, Status);
end;

procedure Transaction.deprecatedRollback(Status: Status);
begin
  TransactionVTable(vTable).deprecatedRollback(Self, Status);
end;

procedure Transaction.rollbackRetaining(Status: Status);
begin
  TransactionVTable(vTable).rollbackRetaining(Self, Status);
end;

procedure Transaction.deprecatedDisconnect(Status: Status);
begin
  TransactionVTable(vTable).deprecatedDisconnect(Self, Status);
end;

function Transaction.join(Status: Status; Transaction: Transaction): Transaction;
begin
  Result := TransactionVTable(vTable).join(Self, Status, Transaction);
end;

function Transaction.validate(Status: Status; Attachment: Attachment): Transaction;
begin
  Result := TransactionVTable(vTable).validate(Self, Status, Attachment);
end;

function Transaction.enterDtc(Status: Status): Transaction;
begin
  Result := TransactionVTable(vTable).enterDtc(Self, Status);
end;

procedure Transaction.commit(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedCommit(Status);
    end
  end
  else
  begin
    TransactionVTable(vTable).commit(Self, Status);
  end;
end;

procedure Transaction.rollback(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedRollback(Status);
    end
  end
  else
  begin
    TransactionVTable(vTable).rollback(Self, Status);
  end;
end;

procedure Transaction.disconnect(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedDisconnect(Status);
    end
  end
  else
  begin
    TransactionVTable(vTable).disconnect(Self, Status);
  end;
end;

function MessageMetadata.getCount(Status: Status): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getCount(Self, Status);
end;

function MessageMetadata.getField(Status: Status; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getField(Self, Status, index);
end;

function MessageMetadata.getRelation(Status: Status; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getRelation(Self, Status, index);
end;

function MessageMetadata.getOwner(Status: Status; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getOwner(Self, Status, index);
end;

function MessageMetadata.getAlias(Status: Status; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getAlias(Self, Status, index);
end;

function MessageMetadata.getType(Status: Status; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getType(Self, Status, index);
end;

function MessageMetadata.isNullable(Status: Status; index: Cardinal): Boolean;
begin
  Result := MessageMetadataVTable(vTable).isNullable(Self, Status, index);
end;

function MessageMetadata.getSubType(Status: Status; index: Cardinal): Integer;
begin
  Result := MessageMetadataVTable(vTable).getSubType(Self, Status, index);
end;

function MessageMetadata.getLength(Status: Status; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getLength(Self, Status, index);
end;

function MessageMetadata.getScale(Status: Status; index: Cardinal): Integer;
begin
  Result := MessageMetadataVTable(vTable).getScale(Self, Status, index);
end;

function MessageMetadata.getCharSet(Status: Status; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getCharSet(Self, Status, index);
end;

function MessageMetadata.getOffset(Status: Status; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getOffset(Self, Status, index);
end;

function MessageMetadata.getNullOffset(Status: Status; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getNullOffset(Self, Status, index);
end;

function MessageMetadata.getBuilder(Status: Status): MetadataBuilder;
begin
  Result := MessageMetadataVTable(vTable).getBuilder(Self, Status);
end;

function MessageMetadata.getMessageLength(Status: Status): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getMessageLength(Self, Status);
end;

function MessageMetadata.getAlignment(Status: Status): Cardinal;
begin
  if (vTable.version < 4) then
  begin
    Result := 0;
  end
  else
  begin
    Result := MessageMetadataVTable(vTable).getAlignment(Self, Status);
  end;
end;

function MessageMetadata.getAlignedLength(Status: Status): Cardinal;
begin
  if (vTable.version < 4) then
  begin
    Result := 0;
  end
  else
  begin
    Result := MessageMetadataVTable(vTable).getAlignedLength(Self, Status);
  end;
end;

procedure MetadataBuilder.setType(Status: Status; index: Cardinal; type_: Cardinal);
begin
  MetadataBuilderVTable(vTable).setType(Self, Status, index, type_);
end;

procedure MetadataBuilder.setSubType(Status: Status; index: Cardinal; subType: Integer);
begin
  MetadataBuilderVTable(vTable).setSubType(Self, Status, index, subType);
end;

procedure MetadataBuilder.setLength(Status: Status; index: Cardinal; length: Cardinal);
begin
  MetadataBuilderVTable(vTable).setLength(Self, Status, index, length);
end;

procedure MetadataBuilder.setCharSet(Status: Status; index: Cardinal; charSet: Cardinal);
begin
  MetadataBuilderVTable(vTable).setCharSet(Self, Status, index, charSet);
end;

procedure MetadataBuilder.setScale(Status: Status; index: Cardinal; scale: Integer);
begin
  MetadataBuilderVTable(vTable).setScale(Self, Status, index, scale);
end;

procedure MetadataBuilder.truncate(Status: Status; count: Cardinal);
begin
  MetadataBuilderVTable(vTable).truncate(Self, Status, count);
end;

procedure MetadataBuilder.moveNameToIndex(Status: Status; name: PAnsiChar; index: Cardinal);
begin
  MetadataBuilderVTable(vTable).moveNameToIndex(Self, Status, name, index);
end;

procedure MetadataBuilder.remove(Status: Status; index: Cardinal);
begin
  MetadataBuilderVTable(vTable).remove(Self, Status, index);
end;

function MetadataBuilder.addField(Status: Status): Cardinal;
begin
  Result := MetadataBuilderVTable(vTable).addField(Self, Status);
end;

function MetadataBuilder.getMetadata(Status: Status): MessageMetadata;
begin
  Result := MetadataBuilderVTable(vTable).getMetadata(Self, Status);
end;

procedure MetadataBuilder.setField(Status: Status; index: Cardinal; field: PAnsiChar);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    MetadataBuilderVTable(vTable).setField(Self, Status, index, field);
  end;
end;

procedure MetadataBuilder.setRelation(Status: Status; index: Cardinal; relation: PAnsiChar);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    MetadataBuilderVTable(vTable).setRelation(Self, Status, index, relation);
  end;
end;

procedure MetadataBuilder.setOwner(Status: Status; index: Cardinal; owner: PAnsiChar);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    MetadataBuilderVTable(vTable).setOwner(Self, Status, index, owner);
  end;
end;

procedure MetadataBuilder.setAlias(Status: Status; index: Cardinal; alias: PAnsiChar);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    MetadataBuilderVTable(vTable).setAlias(Self, Status, index, alias);
  end;
end;

function ResultSet.fetchNext(Status: Status; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchNext(Self, Status, message);
end;

function ResultSet.fetchPrior(Status: Status; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchPrior(Self, Status, message);
end;

function ResultSet.fetchFirst(Status: Status; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchFirst(Self, Status, message);
end;

function ResultSet.fetchLast(Status: Status; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchLast(Self, Status, message);
end;

function ResultSet.fetchAbsolute(Status: Status; position: Integer; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchAbsolute(Self, Status, position, message);
end;

function ResultSet.fetchRelative(Status: Status; offset: Integer; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchRelative(Self, Status, offset, message);
end;

function ResultSet.isEof(Status: Status): Boolean;
begin
  Result := ResultSetVTable(vTable).isEof(Self, Status);
end;

function ResultSet.isBof(Status: Status): Boolean;
begin
  Result := ResultSetVTable(vTable).isBof(Self, Status);
end;

function ResultSet.getMetadata(Status: Status): MessageMetadata;
begin
  Result := ResultSetVTable(vTable).getMetadata(Self, Status);
end;

procedure ResultSet.deprecatedClose(Status: Status);
begin
  ResultSetVTable(vTable).deprecatedClose(Self, Status);
end;

procedure ResultSet.setDelayedOutputFormat(Status: Status; format: MessageMetadata);
begin
  ResultSetVTable(vTable).setDelayedOutputFormat(Self, Status, format);
end;

procedure ResultSet.close(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedClose(Status);
    end
  end
  else
  begin
    ResultSetVTable(vTable).close(Self, Status);
  end;
end;

procedure ResultSet.getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  if (vTable.version < 5) then
  begin
  end
  else
  begin
    ResultSetVTable(vTable).getInfo(Self, Status, itemsLength, items, bufferLength, buffer);
  end;
end;

procedure Statement.getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  StatementVTable(vTable).getInfo(Self, Status, itemsLength, items, bufferLength, buffer);
end;

function Statement.getType(Status: Status): Cardinal;
begin
  Result := StatementVTable(vTable).getType(Self, Status);
end;

function Statement.getPlan(Status: Status; detailed: Boolean): PAnsiChar;
begin
  Result := StatementVTable(vTable).getPlan(Self, Status, detailed);
end;

function Statement.getAffectedRecords(Status: Status): QWord;
begin
  Result := StatementVTable(vTable).getAffectedRecords(Self, Status);
end;

function Statement.getInputMetadata(Status: Status): MessageMetadata;
begin
  Result := StatementVTable(vTable).getInputMetadata(Self, Status);
end;

function Statement.getOutputMetadata(Status: Status): MessageMetadata;
begin
  Result := StatementVTable(vTable).getOutputMetadata(Self, Status);
end;

function Statement.execute(Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata;
  outBuffer: Pointer): Transaction;
begin
  Result := StatementVTable(vTable).execute(Self, Status, Transaction, inMetadata, inBuffer, outMetadata, outBuffer);
end;

function Statement.openCursor(Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata;
  flags: Cardinal): ResultSet;
begin
  Result := StatementVTable(vTable).openCursor(Self, Status, Transaction, inMetadata, inBuffer, outMetadata, flags);
end;

procedure Statement.setCursorName(Status: Status; name: PAnsiChar);
begin
  StatementVTable(vTable).setCursorName(Self, Status, name);
end;

procedure Statement.deprecatedFree(Status: Status);
begin
  StatementVTable(vTable).deprecatedFree(Self, Status);
end;

function Statement.getFlags(Status: Status): Cardinal;
begin
  Result := StatementVTable(vTable).getFlags(Self, Status);
end;

function Statement.getTimeout(Status: Status): Cardinal;
begin
  if (vTable.version < 4) then
  begin
    Result := 0;
  end
  else
  begin
    Result := StatementVTable(vTable).getTimeout(Self, Status);
  end;
end;

procedure Statement.setTimeout(Status: Status; timeOut: Cardinal);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    StatementVTable(vTable).setTimeout(Self, Status, timeOut);
  end;
end;

function Statement.createBatch(Status: Status; inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch;
begin
  if (vTable.version < 4) then
  begin
    Result := nil;
  end
  else
  begin
    Result := StatementVTable(vTable).createBatch(Self, Status, inMetadata, parLength, par);
  end;
end;

procedure Statement.free(Status: Status);
begin
  if (vTable.version < 5) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedFree(Status);
    end
  end
  else
  begin
    StatementVTable(vTable).free(Self, Status);
  end;
end;

procedure Batch.add(Status: Status; count: Cardinal; inBuffer: Pointer);
begin
  BatchVTable(vTable).add(Self, Status, count, inBuffer);
end;

procedure Batch.addBlob(Status: Status; length: Cardinal; inBuffer: Pointer; blobId: ISC_QUADPtr; parLength: Cardinal; par: BytePtr);
begin
  BatchVTable(vTable).addBlob(Self, Status, length, inBuffer, blobId, parLength, par);
end;

procedure Batch.appendBlobData(Status: Status; length: Cardinal; inBuffer: Pointer);
begin
  BatchVTable(vTable).appendBlobData(Self, Status, length, inBuffer);
end;

procedure Batch.addBlobStream(Status: Status; length: Cardinal; inBuffer: Pointer);
begin
  BatchVTable(vTable).addBlobStream(Self, Status, length, inBuffer);
end;

procedure Batch.registerBlob(Status: Status; existingBlob: ISC_QUADPtr; blobId: ISC_QUADPtr);
begin
  BatchVTable(vTable).registerBlob(Self, Status, existingBlob, blobId);
end;

function Batch.execute(Status: Status; Transaction: Transaction): BatchCompletionState;
begin
  Result := BatchVTable(vTable).execute(Self, Status, Transaction);
end;

procedure Batch.cancel(Status: Status);
begin
  BatchVTable(vTable).cancel(Self, Status);
end;

function Batch.getBlobAlignment(Status: Status): Cardinal;
begin
  Result := BatchVTable(vTable).getBlobAlignment(Self, Status);
end;

function Batch.getMetadata(Status: Status): MessageMetadata;
begin
  Result := BatchVTable(vTable).getMetadata(Self, Status);
end;

procedure Batch.setDefaultBpb(Status: Status; parLength: Cardinal; par: BytePtr);
begin
  BatchVTable(vTable).setDefaultBpb(Self, Status, parLength, par);
end;

procedure Batch.deprecatedClose(Status: Status);
begin
  BatchVTable(vTable).deprecatedClose(Self, Status);
end;

procedure Batch.close(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedClose(Status);
    end
  end
  else
  begin
    BatchVTable(vTable).close(Self, Status);
  end;
end;

procedure Batch.getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    BatchVTable(vTable).getInfo(Self, Status, itemsLength, items, bufferLength, buffer);
  end;
end;

function BatchCompletionState.getSize(Status: Status): Cardinal;
begin
  Result := BatchCompletionStateVTable(vTable).getSize(Self, Status);
end;

function BatchCompletionState.getState(Status: Status; pos: Cardinal): Integer;
begin
  Result := BatchCompletionStateVTable(vTable).getState(Self, Status, pos);
end;

function BatchCompletionState.findError(Status: Status; pos: Cardinal): Cardinal;
begin
  Result := BatchCompletionStateVTable(vTable).findError(Self, Status, pos);
end;

procedure BatchCompletionState.getStatus(Status: Status; to_: Status; pos: Cardinal);
begin
  BatchCompletionStateVTable(vTable).getStatus(Self, Status, to_, pos);
end;

procedure Replicator.process(Status: Status; length: Cardinal; data: BytePtr);
begin
  ReplicatorVTable(vTable).process(Self, Status, length, data);
end;

procedure Replicator.deprecatedClose(Status: Status);
begin
  ReplicatorVTable(vTable).deprecatedClose(Self, Status);
end;

procedure Replicator.close(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedClose(Status);
    end
  end
  else
  begin
    ReplicatorVTable(vTable).close(Self, Status);
  end;
end;

procedure Request.receive(Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer);
begin
  RequestVTable(vTable).receive(Self, Status, level, msgType, length, message);
end;

procedure Request.send(Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer);
begin
  RequestVTable(vTable).send(Self, Status, level, msgType, length, message);
end;

procedure Request.getInfo(Status: Status; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  RequestVTable(vTable).getInfo(Self, Status, level, itemsLength, items, bufferLength, buffer);
end;

procedure Request.start(Status: Status; tra: Transaction; level: Integer);
begin
  RequestVTable(vTable).start(Self, Status, tra, level);
end;

procedure Request.startAndSend(Status: Status; tra: Transaction; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer);
begin
  RequestVTable(vTable).startAndSend(Self, Status, tra, level, msgType, length, message);
end;

procedure Request.unwind(Status: Status; level: Integer);
begin
  RequestVTable(vTable).unwind(Self, Status, level);
end;

procedure Request.deprecatedFree(Status: Status);
begin
  RequestVTable(vTable).deprecatedFree(Self, Status);
end;

procedure Request.free(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedFree(Status);
    end
  end
  else
  begin
    RequestVTable(vTable).free(Self, Status);
  end;
end;

procedure Events.deprecatedCancel(Status: Status);
begin
  EventsVTable(vTable).deprecatedCancel(Self, Status);
end;

procedure Events.cancel(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedCancel(Status);
    end
  end
  else
  begin
    EventsVTable(vTable).cancel(Self, Status);
  end;
end;

procedure Attachment.getInfo(Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  AttachmentVTable(vTable).getInfo(Self, Status, itemsLength, items, bufferLength, buffer);
end;

function Attachment.startTransaction(Status: Status; tpbLength: Cardinal; tpb: BytePtr): Transaction;
begin
  Result := AttachmentVTable(vTable).startTransaction(Self, Status, tpbLength, tpb);
end;

function Attachment.reconnectTransaction(Status: Status; length: Cardinal; id: BytePtr): Transaction;
begin
  Result := AttachmentVTable(vTable).reconnectTransaction(Self, Status, length, id);
end;

function Attachment.compileRequest(Status: Status; blrLength: Cardinal; blr: BytePtr): Request;
begin
  Result := AttachmentVTable(vTable).compileRequest(Self, Status, blrLength, blr);
end;

procedure Attachment.transactRequest(Status: Status; Transaction: Transaction; blrLength: Cardinal; blr: BytePtr; inMsgLength: Cardinal;
  inMsg: BytePtr; outMsgLength: Cardinal; outMsg: BytePtr);
begin
  AttachmentVTable(vTable).transactRequest(Self, Status, Transaction, blrLength, blr, inMsgLength, inMsg, outMsgLength, outMsg);
end;

function Attachment.createBlob(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): Blob;
begin
  Result := AttachmentVTable(vTable).createBlob(Self, Status, Transaction, id, bpbLength, bpb);
end;

function Attachment.openBlob(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): Blob;
begin
  Result := AttachmentVTable(vTable).openBlob(Self, Status, Transaction, id, bpbLength, bpb);
end;

function Attachment.getSlice(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
  param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer;
begin
  Result := AttachmentVTable(vTable).getSlice(Self, Status, Transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
end;

procedure Attachment.putSlice(Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
  param: BytePtr; sliceLength: Integer; slice: BytePtr);
begin
  AttachmentVTable(vTable).putSlice(Self, Status, Transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
end;

procedure Attachment.executeDyn(Status: Status; Transaction: Transaction; length: Cardinal; dyn: BytePtr);
begin
  AttachmentVTable(vTable).executeDyn(Self, Status, Transaction, length, dyn);
end;

function Attachment.prepare(Status: Status; tra: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal; flags: Cardinal)
  : Statement;
begin
  Result := AttachmentVTable(vTable).prepare(Self, Status, tra, stmtLength, sqlStmt, dialect, flags);
end;

function Attachment.execute(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
  inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; outBuffer: Pointer): Transaction;
begin
  Result := AttachmentVTable(vTable).execute(Self, Status, Transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata, outBuffer);
end;

function Attachment.openCursor(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
  inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal): ResultSet;
begin
  Result := AttachmentVTable(vTable).openCursor(Self, Status, Transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata,
    cursorName, cursorFlags);
end;

function Attachment.queEvents(Status: Status; callback: EventCallback; length: Cardinal; Events: BytePtr): Events;
begin
  Result := AttachmentVTable(vTable).queEvents(Self, Status, callback, length, Events);
end;

procedure Attachment.cancelOperation(Status: Status; option: Integer);
begin
  AttachmentVTable(vTable).cancelOperation(Self, Status, option);
end;

procedure Attachment.ping(Status: Status);
begin
  AttachmentVTable(vTable).ping(Self, Status);
end;

procedure Attachment.deprecatedDetach(Status: Status);
begin
  AttachmentVTable(vTable).deprecatedDetach(Self, Status);
end;

procedure Attachment.deprecatedDropDatabase(Status: Status);
begin
  AttachmentVTable(vTable).deprecatedDropDatabase(Self, Status);
end;

function Attachment.getIdleTimeout(Status: Status): Cardinal;
begin
  if (vTable.version < 4) then
  begin
    Result := 0;
  end
  else
  begin
    Result := AttachmentVTable(vTable).getIdleTimeout(Self, Status);
  end;
end;

procedure Attachment.setIdleTimeout(Status: Status; timeOut: Cardinal);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    AttachmentVTable(vTable).setIdleTimeout(Self, Status, timeOut);
  end;
end;

function Attachment.getStatementTimeout(Status: Status): Cardinal;
begin
  if (vTable.version < 4) then
  begin
    Result := 0;
  end
  else
  begin
    Result := AttachmentVTable(vTable).getStatementTimeout(Self, Status);
  end;
end;

procedure Attachment.setStatementTimeout(Status: Status; timeOut: Cardinal);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    AttachmentVTable(vTable).setStatementTimeout(Self, Status, timeOut);
  end;
end;

function Attachment.createBatch(Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
  inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch;
begin
  if (vTable.version < 4) then
  begin
    Result := nil;
  end
  else
  begin
    Result := AttachmentVTable(vTable).createBatch(Self, Status, Transaction, stmtLength, sqlStmt, dialect, inMetadata, parLength, par);
  end;
end;

function Attachment.createReplicator(Status: Status): Replicator;
begin
  if (vTable.version < 4) then
  begin
    Result := nil;
  end
  else
  begin
    Result := AttachmentVTable(vTable).createReplicator(Self, Status);
  end;
end;

procedure Attachment.detach(Status: Status);
begin
  if (vTable.version < 5) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedDetach(Status);
    end
  end
  else
  begin
    AttachmentVTable(vTable).detach(Self, Status);
  end;
end;

procedure Attachment.dropDatabase(Status: Status);
begin
  if (vTable.version < 5) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedDropDatabase(Status);
    end
  end
  else
  begin
    AttachmentVTable(vTable).dropDatabase(Self, Status);
  end;
end;

procedure Service.deprecatedDetach(Status: Status);
begin
  ServiceVTable(vTable).deprecatedDetach(Self, Status);
end;

procedure Service.query(Status: Status; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal; receiveItems: BytePtr;
  bufferLength: Cardinal; buffer: BytePtr);
begin
  ServiceVTable(vTable).query(Self, Status, sendLength, sendItems, receiveLength, receiveItems, bufferLength, buffer);
end;

procedure Service.start(Status: Status; spbLength: Cardinal; spb: BytePtr);
begin
  ServiceVTable(vTable).start(Self, Status, spbLength, spb);
end;

procedure Service.detach(Status: Status);
begin
  if (vTable.version < 4) then
  begin
    if FB_UsedInYValve then
    begin
    end
    else
    begin
      deprecatedDetach(Status);
    end
  end
  else
  begin
    ServiceVTable(vTable).detach(Self, Status);
  end;
end;

procedure Service.cancel(Status: Status);
begin
  if (vTable.version < 5) then
  begin
  end
  else
  begin
    ServiceVTable(vTable).cancel(Self, Status);
  end;
end;

function Provider.attachDatabase(Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment;
begin
  Result := ProviderVTable(vTable).attachDatabase(Self, Status, filename, dpbLength, dpb);
end;

function Provider.createDatabase(Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): Attachment;
begin
  Result := ProviderVTable(vTable).createDatabase(Self, Status, filename, dpbLength, dpb);
end;

function Provider.attachServiceManager(Status: Status; Service: PAnsiChar; spbLength: Cardinal; spb: BytePtr): Service;
begin
  Result := ProviderVTable(vTable).attachServiceManager(Self, Status, Service, spbLength, spb);
end;

procedure Provider.shutdown(Status: Status; timeOut: Cardinal; reason: Integer);
begin
  ProviderVTable(vTable).shutdown(Self, Status, timeOut, reason);
end;

procedure Provider.setDbCryptCallback(Status: Status; cryptCallback: CryptKeyCallback);
begin
  ProviderVTable(vTable).setDbCryptCallback(Self, Status, cryptCallback);
end;

procedure DtcStart.addAttachment(Status: Status; att: Attachment);
begin
  DtcStartVTable(vTable).addAttachment(Self, Status, att);
end;

procedure DtcStart.addWithTpb(Status: Status; att: Attachment; length: Cardinal; tpb: BytePtr);
begin
  DtcStartVTable(vTable).addWithTpb(Self, Status, att, length, tpb);
end;

function DtcStart.start(Status: Status): Transaction;
begin
  Result := DtcStartVTable(vTable).start(Self, Status);
end;

function Dtc.join(Status: Status; one: Transaction; two: Transaction): Transaction;
begin
  Result := DtcVTable(vTable).join(Self, Status, one, two);
end;

function Dtc.startBuilder(Status: Status): DtcStart;
begin
  Result := DtcVTable(vTable).startBuilder(Self, Status);
end;

procedure Writer.reset();
begin
  WriterVTable(vTable).reset(Self);
end;

procedure Writer.add(Status: Status; name: PAnsiChar);
begin
  WriterVTable(vTable).add(Self, Status, name);
end;

procedure Writer.setType(Status: Status; value: PAnsiChar);
begin
  WriterVTable(vTable).setType(Self, Status, value);
end;

procedure Writer.setDb(Status: Status; value: PAnsiChar);
begin
  WriterVTable(vTable).setDb(Self, Status, value);
end;

function ServerBlock.getLogin(): PAnsiChar;
begin
  Result := ServerBlockVTable(vTable).getLogin(Self);
end;

function ServerBlock.getData(length: CardinalPtr): BytePtr;
begin
  Result := ServerBlockVTable(vTable).getData(Self, length);
end;

procedure ServerBlock.putData(Status: Status; length: Cardinal; data: Pointer);
begin
  ServerBlockVTable(vTable).putData(Self, Status, length, data);
end;

function ServerBlock.newKey(Status: Status): CryptKey;
begin
  Result := ServerBlockVTable(vTable).newKey(Self, Status);
end;

function ClientBlock.getLogin(): PAnsiChar;
begin
  Result := ClientBlockVTable(vTable).getLogin(Self);
end;

function ClientBlock.getPassword(): PAnsiChar;
begin
  Result := ClientBlockVTable(vTable).getPassword(Self);
end;

function ClientBlock.getData(length: CardinalPtr): BytePtr;
begin
  Result := ClientBlockVTable(vTable).getData(Self, length);
end;

procedure ClientBlock.putData(Status: Status; length: Cardinal; data: Pointer);
begin
  ClientBlockVTable(vTable).putData(Self, Status, length, data);
end;

function ClientBlock.newKey(Status: Status): CryptKey;
begin
  Result := ClientBlockVTable(vTable).newKey(Self, Status);
end;

function ClientBlock.getAuthBlock(Status: Status): AuthBlock;
begin
  if (vTable.version < 4) then
  begin
    Result := nil;
  end
  else
  begin
    Result := ClientBlockVTable(vTable).getAuthBlock(Self, Status);
  end;
end;

function Server.authenticate(Status: Status; sBlock: ServerBlock; writerInterface: Writer): Integer;
begin
  Result := ServerVTable(vTable).authenticate(Self, Status, sBlock, writerInterface);
end;

procedure Server.setDbCryptCallback(Status: Status; cryptCallback: CryptKeyCallback);
begin
  if (vTable.version < 6) then
  begin
  end
  else
  begin
    ServerVTable(vTable).setDbCryptCallback(Self, Status, cryptCallback);
  end;
end;

function Client.authenticate(Status: Status; cBlock: ClientBlock): Integer;
begin
  Result := ClientVTable(vTable).authenticate(Self, Status, cBlock);
end;

function UserField.entered(): Integer;
begin
  Result := UserFieldVTable(vTable).entered(Self);
end;

function UserField.specified(): Integer;
begin
  Result := UserFieldVTable(vTable).specified(Self);
end;

procedure UserField.setEntered(Status: Status; newValue: Integer);
begin
  UserFieldVTable(vTable).setEntered(Self, Status, newValue);
end;

function CharUserField.get(): PAnsiChar;
begin
  Result := CharUserFieldVTable(vTable).get(Self);
end;

procedure CharUserField.set_(Status: Status; newValue: PAnsiChar);
begin
  CharUserFieldVTable(vTable).set_(Self, Status, newValue);
end;

function IntUserField.get(): Integer;
begin
  Result := IntUserFieldVTable(vTable).get(Self);
end;

procedure IntUserField.set_(Status: Status; newValue: Integer);
begin
  IntUserFieldVTable(vTable).set_(Self, Status, newValue);
end;

function User.operation(): Cardinal;
begin
  Result := UserVTable(vTable).operation(Self);
end;

function User.userName(): CharUserField;
begin
  Result := UserVTable(vTable).userName(Self);
end;

function User.password(): CharUserField;
begin
  Result := UserVTable(vTable).password(Self);
end;

function User.firstName(): CharUserField;
begin
  Result := UserVTable(vTable).firstName(Self);
end;

function User.lastName(): CharUserField;
begin
  Result := UserVTable(vTable).lastName(Self);
end;

function User.middleName(): CharUserField;
begin
  Result := UserVTable(vTable).middleName(Self);
end;

function User.comment(): CharUserField;
begin
  Result := UserVTable(vTable).comment(Self);
end;

function User.attributes(): CharUserField;
begin
  Result := UserVTable(vTable).attributes(Self);
end;

function User.active(): IntUserField;
begin
  Result := UserVTable(vTable).active(Self);
end;

function User.admin(): IntUserField;
begin
  Result := UserVTable(vTable).admin(Self);
end;

procedure User.clear(Status: Status);
begin
  UserVTable(vTable).clear(Self, Status);
end;

procedure ListUsers.list(Status: Status; User: User);
begin
  ListUsersVTable(vTable).list(Self, Status, User);
end;

function LogonInfo.name(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).name(Self);
end;

function LogonInfo.role(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).role(Self);
end;

function LogonInfo.networkProtocol(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).networkProtocol(Self);
end;

function LogonInfo.remoteAddress(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).remoteAddress(Self);
end;

function LogonInfo.AuthBlock(length: CardinalPtr): BytePtr;
begin
  Result := LogonInfoVTable(vTable).AuthBlock(Self, length);
end;

function LogonInfo.Attachment(Status: Status): Attachment;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := LogonInfoVTable(vTable).Attachment(Self, Status);
  end;
end;

function LogonInfo.Transaction(Status: Status): Transaction;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := LogonInfoVTable(vTable).Transaction(Self, Status);
  end;
end;

procedure Management.start(Status: Status; LogonInfo: LogonInfo);
begin
  ManagementVTable(vTable).start(Self, Status, LogonInfo);
end;

function Management.execute(Status: Status; User: User; callback: ListUsers): Integer;
begin
  Result := ManagementVTable(vTable).execute(Self, Status, User, callback);
end;

procedure Management.commit(Status: Status);
begin
  ManagementVTable(vTable).commit(Self, Status);
end;

procedure Management.rollback(Status: Status);
begin
  ManagementVTable(vTable).rollback(Self, Status);
end;

function AuthBlock.getType(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getType(Self);
end;

function AuthBlock.getName(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getName(Self);
end;

function AuthBlock.getPlugin(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getPlugin(Self);
end;

function AuthBlock.getSecurityDb(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getSecurityDb(Self);
end;

function AuthBlock.getOriginalPlugin(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getOriginalPlugin(Self);
end;

function AuthBlock.next(Status: Status): Boolean;
begin
  Result := AuthBlockVTable(vTable).next(Self, Status);
end;

function AuthBlock.first(Status: Status): Boolean;
begin
  Result := AuthBlockVTable(vTable).first(Self, Status);
end;

function WireCryptPlugin.getKnownTypes(Status: Status): PAnsiChar;
begin
  Result := WireCryptPluginVTable(vTable).getKnownTypes(Self, Status);
end;

procedure WireCryptPlugin.setKey(Status: Status; key: CryptKey);
begin
  WireCryptPluginVTable(vTable).setKey(Self, Status, key);
end;

procedure WireCryptPlugin.encrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
begin
  WireCryptPluginVTable(vTable).encrypt(Self, Status, length, from, to_);
end;

procedure WireCryptPlugin.decrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
begin
  WireCryptPluginVTable(vTable).decrypt(Self, Status, length, from, to_);
end;

function WireCryptPlugin.getSpecificData(Status: Status; keyType: PAnsiChar; length: CardinalPtr): BytePtr;
begin
  if (vTable.version < 5) then
  begin
    Result := nil;
  end
  else
  begin
    Result := WireCryptPluginVTable(vTable).getSpecificData(Self, Status, keyType, length);
  end;
end;

procedure WireCryptPlugin.setSpecificData(Status: Status; keyType: PAnsiChar; length: Cardinal; data: BytePtr);
begin
  if (vTable.version < 5) then
  begin
  end
  else
  begin
    WireCryptPluginVTable(vTable).setSpecificData(Self, Status, keyType, length, data);
  end;
end;

function CryptKeyCallback.callback(dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer): Cardinal;
begin
  Result := CryptKeyCallbackVTable(vTable).callback(Self, dataLength, data, bufferLength, buffer);
end;

function CryptKeyCallback.afterAttach(Status: Status; dbName: PAnsiChar; attStatus: Status): Cardinal;
begin
  if (vTable.version < 3) then
  begin
    Result := 0;
  end
  else
  begin
    Result := CryptKeyCallbackVTable(vTable).afterAttach(Self, Status, dbName, attStatus);
  end;
end;

procedure CryptKeyCallback.dispose();
begin
  if (vTable.version < 3) then
  begin
  end
  else
  begin
    CryptKeyCallbackVTable(vTable).dispose(Self);
  end;
end;

function KeyHolderPlugin.keyCallback(Status: Status; callback: CryptKeyCallback): Integer;
begin
  Result := KeyHolderPluginVTable(vTable).keyCallback(Self, Status, callback);
end;

function KeyHolderPlugin.keyHandle(Status: Status; keyName: PAnsiChar): CryptKeyCallback;
begin
  Result := KeyHolderPluginVTable(vTable).keyHandle(Self, Status, keyName);
end;

function KeyHolderPlugin.useOnlyOwnKeys(Status: Status): Boolean;
begin
  if (vTable.version < 5) then
  begin
    Result := FALSE;
  end
  else
  begin
    Result := KeyHolderPluginVTable(vTable).useOnlyOwnKeys(Self, Status);
  end;
end;

function KeyHolderPlugin.chainHandle(Status: Status): CryptKeyCallback;
begin
  if (vTable.version < 5) then
  begin
    Result := nil;
  end
  else
  begin
    Result := KeyHolderPluginVTable(vTable).chainHandle(Self, Status);
  end;
end;

function DbCryptInfo.getDatabaseFullPath(Status: Status): PAnsiChar;
begin
  Result := DbCryptInfoVTable(vTable).getDatabaseFullPath(Self, Status);
end;

procedure DbCryptPlugin.setKey(Status: Status; length: Cardinal; sources: KeyHolderPluginPtr; keyName: PAnsiChar);
begin
  DbCryptPluginVTable(vTable).setKey(Self, Status, length, sources, keyName);
end;

procedure DbCryptPlugin.encrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
begin
  DbCryptPluginVTable(vTable).encrypt(Self, Status, length, from, to_);
end;

procedure DbCryptPlugin.decrypt(Status: Status; length: Cardinal; from: Pointer; to_: Pointer);
begin
  DbCryptPluginVTable(vTable).decrypt(Self, Status, length, from, to_);
end;

procedure DbCryptPlugin.setInfo(Status: Status; info: DbCryptInfo);
begin
  if (vTable.version < 5) then
  begin
  end
  else
  begin
    DbCryptPluginVTable(vTable).setInfo(Self, Status, info);
  end;
end;

function ExternalContext.getMaster(): Master;
begin
  Result := ExternalContextVTable(vTable).getMaster(Self);
end;

function ExternalContext.getEngine(Status: Status): ExternalEngine;
begin
  Result := ExternalContextVTable(vTable).getEngine(Self, Status);
end;

function ExternalContext.getAttachment(Status: Status): Attachment;
begin
  Result := ExternalContextVTable(vTable).getAttachment(Self, Status);
end;

function ExternalContext.getTransaction(Status: Status): Transaction;
begin
  Result := ExternalContextVTable(vTable).getTransaction(Self, Status);
end;

function ExternalContext.getUserName(): PAnsiChar;
begin
  Result := ExternalContextVTable(vTable).getUserName(Self);
end;

function ExternalContext.getDatabaseName(): PAnsiChar;
begin
  Result := ExternalContextVTable(vTable).getDatabaseName(Self);
end;

function ExternalContext.getClientCharSet(): PAnsiChar;
begin
  Result := ExternalContextVTable(vTable).getClientCharSet(Self);
end;

function ExternalContext.obtainInfoCode(): Integer;
begin
  Result := ExternalContextVTable(vTable).obtainInfoCode(Self);
end;

function ExternalContext.getInfo(code: Integer): Pointer;
begin
  Result := ExternalContextVTable(vTable).getInfo(Self, code);
end;

function ExternalContext.setInfo(code: Integer; value: Pointer): Pointer;
begin
  Result := ExternalContextVTable(vTable).setInfo(Self, code, value);
end;

function ExternalResultSet.fetch(Status: Status): Boolean;
begin
  Result := ExternalResultSetVTable(vTable).fetch(Self, Status);
end;

procedure ExternalFunction.getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal);
begin
  ExternalFunctionVTable(vTable).getCharSet(Self, Status, context, name, nameSize);
end;

procedure ExternalFunction.execute(Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer);
begin
  ExternalFunctionVTable(vTable).execute(Self, Status, context, inMsg, outMsg);
end;

procedure ExternalProcedure.getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal);
begin
  ExternalProcedureVTable(vTable).getCharSet(Self, Status, context, name, nameSize);
end;

function ExternalProcedure.open(Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer): ExternalResultSet;
begin
  Result := ExternalProcedureVTable(vTable).open(Self, Status, context, inMsg, outMsg);
end;

procedure ExternalTrigger.getCharSet(Status: Status; context: ExternalContext; name: PAnsiChar; nameSize: Cardinal);
begin
  ExternalTriggerVTable(vTable).getCharSet(Self, Status, context, name, nameSize);
end;

procedure ExternalTrigger.execute(Status: Status; context: ExternalContext; action: Cardinal; oldMsg: Pointer; newMsg: Pointer);
begin
  ExternalTriggerVTable(vTable).execute(Self, Status, context, action, oldMsg, newMsg);
end;

function RoutineMetadata.getPackage(Status: Status): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getPackage(Self, Status);
end;

function RoutineMetadata.getName(Status: Status): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getName(Self, Status);
end;

function RoutineMetadata.getEntryPoint(Status: Status): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getEntryPoint(Self, Status);
end;

function RoutineMetadata.getBody(Status: Status): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getBody(Self, Status);
end;

function RoutineMetadata.getInputMetadata(Status: Status): MessageMetadata;
begin
  Result := RoutineMetadataVTable(vTable).getInputMetadata(Self, Status);
end;

function RoutineMetadata.getOutputMetadata(Status: Status): MessageMetadata;
begin
  Result := RoutineMetadataVTable(vTable).getOutputMetadata(Self, Status);
end;

function RoutineMetadata.getTriggerMetadata(Status: Status): MessageMetadata;
begin
  Result := RoutineMetadataVTable(vTable).getTriggerMetadata(Self, Status);
end;

function RoutineMetadata.getTriggerTable(Status: Status): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getTriggerTable(Self, Status);
end;

function RoutineMetadata.getTriggerType(Status: Status): Cardinal;
begin
  Result := RoutineMetadataVTable(vTable).getTriggerType(Self, Status);
end;

procedure ExternalEngine.open(Status: Status; context: ExternalContext; charSet: PAnsiChar; charSetSize: Cardinal);
begin
  ExternalEngineVTable(vTable).open(Self, Status, context, charSet, charSetSize);
end;

procedure ExternalEngine.openAttachment(Status: Status; context: ExternalContext);
begin
  ExternalEngineVTable(vTable).openAttachment(Self, Status, context);
end;

procedure ExternalEngine.closeAttachment(Status: Status; context: ExternalContext);
begin
  ExternalEngineVTable(vTable).closeAttachment(Self, Status, context);
end;

function ExternalEngine.makeFunction(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
  outBuilder: MetadataBuilder): ExternalFunction;
begin
  Result := ExternalEngineVTable(vTable).makeFunction(Self, Status, context, metadata, inBuilder, outBuilder);
end;

function ExternalEngine.makeProcedure(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
  outBuilder: MetadataBuilder): ExternalProcedure;
begin
  Result := ExternalEngineVTable(vTable).makeProcedure(Self, Status, context, metadata, inBuilder, outBuilder);
end;

function ExternalEngine.makeTrigger(Status: Status; context: ExternalContext; metadata: RoutineMetadata; fieldsBuilder: MetadataBuilder)
  : ExternalTrigger;
begin
  Result := ExternalEngineVTable(vTable).makeTrigger(Self, Status, context, metadata, fieldsBuilder);
end;

procedure Timer.handler();
begin
  TimerVTable(vTable).handler(Self);
end;

procedure TimerControl.start(Status: Status; Timer: Timer; microSeconds: QWord);
begin
  TimerControlVTable(vTable).start(Self, Status, Timer, microSeconds);
end;

procedure TimerControl.stop(Status: Status; Timer: Timer);
begin
  TimerControlVTable(vTable).stop(Self, Status, Timer);
end;

procedure VersionCallback.callback(Status: Status; text: PAnsiChar);
begin
  VersionCallbackVTable(vTable).callback(Self, Status, text);
end;

procedure Util.getFbVersion(Status: Status; att: Attachment; callback: VersionCallback);
begin
  UtilVTable(vTable).getFbVersion(Self, Status, att, callback);
end;

procedure Util.loadBlob(Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar; txt: Boolean);
begin
  UtilVTable(vTable).loadBlob(Self, Status, blobId, att, tra, file_, txt);
end;

procedure Util.dumpBlob(Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar; txt: Boolean);
begin
  UtilVTable(vTable).dumpBlob(Self, Status, blobId, att, tra, file_, txt);
end;

procedure Util.getPerfCounters(Status: Status; att: Attachment; countersSet: PAnsiChar; counters: Int64Ptr);
begin
  UtilVTable(vTable).getPerfCounters(Self, Status, att, countersSet, counters);
end;

function Util.executeCreateDatabase(Status: Status; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal; stmtIsCreateDb: BooleanPtr)
  : Attachment;
begin
  Result := UtilVTable(vTable).executeCreateDatabase(Self, Status, stmtLength, creatDBstatement, dialect, stmtIsCreateDb);
end;

procedure Util.decodeDate(date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr);
begin
  UtilVTable(vTable).decodeDate(Self, date, year, month, day);
end;

procedure Util.decodeTime(time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr);
begin
  UtilVTable(vTable).decodeTime(Self, time, hours, minutes, seconds, fractions);
end;

function Util.encodeDate(year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE;
begin
  Result := UtilVTable(vTable).encodeDate(Self, year, month, day);
end;

function Util.encodeTime(hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME;
begin
  Result := UtilVTable(vTable).encodeTime(Self, hours, minutes, seconds, fractions);
end;

function Util.formatStatus(buffer: PAnsiChar; bufferSize: Cardinal; Status: Status): Cardinal;
begin
  Result := UtilVTable(vTable).formatStatus(Self, buffer, bufferSize, Status);
end;

function Util.getClientVersion(): Cardinal;
begin
  Result := UtilVTable(vTable).getClientVersion(Self);
end;

function Util.getXpbBuilder(Status: Status; kind: Cardinal; buf: BytePtr; len: Cardinal): XpbBuilder;
begin
  Result := UtilVTable(vTable).getXpbBuilder(Self, Status, kind, buf, len);
end;

function Util.setOffsets(Status: Status; metadata: MessageMetadata; callback: OffsetsCallback): Cardinal;
begin
  Result := UtilVTable(vTable).setOffsets(Self, Status, metadata, callback);
end;

function Util.getDecFloat16(Status: Status): DecFloat16;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := UtilVTable(vTable).getDecFloat16(Self, Status);
  end;
end;

function Util.getDecFloat34(Status: Status): DecFloat34;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := UtilVTable(vTable).getDecFloat34(Self, Status);
  end;
end;

procedure Util.decodeTimeTz(Status: Status; timeTz: ISC_TIME_TZPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
  fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar);
begin
  if (vTable.version < 3) then
  begin
  end
  else
  begin
    UtilVTable(vTable).decodeTimeTz(Self, Status, timeTz, hours, minutes, seconds, fractions, timeZoneBufferLength, timeZoneBuffer);
  end;
end;

procedure Util.decodeTimeStampTz(Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr;
  hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar);
begin
  if (vTable.version < 3) then
  begin
  end
  else
  begin
    UtilVTable(vTable).decodeTimeStampTz(Self, Status, timeStampTz, year, month, day, hours, minutes, seconds, fractions, timeZoneBufferLength,
      timeZoneBuffer);
  end;
end;

procedure Util.encodeTimeTz(Status: Status; timeTz: ISC_TIME_TZPtr; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal;
  timeZone: PAnsiChar);
begin
  if (vTable.version < 3) then
  begin
  end
  else
  begin
    UtilVTable(vTable).encodeTimeTz(Self, Status, timeTz, hours, minutes, seconds, fractions, timeZone);
  end;
end;

procedure Util.encodeTimeStampTz(Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: Cardinal; month: Cardinal; day: Cardinal; hours: Cardinal;
  minutes: Cardinal; seconds: Cardinal; fractions: Cardinal; timeZone: PAnsiChar);
begin
  if (vTable.version < 3) then
  begin
  end
  else
  begin
    UtilVTable(vTable).encodeTimeStampTz(Self, Status, timeStampTz, year, month, day, hours, minutes, seconds, fractions, timeZone);
  end;
end;

function Util.getInt128(Status: Status): Int128;
begin
  if (vTable.version < 4) then
  begin
    Result := nil;
  end
  else
  begin
    Result := UtilVTable(vTable).getInt128(Self, Status);
  end;
end;

procedure Util.decodeTimeTzEx(Status: Status; timeTz: ISC_TIME_TZ_EXPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
  fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    UtilVTable(vTable).decodeTimeTzEx(Self, Status, timeTz, hours, minutes, seconds, fractions, timeZoneBufferLength, timeZoneBuffer);
  end;
end;

procedure Util.decodeTimeStampTzEx(Status: Status; timeStampTz: ISC_TIMESTAMP_TZ_EXPtr; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr;
  hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar);
begin
  if (vTable.version < 4) then
  begin
  end
  else
  begin
    UtilVTable(vTable).decodeTimeStampTzEx(Self, Status, timeStampTz, year, month, day, hours, minutes, seconds, fractions, timeZoneBufferLength,
      timeZoneBuffer);
  end;
end;

procedure OffsetsCallback.setOffset(Status: Status; index: Cardinal; offset: Cardinal; nullOffset: Cardinal);
begin
  OffsetsCallbackVTable(vTable).setOffset(Self, Status, index, offset, nullOffset);
end;

procedure XpbBuilder.clear(Status: Status);
begin
  XpbBuilderVTable(vTable).clear(Self, Status);
end;

procedure XpbBuilder.removeCurrent(Status: Status);
begin
  XpbBuilderVTable(vTable).removeCurrent(Self, Status);
end;

procedure XpbBuilder.insertInt(Status: Status; tag: Byte; value: Integer);
begin
  XpbBuilderVTable(vTable).insertInt(Self, Status, tag, value);
end;

procedure XpbBuilder.insertBigInt(Status: Status; tag: Byte; value: Int64);
begin
  XpbBuilderVTable(vTable).insertBigInt(Self, Status, tag, value);
end;

procedure XpbBuilder.insertBytes(Status: Status; tag: Byte; bytes: Pointer; length: Cardinal);
begin
  XpbBuilderVTable(vTable).insertBytes(Self, Status, tag, bytes, length);
end;

procedure XpbBuilder.insertString(Status: Status; tag: Byte; str: PAnsiChar);
begin
  XpbBuilderVTable(vTable).insertString(Self, Status, tag, str);
end;

procedure XpbBuilder.insertTag(Status: Status; tag: Byte);
begin
  XpbBuilderVTable(vTable).insertTag(Self, Status, tag);
end;

function XpbBuilder.isEof(Status: Status): Boolean;
begin
  Result := XpbBuilderVTable(vTable).isEof(Self, Status);
end;

procedure XpbBuilder.moveNext(Status: Status);
begin
  XpbBuilderVTable(vTable).moveNext(Self, Status);
end;

procedure XpbBuilder.rewind(Status: Status);
begin
  XpbBuilderVTable(vTable).rewind(Self, Status);
end;

function XpbBuilder.findFirst(Status: Status; tag: Byte): Boolean;
begin
  Result := XpbBuilderVTable(vTable).findFirst(Self, Status, tag);
end;

function XpbBuilder.findNext(Status: Status): Boolean;
begin
  Result := XpbBuilderVTable(vTable).findNext(Self, Status);
end;

function XpbBuilder.getTag(Status: Status): Byte;
begin
  Result := XpbBuilderVTable(vTable).getTag(Self, Status);
end;

function XpbBuilder.getLength(Status: Status): Cardinal;
begin
  Result := XpbBuilderVTable(vTable).getLength(Self, Status);
end;

function XpbBuilder.getInt(Status: Status): Integer;
begin
  Result := XpbBuilderVTable(vTable).getInt(Self, Status);
end;

function XpbBuilder.getBigInt(Status: Status): Int64;
begin
  Result := XpbBuilderVTable(vTable).getBigInt(Self, Status);
end;

function XpbBuilder.getString(Status: Status): PAnsiChar;
begin
  Result := XpbBuilderVTable(vTable).getString(Self, Status);
end;

function XpbBuilder.getBytes(Status: Status): BytePtr;
begin
  Result := XpbBuilderVTable(vTable).getBytes(Self, Status);
end;

function XpbBuilder.getBufferLength(Status: Status): Cardinal;
begin
  Result := XpbBuilderVTable(vTable).getBufferLength(Self, Status);
end;

function XpbBuilder.getBuffer(Status: Status): BytePtr;
begin
  Result := XpbBuilderVTable(vTable).getBuffer(Self, Status);
end;

function TraceConnection.getKind(): Cardinal;
begin
  Result := TraceConnectionVTable(vTable).getKind(Self);
end;

function TraceConnection.getProcessID(): Integer;
begin
  Result := TraceConnectionVTable(vTable).getProcessID(Self);
end;

function TraceConnection.getUserName(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getUserName(Self);
end;

function TraceConnection.getRoleName(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRoleName(Self);
end;

function TraceConnection.getCharSet(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getCharSet(Self);
end;

function TraceConnection.getRemoteProtocol(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRemoteProtocol(Self);
end;

function TraceConnection.getRemoteAddress(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRemoteAddress(Self);
end;

function TraceConnection.getRemoteProcessID(): Integer;
begin
  Result := TraceConnectionVTable(vTable).getRemoteProcessID(Self);
end;

function TraceConnection.getRemoteProcessName(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRemoteProcessName(Self);
end;

function TraceDatabaseConnection.getConnectionID(): Int64;
begin
  Result := TraceDatabaseConnectionVTable(vTable).getConnectionID(Self);
end;

function TraceDatabaseConnection.getDatabaseName(): PAnsiChar;
begin
  Result := TraceDatabaseConnectionVTable(vTable).getDatabaseName(Self);
end;

function TraceTransaction.getTransactionID(): Int64;
begin
  Result := TraceTransactionVTable(vTable).getTransactionID(Self);
end;

function TraceTransaction.getReadOnly(): Boolean;
begin
  Result := TraceTransactionVTable(vTable).getReadOnly(Self);
end;

function TraceTransaction.getWait(): Integer;
begin
  Result := TraceTransactionVTable(vTable).getWait(Self);
end;

function TraceTransaction.getIsolation(): Cardinal;
begin
  Result := TraceTransactionVTable(vTable).getIsolation(Self);
end;

function TraceTransaction.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceTransactionVTable(vTable).getPerf(Self);
end;

function TraceTransaction.getInitialID(): Int64;
begin
  if (vTable.version < 3) then
  begin
    Result := 0;
  end
  else
  begin
    Result := TraceTransactionVTable(vTable).getInitialID(Self);
  end;
end;

function TraceTransaction.getPreviousID(): Int64;
begin
  if (vTable.version < 3) then
  begin
    Result := 0;
  end
  else
  begin
    Result := TraceTransactionVTable(vTable).getPreviousID(Self);
  end;
end;

function TraceParams.getCount(): Cardinal;
begin
  Result := TraceParamsVTable(vTable).getCount(Self);
end;

function TraceParams.getParam(idx: Cardinal): dscPtr;
begin
  Result := TraceParamsVTable(vTable).getParam(Self, idx);
end;

function TraceParams.getTextUTF8(Status: Status; idx: Cardinal): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := TraceParamsVTable(vTable).getTextUTF8(Self, Status, idx);
  end;
end;

function TraceStatement.getStmtID(): Int64;
begin
  Result := TraceStatementVTable(vTable).getStmtID(Self);
end;

function TraceStatement.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceStatementVTable(vTable).getPerf(Self);
end;

function TraceSQLStatement.getText(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getText(Self);
end;

function TraceSQLStatement.getPlan(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getPlan(Self);
end;

function TraceSQLStatement.getInputs(): TraceParams;
begin
  Result := TraceSQLStatementVTable(vTable).getInputs(Self);
end;

function TraceSQLStatement.getTextUTF8(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getTextUTF8(Self);
end;

function TraceSQLStatement.getExplainedPlan(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getExplainedPlan(Self);
end;

function TraceBLRStatement.getData(): BytePtr;
begin
  Result := TraceBLRStatementVTable(vTable).getData(Self);
end;

function TraceBLRStatement.getDataLength(): Cardinal;
begin
  Result := TraceBLRStatementVTable(vTable).getDataLength(Self);
end;

function TraceBLRStatement.getText(): PAnsiChar;
begin
  Result := TraceBLRStatementVTable(vTable).getText(Self);
end;

function TraceDYNRequest.getData(): BytePtr;
begin
  Result := TraceDYNRequestVTable(vTable).getData(Self);
end;

function TraceDYNRequest.getDataLength(): Cardinal;
begin
  Result := TraceDYNRequestVTable(vTable).getDataLength(Self);
end;

function TraceDYNRequest.getText(): PAnsiChar;
begin
  Result := TraceDYNRequestVTable(vTable).getText(Self);
end;

function TraceContextVariable.getNameSpace(): PAnsiChar;
begin
  Result := TraceContextVariableVTable(vTable).getNameSpace(Self);
end;

function TraceContextVariable.getVarName(): PAnsiChar;
begin
  Result := TraceContextVariableVTable(vTable).getVarName(Self);
end;

function TraceContextVariable.getVarValue(): PAnsiChar;
begin
  Result := TraceContextVariableVTable(vTable).getVarValue(Self);
end;

function TraceProcedure.getProcName(): PAnsiChar;
begin
  Result := TraceProcedureVTable(vTable).getProcName(Self);
end;

function TraceProcedure.getInputs(): TraceParams;
begin
  Result := TraceProcedureVTable(vTable).getInputs(Self);
end;

function TraceProcedure.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceProcedureVTable(vTable).getPerf(Self);
end;

function TraceProcedure.getStmtID(): Int64;
begin
  if (vTable.version < 3) then
  begin
    Result := 0;
  end
  else
  begin
    Result := TraceProcedureVTable(vTable).getStmtID(Self);
  end;
end;

function TraceProcedure.getPlan(): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := TraceProcedureVTable(vTable).getPlan(Self);
  end;
end;

function TraceProcedure.getExplainedPlan(): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := TraceProcedureVTable(vTable).getExplainedPlan(Self);
  end;
end;

function TraceFunction.getFuncName(): PAnsiChar;
begin
  Result := TraceFunctionVTable(vTable).getFuncName(Self);
end;

function TraceFunction.getInputs(): TraceParams;
begin
  Result := TraceFunctionVTable(vTable).getInputs(Self);
end;

function TraceFunction.getResult(): TraceParams;
begin
  Result := TraceFunctionVTable(vTable).getResult(Self);
end;

function TraceFunction.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceFunctionVTable(vTable).getPerf(Self);
end;

function TraceFunction.getStmtID(): Int64;
begin
  if (vTable.version < 3) then
  begin
    Result := 0;
  end
  else
  begin
    Result := TraceFunctionVTable(vTable).getStmtID(Self);
  end;
end;

function TraceFunction.getPlan(): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := TraceFunctionVTable(vTable).getPlan(Self);
  end;
end;

function TraceFunction.getExplainedPlan(): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := TraceFunctionVTable(vTable).getExplainedPlan(Self);
  end;
end;

function TraceTrigger.getTriggerName(): PAnsiChar;
begin
  Result := TraceTriggerVTable(vTable).getTriggerName(Self);
end;

function TraceTrigger.getRelationName(): PAnsiChar;
begin
  Result := TraceTriggerVTable(vTable).getRelationName(Self);
end;

function TraceTrigger.getAction(): Integer;
begin
  Result := TraceTriggerVTable(vTable).getAction(Self);
end;

function TraceTrigger.getWhich(): Integer;
begin
  Result := TraceTriggerVTable(vTable).getWhich(Self);
end;

function TraceTrigger.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceTriggerVTable(vTable).getPerf(Self);
end;

function TraceTrigger.getStmtID(): Int64;
begin
  if (vTable.version < 3) then
  begin
    Result := 0;
  end
  else
  begin
    Result := TraceTriggerVTable(vTable).getStmtID(Self);
  end;
end;

function TraceTrigger.getPlan(): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := TraceTriggerVTable(vTable).getPlan(Self);
  end;
end;

function TraceTrigger.getExplainedPlan(): PAnsiChar;
begin
  if (vTable.version < 3) then
  begin
    Result := nil;
  end
  else
  begin
    Result := TraceTriggerVTable(vTable).getExplainedPlan(Self);
  end;
end;

function TraceServiceConnection.getServiceID(): Pointer;
begin
  Result := TraceServiceConnectionVTable(vTable).getServiceID(Self);
end;

function TraceServiceConnection.getServiceMgr(): PAnsiChar;
begin
  Result := TraceServiceConnectionVTable(vTable).getServiceMgr(Self);
end;

function TraceServiceConnection.getServiceName(): PAnsiChar;
begin
  Result := TraceServiceConnectionVTable(vTable).getServiceName(Self);
end;

function TraceStatusVector.hasError(): Boolean;
begin
  Result := TraceStatusVectorVTable(vTable).hasError(Self);
end;

function TraceStatusVector.hasWarning(): Boolean;
begin
  Result := TraceStatusVectorVTable(vTable).hasWarning(Self);
end;

function TraceStatusVector.getStatus(): Status;
begin
  Result := TraceStatusVectorVTable(vTable).getStatus(Self);
end;

function TraceStatusVector.getText(): PAnsiChar;
begin
  Result := TraceStatusVectorVTable(vTable).getText(Self);
end;

function TraceSweepInfo.getOIT(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getOIT(Self);
end;

function TraceSweepInfo.getOST(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getOST(Self);
end;

function TraceSweepInfo.getOAT(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getOAT(Self);
end;

function TraceSweepInfo.getNext(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getNext(Self);
end;

function TraceSweepInfo.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceSweepInfoVTable(vTable).getPerf(Self);
end;

function TraceLogWriter.write(buf: Pointer; size: Cardinal): Cardinal;
begin
  Result := TraceLogWriterVTable(vTable).write(Self, buf, size);
end;

function TraceLogWriter.write_s(Status: Status; buf: Pointer; size: Cardinal): Cardinal;
begin
  if (vTable.version < 4) then
  begin
    Result := 0;
  end
  else
  begin
    Result := TraceLogWriterVTable(vTable).write_s(Self, Status, buf, size);
  end;
end;

function TraceInitInfo.getConfigText(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getConfigText(Self);
end;

function TraceInitInfo.getTraceSessionID(): Integer;
begin
  Result := TraceInitInfoVTable(vTable).getTraceSessionID(Self);
end;

function TraceInitInfo.getTraceSessionName(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getTraceSessionName(Self);
end;

function TraceInitInfo.getFirebirdRootDirectory(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getFirebirdRootDirectory(Self);
end;

function TraceInitInfo.getDatabaseName(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getDatabaseName(Self);
end;

function TraceInitInfo.getConnection(): TraceDatabaseConnection;
begin
  Result := TraceInitInfoVTable(vTable).getConnection(Self);
end;

function TraceInitInfo.getLogWriter(): TraceLogWriter;
begin
  Result := TraceInitInfoVTable(vTable).getLogWriter(Self);
end;

function TracePlugin.trace_get_error(): PAnsiChar;
begin
  Result := TracePluginVTable(vTable).trace_get_error(Self);
end;

function TracePlugin.trace_attach(connection: TraceDatabaseConnection; create_db: Boolean; att_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_attach(Self, connection, create_db, att_result);
end;

function TracePlugin.trace_detach(connection: TraceDatabaseConnection; drop_db: Boolean): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_detach(Self, connection, drop_db);
end;

function TracePlugin.trace_transaction_start(connection: TraceDatabaseConnection; Transaction: TraceTransaction; tpb_length: Cardinal; tpb: BytePtr;
  tra_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_transaction_start(Self, connection, Transaction, tpb_length, tpb, tra_result);
end;

function TracePlugin.trace_transaction_end(connection: TraceDatabaseConnection; Transaction: TraceTransaction; commit: Boolean;
  retain_context: Boolean; tra_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_transaction_end(Self, connection, Transaction, commit, retain_context, tra_result);
end;

function TracePlugin.trace_proc_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; procedure_: TraceProcedure;
  started: Boolean; proc_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_proc_execute(Self, connection, Transaction, procedure_, started, proc_result);
end;

function TracePlugin.trace_trigger_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; trigger: TraceTrigger;
  started: Boolean; trig_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_trigger_execute(Self, connection, Transaction, trigger, started, trig_result);
end;

function TracePlugin.trace_set_context(connection: TraceDatabaseConnection; Transaction: TraceTransaction; variable: TraceContextVariable): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_set_context(Self, connection, Transaction, variable);
end;

function TracePlugin.trace_dsql_prepare(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement;
  time_millis: Int64; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dsql_prepare(Self, connection, Transaction, Statement, time_millis, req_result);
end;

function TracePlugin.trace_dsql_free(connection: TraceDatabaseConnection; Statement: TraceSQLStatement; option: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dsql_free(Self, connection, Statement, option);
end;

function TracePlugin.trace_dsql_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement;
  started: Boolean; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dsql_execute(Self, connection, Transaction, Statement, started, req_result);
end;

function TracePlugin.trace_blr_compile(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceBLRStatement;
  time_millis: Int64; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_blr_compile(Self, connection, Transaction, Statement, time_millis, req_result);
end;

function TracePlugin.trace_blr_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceBLRStatement;
  req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_blr_execute(Self, connection, Transaction, Statement, req_result);
end;

function TracePlugin.trace_dyn_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Request: TraceDYNRequest;
  time_millis: Int64; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dyn_execute(Self, connection, Transaction, Request, time_millis, req_result);
end;

function TracePlugin.trace_service_attach(Service: TraceServiceConnection; att_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_attach(Self, Service, att_result);
end;

function TracePlugin.trace_service_start(Service: TraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar;
  start_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_start(Self, Service, switches_length, switches, start_result);
end;

function TracePlugin.trace_service_query(Service: TraceServiceConnection; send_item_length: Cardinal; send_items: BytePtr; recv_item_length: Cardinal;
  recv_items: BytePtr; query_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_query(Self, Service, send_item_length, send_items, recv_item_length, recv_items, query_result);
end;

function TracePlugin.trace_service_detach(Service: TraceServiceConnection; detach_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_detach(Self, Service, detach_result);
end;

function TracePlugin.trace_event_error(connection: TraceConnection; Status: TraceStatusVector; function_: PAnsiChar): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_event_error(Self, connection, Status, function_);
end;

function TracePlugin.trace_event_sweep(connection: TraceDatabaseConnection; sweep: TraceSweepInfo; sweep_state: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_event_sweep(Self, connection, sweep, sweep_state);
end;

function TracePlugin.trace_func_execute(connection: TraceDatabaseConnection; Transaction: TraceTransaction; function_: TraceFunction;
  started: Boolean; func_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_func_execute(Self, connection, Transaction, function_, started, func_result);
end;

function TracePlugin.trace_dsql_restart(connection: TraceDatabaseConnection; Transaction: TraceTransaction; Statement: TraceSQLStatement;
  number: Cardinal): Boolean;
begin
  if (vTable.version < 4) then
  begin
    Result := FALSE;
  end
  else
  begin
    Result := TracePluginVTable(vTable).trace_dsql_restart(Self, connection, Transaction, Statement, number);
  end;
end;

function TracePlugin.trace_proc_compile(connection: TraceDatabaseConnection; procedure_: TraceProcedure; time_millis: Int64;
  proc_result: Cardinal): Boolean;
begin
  if (vTable.version < 5) then
  begin
    Result := FALSE;
  end
  else
  begin
    Result := TracePluginVTable(vTable).trace_proc_compile(Self, connection, procedure_, time_millis, proc_result);
  end;
end;

function TracePlugin.trace_func_compile(connection: TraceDatabaseConnection; function_: TraceFunction; time_millis: Int64;
  func_result: Cardinal): Boolean;
begin
  if (vTable.version < 5) then
  begin
    Result := FALSE;
  end
  else
  begin
    Result := TracePluginVTable(vTable).trace_func_compile(Self, connection, function_, time_millis, func_result);
  end;
end;

function TracePlugin.trace_trigger_compile(connection: TraceDatabaseConnection; trigger: TraceTrigger; time_millis: Int64;
  trig_result: Cardinal): Boolean;
begin
  if (vTable.version < 5) then
  begin
    Result := FALSE;
  end
  else
  begin
    Result := TracePluginVTable(vTable).trace_trigger_compile(Self, connection, trigger, time_millis, trig_result);
  end;
end;

function TraceFactory.trace_needs(): QWord;
begin
  Result := TraceFactoryVTable(vTable).trace_needs(Self);
end;

function TraceFactory.trace_create(Status: Status; init_info: TraceInitInfo): TracePlugin;
begin
  Result := TraceFactoryVTable(vTable).trace_create(Self, Status, init_info);
end;

procedure UdrFunctionFactory.setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
  outBuilder: MetadataBuilder);
begin
  UdrFunctionFactoryVTable(vTable).setup(Self, Status, context, metadata, inBuilder, outBuilder);
end;

function UdrFunctionFactory.newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalFunction;
begin
  Result := UdrFunctionFactoryVTable(vTable).newItem(Self, Status, context, metadata);
end;

procedure UdrProcedureFactory.setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; inBuilder: MetadataBuilder;
  outBuilder: MetadataBuilder);
begin
  UdrProcedureFactoryVTable(vTable).setup(Self, Status, context, metadata, inBuilder, outBuilder);
end;

function UdrProcedureFactory.newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalProcedure;
begin
  Result := UdrProcedureFactoryVTable(vTable).newItem(Self, Status, context, metadata);
end;

procedure UdrTriggerFactory.setup(Status: Status; context: ExternalContext; metadata: RoutineMetadata; fieldsBuilder: MetadataBuilder);
begin
  UdrTriggerFactoryVTable(vTable).setup(Self, Status, context, metadata, fieldsBuilder);
end;

function UdrTriggerFactory.newItem(Status: Status; context: ExternalContext; metadata: RoutineMetadata): ExternalTrigger;
begin
  Result := UdrTriggerFactoryVTable(vTable).newItem(Self, Status, context, metadata);
end;

function UdrPlugin.getMaster(): Master;
begin
  Result := UdrPluginVTable(vTable).getMaster(Self);
end;

procedure UdrPlugin.registerFunction(Status: Status; name: PAnsiChar; factory: UdrFunctionFactory);
begin
  UdrPluginVTable(vTable).registerFunction(Self, Status, name, factory);
end;

procedure UdrPlugin.registerProcedure(Status: Status; name: PAnsiChar; factory: UdrProcedureFactory);
begin
  UdrPluginVTable(vTable).registerProcedure(Self, Status, name, factory);
end;

procedure UdrPlugin.registerTrigger(Status: Status; name: PAnsiChar; factory: UdrTriggerFactory);
begin
  UdrPluginVTable(vTable).registerTrigger(Self, Status, name, factory);
end;

procedure DecFloat16.toBcd(from: FB_DEC16Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr);
begin
  DecFloat16VTable(vTable).toBcd(Self, from, sign, bcd, exp);
end;

procedure DecFloat16.toString(Status: Status; from: FB_DEC16Ptr; bufferLength: Cardinal; buffer: PAnsiChar);
begin
  DecFloat16VTable(vTable).toString(Self, Status, from, bufferLength, buffer);
end;

procedure DecFloat16.fromBcd(sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC16Ptr);
begin
  DecFloat16VTable(vTable).fromBcd(Self, sign, bcd, exp, to_);
end;

procedure DecFloat16.fromString(Status: Status; from: PAnsiChar; to_: FB_DEC16Ptr);
begin
  DecFloat16VTable(vTable).fromString(Self, Status, from, to_);
end;

procedure DecFloat34.toBcd(from: FB_DEC34Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr);
begin
  DecFloat34VTable(vTable).toBcd(Self, from, sign, bcd, exp);
end;

procedure DecFloat34.toString(Status: Status; from: FB_DEC34Ptr; bufferLength: Cardinal; buffer: PAnsiChar);
begin
  DecFloat34VTable(vTable).toString(Self, Status, from, bufferLength, buffer);
end;

procedure DecFloat34.fromBcd(sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC34Ptr);
begin
  DecFloat34VTable(vTable).fromBcd(Self, sign, bcd, exp, to_);
end;

procedure DecFloat34.fromString(Status: Status; from: PAnsiChar; to_: FB_DEC34Ptr);
begin
  DecFloat34VTable(vTable).fromString(Self, Status, from, to_);
end;

procedure Int128.toString(Status: Status; from: FB_I128Ptr; scale: Integer; bufferLength: Cardinal; buffer: PAnsiChar);
begin
  Int128VTable(vTable).toString(Self, Status, from, scale, bufferLength, buffer);
end;

procedure Int128.fromString(Status: Status; scale: Integer; from: PAnsiChar; to_: FB_I128Ptr);
begin
  Int128VTable(vTable).fromString(Self, Status, scale, from, to_);
end;

function ReplicatedField.getName(): PAnsiChar;
begin
  Result := ReplicatedFieldVTable(vTable).getName(Self);
end;

function ReplicatedField.getType(): Cardinal;
begin
  Result := ReplicatedFieldVTable(vTable).getType(Self);
end;

function ReplicatedField.getSubType(): Integer;
begin
  Result := ReplicatedFieldVTable(vTable).getSubType(Self);
end;

function ReplicatedField.getScale(): Integer;
begin
  Result := ReplicatedFieldVTable(vTable).getScale(Self);
end;

function ReplicatedField.getLength(): Cardinal;
begin
  Result := ReplicatedFieldVTable(vTable).getLength(Self);
end;

function ReplicatedField.getCharSet(): Cardinal;
begin
  Result := ReplicatedFieldVTable(vTable).getCharSet(Self);
end;

function ReplicatedField.getData(): Pointer;
begin
  Result := ReplicatedFieldVTable(vTable).getData(Self);
end;

function ReplicatedRecord.getCount(): Cardinal;
begin
  Result := ReplicatedRecordVTable(vTable).getCount(Self);
end;

function ReplicatedRecord.getField(index: Cardinal): ReplicatedField;
begin
  Result := ReplicatedRecordVTable(vTable).getField(Self, index);
end;

function ReplicatedRecord.getRawLength(): Cardinal;
begin
  Result := ReplicatedRecordVTable(vTable).getRawLength(Self);
end;

function ReplicatedRecord.getRawData(): BytePtr;
begin
  Result := ReplicatedRecordVTable(vTable).getRawData(Self);
end;

procedure ReplicatedTransaction.prepare(Status: Status);
begin
  ReplicatedTransactionVTable(vTable).prepare(Self, Status);
end;

procedure ReplicatedTransaction.commit(Status: Status);
begin
  ReplicatedTransactionVTable(vTable).commit(Self, Status);
end;

procedure ReplicatedTransaction.rollback(Status: Status);
begin
  ReplicatedTransactionVTable(vTable).rollback(Self, Status);
end;

procedure ReplicatedTransaction.startSavepoint(Status: Status);
begin
  ReplicatedTransactionVTable(vTable).startSavepoint(Self, Status);
end;

procedure ReplicatedTransaction.releaseSavepoint(Status: Status);
begin
  ReplicatedTransactionVTable(vTable).releaseSavepoint(Self, Status);
end;

procedure ReplicatedTransaction.rollbackSavepoint(Status: Status);
begin
  ReplicatedTransactionVTable(vTable).rollbackSavepoint(Self, Status);
end;

procedure ReplicatedTransaction.insertRecord(Status: Status; name: PAnsiChar; record_: ReplicatedRecord);
begin
  ReplicatedTransactionVTable(vTable).insertRecord(Self, Status, name, record_);
end;

procedure ReplicatedTransaction.updateRecord(Status: Status; name: PAnsiChar; orgRecord: ReplicatedRecord; newRecord: ReplicatedRecord);
begin
  ReplicatedTransactionVTable(vTable).updateRecord(Self, Status, name, orgRecord, newRecord);
end;

procedure ReplicatedTransaction.deleteRecord(Status: Status; name: PAnsiChar; record_: ReplicatedRecord);
begin
  ReplicatedTransactionVTable(vTable).deleteRecord(Self, Status, name, record_);
end;

procedure ReplicatedTransaction.executeSql(Status: Status; sql: PAnsiChar);
begin
  ReplicatedTransactionVTable(vTable).executeSql(Self, Status, sql);
end;

procedure ReplicatedTransaction.executeSqlIntl(Status: Status; charSet: Cardinal; sql: PAnsiChar);
begin
  ReplicatedTransactionVTable(vTable).executeSqlIntl(Self, Status, charSet, sql);
end;

function ReplicatedSession.init(Status: Status; Attachment: Attachment): Boolean;
begin
  Result := ReplicatedSessionVTable(vTable).init(Self, Status, Attachment);
end;

function ReplicatedSession.startTransaction(Status: Status; Transaction: Transaction; number: Int64): ReplicatedTransaction;
begin
  Result := ReplicatedSessionVTable(vTable).startTransaction(Self, Status, Transaction, number);
end;

procedure ReplicatedSession.cleanupTransaction(Status: Status; number: Int64);
begin
  ReplicatedSessionVTable(vTable).cleanupTransaction(Self, Status, number);
end;

procedure ReplicatedSession.setSequence(Status: Status; name: PAnsiChar; value: Int64);
begin
  ReplicatedSessionVTable(vTable).setSequence(Self, Status, name, value);
end;

procedure ProfilerPlugin.init(Status: Status; Attachment: Attachment; ticksFrequency: QWord);
begin
  ProfilerPluginVTable(vTable).init(Self, Status, Attachment, ticksFrequency);
end;

function ProfilerPlugin.startSession(Status: Status; description: PAnsiChar; options: PAnsiChar; timestamp: ISC_TIMESTAMP_TZ): ProfilerSession;
begin
  Result := ProfilerPluginVTable(vTable).startSession(Self, Status, description, options, timestamp);
end;

procedure ProfilerPlugin.flush(Status: Status);
begin
  ProfilerPluginVTable(vTable).flush(Self, Status);
end;

function ProfilerSession.getId(): Int64;
begin
  Result := ProfilerSessionVTable(vTable).getId(Self);
end;

function ProfilerSession.getFlags(): Cardinal;
begin
  Result := ProfilerSessionVTable(vTable).getFlags(Self);
end;

procedure ProfilerSession.cancel(Status: Status);
begin
  ProfilerSessionVTable(vTable).cancel(Self, Status);
end;

procedure ProfilerSession.finish(Status: Status; timestamp: ISC_TIMESTAMP_TZ);
begin
  ProfilerSessionVTable(vTable).finish(Self, Status, timestamp);
end;

procedure ProfilerSession.defineStatement(Status: Status; statementId: Int64; parentStatementId: Int64; type_: PAnsiChar; packageName: PAnsiChar;
  routineName: PAnsiChar; sqlText: PAnsiChar);
begin
  ProfilerSessionVTable(vTable).defineStatement(Self, Status, statementId, parentStatementId, type_, packageName, routineName, sqlText);
end;

procedure ProfilerSession.defineCursor(statementId: Int64; cursorId: Cardinal; name: PAnsiChar; line: Cardinal; column: Cardinal);
begin
  ProfilerSessionVTable(vTable).defineCursor(Self, statementId, cursorId, name, line, column);
end;

procedure ProfilerSession.defineRecordSource(statementId: Int64; cursorId: Cardinal; recSourceId: Cardinal; level: Cardinal; accessPath: PAnsiChar;
  parentRecSourceId: Cardinal);
begin
  ProfilerSessionVTable(vTable).defineRecordSource(Self, statementId, cursorId, recSourceId, level, accessPath, parentRecSourceId);
end;

procedure ProfilerSession.onRequestStart(Status: Status; statementId: Int64; requestId: Int64; callerStatementId: Int64; callerRequestId: Int64;
  timestamp: ISC_TIMESTAMP_TZ);
begin
  ProfilerSessionVTable(vTable).onRequestStart(Self, Status, statementId, requestId, callerStatementId, callerRequestId, timestamp);
end;

procedure ProfilerSession.onRequestFinish(Status: Status; statementId: Int64; requestId: Int64; timestamp: ISC_TIMESTAMP_TZ; stats: ProfilerStats);
begin
  ProfilerSessionVTable(vTable).onRequestFinish(Self, Status, statementId, requestId, timestamp, stats);
end;

procedure ProfilerSession.beforePsqlLineColumn(statementId: Int64; requestId: Int64; line: Cardinal; column: Cardinal);
begin
  ProfilerSessionVTable(vTable).beforePsqlLineColumn(Self, statementId, requestId, line, column);
end;

procedure ProfilerSession.afterPsqlLineColumn(statementId: Int64; requestId: Int64; line: Cardinal; column: Cardinal; stats: ProfilerStats);
begin
  ProfilerSessionVTable(vTable).afterPsqlLineColumn(Self, statementId, requestId, line, column, stats);
end;

procedure ProfilerSession.beforeRecordSourceOpen(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal);
begin
  ProfilerSessionVTable(vTable).beforeRecordSourceOpen(Self, statementId, requestId, cursorId, recSourceId);
end;

procedure ProfilerSession.afterRecordSourceOpen(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal;
  stats: ProfilerStats);
begin
  ProfilerSessionVTable(vTable).afterRecordSourceOpen(Self, statementId, requestId, cursorId, recSourceId, stats);
end;

procedure ProfilerSession.beforeRecordSourceGetRecord(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal);
begin
  ProfilerSessionVTable(vTable).beforeRecordSourceGetRecord(Self, statementId, requestId, cursorId, recSourceId);
end;

procedure ProfilerSession.afterRecordSourceGetRecord(statementId: Int64; requestId: Int64; cursorId: Cardinal; recSourceId: Cardinal;
  stats: ProfilerStats);
begin
  ProfilerSessionVTable(vTable).afterRecordSourceGetRecord(Self, statementId, requestId, cursorId, recSourceId, stats);
end;

function ProfilerStats.getElapsedTicks(): QWord;
begin
  Result := ProfilerStatsVTable(vTable).getElapsedTicks(Self);
end;

var
  VersionedImpl_vTable: VersionedVTable;

constructor VersionedImpl.create;
begin
  vTable := VersionedImpl_vTable;
end;

procedure ReferenceCountedImpl_addRefDispatcher(this: ReferenceCounted); cdecl;
begin
  ReferenceCountedImpl(this).addRef();
end;

function ReferenceCountedImpl_releaseDispatcher(this: ReferenceCounted): Integer; cdecl;
begin
  Result := ReferenceCountedImpl(this).release();
end;

var
  ReferenceCountedImpl_vTable: ReferenceCountedVTable;

constructor ReferenceCountedImpl.create;
begin
  vTable := ReferenceCountedImpl_vTable;
end;

procedure DisposableImpl_disposeDispatcher(this: Disposable); cdecl;
begin
  DisposableImpl(this).dispose();
end;

var
  DisposableImpl_vTable: DisposableVTable;

constructor DisposableImpl.create;
begin
  vTable := DisposableImpl_vTable;
end;

procedure StatusImpl_disposeDispatcher(this: Status); cdecl;
begin
  StatusImpl(this).dispose();
end;

procedure StatusImpl_initDispatcher(this: Status); cdecl;
begin
  StatusImpl(this).init();
end;

function StatusImpl_getStateDispatcher(this: Status): Cardinal; cdecl;
begin
  Result := StatusImpl(this).getState();
end;

procedure StatusImpl_setErrors2Dispatcher(this: Status; length: Cardinal; value: NativeIntPtr); cdecl;
begin
  StatusImpl(this).setErrors2(length, value);
end;

procedure StatusImpl_setWarnings2Dispatcher(this: Status; length: Cardinal; value: NativeIntPtr); cdecl;
begin
  StatusImpl(this).setWarnings2(length, value);
end;

procedure StatusImpl_setErrorsDispatcher(this: Status; value: NativeIntPtr); cdecl;
begin
  StatusImpl(this).setErrors(value);
end;

procedure StatusImpl_setWarningsDispatcher(this: Status; value: NativeIntPtr); cdecl;
begin
  StatusImpl(this).setWarnings(value);
end;

function StatusImpl_getErrorsDispatcher(this: Status): NativeIntPtr; cdecl;
begin
  Result := StatusImpl(this).getErrors();
end;

function StatusImpl_getWarningsDispatcher(this: Status): NativeIntPtr; cdecl;
begin
  Result := StatusImpl(this).getWarnings();
end;

function StatusImpl_cloneDispatcher(this: Status): Status; cdecl;
begin
  Result := StatusImpl(this).clone();
end;

var
  StatusImpl_vTable: StatusVTable;

constructor StatusImpl.create;
begin
  vTable := StatusImpl_vTable;
end;

function MasterImpl_getStatusDispatcher(this: Master): Status; cdecl;
begin
  Result := MasterImpl(this).getStatus();
end;

function MasterImpl_getDispatcherDispatcher(this: Master): Provider; cdecl;
begin
  Result := MasterImpl(this).getDispatcher();
end;

function MasterImpl_getPluginManagerDispatcher(this: Master): PluginManager; cdecl;
begin
  Result := MasterImpl(this).getPluginManager();
end;

function MasterImpl_getTimerControlDispatcher(this: Master): TimerControl; cdecl;
begin
  Result := MasterImpl(this).getTimerControl();
end;

function MasterImpl_getDtcDispatcher(this: Master): Dtc; cdecl;
begin
  Result := MasterImpl(this).getDtc();
end;

function MasterImpl_registerAttachmentDispatcher(this: Master; Provider: Provider; Attachment: Attachment): Attachment; cdecl;
begin
  Result := MasterImpl(this).registerAttachment(Provider, Attachment);
end;

function MasterImpl_registerTransactionDispatcher(this: Master; Attachment: Attachment; Transaction: Transaction): Transaction; cdecl;
begin
  Result := MasterImpl(this).registerTransaction(Attachment, Transaction);
end;

function MasterImpl_getMetadataBuilderDispatcher(this: Master; Status: Status; fieldCount: Cardinal): MetadataBuilder; cdecl;
begin
  Result := MasterImpl(this).getMetadataBuilder(Status, fieldCount);
end;

function MasterImpl_serverModeDispatcher(this: Master; mode: Integer): Integer; cdecl;
begin
  Result := MasterImpl(this).serverMode(mode);
end;

function MasterImpl_getUtilInterfaceDispatcher(this: Master): Util; cdecl;
begin
  Result := MasterImpl(this).getUtilInterface();
end;

function MasterImpl_getConfigManagerDispatcher(this: Master): ConfigManager; cdecl;
begin
  Result := MasterImpl(this).getConfigManager();
end;

function MasterImpl_getProcessExitingDispatcher(this: Master): Boolean; cdecl;
begin
  Result := MasterImpl(this).getProcessExiting();
end;

var
  MasterImpl_vTable: MasterVTable;

constructor MasterImpl.create;
begin
  vTable := MasterImpl_vTable;
end;

procedure PluginBaseImpl_addRefDispatcher(this: PluginBase); cdecl;
begin
  PluginBaseImpl(this).addRef();
end;

function PluginBaseImpl_releaseDispatcher(this: PluginBase): Integer; cdecl;
begin
  Result := PluginBaseImpl(this).release();
end;

procedure PluginBaseImpl_setOwnerDispatcher(this: PluginBase; r: ReferenceCounted); cdecl;
begin
  PluginBaseImpl(this).setOwner(r);
end;

function PluginBaseImpl_getOwnerDispatcher(this: PluginBase): ReferenceCounted; cdecl;
begin
  Result := PluginBaseImpl(this).getOwner();
end;

var
  PluginBaseImpl_vTable: PluginBaseVTable;

constructor PluginBaseImpl.create;
begin
  vTable := PluginBaseImpl_vTable;
end;

procedure PluginSetImpl_addRefDispatcher(this: PluginSet); cdecl;
begin
  PluginSetImpl(this).addRef();
end;

function PluginSetImpl_releaseDispatcher(this: PluginSet): Integer; cdecl;
begin
  Result := PluginSetImpl(this).release();
end;

function PluginSetImpl_getNameDispatcher(this: PluginSet): PAnsiChar; cdecl;
begin
  Result := PluginSetImpl(this).getName();
end;

function PluginSetImpl_getModuleNameDispatcher(this: PluginSet): PAnsiChar; cdecl;
begin
  Result := PluginSetImpl(this).getModuleName();
end;

function PluginSetImpl_getPluginDispatcher(this: PluginSet; Status: Status): PluginBase; cdecl;
begin
  Result := PluginSetImpl(this).getPlugin(Status);
end;

procedure PluginSetImpl_nextDispatcher(this: PluginSet; Status: Status); cdecl;
begin
  PluginSetImpl(this).next(Status);
end;

procedure PluginSetImpl_set_Dispatcher(this: PluginSet; Status: Status; s: PAnsiChar); cdecl;
begin
  PluginSetImpl(this).set_(Status, s);
end;

var
  PluginSetImpl_vTable: PluginSetVTable;

constructor PluginSetImpl.create;
begin
  vTable := PluginSetImpl_vTable;
end;

procedure ConfigEntryImpl_addRefDispatcher(this: ConfigEntry); cdecl;
begin
  ConfigEntryImpl(this).addRef();
end;

function ConfigEntryImpl_releaseDispatcher(this: ConfigEntry): Integer; cdecl;
begin
  Result := ConfigEntryImpl(this).release();
end;

function ConfigEntryImpl_getNameDispatcher(this: ConfigEntry): PAnsiChar; cdecl;
begin
  Result := ConfigEntryImpl(this).getName();
end;

function ConfigEntryImpl_getValueDispatcher(this: ConfigEntry): PAnsiChar; cdecl;
begin
  Result := ConfigEntryImpl(this).getValue();
end;

function ConfigEntryImpl_getIntValueDispatcher(this: ConfigEntry): Int64; cdecl;
begin
  Result := ConfigEntryImpl(this).getIntValue();
end;

function ConfigEntryImpl_getBoolValueDispatcher(this: ConfigEntry): Boolean; cdecl;
begin
  Result := ConfigEntryImpl(this).getBoolValue();
end;

function ConfigEntryImpl_getSubConfigDispatcher(this: ConfigEntry; Status: Status): Config; cdecl;
begin
  Result := ConfigEntryImpl(this).getSubConfig(Status);
end;

var
  ConfigEntryImpl_vTable: ConfigEntryVTable;

constructor ConfigEntryImpl.create;
begin
  vTable := ConfigEntryImpl_vTable;
end;

procedure ConfigImpl_addRefDispatcher(this: Config); cdecl;
begin
  ConfigImpl(this).addRef();
end;

function ConfigImpl_releaseDispatcher(this: Config): Integer; cdecl;
begin
  Result := ConfigImpl(this).release();
end;

function ConfigImpl_findDispatcher(this: Config; Status: Status; name: PAnsiChar): ConfigEntry; cdecl;
begin
  Result := ConfigImpl(this).find(Status, name);
end;

function ConfigImpl_findValueDispatcher(this: Config; Status: Status; name: PAnsiChar; value: PAnsiChar): ConfigEntry; cdecl;
begin
  Result := ConfigImpl(this).findValue(Status, name, value);
end;

function ConfigImpl_findPosDispatcher(this: Config; Status: Status; name: PAnsiChar; pos: Cardinal): ConfigEntry; cdecl;
begin
  Result := ConfigImpl(this).findPos(Status, name, pos);
end;

var
  ConfigImpl_vTable: ConfigVTable;

constructor ConfigImpl.create;
begin
  vTable := ConfigImpl_vTable;
end;

procedure FirebirdConfImpl_addRefDispatcher(this: FirebirdConf); cdecl;
begin
  FirebirdConfImpl(this).addRef();
end;

function FirebirdConfImpl_releaseDispatcher(this: FirebirdConf): Integer; cdecl;
begin
  Result := FirebirdConfImpl(this).release();
end;

function FirebirdConfImpl_getKeyDispatcher(this: FirebirdConf; name: PAnsiChar): Cardinal; cdecl;
begin
  Result := FirebirdConfImpl(this).getKey(name);
end;

function FirebirdConfImpl_asIntegerDispatcher(this: FirebirdConf; key: Cardinal): Int64; cdecl;
begin
  Result := FirebirdConfImpl(this).asInteger(key);
end;

function FirebirdConfImpl_asStringDispatcher(this: FirebirdConf; key: Cardinal): PAnsiChar; cdecl;
begin
  Result := FirebirdConfImpl(this).asString(key);
end;

function FirebirdConfImpl_asBooleanDispatcher(this: FirebirdConf; key: Cardinal): Boolean; cdecl;
begin
  Result := FirebirdConfImpl(this).asBoolean(key);
end;

function FirebirdConfImpl_getVersionDispatcher(this: FirebirdConf; Status: Status): Cardinal; cdecl;
begin
  Result := FirebirdConfImpl(this).getVersion(Status);
end;

var
  FirebirdConfImpl_vTable: FirebirdConfVTable;

constructor FirebirdConfImpl.create;
begin
  vTable := FirebirdConfImpl_vTable;
end;

procedure PluginConfigImpl_addRefDispatcher(this: PluginConfig); cdecl;
begin
  PluginConfigImpl(this).addRef();
end;

function PluginConfigImpl_releaseDispatcher(this: PluginConfig): Integer; cdecl;
begin
  Result := PluginConfigImpl(this).release();
end;

function PluginConfigImpl_getConfigFileNameDispatcher(this: PluginConfig): PAnsiChar; cdecl;
begin
  Result := PluginConfigImpl(this).getConfigFileName();
end;

function PluginConfigImpl_getDefaultConfigDispatcher(this: PluginConfig; Status: Status): Config; cdecl;
begin
  Result := PluginConfigImpl(this).getDefaultConfig(Status);
end;

function PluginConfigImpl_getFirebirdConfDispatcher(this: PluginConfig; Status: Status): FirebirdConf; cdecl;
begin
  Result := PluginConfigImpl(this).getFirebirdConf(Status);
end;

procedure PluginConfigImpl_setReleaseDelayDispatcher(this: PluginConfig; Status: Status; microSeconds: QWord); cdecl;
begin
  PluginConfigImpl(this).setReleaseDelay(Status, microSeconds);
end;

var
  PluginConfigImpl_vTable: PluginConfigVTable;

constructor PluginConfigImpl.create;
begin
  vTable := PluginConfigImpl_vTable;
end;

function PluginFactoryImpl_createPluginDispatcher(this: PluginFactory; Status: Status; factoryParameter: PluginConfig): PluginBase; cdecl;
begin
  Result := PluginFactoryImpl(this).createPlugin(Status, factoryParameter);
end;

var
  PluginFactoryImpl_vTable: PluginFactoryVTable;

constructor PluginFactoryImpl.create;
begin
  vTable := PluginFactoryImpl_vTable;
end;

procedure PluginModuleImpl_doCleanDispatcher(this: PluginModule); cdecl;
begin
  PluginModuleImpl(this).doClean();
end;

procedure PluginModuleImpl_threadDetachDispatcher(this: PluginModule); cdecl;
begin
  PluginModuleImpl(this).threadDetach();
end;

var
  PluginModuleImpl_vTable: PluginModuleVTable;

constructor PluginModuleImpl.create;
begin
  vTable := PluginModuleImpl_vTable;
end;

procedure PluginManagerImpl_registerPluginFactoryDispatcher(this: PluginManager; pluginType: Cardinal; defaultName: PAnsiChar;
  factory: PluginFactory); cdecl;
begin
  PluginManagerImpl(this).registerPluginFactory(pluginType, defaultName, factory);
end;

procedure PluginManagerImpl_registerModuleDispatcher(this: PluginManager; cleanup: PluginModule); cdecl;
begin
  PluginManagerImpl(this).registerModule(cleanup);
end;

procedure PluginManagerImpl_unregisterModuleDispatcher(this: PluginManager; cleanup: PluginModule); cdecl;
begin
  PluginManagerImpl(this).unregisterModule(cleanup);
end;

function PluginManagerImpl_getPluginsDispatcher(this: PluginManager; Status: Status; pluginType: Cardinal; namesList: PAnsiChar;
  FirebirdConf: FirebirdConf): PluginSet; cdecl;
begin
  Result := PluginManagerImpl(this).getPlugins(Status, pluginType, namesList, FirebirdConf);
end;

function PluginManagerImpl_getConfigDispatcher(this: PluginManager; Status: Status; filename: PAnsiChar): Config; cdecl;
begin
  Result := PluginManagerImpl(this).getConfig(Status, filename);
end;

procedure PluginManagerImpl_releasePluginDispatcher(this: PluginManager; plugin: PluginBase); cdecl;
begin
  PluginManagerImpl(this).releasePlugin(plugin);
end;

var
  PluginManagerImpl_vTable: PluginManagerVTable;

constructor PluginManagerImpl.create;
begin
  vTable := PluginManagerImpl_vTable;
end;

procedure CryptKeyImpl_setSymmetricDispatcher(this: CryptKey; Status: Status; type_: PAnsiChar; keyLength: Cardinal; key: Pointer); cdecl;
begin
  CryptKeyImpl(this).setSymmetric(Status, type_, keyLength, key);
end;

procedure CryptKeyImpl_setAsymmetricDispatcher(this: CryptKey; Status: Status; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer;
  decryptKeyLength: Cardinal; decryptKey: Pointer); cdecl;
begin
  CryptKeyImpl(this).setAsymmetric(Status, type_, encryptKeyLength, encryptKey, decryptKeyLength, decryptKey);
end;

function CryptKeyImpl_getEncryptKeyDispatcher(this: CryptKey; length: CardinalPtr): Pointer; cdecl;
begin
  Result := CryptKeyImpl(this).getEncryptKey(length);
end;

function CryptKeyImpl_getDecryptKeyDispatcher(this: CryptKey; length: CardinalPtr): Pointer; cdecl;
begin
  Result := CryptKeyImpl(this).getDecryptKey(length);
end;

var
  CryptKeyImpl_vTable: CryptKeyVTable;

constructor CryptKeyImpl.create;
begin
  vTable := CryptKeyImpl_vTable;
end;

function ConfigManagerImpl_getDirectoryDispatcher(this: ConfigManager; code: Cardinal): PAnsiChar; cdecl;
begin
  Result := ConfigManagerImpl(this).getDirectory(code);
end;

function ConfigManagerImpl_getFirebirdConfDispatcher(this: ConfigManager): FirebirdConf; cdecl;
begin
  Result := ConfigManagerImpl(this).getFirebirdConf();
end;

function ConfigManagerImpl_getDatabaseConfDispatcher(this: ConfigManager; dbName: PAnsiChar): FirebirdConf; cdecl;
begin
  Result := ConfigManagerImpl(this).getDatabaseConf(dbName);
end;

function ConfigManagerImpl_getPluginConfigDispatcher(this: ConfigManager; configuredPlugin: PAnsiChar): Config; cdecl;
begin
  Result := ConfigManagerImpl(this).getPluginConfig(configuredPlugin);
end;

function ConfigManagerImpl_getInstallDirectoryDispatcher(this: ConfigManager): PAnsiChar; cdecl;
begin
  Result := ConfigManagerImpl(this).getInstallDirectory();
end;

function ConfigManagerImpl_getRootDirectoryDispatcher(this: ConfigManager): PAnsiChar; cdecl;
begin
  Result := ConfigManagerImpl(this).getRootDirectory();
end;

function ConfigManagerImpl_getDefaultSecurityDbDispatcher(this: ConfigManager): PAnsiChar; cdecl;
begin
  Result := ConfigManagerImpl(this).getDefaultSecurityDb();
end;

var
  ConfigManagerImpl_vTable: ConfigManagerVTable;

constructor ConfigManagerImpl.create;
begin
  vTable := ConfigManagerImpl_vTable;
end;

procedure EventCallbackImpl_addRefDispatcher(this: EventCallback); cdecl;
begin
  EventCallbackImpl(this).addRef();
end;

function EventCallbackImpl_releaseDispatcher(this: EventCallback): Integer; cdecl;
begin
  Result := EventCallbackImpl(this).release();
end;

procedure EventCallbackImpl_eventCallbackFunctionDispatcher(this: EventCallback; length: Cardinal; Events: BytePtr); cdecl;
begin
  EventCallbackImpl(this).eventCallbackFunction(length, Events);
end;

var
  EventCallbackImpl_vTable: EventCallbackVTable;

constructor EventCallbackImpl.create;
begin
  vTable := EventCallbackImpl_vTable;
end;

procedure BlobImpl_addRefDispatcher(this: Blob); cdecl;
begin
  BlobImpl(this).addRef();
end;

function BlobImpl_releaseDispatcher(this: Blob): Integer; cdecl;
begin
  Result := BlobImpl(this).release();
end;

procedure BlobImpl_getInfoDispatcher(this: Blob; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  BlobImpl(this).getInfo(Status, itemsLength, items, bufferLength, buffer);
end;

function BlobImpl_getSegmentDispatcher(this: Blob; Status: Status; bufferLength: Cardinal; buffer: Pointer; segmentLength: CardinalPtr)
  : Integer; cdecl;
begin
  Result := BlobImpl(this).getSegment(Status, bufferLength, buffer, segmentLength);
end;

procedure BlobImpl_putSegmentDispatcher(this: Blob; Status: Status; length: Cardinal; buffer: Pointer); cdecl;
begin
  BlobImpl(this).putSegment(Status, length, buffer);
end;

procedure BlobImpl_deprecatedCancelDispatcher(this: Blob; Status: Status); cdecl;
begin
  BlobImpl(this).deprecatedCancel(Status);
end;

procedure BlobImpl_deprecatedCloseDispatcher(this: Blob; Status: Status); cdecl;
begin
  BlobImpl(this).deprecatedClose(Status);
end;

function BlobImpl_seekDispatcher(this: Blob; Status: Status; mode: Integer; offset: Integer): Integer; cdecl;
begin
  Result := BlobImpl(this).seek(Status, mode, offset);
end;

procedure BlobImpl_cancelDispatcher(this: Blob; Status: Status); cdecl;
begin
  BlobImpl(this).cancel(Status);
end;

procedure BlobImpl_closeDispatcher(this: Blob; Status: Status); cdecl;
begin
  BlobImpl(this).close(Status);
end;

var
  BlobImpl_vTable: BlobVTable;

constructor BlobImpl.create;
begin
  vTable := BlobImpl_vTable;
end;

procedure TransactionImpl_addRefDispatcher(this: Transaction); cdecl;
begin
  TransactionImpl(this).addRef();
end;

function TransactionImpl_releaseDispatcher(this: Transaction): Integer; cdecl;
begin
  Result := TransactionImpl(this).release();
end;

procedure TransactionImpl_getInfoDispatcher(this: Transaction; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  TransactionImpl(this).getInfo(Status, itemsLength, items, bufferLength, buffer);
end;

procedure TransactionImpl_prepareDispatcher(this: Transaction; Status: Status; msgLength: Cardinal; message: BytePtr); cdecl;
begin
  TransactionImpl(this).prepare(Status, msgLength, message);
end;

procedure TransactionImpl_deprecatedCommitDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).deprecatedCommit(Status);
end;

procedure TransactionImpl_commitRetainingDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).commitRetaining(Status);
end;

procedure TransactionImpl_deprecatedRollbackDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).deprecatedRollback(Status);
end;

procedure TransactionImpl_rollbackRetainingDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).rollbackRetaining(Status);
end;

procedure TransactionImpl_deprecatedDisconnectDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).deprecatedDisconnect(Status);
end;

function TransactionImpl_joinDispatcher(this: Transaction; Status: Status; Transaction: Transaction): Transaction; cdecl;
begin
  Result := TransactionImpl(this).join(Status, Transaction);
end;

function TransactionImpl_validateDispatcher(this: Transaction; Status: Status; Attachment: Attachment): Transaction; cdecl;
begin
  Result := TransactionImpl(this).validate(Status, Attachment);
end;

function TransactionImpl_enterDtcDispatcher(this: Transaction; Status: Status): Transaction; cdecl;
begin
  Result := TransactionImpl(this).enterDtc(Status);
end;

procedure TransactionImpl_commitDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).commit(Status);
end;

procedure TransactionImpl_rollbackDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).rollback(Status);
end;

procedure TransactionImpl_disconnectDispatcher(this: Transaction; Status: Status); cdecl;
begin
  TransactionImpl(this).disconnect(Status);
end;

var
  TransactionImpl_vTable: TransactionVTable;

constructor TransactionImpl.create;
begin
  vTable := TransactionImpl_vTable;
end;

procedure MessageMetadataImpl_addRefDispatcher(this: MessageMetadata); cdecl;
begin
  MessageMetadataImpl(this).addRef();
end;

function MessageMetadataImpl_releaseDispatcher(this: MessageMetadata): Integer; cdecl;
begin
  Result := MessageMetadataImpl(this).release();
end;

function MessageMetadataImpl_getCountDispatcher(this: MessageMetadata; Status: Status): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getCount(Status);
end;

function MessageMetadataImpl_getFieldDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := MessageMetadataImpl(this).getField(Status, index);
end;

function MessageMetadataImpl_getRelationDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := MessageMetadataImpl(this).getRelation(Status, index);
end;

function MessageMetadataImpl_getOwnerDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := MessageMetadataImpl(this).getOwner(Status, index);
end;

function MessageMetadataImpl_getAliasDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := MessageMetadataImpl(this).getAlias(Status, index);
end;

function MessageMetadataImpl_getTypeDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getType(Status, index);
end;

function MessageMetadataImpl_isNullableDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Boolean; cdecl;
begin
  Result := MessageMetadataImpl(this).isNullable(Status, index);
end;

function MessageMetadataImpl_getSubTypeDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Integer; cdecl;
begin
  Result := MessageMetadataImpl(this).getSubType(Status, index);
end;

function MessageMetadataImpl_getLengthDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getLength(Status, index);
end;

function MessageMetadataImpl_getScaleDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Integer; cdecl;
begin
  Result := MessageMetadataImpl(this).getScale(Status, index);
end;

function MessageMetadataImpl_getCharSetDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getCharSet(Status, index);
end;

function MessageMetadataImpl_getOffsetDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getOffset(Status, index);
end;

function MessageMetadataImpl_getNullOffsetDispatcher(this: MessageMetadata; Status: Status; index: Cardinal): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getNullOffset(Status, index);
end;

function MessageMetadataImpl_getBuilderDispatcher(this: MessageMetadata; Status: Status): MetadataBuilder; cdecl;
begin
  Result := MessageMetadataImpl(this).getBuilder(Status);
end;

function MessageMetadataImpl_getMessageLengthDispatcher(this: MessageMetadata; Status: Status): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getMessageLength(Status);
end;

function MessageMetadataImpl_getAlignmentDispatcher(this: MessageMetadata; Status: Status): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getAlignment(Status);
end;

function MessageMetadataImpl_getAlignedLengthDispatcher(this: MessageMetadata; Status: Status): Cardinal; cdecl;
begin
  Result := MessageMetadataImpl(this).getAlignedLength(Status);
end;

var
  MessageMetadataImpl_vTable: MessageMetadataVTable;

constructor MessageMetadataImpl.create;
begin
  vTable := MessageMetadataImpl_vTable;
end;

procedure MetadataBuilderImpl_addRefDispatcher(this: MetadataBuilder); cdecl;
begin
  MetadataBuilderImpl(this).addRef();
end;

function MetadataBuilderImpl_releaseDispatcher(this: MetadataBuilder): Integer; cdecl;
begin
  Result := MetadataBuilderImpl(this).release();
end;

procedure MetadataBuilderImpl_setTypeDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; type_: Cardinal); cdecl;
begin
  MetadataBuilderImpl(this).setType(Status, index, type_);
end;

procedure MetadataBuilderImpl_setSubTypeDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; subType: Integer); cdecl;
begin
  MetadataBuilderImpl(this).setSubType(Status, index, subType);
end;

procedure MetadataBuilderImpl_setLengthDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; length: Cardinal); cdecl;
begin
  MetadataBuilderImpl(this).setLength(Status, index, length);
end;

procedure MetadataBuilderImpl_setCharSetDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; charSet: Cardinal); cdecl;
begin
  MetadataBuilderImpl(this).setCharSet(Status, index, charSet);
end;

procedure MetadataBuilderImpl_setScaleDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; scale: Integer); cdecl;
begin
  MetadataBuilderImpl(this).setScale(Status, index, scale);
end;

procedure MetadataBuilderImpl_truncateDispatcher(this: MetadataBuilder; Status: Status; count: Cardinal); cdecl;
begin
  MetadataBuilderImpl(this).truncate(Status, count);
end;

procedure MetadataBuilderImpl_moveNameToIndexDispatcher(this: MetadataBuilder; Status: Status; name: PAnsiChar; index: Cardinal); cdecl;
begin
  MetadataBuilderImpl(this).moveNameToIndex(Status, name, index);
end;

procedure MetadataBuilderImpl_removeDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal); cdecl;
begin
  MetadataBuilderImpl(this).remove(Status, index);
end;

function MetadataBuilderImpl_addFieldDispatcher(this: MetadataBuilder; Status: Status): Cardinal; cdecl;
begin
  Result := MetadataBuilderImpl(this).addField(Status);
end;

function MetadataBuilderImpl_getMetadataDispatcher(this: MetadataBuilder; Status: Status): MessageMetadata; cdecl;
begin
  Result := MetadataBuilderImpl(this).getMetadata(Status);
end;

procedure MetadataBuilderImpl_setFieldDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; field: PAnsiChar); cdecl;
begin
  MetadataBuilderImpl(this).setField(Status, index, field);
end;

procedure MetadataBuilderImpl_setRelationDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; relation: PAnsiChar); cdecl;
begin
  MetadataBuilderImpl(this).setRelation(Status, index, relation);
end;

procedure MetadataBuilderImpl_setOwnerDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; owner: PAnsiChar); cdecl;
begin
  MetadataBuilderImpl(this).setOwner(Status, index, owner);
end;

procedure MetadataBuilderImpl_setAliasDispatcher(this: MetadataBuilder; Status: Status; index: Cardinal; alias: PAnsiChar); cdecl;
begin
  MetadataBuilderImpl(this).setAlias(Status, index, alias);
end;

var
  MetadataBuilderImpl_vTable: MetadataBuilderVTable;

constructor MetadataBuilderImpl.create;
begin
  vTable := MetadataBuilderImpl_vTable;
end;

procedure ResultSetImpl_addRefDispatcher(this: ResultSet); cdecl;
begin
  ResultSetImpl(this).addRef();
end;

function ResultSetImpl_releaseDispatcher(this: ResultSet): Integer; cdecl;
begin
  Result := ResultSetImpl(this).release();
end;

function ResultSetImpl_fetchNextDispatcher(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
begin
  Result := ResultSetImpl(this).fetchNext(Status, message);
end;

function ResultSetImpl_fetchPriorDispatcher(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
begin
  Result := ResultSetImpl(this).fetchPrior(Status, message);
end;

function ResultSetImpl_fetchFirstDispatcher(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
begin
  Result := ResultSetImpl(this).fetchFirst(Status, message);
end;

function ResultSetImpl_fetchLastDispatcher(this: ResultSet; Status: Status; message: Pointer): Integer; cdecl;
begin
  Result := ResultSetImpl(this).fetchLast(Status, message);
end;

function ResultSetImpl_fetchAbsoluteDispatcher(this: ResultSet; Status: Status; position: Integer; message: Pointer): Integer; cdecl;
begin
  Result := ResultSetImpl(this).fetchAbsolute(Status, position, message);
end;

function ResultSetImpl_fetchRelativeDispatcher(this: ResultSet; Status: Status; offset: Integer; message: Pointer): Integer; cdecl;
begin
  Result := ResultSetImpl(this).fetchRelative(Status, offset, message);
end;

function ResultSetImpl_isEofDispatcher(this: ResultSet; Status: Status): Boolean; cdecl;
begin
  Result := ResultSetImpl(this).isEof(Status);
end;

function ResultSetImpl_isBofDispatcher(this: ResultSet; Status: Status): Boolean; cdecl;
begin
  Result := ResultSetImpl(this).isBof(Status);
end;

function ResultSetImpl_getMetadataDispatcher(this: ResultSet; Status: Status): MessageMetadata; cdecl;
begin
  Result := ResultSetImpl(this).getMetadata(Status);
end;

procedure ResultSetImpl_deprecatedCloseDispatcher(this: ResultSet; Status: Status); cdecl;
begin
  ResultSetImpl(this).deprecatedClose(Status);
end;

procedure ResultSetImpl_setDelayedOutputFormatDispatcher(this: ResultSet; Status: Status; format: MessageMetadata); cdecl;
begin
  ResultSetImpl(this).setDelayedOutputFormat(Status, format);
end;

procedure ResultSetImpl_closeDispatcher(this: ResultSet; Status: Status); cdecl;
begin
  ResultSetImpl(this).close(Status);
end;

procedure ResultSetImpl_getInfoDispatcher(this: ResultSet; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  ResultSetImpl(this).getInfo(Status, itemsLength, items, bufferLength, buffer);
end;

var
  ResultSetImpl_vTable: ResultSetVTable;

constructor ResultSetImpl.create;
begin
  vTable := ResultSetImpl_vTable;
end;

procedure StatementImpl_addRefDispatcher(this: Statement); cdecl;
begin
  StatementImpl(this).addRef();
end;

function StatementImpl_releaseDispatcher(this: Statement): Integer; cdecl;
begin
  Result := StatementImpl(this).release();
end;

procedure StatementImpl_getInfoDispatcher(this: Statement; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  StatementImpl(this).getInfo(Status, itemsLength, items, bufferLength, buffer);
end;

function StatementImpl_getTypeDispatcher(this: Statement; Status: Status): Cardinal; cdecl;
begin
  Result := StatementImpl(this).getType(Status);
end;

function StatementImpl_getPlanDispatcher(this: Statement; Status: Status; detailed: Boolean): PAnsiChar; cdecl;
begin
  Result := StatementImpl(this).getPlan(Status, detailed);
end;

function StatementImpl_getAffectedRecordsDispatcher(this: Statement; Status: Status): QWord; cdecl;
begin
  Result := StatementImpl(this).getAffectedRecords(Status);
end;

function StatementImpl_getInputMetadataDispatcher(this: Statement; Status: Status): MessageMetadata; cdecl;
begin
  Result := StatementImpl(this).getInputMetadata(Status);
end;

function StatementImpl_getOutputMetadataDispatcher(this: Statement; Status: Status): MessageMetadata; cdecl;
begin
  Result := StatementImpl(this).getOutputMetadata(Status);
end;

function StatementImpl_executeDispatcher(this: Statement; Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer;
  outMetadata: MessageMetadata; outBuffer: Pointer): Transaction; cdecl;
begin
  Result := StatementImpl(this).execute(Status, Transaction, inMetadata, inBuffer, outMetadata, outBuffer);
end;

function StatementImpl_openCursorDispatcher(this: Statement; Status: Status; Transaction: Transaction; inMetadata: MessageMetadata; inBuffer: Pointer;
  outMetadata: MessageMetadata; flags: Cardinal): ResultSet; cdecl;
begin
  Result := StatementImpl(this).openCursor(Status, Transaction, inMetadata, inBuffer, outMetadata, flags);
end;

procedure StatementImpl_setCursorNameDispatcher(this: Statement; Status: Status; name: PAnsiChar); cdecl;
begin
  StatementImpl(this).setCursorName(Status, name);
end;

procedure StatementImpl_deprecatedFreeDispatcher(this: Statement; Status: Status); cdecl;
begin
  StatementImpl(this).deprecatedFree(Status);
end;

function StatementImpl_getFlagsDispatcher(this: Statement; Status: Status): Cardinal; cdecl;
begin
  Result := StatementImpl(this).getFlags(Status);
end;

function StatementImpl_getTimeoutDispatcher(this: Statement; Status: Status): Cardinal; cdecl;
begin
  Result := StatementImpl(this).getTimeout(Status);
end;

procedure StatementImpl_setTimeoutDispatcher(this: Statement; Status: Status; timeOut: Cardinal); cdecl;
begin
  StatementImpl(this).setTimeout(Status, timeOut);
end;

function StatementImpl_createBatchDispatcher(this: Statement; Status: Status; inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr)
  : Batch; cdecl;
begin
  Result := StatementImpl(this).createBatch(Status, inMetadata, parLength, par);
end;

procedure StatementImpl_freeDispatcher(this: Statement; Status: Status); cdecl;
begin
  StatementImpl(this).free(Status);
end;

var
  StatementImpl_vTable: StatementVTable;

constructor StatementImpl.create;
begin
  vTable := StatementImpl_vTable;
end;

procedure BatchImpl_addRefDispatcher(this: Batch); cdecl;
begin
  BatchImpl(this).addRef();
end;

function BatchImpl_releaseDispatcher(this: Batch): Integer; cdecl;
begin
  Result := BatchImpl(this).release();
end;

procedure BatchImpl_addDispatcher(this: Batch; Status: Status; count: Cardinal; inBuffer: Pointer); cdecl;
begin
  BatchImpl(this).add(Status, count, inBuffer);
end;

procedure BatchImpl_addBlobDispatcher(this: Batch; Status: Status; length: Cardinal; inBuffer: Pointer; blobId: ISC_QUADPtr; parLength: Cardinal;
  par: BytePtr); cdecl;
begin
  BatchImpl(this).addBlob(Status, length, inBuffer, blobId, parLength, par);
end;

procedure BatchImpl_appendBlobDataDispatcher(this: Batch; Status: Status; length: Cardinal; inBuffer: Pointer); cdecl;
begin
  BatchImpl(this).appendBlobData(Status, length, inBuffer);
end;

procedure BatchImpl_addBlobStreamDispatcher(this: Batch; Status: Status; length: Cardinal; inBuffer: Pointer); cdecl;
begin
  BatchImpl(this).addBlobStream(Status, length, inBuffer);
end;

procedure BatchImpl_registerBlobDispatcher(this: Batch; Status: Status; existingBlob: ISC_QUADPtr; blobId: ISC_QUADPtr); cdecl;
begin
  BatchImpl(this).registerBlob(Status, existingBlob, blobId);
end;

function BatchImpl_executeDispatcher(this: Batch; Status: Status; Transaction: Transaction): BatchCompletionState; cdecl;
begin
  Result := BatchImpl(this).execute(Status, Transaction);
end;

procedure BatchImpl_cancelDispatcher(this: Batch; Status: Status); cdecl;
begin
  BatchImpl(this).cancel(Status);
end;

function BatchImpl_getBlobAlignmentDispatcher(this: Batch; Status: Status): Cardinal; cdecl;
begin
  Result := BatchImpl(this).getBlobAlignment(Status);
end;

function BatchImpl_getMetadataDispatcher(this: Batch; Status: Status): MessageMetadata; cdecl;
begin
  Result := BatchImpl(this).getMetadata(Status);
end;

procedure BatchImpl_setDefaultBpbDispatcher(this: Batch; Status: Status; parLength: Cardinal; par: BytePtr); cdecl;
begin
  BatchImpl(this).setDefaultBpb(Status, parLength, par);
end;

procedure BatchImpl_deprecatedCloseDispatcher(this: Batch; Status: Status); cdecl;
begin
  BatchImpl(this).deprecatedClose(Status);
end;

procedure BatchImpl_closeDispatcher(this: Batch; Status: Status); cdecl;
begin
  BatchImpl(this).close(Status);
end;

procedure BatchImpl_getInfoDispatcher(this: Batch; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  BatchImpl(this).getInfo(Status, itemsLength, items, bufferLength, buffer);
end;

var
  BatchImpl_vTable: BatchVTable;

constructor BatchImpl.create;
begin
  vTable := BatchImpl_vTable;
end;

procedure BatchCompletionStateImpl_disposeDispatcher(this: BatchCompletionState); cdecl;
begin
  BatchCompletionStateImpl(this).dispose();
end;

function BatchCompletionStateImpl_getSizeDispatcher(this: BatchCompletionState; Status: Status): Cardinal; cdecl;
begin
  Result := BatchCompletionStateImpl(this).getSize(Status);
end;

function BatchCompletionStateImpl_getStateDispatcher(this: BatchCompletionState; Status: Status; pos: Cardinal): Integer; cdecl;
begin
  Result := BatchCompletionStateImpl(this).getState(Status, pos);
end;

function BatchCompletionStateImpl_findErrorDispatcher(this: BatchCompletionState; Status: Status; pos: Cardinal): Cardinal; cdecl;
begin
  Result := BatchCompletionStateImpl(this).findError(Status, pos);
end;

procedure BatchCompletionStateImpl_getStatusDispatcher(this: BatchCompletionState; Status: Status; to_: Status; pos: Cardinal); cdecl;
begin
  BatchCompletionStateImpl(this).getStatus(Status, to_, pos);
end;

var
  BatchCompletionStateImpl_vTable: BatchCompletionStateVTable;

constructor BatchCompletionStateImpl.create;
begin
  vTable := BatchCompletionStateImpl_vTable;
end;

procedure ReplicatorImpl_addRefDispatcher(this: Replicator); cdecl;
begin
  ReplicatorImpl(this).addRef();
end;

function ReplicatorImpl_releaseDispatcher(this: Replicator): Integer; cdecl;
begin
  Result := ReplicatorImpl(this).release();
end;

procedure ReplicatorImpl_processDispatcher(this: Replicator; Status: Status; length: Cardinal; data: BytePtr); cdecl;
begin
  ReplicatorImpl(this).process(Status, length, data);
end;

procedure ReplicatorImpl_deprecatedCloseDispatcher(this: Replicator; Status: Status); cdecl;
begin
  ReplicatorImpl(this).deprecatedClose(Status);
end;

procedure ReplicatorImpl_closeDispatcher(this: Replicator; Status: Status); cdecl;
begin
  ReplicatorImpl(this).close(Status);
end;

var
  ReplicatorImpl_vTable: ReplicatorVTable;

constructor ReplicatorImpl.create;
begin
  vTable := ReplicatorImpl_vTable;
end;

procedure RequestImpl_addRefDispatcher(this: Request); cdecl;
begin
  RequestImpl(this).addRef();
end;

function RequestImpl_releaseDispatcher(this: Request): Integer; cdecl;
begin
  Result := RequestImpl(this).release();
end;

procedure RequestImpl_receiveDispatcher(this: Request; Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer); cdecl;
begin
  RequestImpl(this).receive(Status, level, msgType, length, message);
end;

procedure RequestImpl_sendDispatcher(this: Request; Status: Status; level: Integer; msgType: Cardinal; length: Cardinal; message: Pointer); cdecl;
begin
  RequestImpl(this).send(Status, level, msgType, length, message);
end;

procedure RequestImpl_getInfoDispatcher(this: Request; Status: Status; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  RequestImpl(this).getInfo(Status, level, itemsLength, items, bufferLength, buffer);
end;

procedure RequestImpl_startDispatcher(this: Request; Status: Status; tra: Transaction; level: Integer); cdecl;
begin
  RequestImpl(this).start(Status, tra, level);
end;

procedure RequestImpl_startAndSendDispatcher(this: Request; Status: Status; tra: Transaction; level: Integer; msgType: Cardinal; length: Cardinal;
  message: Pointer); cdecl;
begin
  RequestImpl(this).startAndSend(Status, tra, level, msgType, length, message);
end;

procedure RequestImpl_unwindDispatcher(this: Request; Status: Status; level: Integer); cdecl;
begin
  RequestImpl(this).unwind(Status, level);
end;

procedure RequestImpl_deprecatedFreeDispatcher(this: Request; Status: Status); cdecl;
begin
  RequestImpl(this).deprecatedFree(Status);
end;

procedure RequestImpl_freeDispatcher(this: Request; Status: Status); cdecl;
begin
  RequestImpl(this).free(Status);
end;

var
  RequestImpl_vTable: RequestVTable;

constructor RequestImpl.create;
begin
  vTable := RequestImpl_vTable;
end;

procedure EventsImpl_addRefDispatcher(this: Events); cdecl;
begin
  EventsImpl(this).addRef();
end;

function EventsImpl_releaseDispatcher(this: Events): Integer; cdecl;
begin
  Result := EventsImpl(this).release();
end;

procedure EventsImpl_deprecatedCancelDispatcher(this: Events; Status: Status); cdecl;
begin
  EventsImpl(this).deprecatedCancel(Status);
end;

procedure EventsImpl_cancelDispatcher(this: Events; Status: Status); cdecl;
begin
  EventsImpl(this).cancel(Status);
end;

var
  EventsImpl_vTable: EventsVTable;

constructor EventsImpl.create;
begin
  vTable := EventsImpl_vTable;
end;

procedure AttachmentImpl_addRefDispatcher(this: Attachment); cdecl;
begin
  AttachmentImpl(this).addRef();
end;

function AttachmentImpl_releaseDispatcher(this: Attachment): Integer; cdecl;
begin
  Result := AttachmentImpl(this).release();
end;

procedure AttachmentImpl_getInfoDispatcher(this: Attachment; Status: Status; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  AttachmentImpl(this).getInfo(Status, itemsLength, items, bufferLength, buffer);
end;

function AttachmentImpl_startTransactionDispatcher(this: Attachment; Status: Status; tpbLength: Cardinal; tpb: BytePtr): Transaction; cdecl;
begin
  Result := AttachmentImpl(this).startTransaction(Status, tpbLength, tpb);
end;

function AttachmentImpl_reconnectTransactionDispatcher(this: Attachment; Status: Status; length: Cardinal; id: BytePtr): Transaction; cdecl;
begin
  Result := AttachmentImpl(this).reconnectTransaction(Status, length, id);
end;

function AttachmentImpl_compileRequestDispatcher(this: Attachment; Status: Status; blrLength: Cardinal; blr: BytePtr): Request; cdecl;
begin
  Result := AttachmentImpl(this).compileRequest(Status, blrLength, blr);
end;

procedure AttachmentImpl_transactRequestDispatcher(this: Attachment; Status: Status; Transaction: Transaction; blrLength: Cardinal; blr: BytePtr;
  inMsgLength: Cardinal; inMsg: BytePtr; outMsgLength: Cardinal; outMsg: BytePtr); cdecl;
begin
  AttachmentImpl(this).transactRequest(Status, Transaction, blrLength, blr, inMsgLength, inMsg, outMsgLength, outMsg);
end;

function AttachmentImpl_createBlobDispatcher(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal;
  bpb: BytePtr): Blob; cdecl;
begin
  Result := AttachmentImpl(this).createBlob(Status, Transaction, id, bpbLength, bpb);
end;

function AttachmentImpl_openBlobDispatcher(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; bpbLength: Cardinal;
  bpb: BytePtr): Blob; cdecl;
begin
  Result := AttachmentImpl(this).openBlob(Status, Transaction, id, bpbLength, bpb);
end;

function AttachmentImpl_getSliceDispatcher(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal;
  sdl: BytePtr; paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer; cdecl;
begin
  Result := AttachmentImpl(this).getSlice(Status, Transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
end;

procedure AttachmentImpl_putSliceDispatcher(this: Attachment; Status: Status; Transaction: Transaction; id: ISC_QUADPtr; sdlLength: Cardinal;
  sdl: BytePtr; paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr); cdecl;
begin
  AttachmentImpl(this).putSlice(Status, Transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
end;

procedure AttachmentImpl_executeDynDispatcher(this: Attachment; Status: Status; Transaction: Transaction; length: Cardinal; dyn: BytePtr); cdecl;
begin
  AttachmentImpl(this).executeDyn(Status, Transaction, length, dyn);
end;

function AttachmentImpl_prepareDispatcher(this: Attachment; Status: Status; tra: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
  dialect: Cardinal; flags: Cardinal): Statement; cdecl;
begin
  Result := AttachmentImpl(this).prepare(Status, tra, stmtLength, sqlStmt, dialect, flags);
end;

function AttachmentImpl_executeDispatcher(this: Attachment; Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
  dialect: Cardinal; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; outBuffer: Pointer): Transaction; cdecl;
begin
  Result := AttachmentImpl(this).execute(Status, Transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata, outBuffer);
end;

function AttachmentImpl_openCursorDispatcher(this: Attachment; Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
  dialect: Cardinal; inMetadata: MessageMetadata; inBuffer: Pointer; outMetadata: MessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal)
  : ResultSet; cdecl;
begin
  Result := AttachmentImpl(this).openCursor(Status, Transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata, cursorName,
    cursorFlags);
end;

function AttachmentImpl_queEventsDispatcher(this: Attachment; Status: Status; callback: EventCallback; length: Cardinal; Events: BytePtr)
  : Events; cdecl;
begin
  Result := AttachmentImpl(this).queEvents(Status, callback, length, Events);
end;

procedure AttachmentImpl_cancelOperationDispatcher(this: Attachment; Status: Status; option: Integer); cdecl;
begin
  AttachmentImpl(this).cancelOperation(Status, option);
end;

procedure AttachmentImpl_pingDispatcher(this: Attachment; Status: Status); cdecl;
begin
  AttachmentImpl(this).ping(Status);
end;

procedure AttachmentImpl_deprecatedDetachDispatcher(this: Attachment; Status: Status); cdecl;
begin
  AttachmentImpl(this).deprecatedDetach(Status);
end;

procedure AttachmentImpl_deprecatedDropDatabaseDispatcher(this: Attachment; Status: Status); cdecl;
begin
  AttachmentImpl(this).deprecatedDropDatabase(Status);
end;

function AttachmentImpl_getIdleTimeoutDispatcher(this: Attachment; Status: Status): Cardinal; cdecl;
begin
  Result := AttachmentImpl(this).getIdleTimeout(Status);
end;

procedure AttachmentImpl_setIdleTimeoutDispatcher(this: Attachment; Status: Status; timeOut: Cardinal); cdecl;
begin
  AttachmentImpl(this).setIdleTimeout(Status, timeOut);
end;

function AttachmentImpl_getStatementTimeoutDispatcher(this: Attachment; Status: Status): Cardinal; cdecl;
begin
  Result := AttachmentImpl(this).getStatementTimeout(Status);
end;

procedure AttachmentImpl_setStatementTimeoutDispatcher(this: Attachment; Status: Status; timeOut: Cardinal); cdecl;
begin
  AttachmentImpl(this).setStatementTimeout(Status, timeOut);
end;

function AttachmentImpl_createBatchDispatcher(this: Attachment; Status: Status; Transaction: Transaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
  dialect: Cardinal; inMetadata: MessageMetadata; parLength: Cardinal; par: BytePtr): Batch; cdecl;
begin
  Result := AttachmentImpl(this).createBatch(Status, Transaction, stmtLength, sqlStmt, dialect, inMetadata, parLength, par);
end;

function AttachmentImpl_createReplicatorDispatcher(this: Attachment; Status: Status): Replicator; cdecl;
begin
  Result := AttachmentImpl(this).createReplicator(Status);
end;

procedure AttachmentImpl_detachDispatcher(this: Attachment; Status: Status); cdecl;
begin
  AttachmentImpl(this).detach(Status);
end;

procedure AttachmentImpl_dropDatabaseDispatcher(this: Attachment; Status: Status); cdecl;
begin
  AttachmentImpl(this).dropDatabase(Status);
end;

var
  AttachmentImpl_vTable: AttachmentVTable;

constructor AttachmentImpl.create;
begin
  vTable := AttachmentImpl_vTable;
end;

procedure ServiceImpl_addRefDispatcher(this: Service); cdecl;
begin
  ServiceImpl(this).addRef();
end;

function ServiceImpl_releaseDispatcher(this: Service): Integer; cdecl;
begin
  Result := ServiceImpl(this).release();
end;

procedure ServiceImpl_deprecatedDetachDispatcher(this: Service; Status: Status); cdecl;
begin
  ServiceImpl(this).deprecatedDetach(Status);
end;

procedure ServiceImpl_queryDispatcher(this: Service; Status: Status; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal;
  receiveItems: BytePtr; bufferLength: Cardinal; buffer: BytePtr); cdecl;
begin
  ServiceImpl(this).query(Status, sendLength, sendItems, receiveLength, receiveItems, bufferLength, buffer);
end;

procedure ServiceImpl_startDispatcher(this: Service; Status: Status; spbLength: Cardinal; spb: BytePtr); cdecl;
begin
  ServiceImpl(this).start(Status, spbLength, spb);
end;

procedure ServiceImpl_detachDispatcher(this: Service; Status: Status); cdecl;
begin
  ServiceImpl(this).detach(Status);
end;

procedure ServiceImpl_cancelDispatcher(this: Service; Status: Status); cdecl;
begin
  ServiceImpl(this).cancel(Status);
end;

var
  ServiceImpl_vTable: ServiceVTable;

constructor ServiceImpl.create;
begin
  vTable := ServiceImpl_vTable;
end;

procedure ProviderImpl_addRefDispatcher(this: Provider); cdecl;
begin
  ProviderImpl(this).addRef();
end;

function ProviderImpl_releaseDispatcher(this: Provider): Integer; cdecl;
begin
  Result := ProviderImpl(this).release();
end;

procedure ProviderImpl_setOwnerDispatcher(this: Provider; r: ReferenceCounted); cdecl;
begin
  ProviderImpl(this).setOwner(r);
end;

function ProviderImpl_getOwnerDispatcher(this: Provider): ReferenceCounted; cdecl;
begin
  Result := ProviderImpl(this).getOwner();
end;

function ProviderImpl_attachDatabaseDispatcher(this: Provider; Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr)
  : Attachment; cdecl;
begin
  Result := ProviderImpl(this).attachDatabase(Status, filename, dpbLength, dpb);
end;

function ProviderImpl_createDatabaseDispatcher(this: Provider; Status: Status; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr)
  : Attachment; cdecl;
begin
  Result := ProviderImpl(this).createDatabase(Status, filename, dpbLength, dpb);
end;

function ProviderImpl_attachServiceManagerDispatcher(this: Provider; Status: Status; Service: PAnsiChar; spbLength: Cardinal; spb: BytePtr)
  : Service; cdecl;
begin
  Result := ProviderImpl(this).attachServiceManager(Status, Service, spbLength, spb);
end;

procedure ProviderImpl_shutdownDispatcher(this: Provider; Status: Status; timeOut: Cardinal; reason: Integer); cdecl;
begin
  ProviderImpl(this).shutdown(Status, timeOut, reason);
end;

procedure ProviderImpl_setDbCryptCallbackDispatcher(this: Provider; Status: Status; cryptCallback: CryptKeyCallback); cdecl;
begin
  ProviderImpl(this).setDbCryptCallback(Status, cryptCallback);
end;

var
  ProviderImpl_vTable: ProviderVTable;

constructor ProviderImpl.create;
begin
  vTable := ProviderImpl_vTable;
end;

procedure DtcStartImpl_disposeDispatcher(this: DtcStart); cdecl;
begin
  DtcStartImpl(this).dispose();
end;

procedure DtcStartImpl_addAttachmentDispatcher(this: DtcStart; Status: Status; att: Attachment); cdecl;
begin
  DtcStartImpl(this).addAttachment(Status, att);
end;

procedure DtcStartImpl_addWithTpbDispatcher(this: DtcStart; Status: Status; att: Attachment; length: Cardinal; tpb: BytePtr); cdecl;
begin
  DtcStartImpl(this).addWithTpb(Status, att, length, tpb);
end;

function DtcStartImpl_startDispatcher(this: DtcStart; Status: Status): Transaction; cdecl;
begin
  Result := DtcStartImpl(this).start(Status);
end;

var
  DtcStartImpl_vTable: DtcStartVTable;

constructor DtcStartImpl.create;
begin
  vTable := DtcStartImpl_vTable;
end;

function DtcImpl_joinDispatcher(this: Dtc; Status: Status; one: Transaction; two: Transaction): Transaction; cdecl;
begin
  Result := DtcImpl(this).join(Status, one, two);
end;

function DtcImpl_startBuilderDispatcher(this: Dtc; Status: Status): DtcStart; cdecl;
begin
  Result := DtcImpl(this).startBuilder(Status);
end;

var
  DtcImpl_vTable: DtcVTable;

constructor DtcImpl.create;
begin
  vTable := DtcImpl_vTable;
end;

procedure AuthImpl_addRefDispatcher(this: Auth); cdecl;
begin
  AuthImpl(this).addRef();
end;

function AuthImpl_releaseDispatcher(this: Auth): Integer; cdecl;
begin
  Result := AuthImpl(this).release();
end;

procedure AuthImpl_setOwnerDispatcher(this: Auth; r: ReferenceCounted); cdecl;
begin
  AuthImpl(this).setOwner(r);
end;

function AuthImpl_getOwnerDispatcher(this: Auth): ReferenceCounted; cdecl;
begin
  Result := AuthImpl(this).getOwner();
end;

var
  AuthImpl_vTable: AuthVTable;

constructor AuthImpl.create;
begin
  vTable := AuthImpl_vTable;
end;

procedure WriterImpl_resetDispatcher(this: Writer); cdecl;
begin
  WriterImpl(this).reset();
end;

procedure WriterImpl_addDispatcher(this: Writer; Status: Status; name: PAnsiChar); cdecl;
begin
  WriterImpl(this).add(Status, name);
end;

procedure WriterImpl_setTypeDispatcher(this: Writer; Status: Status; value: PAnsiChar); cdecl;
begin
  WriterImpl(this).setType(Status, value);
end;

procedure WriterImpl_setDbDispatcher(this: Writer; Status: Status; value: PAnsiChar); cdecl;
begin
  WriterImpl(this).setDb(Status, value);
end;

var
  WriterImpl_vTable: WriterVTable;

constructor WriterImpl.create;
begin
  vTable := WriterImpl_vTable;
end;

function ServerBlockImpl_getLoginDispatcher(this: ServerBlock): PAnsiChar; cdecl;
begin
  Result := ServerBlockImpl(this).getLogin();
end;

function ServerBlockImpl_getDataDispatcher(this: ServerBlock; length: CardinalPtr): BytePtr; cdecl;
begin
  Result := ServerBlockImpl(this).getData(length);
end;

procedure ServerBlockImpl_putDataDispatcher(this: ServerBlock; Status: Status; length: Cardinal; data: Pointer); cdecl;
begin
  ServerBlockImpl(this).putData(Status, length, data);
end;

function ServerBlockImpl_newKeyDispatcher(this: ServerBlock; Status: Status): CryptKey; cdecl;
begin
  Result := ServerBlockImpl(this).newKey(Status);
end;

var
  ServerBlockImpl_vTable: ServerBlockVTable;

constructor ServerBlockImpl.create;
begin
  vTable := ServerBlockImpl_vTable;
end;

procedure ClientBlockImpl_addRefDispatcher(this: ClientBlock); cdecl;
begin
  ClientBlockImpl(this).addRef();
end;

function ClientBlockImpl_releaseDispatcher(this: ClientBlock): Integer; cdecl;
begin
  Result := ClientBlockImpl(this).release();
end;

function ClientBlockImpl_getLoginDispatcher(this: ClientBlock): PAnsiChar; cdecl;
begin
  Result := ClientBlockImpl(this).getLogin();
end;

function ClientBlockImpl_getPasswordDispatcher(this: ClientBlock): PAnsiChar; cdecl;
begin
  Result := ClientBlockImpl(this).getPassword();
end;

function ClientBlockImpl_getDataDispatcher(this: ClientBlock; length: CardinalPtr): BytePtr; cdecl;
begin
  Result := ClientBlockImpl(this).getData(length);
end;

procedure ClientBlockImpl_putDataDispatcher(this: ClientBlock; Status: Status; length: Cardinal; data: Pointer); cdecl;
begin
  ClientBlockImpl(this).putData(Status, length, data);
end;

function ClientBlockImpl_newKeyDispatcher(this: ClientBlock; Status: Status): CryptKey; cdecl;
begin
  Result := ClientBlockImpl(this).newKey(Status);
end;

function ClientBlockImpl_getAuthBlockDispatcher(this: ClientBlock; Status: Status): AuthBlock; cdecl;
begin
  Result := ClientBlockImpl(this).getAuthBlock(Status);
end;

var
  ClientBlockImpl_vTable: ClientBlockVTable;

constructor ClientBlockImpl.create;
begin
  vTable := ClientBlockImpl_vTable;
end;

procedure ServerImpl_addRefDispatcher(this: Server); cdecl;
begin
  ServerImpl(this).addRef();
end;

function ServerImpl_releaseDispatcher(this: Server): Integer; cdecl;
begin
  Result := ServerImpl(this).release();
end;

procedure ServerImpl_setOwnerDispatcher(this: Server; r: ReferenceCounted); cdecl;
begin
  ServerImpl(this).setOwner(r);
end;

function ServerImpl_getOwnerDispatcher(this: Server): ReferenceCounted; cdecl;
begin
  Result := ServerImpl(this).getOwner();
end;

function ServerImpl_authenticateDispatcher(this: Server; Status: Status; sBlock: ServerBlock; writerInterface: Writer): Integer; cdecl;
begin
  Result := ServerImpl(this).authenticate(Status, sBlock, writerInterface);
end;

procedure ServerImpl_setDbCryptCallbackDispatcher(this: Server; Status: Status; cryptCallback: CryptKeyCallback); cdecl;
begin
  ServerImpl(this).setDbCryptCallback(Status, cryptCallback);
end;

var
  ServerImpl_vTable: ServerVTable;

constructor ServerImpl.create;
begin
  vTable := ServerImpl_vTable;
end;

procedure ClientImpl_addRefDispatcher(this: Client); cdecl;
begin
  ClientImpl(this).addRef();
end;

function ClientImpl_releaseDispatcher(this: Client): Integer; cdecl;
begin
  Result := ClientImpl(this).release();
end;

procedure ClientImpl_setOwnerDispatcher(this: Client; r: ReferenceCounted); cdecl;
begin
  ClientImpl(this).setOwner(r);
end;

function ClientImpl_getOwnerDispatcher(this: Client): ReferenceCounted; cdecl;
begin
  Result := ClientImpl(this).getOwner();
end;

function ClientImpl_authenticateDispatcher(this: Client; Status: Status; cBlock: ClientBlock): Integer; cdecl;
begin
  Result := ClientImpl(this).authenticate(Status, cBlock);
end;

var
  ClientImpl_vTable: ClientVTable;

constructor ClientImpl.create;
begin
  vTable := ClientImpl_vTable;
end;

function UserFieldImpl_enteredDispatcher(this: UserField): Integer; cdecl;
begin
  Result := UserFieldImpl(this).entered();
end;

function UserFieldImpl_specifiedDispatcher(this: UserField): Integer; cdecl;
begin
  Result := UserFieldImpl(this).specified();
end;

procedure UserFieldImpl_setEnteredDispatcher(this: UserField; Status: Status; newValue: Integer); cdecl;
begin
  UserFieldImpl(this).setEntered(Status, newValue);
end;

var
  UserFieldImpl_vTable: UserFieldVTable;

constructor UserFieldImpl.create;
begin
  vTable := UserFieldImpl_vTable;
end;

function CharUserFieldImpl_enteredDispatcher(this: CharUserField): Integer; cdecl;
begin
  Result := CharUserFieldImpl(this).entered();
end;

function CharUserFieldImpl_specifiedDispatcher(this: CharUserField): Integer; cdecl;
begin
  Result := CharUserFieldImpl(this).specified();
end;

procedure CharUserFieldImpl_setEnteredDispatcher(this: CharUserField; Status: Status; newValue: Integer); cdecl;
begin
  CharUserFieldImpl(this).setEntered(Status, newValue);
end;

function CharUserFieldImpl_getDispatcher(this: CharUserField): PAnsiChar; cdecl;
begin
  Result := CharUserFieldImpl(this).get();
end;

procedure CharUserFieldImpl_set_Dispatcher(this: CharUserField; Status: Status; newValue: PAnsiChar); cdecl;
begin
  CharUserFieldImpl(this).set_(Status, newValue);
end;

var
  CharUserFieldImpl_vTable: CharUserFieldVTable;

constructor CharUserFieldImpl.create;
begin
  vTable := CharUserFieldImpl_vTable;
end;

function IntUserFieldImpl_enteredDispatcher(this: IntUserField): Integer; cdecl;
begin
  Result := IntUserFieldImpl(this).entered();
end;

function IntUserFieldImpl_specifiedDispatcher(this: IntUserField): Integer; cdecl;
begin
  Result := IntUserFieldImpl(this).specified();
end;

procedure IntUserFieldImpl_setEnteredDispatcher(this: IntUserField; Status: Status; newValue: Integer); cdecl;
begin
  IntUserFieldImpl(this).setEntered(Status, newValue);
end;

function IntUserFieldImpl_getDispatcher(this: IntUserField): Integer; cdecl;
begin
  Result := IntUserFieldImpl(this).get();
end;

procedure IntUserFieldImpl_set_Dispatcher(this: IntUserField; Status: Status; newValue: Integer); cdecl;
begin
  IntUserFieldImpl(this).set_(Status, newValue);
end;

var
  IntUserFieldImpl_vTable: IntUserFieldVTable;

constructor IntUserFieldImpl.create;
begin
  vTable := IntUserFieldImpl_vTable;
end;

function UserImpl_operationDispatcher(this: User): Cardinal; cdecl;
begin
  Result := UserImpl(this).operation();
end;

function UserImpl_userNameDispatcher(this: User): CharUserField; cdecl;
begin
  Result := UserImpl(this).userName();
end;

function UserImpl_passwordDispatcher(this: User): CharUserField; cdecl;
begin
  Result := UserImpl(this).password();
end;

function UserImpl_firstNameDispatcher(this: User): CharUserField; cdecl;
begin
  Result := UserImpl(this).firstName();
end;

function UserImpl_lastNameDispatcher(this: User): CharUserField; cdecl;
begin
  Result := UserImpl(this).lastName();
end;

function UserImpl_middleNameDispatcher(this: User): CharUserField; cdecl;
begin
  Result := UserImpl(this).middleName();
end;

function UserImpl_commentDispatcher(this: User): CharUserField; cdecl;
begin
  Result := UserImpl(this).comment();
end;

function UserImpl_attributesDispatcher(this: User): CharUserField; cdecl;
begin
  Result := UserImpl(this).attributes();
end;

function UserImpl_activeDispatcher(this: User): IntUserField; cdecl;
begin
  Result := UserImpl(this).active();
end;

function UserImpl_adminDispatcher(this: User): IntUserField; cdecl;
begin
  Result := UserImpl(this).admin();
end;

procedure UserImpl_clearDispatcher(this: User; Status: Status); cdecl;
begin
  UserImpl(this).clear(Status);
end;

var
  UserImpl_vTable: UserVTable;

constructor UserImpl.create;
begin
  vTable := UserImpl_vTable;
end;

procedure ListUsersImpl_listDispatcher(this: ListUsers; Status: Status; User: User); cdecl;
begin
  ListUsersImpl(this).list(Status, User);
end;

var
  ListUsersImpl_vTable: ListUsersVTable;

constructor ListUsersImpl.create;
begin
  vTable := ListUsersImpl_vTable;
end;

function LogonInfoImpl_nameDispatcher(this: LogonInfo): PAnsiChar; cdecl;
begin
  Result := LogonInfoImpl(this).name();
end;

function LogonInfoImpl_roleDispatcher(this: LogonInfo): PAnsiChar; cdecl;
begin
  Result := LogonInfoImpl(this).role();
end;

function LogonInfoImpl_networkProtocolDispatcher(this: LogonInfo): PAnsiChar; cdecl;
begin
  Result := LogonInfoImpl(this).networkProtocol();
end;

function LogonInfoImpl_remoteAddressDispatcher(this: LogonInfo): PAnsiChar; cdecl;
begin
  Result := LogonInfoImpl(this).remoteAddress();
end;

function LogonInfoImpl_authBlockDispatcher(this: LogonInfo; length: CardinalPtr): BytePtr; cdecl;
begin
  Result := LogonInfoImpl(this).AuthBlock(length);
end;

function LogonInfoImpl_attachmentDispatcher(this: LogonInfo; Status: Status): Attachment; cdecl;
begin
  Result := LogonInfoImpl(this).Attachment(Status);
end;

function LogonInfoImpl_transactionDispatcher(this: LogonInfo; Status: Status): Transaction; cdecl;
begin
  Result := LogonInfoImpl(this).Transaction(Status);
end;

var
  LogonInfoImpl_vTable: LogonInfoVTable;

constructor LogonInfoImpl.create;
begin
  vTable := LogonInfoImpl_vTable;
end;

procedure ManagementImpl_addRefDispatcher(this: Management); cdecl;
begin
  ManagementImpl(this).addRef();
end;

function ManagementImpl_releaseDispatcher(this: Management): Integer; cdecl;
begin
  Result := ManagementImpl(this).release();
end;

procedure ManagementImpl_setOwnerDispatcher(this: Management; r: ReferenceCounted); cdecl;
begin
  ManagementImpl(this).setOwner(r);
end;

function ManagementImpl_getOwnerDispatcher(this: Management): ReferenceCounted; cdecl;
begin
  Result := ManagementImpl(this).getOwner();
end;

procedure ManagementImpl_startDispatcher(this: Management; Status: Status; LogonInfo: LogonInfo); cdecl;
begin
  ManagementImpl(this).start(Status, LogonInfo);
end;

function ManagementImpl_executeDispatcher(this: Management; Status: Status; User: User; callback: ListUsers): Integer; cdecl;
begin
  Result := ManagementImpl(this).execute(Status, User, callback);
end;

procedure ManagementImpl_commitDispatcher(this: Management; Status: Status); cdecl;
begin
  ManagementImpl(this).commit(Status);
end;

procedure ManagementImpl_rollbackDispatcher(this: Management; Status: Status); cdecl;
begin
  ManagementImpl(this).rollback(Status);
end;

var
  ManagementImpl_vTable: ManagementVTable;

constructor ManagementImpl.create;
begin
  vTable := ManagementImpl_vTable;
end;

function AuthBlockImpl_getTypeDispatcher(this: AuthBlock): PAnsiChar; cdecl;
begin
  Result := AuthBlockImpl(this).getType();
end;

function AuthBlockImpl_getNameDispatcher(this: AuthBlock): PAnsiChar; cdecl;
begin
  Result := AuthBlockImpl(this).getName();
end;

function AuthBlockImpl_getPluginDispatcher(this: AuthBlock): PAnsiChar; cdecl;
begin
  Result := AuthBlockImpl(this).getPlugin();
end;

function AuthBlockImpl_getSecurityDbDispatcher(this: AuthBlock): PAnsiChar; cdecl;
begin
  Result := AuthBlockImpl(this).getSecurityDb();
end;

function AuthBlockImpl_getOriginalPluginDispatcher(this: AuthBlock): PAnsiChar; cdecl;
begin
  Result := AuthBlockImpl(this).getOriginalPlugin();
end;

function AuthBlockImpl_nextDispatcher(this: AuthBlock; Status: Status): Boolean; cdecl;
begin
  Result := AuthBlockImpl(this).next(Status);
end;

function AuthBlockImpl_firstDispatcher(this: AuthBlock; Status: Status): Boolean; cdecl;
begin
  Result := AuthBlockImpl(this).first(Status);
end;

var
  AuthBlockImpl_vTable: AuthBlockVTable;

constructor AuthBlockImpl.create;
begin
  vTable := AuthBlockImpl_vTable;
end;

procedure WireCryptPluginImpl_addRefDispatcher(this: WireCryptPlugin); cdecl;
begin
  WireCryptPluginImpl(this).addRef();
end;

function WireCryptPluginImpl_releaseDispatcher(this: WireCryptPlugin): Integer; cdecl;
begin
  Result := WireCryptPluginImpl(this).release();
end;

procedure WireCryptPluginImpl_setOwnerDispatcher(this: WireCryptPlugin; r: ReferenceCounted); cdecl;
begin
  WireCryptPluginImpl(this).setOwner(r);
end;

function WireCryptPluginImpl_getOwnerDispatcher(this: WireCryptPlugin): ReferenceCounted; cdecl;
begin
  Result := WireCryptPluginImpl(this).getOwner();
end;

function WireCryptPluginImpl_getKnownTypesDispatcher(this: WireCryptPlugin; Status: Status): PAnsiChar; cdecl;
begin
  Result := WireCryptPluginImpl(this).getKnownTypes(Status);
end;

procedure WireCryptPluginImpl_setKeyDispatcher(this: WireCryptPlugin; Status: Status; key: CryptKey); cdecl;
begin
  WireCryptPluginImpl(this).setKey(Status, key);
end;

procedure WireCryptPluginImpl_encryptDispatcher(this: WireCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  WireCryptPluginImpl(this).encrypt(Status, length, from, to_);
end;

procedure WireCryptPluginImpl_decryptDispatcher(this: WireCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  WireCryptPluginImpl(this).decrypt(Status, length, from, to_);
end;

function WireCryptPluginImpl_getSpecificDataDispatcher(this: WireCryptPlugin; Status: Status; keyType: PAnsiChar; length: CardinalPtr)
  : BytePtr; cdecl;
begin
  Result := WireCryptPluginImpl(this).getSpecificData(Status, keyType, length);
end;

procedure WireCryptPluginImpl_setSpecificDataDispatcher(this: WireCryptPlugin; Status: Status; keyType: PAnsiChar; length: Cardinal;
  data: BytePtr); cdecl;
begin
  WireCryptPluginImpl(this).setSpecificData(Status, keyType, length, data);
end;

var
  WireCryptPluginImpl_vTable: WireCryptPluginVTable;

constructor WireCryptPluginImpl.create;
begin
  vTable := WireCryptPluginImpl_vTable;
end;

function CryptKeyCallbackImpl_callbackDispatcher(this: CryptKeyCallback; dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer)
  : Cardinal; cdecl;
begin
  Result := CryptKeyCallbackImpl(this).callback(dataLength, data, bufferLength, buffer);
end;

function CryptKeyCallbackImpl_afterAttachDispatcher(this: CryptKeyCallback; Status: Status; dbName: PAnsiChar; attStatus: Status): Cardinal; cdecl;
begin
  Result := CryptKeyCallbackImpl(this).afterAttach(Status, dbName, attStatus);
end;

function CryptKeyCallbackImpl.afterAttach(Status: Status; dbName: PAnsiChar; attStatus: Status): Cardinal;
begin
  Result := 0;
end;

procedure CryptKeyCallbackImpl_disposeDispatcher(this: CryptKeyCallback); cdecl;
begin
  CryptKeyCallbackImpl(this).dispose();
end;

procedure CryptKeyCallbackImpl.dispose();
begin
end;

var
  CryptKeyCallbackImpl_vTable: CryptKeyCallbackVTable;

constructor CryptKeyCallbackImpl.create;
begin
  vTable := CryptKeyCallbackImpl_vTable;
end;

procedure KeyHolderPluginImpl_addRefDispatcher(this: KeyHolderPlugin); cdecl;
begin
  KeyHolderPluginImpl(this).addRef();
end;

function KeyHolderPluginImpl_releaseDispatcher(this: KeyHolderPlugin): Integer; cdecl;
begin
  Result := KeyHolderPluginImpl(this).release();
end;

procedure KeyHolderPluginImpl_setOwnerDispatcher(this: KeyHolderPlugin; r: ReferenceCounted); cdecl;
begin
  KeyHolderPluginImpl(this).setOwner(r);
end;

function KeyHolderPluginImpl_getOwnerDispatcher(this: KeyHolderPlugin): ReferenceCounted; cdecl;
begin
  Result := KeyHolderPluginImpl(this).getOwner();
end;

function KeyHolderPluginImpl_keyCallbackDispatcher(this: KeyHolderPlugin; Status: Status; callback: CryptKeyCallback): Integer; cdecl;
begin
  Result := KeyHolderPluginImpl(this).keyCallback(Status, callback);
end;

function KeyHolderPluginImpl_keyHandleDispatcher(this: KeyHolderPlugin; Status: Status; keyName: PAnsiChar): CryptKeyCallback; cdecl;
begin
  Result := KeyHolderPluginImpl(this).keyHandle(Status, keyName);
end;

function KeyHolderPluginImpl_useOnlyOwnKeysDispatcher(this: KeyHolderPlugin; Status: Status): Boolean; cdecl;
begin
  Result := KeyHolderPluginImpl(this).useOnlyOwnKeys(Status);
end;

function KeyHolderPluginImpl_chainHandleDispatcher(this: KeyHolderPlugin; Status: Status): CryptKeyCallback; cdecl;
begin
  Result := KeyHolderPluginImpl(this).chainHandle(Status);
end;

var
  KeyHolderPluginImpl_vTable: KeyHolderPluginVTable;

constructor KeyHolderPluginImpl.create;
begin
  vTable := KeyHolderPluginImpl_vTable;
end;

procedure DbCryptInfoImpl_addRefDispatcher(this: DbCryptInfo); cdecl;
begin
  DbCryptInfoImpl(this).addRef();
end;

function DbCryptInfoImpl_releaseDispatcher(this: DbCryptInfo): Integer; cdecl;
begin
  Result := DbCryptInfoImpl(this).release();
end;

function DbCryptInfoImpl_getDatabaseFullPathDispatcher(this: DbCryptInfo; Status: Status): PAnsiChar; cdecl;
begin
  Result := DbCryptInfoImpl(this).getDatabaseFullPath(Status);
end;

var
  DbCryptInfoImpl_vTable: DbCryptInfoVTable;

constructor DbCryptInfoImpl.create;
begin
  vTable := DbCryptInfoImpl_vTable;
end;

procedure DbCryptPluginImpl_addRefDispatcher(this: DbCryptPlugin); cdecl;
begin
  DbCryptPluginImpl(this).addRef();
end;

function DbCryptPluginImpl_releaseDispatcher(this: DbCryptPlugin): Integer; cdecl;
begin
  Result := DbCryptPluginImpl(this).release();
end;

procedure DbCryptPluginImpl_setOwnerDispatcher(this: DbCryptPlugin; r: ReferenceCounted); cdecl;
begin
  DbCryptPluginImpl(this).setOwner(r);
end;

function DbCryptPluginImpl_getOwnerDispatcher(this: DbCryptPlugin): ReferenceCounted; cdecl;
begin
  Result := DbCryptPluginImpl(this).getOwner();
end;

procedure DbCryptPluginImpl_setKeyDispatcher(this: DbCryptPlugin; Status: Status; length: Cardinal; sources: KeyHolderPluginPtr;
  keyName: PAnsiChar); cdecl;
begin
  DbCryptPluginImpl(this).setKey(Status, length, sources, keyName);
end;

procedure DbCryptPluginImpl_encryptDispatcher(this: DbCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  DbCryptPluginImpl(this).encrypt(Status, length, from, to_);
end;

procedure DbCryptPluginImpl_decryptDispatcher(this: DbCryptPlugin; Status: Status; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  DbCryptPluginImpl(this).decrypt(Status, length, from, to_);
end;

procedure DbCryptPluginImpl_setInfoDispatcher(this: DbCryptPlugin; Status: Status; info: DbCryptInfo); cdecl;
begin
  DbCryptPluginImpl(this).setInfo(Status, info);
end;

var
  DbCryptPluginImpl_vTable: DbCryptPluginVTable;

constructor DbCryptPluginImpl.create;
begin
  vTable := DbCryptPluginImpl_vTable;
end;

function ExternalContextImpl_getMasterDispatcher(this: ExternalContext): Master; cdecl;
begin
  Result := ExternalContextImpl(this).getMaster();
end;

function ExternalContextImpl_getEngineDispatcher(this: ExternalContext; Status: Status): ExternalEngine; cdecl;
begin
  Result := ExternalContextImpl(this).getEngine(Status);
end;

function ExternalContextImpl_getAttachmentDispatcher(this: ExternalContext; Status: Status): Attachment; cdecl;
begin
  Result := ExternalContextImpl(this).getAttachment(Status);
end;

function ExternalContextImpl_getTransactionDispatcher(this: ExternalContext; Status: Status): Transaction; cdecl;
begin
  Result := ExternalContextImpl(this).getTransaction(Status);
end;

function ExternalContextImpl_getUserNameDispatcher(this: ExternalContext): PAnsiChar; cdecl;
begin
  Result := ExternalContextImpl(this).getUserName();
end;

function ExternalContextImpl_getDatabaseNameDispatcher(this: ExternalContext): PAnsiChar; cdecl;
begin
  Result := ExternalContextImpl(this).getDatabaseName();
end;

function ExternalContextImpl_getClientCharSetDispatcher(this: ExternalContext): PAnsiChar; cdecl;
begin
  Result := ExternalContextImpl(this).getClientCharSet();
end;

function ExternalContextImpl_obtainInfoCodeDispatcher(this: ExternalContext): Integer; cdecl;
begin
  Result := ExternalContextImpl(this).obtainInfoCode();
end;

function ExternalContextImpl_getInfoDispatcher(this: ExternalContext; code: Integer): Pointer; cdecl;
begin
  Result := ExternalContextImpl(this).getInfo(code);
end;

function ExternalContextImpl_setInfoDispatcher(this: ExternalContext; code: Integer; value: Pointer): Pointer; cdecl;
begin
  Result := ExternalContextImpl(this).setInfo(code, value);
end;

var
  ExternalContextImpl_vTable: ExternalContextVTable;

constructor ExternalContextImpl.create;
begin
  vTable := ExternalContextImpl_vTable;
end;

procedure ExternalResultSetImpl_disposeDispatcher(this: ExternalResultSet); cdecl;
begin
  ExternalResultSetImpl(this).dispose();
end;

function ExternalResultSetImpl_fetchDispatcher(this: ExternalResultSet; Status: Status): Boolean; cdecl;
begin
  Result := ExternalResultSetImpl(this).fetch(Status);
end;

var
  ExternalResultSetImpl_vTable: ExternalResultSetVTable;

constructor ExternalResultSetImpl.create;
begin
  vTable := ExternalResultSetImpl_vTable;
end;

procedure ExternalFunctionImpl_disposeDispatcher(this: ExternalFunction); cdecl;
begin
  ExternalFunctionImpl(this).dispose();
end;

procedure ExternalFunctionImpl_getCharSetDispatcher(this: ExternalFunction; Status: Status; context: ExternalContext; name: PAnsiChar;
  nameSize: Cardinal); cdecl;
begin
  ExternalFunctionImpl(this).getCharSet(Status, context, name, nameSize);
end;

procedure ExternalFunctionImpl_executeDispatcher(this: ExternalFunction; Status: Status; context: ExternalContext; inMsg: Pointer;
  outMsg: Pointer); cdecl;
begin
  ExternalFunctionImpl(this).execute(Status, context, inMsg, outMsg);
end;

var
  ExternalFunctionImpl_vTable: ExternalFunctionVTable;

constructor ExternalFunctionImpl.create;
begin
  vTable := ExternalFunctionImpl_vTable;
end;

procedure ExternalProcedureImpl_disposeDispatcher(this: ExternalProcedure); cdecl;
begin
  ExternalProcedureImpl(this).dispose();
end;

procedure ExternalProcedureImpl_getCharSetDispatcher(this: ExternalProcedure; Status: Status; context: ExternalContext; name: PAnsiChar;
  nameSize: Cardinal); cdecl;
begin
  ExternalProcedureImpl(this).getCharSet(Status, context, name, nameSize);
end;

function ExternalProcedureImpl_openDispatcher(this: ExternalProcedure; Status: Status; context: ExternalContext; inMsg: Pointer; outMsg: Pointer)
  : ExternalResultSet; cdecl;
begin
  Result := ExternalProcedureImpl(this).open(Status, context, inMsg, outMsg);
end;

var
  ExternalProcedureImpl_vTable: ExternalProcedureVTable;

constructor ExternalProcedureImpl.create;
begin
  vTable := ExternalProcedureImpl_vTable;
end;

procedure ExternalTriggerImpl_disposeDispatcher(this: ExternalTrigger); cdecl;
begin
  ExternalTriggerImpl(this).dispose();
end;

procedure ExternalTriggerImpl_getCharSetDispatcher(this: ExternalTrigger; Status: Status; context: ExternalContext; name: PAnsiChar;
  nameSize: Cardinal); cdecl;
begin
  ExternalTriggerImpl(this).getCharSet(Status, context, name, nameSize);
end;

procedure ExternalTriggerImpl_executeDispatcher(this: ExternalTrigger; Status: Status; context: ExternalContext; action: Cardinal; oldMsg: Pointer;
  newMsg: Pointer); cdecl;
begin
  ExternalTriggerImpl(this).execute(Status, context, action, oldMsg, newMsg);
end;

var
  ExternalTriggerImpl_vTable: ExternalTriggerVTable;

constructor ExternalTriggerImpl.create;
begin
  vTable := ExternalTriggerImpl_vTable;
end;

function RoutineMetadataImpl_getPackageDispatcher(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
begin
  Result := RoutineMetadataImpl(this).getPackage(Status);
end;

function RoutineMetadataImpl_getNameDispatcher(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
begin
  Result := RoutineMetadataImpl(this).getName(Status);
end;

function RoutineMetadataImpl_getEntryPointDispatcher(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
begin
  Result := RoutineMetadataImpl(this).getEntryPoint(Status);
end;

function RoutineMetadataImpl_getBodyDispatcher(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
begin
  Result := RoutineMetadataImpl(this).getBody(Status);
end;

function RoutineMetadataImpl_getInputMetadataDispatcher(this: RoutineMetadata; Status: Status): MessageMetadata; cdecl;
begin
  Result := RoutineMetadataImpl(this).getInputMetadata(Status);
end;

function RoutineMetadataImpl_getOutputMetadataDispatcher(this: RoutineMetadata; Status: Status): MessageMetadata; cdecl;
begin
  Result := RoutineMetadataImpl(this).getOutputMetadata(Status);
end;

function RoutineMetadataImpl_getTriggerMetadataDispatcher(this: RoutineMetadata; Status: Status): MessageMetadata; cdecl;
begin
  Result := RoutineMetadataImpl(this).getTriggerMetadata(Status);
end;

function RoutineMetadataImpl_getTriggerTableDispatcher(this: RoutineMetadata; Status: Status): PAnsiChar; cdecl;
begin
  Result := RoutineMetadataImpl(this).getTriggerTable(Status);
end;

function RoutineMetadataImpl_getTriggerTypeDispatcher(this: RoutineMetadata; Status: Status): Cardinal; cdecl;
begin
  Result := RoutineMetadataImpl(this).getTriggerType(Status);
end;

var
  RoutineMetadataImpl_vTable: RoutineMetadataVTable;

constructor RoutineMetadataImpl.create;
begin
  vTable := RoutineMetadataImpl_vTable;
end;

procedure ExternalEngineImpl_addRefDispatcher(this: ExternalEngine); cdecl;
begin
  ExternalEngineImpl(this).addRef();
end;

function ExternalEngineImpl_releaseDispatcher(this: ExternalEngine): Integer; cdecl;
begin
  Result := ExternalEngineImpl(this).release();
end;

procedure ExternalEngineImpl_setOwnerDispatcher(this: ExternalEngine; r: ReferenceCounted); cdecl;
begin
  ExternalEngineImpl(this).setOwner(r);
end;

function ExternalEngineImpl_getOwnerDispatcher(this: ExternalEngine): ReferenceCounted; cdecl;
begin
  Result := ExternalEngineImpl(this).getOwner();
end;

procedure ExternalEngineImpl_openDispatcher(this: ExternalEngine; Status: Status; context: ExternalContext; charSet: PAnsiChar;
  charSetSize: Cardinal); cdecl;
begin
  ExternalEngineImpl(this).open(Status, context, charSet, charSetSize);
end;

procedure ExternalEngineImpl_openAttachmentDispatcher(this: ExternalEngine; Status: Status; context: ExternalContext); cdecl;
begin
  ExternalEngineImpl(this).openAttachment(Status, context);
end;

procedure ExternalEngineImpl_closeAttachmentDispatcher(this: ExternalEngine; Status: Status; context: ExternalContext); cdecl;
begin
  ExternalEngineImpl(this).closeAttachment(Status, context);
end;

function ExternalEngineImpl_makeFunctionDispatcher(this: ExternalEngine; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
  inBuilder: MetadataBuilder; outBuilder: MetadataBuilder): ExternalFunction; cdecl;
begin
  Result := ExternalEngineImpl(this).makeFunction(Status, context, metadata, inBuilder, outBuilder);
end;

function ExternalEngineImpl_makeProcedureDispatcher(this: ExternalEngine; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
  inBuilder: MetadataBuilder; outBuilder: MetadataBuilder): ExternalProcedure; cdecl;
begin
  Result := ExternalEngineImpl(this).makeProcedure(Status, context, metadata, inBuilder, outBuilder);
end;

function ExternalEngineImpl_makeTriggerDispatcher(this: ExternalEngine; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
  fieldsBuilder: MetadataBuilder): ExternalTrigger; cdecl;
begin
  Result := ExternalEngineImpl(this).makeTrigger(Status, context, metadata, fieldsBuilder);
end;

var
  ExternalEngineImpl_vTable: ExternalEngineVTable;

constructor ExternalEngineImpl.create;
begin
  vTable := ExternalEngineImpl_vTable;
end;

procedure TimerImpl_addRefDispatcher(this: Timer); cdecl;
begin
  TimerImpl(this).addRef();
end;

function TimerImpl_releaseDispatcher(this: Timer): Integer; cdecl;
begin
  Result := TimerImpl(this).release();
end;

procedure TimerImpl_handlerDispatcher(this: Timer); cdecl;
begin
  TimerImpl(this).handler();
end;

var
  TimerImpl_vTable: TimerVTable;

constructor TimerImpl.create;
begin
  vTable := TimerImpl_vTable;
end;

procedure TimerControlImpl_startDispatcher(this: TimerControl; Status: Status; Timer: Timer; microSeconds: QWord); cdecl;
begin
  TimerControlImpl(this).start(Status, Timer, microSeconds);
end;

procedure TimerControlImpl_stopDispatcher(this: TimerControl; Status: Status; Timer: Timer); cdecl;
begin
  TimerControlImpl(this).stop(Status, Timer);
end;

var
  TimerControlImpl_vTable: TimerControlVTable;

constructor TimerControlImpl.create;
begin
  vTable := TimerControlImpl_vTable;
end;

procedure VersionCallbackImpl_callbackDispatcher(this: VersionCallback; Status: Status; text: PAnsiChar); cdecl;
begin
  VersionCallbackImpl(this).callback(Status, text);
end;

var
  VersionCallbackImpl_vTable: VersionCallbackVTable;

constructor VersionCallbackImpl.create;
begin
  vTable := VersionCallbackImpl_vTable;
end;

procedure UtilImpl_getFbVersionDispatcher(this: Util; Status: Status; att: Attachment; callback: VersionCallback); cdecl;
begin
  UtilImpl(this).getFbVersion(Status, att, callback);
end;

procedure UtilImpl_loadBlobDispatcher(this: Util; Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar;
  txt: Boolean); cdecl;
begin
  UtilImpl(this).loadBlob(Status, blobId, att, tra, file_, txt);
end;

procedure UtilImpl_dumpBlobDispatcher(this: Util; Status: Status; blobId: ISC_QUADPtr; att: Attachment; tra: Transaction; file_: PAnsiChar;
  txt: Boolean); cdecl;
begin
  UtilImpl(this).dumpBlob(Status, blobId, att, tra, file_, txt);
end;

procedure UtilImpl_getPerfCountersDispatcher(this: Util; Status: Status; att: Attachment; countersSet: PAnsiChar; counters: Int64Ptr); cdecl;
begin
  UtilImpl(this).getPerfCounters(Status, att, countersSet, counters);
end;

function UtilImpl_executeCreateDatabaseDispatcher(this: Util; Status: Status; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal;
  stmtIsCreateDb: BooleanPtr): Attachment; cdecl;
begin
  Result := UtilImpl(this).executeCreateDatabase(Status, stmtLength, creatDBstatement, dialect, stmtIsCreateDb);
end;

procedure UtilImpl_decodeDateDispatcher(this: Util; date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr); cdecl;
begin
  UtilImpl(this).decodeDate(date, year, month, day);
end;

procedure UtilImpl_decodeTimeDispatcher(this: Util; time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
  fractions: CardinalPtr); cdecl;
begin
  UtilImpl(this).decodeTime(time, hours, minutes, seconds, fractions);
end;

function UtilImpl_encodeDateDispatcher(this: Util; year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE; cdecl;
begin
  Result := UtilImpl(this).encodeDate(year, month, day);
end;

function UtilImpl_encodeTimeDispatcher(this: Util; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME; cdecl;
begin
  Result := UtilImpl(this).encodeTime(hours, minutes, seconds, fractions);
end;

function UtilImpl_formatStatusDispatcher(this: Util; buffer: PAnsiChar; bufferSize: Cardinal; Status: Status): Cardinal; cdecl;
begin
  Result := UtilImpl(this).formatStatus(buffer, bufferSize, Status);
end;

function UtilImpl_getClientVersionDispatcher(this: Util): Cardinal; cdecl;
begin
  Result := UtilImpl(this).getClientVersion();
end;

function UtilImpl_getXpbBuilderDispatcher(this: Util; Status: Status; kind: Cardinal; buf: BytePtr; len: Cardinal): XpbBuilder; cdecl;
begin
  Result := UtilImpl(this).getXpbBuilder(Status, kind, buf, len);
end;

function UtilImpl_setOffsetsDispatcher(this: Util; Status: Status; metadata: MessageMetadata; callback: OffsetsCallback): Cardinal; cdecl;
begin
  Result := UtilImpl(this).setOffsets(Status, metadata, callback);
end;

function UtilImpl_getDecFloat16Dispatcher(this: Util; Status: Status): DecFloat16; cdecl;
begin
  Result := UtilImpl(this).getDecFloat16(Status);
end;

function UtilImpl_getDecFloat34Dispatcher(this: Util; Status: Status): DecFloat34; cdecl;
begin
  Result := UtilImpl(this).getDecFloat34(Status);
end;

procedure UtilImpl_decodeTimeTzDispatcher(this: Util; Status: Status; timeTz: ISC_TIME_TZPtr; hours: CardinalPtr; minutes: CardinalPtr;
  seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar); cdecl;
begin
  UtilImpl(this).decodeTimeTz(Status, timeTz, hours, minutes, seconds, fractions, timeZoneBufferLength, timeZoneBuffer);
end;

procedure UtilImpl_decodeTimeStampTzDispatcher(this: Util; Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: CardinalPtr; month: CardinalPtr;
  day: CardinalPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal;
  timeZoneBuffer: PAnsiChar); cdecl;
begin
  UtilImpl(this).decodeTimeStampTz(Status, timeStampTz, year, month, day, hours, minutes, seconds, fractions, timeZoneBufferLength, timeZoneBuffer);
end;

procedure UtilImpl_encodeTimeTzDispatcher(this: Util; Status: Status; timeTz: ISC_TIME_TZPtr; hours: Cardinal; minutes: Cardinal; seconds: Cardinal;
  fractions: Cardinal; timeZone: PAnsiChar); cdecl;
begin
  UtilImpl(this).encodeTimeTz(Status, timeTz, hours, minutes, seconds, fractions, timeZone);
end;

procedure UtilImpl_encodeTimeStampTzDispatcher(this: Util; Status: Status; timeStampTz: ISC_TIMESTAMP_TZPtr; year: Cardinal; month: Cardinal;
  day: Cardinal; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal; timeZone: PAnsiChar); cdecl;
begin
  UtilImpl(this).encodeTimeStampTz(Status, timeStampTz, year, month, day, hours, minutes, seconds, fractions, timeZone);
end;

function UtilImpl_getInt128Dispatcher(this: Util; Status: Status): Int128; cdecl;
begin
  Result := UtilImpl(this).getInt128(Status);
end;

procedure UtilImpl_decodeTimeTzExDispatcher(this: Util; Status: Status; timeTz: ISC_TIME_TZ_EXPtr; hours: CardinalPtr; minutes: CardinalPtr;
  seconds: CardinalPtr; fractions: CardinalPtr; timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar); cdecl;
begin
  UtilImpl(this).decodeTimeTzEx(Status, timeTz, hours, minutes, seconds, fractions, timeZoneBufferLength, timeZoneBuffer);
end;

procedure UtilImpl_decodeTimeStampTzExDispatcher(this: Util; Status: Status; timeStampTz: ISC_TIMESTAMP_TZ_EXPtr; year: CardinalPtr;
  month: CardinalPtr; day: CardinalPtr; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr;
  timeZoneBufferLength: Cardinal; timeZoneBuffer: PAnsiChar); cdecl;
begin
  UtilImpl(this).decodeTimeStampTzEx(Status, timeStampTz, year, month, day, hours, minutes, seconds, fractions, timeZoneBufferLength, timeZoneBuffer);
end;

var
  UtilImpl_vTable: UtilVTable;

constructor UtilImpl.create;
begin
  vTable := UtilImpl_vTable;
end;

procedure OffsetsCallbackImpl_setOffsetDispatcher(this: OffsetsCallback; Status: Status; index: Cardinal; offset: Cardinal;
  nullOffset: Cardinal); cdecl;
begin
  OffsetsCallbackImpl(this).setOffset(Status, index, offset, nullOffset);
end;

var
  OffsetsCallbackImpl_vTable: OffsetsCallbackVTable;

constructor OffsetsCallbackImpl.create;
begin
  vTable := OffsetsCallbackImpl_vTable;
end;

procedure XpbBuilderImpl_disposeDispatcher(this: XpbBuilder); cdecl;
begin
  XpbBuilderImpl(this).dispose();
end;

procedure XpbBuilderImpl_clearDispatcher(this: XpbBuilder; Status: Status); cdecl;
begin
  XpbBuilderImpl(this).clear(Status);
end;

procedure XpbBuilderImpl_removeCurrentDispatcher(this: XpbBuilder; Status: Status); cdecl;
begin
  XpbBuilderImpl(this).removeCurrent(Status);
end;

procedure XpbBuilderImpl_insertIntDispatcher(this: XpbBuilder; Status: Status; tag: Byte; value: Integer); cdecl;
begin
  XpbBuilderImpl(this).insertInt(Status, tag, value);
end;

procedure XpbBuilderImpl_insertBigIntDispatcher(this: XpbBuilder; Status: Status; tag: Byte; value: Int64); cdecl;
begin
  XpbBuilderImpl(this).insertBigInt(Status, tag, value);
end;

procedure XpbBuilderImpl_insertBytesDispatcher(this: XpbBuilder; Status: Status; tag: Byte; bytes: Pointer; length: Cardinal); cdecl;
begin
  XpbBuilderImpl(this).insertBytes(Status, tag, bytes, length);
end;

procedure XpbBuilderImpl_insertStringDispatcher(this: XpbBuilder; Status: Status; tag: Byte; str: PAnsiChar); cdecl;
begin
  XpbBuilderImpl(this).insertString(Status, tag, str);
end;

procedure XpbBuilderImpl_insertTagDispatcher(this: XpbBuilder; Status: Status; tag: Byte); cdecl;
begin
  XpbBuilderImpl(this).insertTag(Status, tag);
end;

function XpbBuilderImpl_isEofDispatcher(this: XpbBuilder; Status: Status): Boolean; cdecl;
begin
  Result := XpbBuilderImpl(this).isEof(Status);
end;

procedure XpbBuilderImpl_moveNextDispatcher(this: XpbBuilder; Status: Status); cdecl;
begin
  XpbBuilderImpl(this).moveNext(Status);
end;

procedure XpbBuilderImpl_rewindDispatcher(this: XpbBuilder; Status: Status); cdecl;
begin
  XpbBuilderImpl(this).rewind(Status);
end;

function XpbBuilderImpl_findFirstDispatcher(this: XpbBuilder; Status: Status; tag: Byte): Boolean; cdecl;
begin
  Result := XpbBuilderImpl(this).findFirst(Status, tag);
end;

function XpbBuilderImpl_findNextDispatcher(this: XpbBuilder; Status: Status): Boolean; cdecl;
begin
  Result := XpbBuilderImpl(this).findNext(Status);
end;

function XpbBuilderImpl_getTagDispatcher(this: XpbBuilder; Status: Status): Byte; cdecl;
begin
  Result := XpbBuilderImpl(this).getTag(Status);
end;

function XpbBuilderImpl_getLengthDispatcher(this: XpbBuilder; Status: Status): Cardinal; cdecl;
begin
  Result := XpbBuilderImpl(this).getLength(Status);
end;

function XpbBuilderImpl_getIntDispatcher(this: XpbBuilder; Status: Status): Integer; cdecl;
begin
  Result := XpbBuilderImpl(this).getInt(Status);
end;

function XpbBuilderImpl_getBigIntDispatcher(this: XpbBuilder; Status: Status): Int64; cdecl;
begin
  Result := XpbBuilderImpl(this).getBigInt(Status);
end;

function XpbBuilderImpl_getStringDispatcher(this: XpbBuilder; Status: Status): PAnsiChar; cdecl;
begin
  Result := XpbBuilderImpl(this).getString(Status);
end;

function XpbBuilderImpl_getBytesDispatcher(this: XpbBuilder; Status: Status): BytePtr; cdecl;
begin
  Result := XpbBuilderImpl(this).getBytes(Status);
end;

function XpbBuilderImpl_getBufferLengthDispatcher(this: XpbBuilder; Status: Status): Cardinal; cdecl;
begin
  Result := XpbBuilderImpl(this).getBufferLength(Status);
end;

function XpbBuilderImpl_getBufferDispatcher(this: XpbBuilder; Status: Status): BytePtr; cdecl;
begin
  Result := XpbBuilderImpl(this).getBuffer(Status);
end;

var
  XpbBuilderImpl_vTable: XpbBuilderVTable;

constructor XpbBuilderImpl.create;
begin
  vTable := XpbBuilderImpl_vTable;
end;

function TraceConnectionImpl_getKindDispatcher(this: TraceConnection): Cardinal; cdecl;
begin
  Result := TraceConnectionImpl(this).getKind();
end;

function TraceConnectionImpl_getProcessIDDispatcher(this: TraceConnection): Integer; cdecl;
begin
  Result := TraceConnectionImpl(this).getProcessID();
end;

function TraceConnectionImpl_getUserNameDispatcher(this: TraceConnection): PAnsiChar; cdecl;
begin
  Result := TraceConnectionImpl(this).getUserName();
end;

function TraceConnectionImpl_getRoleNameDispatcher(this: TraceConnection): PAnsiChar; cdecl;
begin
  Result := TraceConnectionImpl(this).getRoleName();
end;

function TraceConnectionImpl_getCharSetDispatcher(this: TraceConnection): PAnsiChar; cdecl;
begin
  Result := TraceConnectionImpl(this).getCharSet();
end;

function TraceConnectionImpl_getRemoteProtocolDispatcher(this: TraceConnection): PAnsiChar; cdecl;
begin
  Result := TraceConnectionImpl(this).getRemoteProtocol();
end;

function TraceConnectionImpl_getRemoteAddressDispatcher(this: TraceConnection): PAnsiChar; cdecl;
begin
  Result := TraceConnectionImpl(this).getRemoteAddress();
end;

function TraceConnectionImpl_getRemoteProcessIDDispatcher(this: TraceConnection): Integer; cdecl;
begin
  Result := TraceConnectionImpl(this).getRemoteProcessID();
end;

function TraceConnectionImpl_getRemoteProcessNameDispatcher(this: TraceConnection): PAnsiChar; cdecl;
begin
  Result := TraceConnectionImpl(this).getRemoteProcessName();
end;

var
  TraceConnectionImpl_vTable: TraceConnectionVTable;

constructor TraceConnectionImpl.create;
begin
  vTable := TraceConnectionImpl_vTable;
end;

function TraceDatabaseConnectionImpl_getKindDispatcher(this: TraceDatabaseConnection): Cardinal; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getKind();
end;

function TraceDatabaseConnectionImpl_getProcessIDDispatcher(this: TraceDatabaseConnection): Integer; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getProcessID();
end;

function TraceDatabaseConnectionImpl_getUserNameDispatcher(this: TraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getUserName();
end;

function TraceDatabaseConnectionImpl_getRoleNameDispatcher(this: TraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getRoleName();
end;

function TraceDatabaseConnectionImpl_getCharSetDispatcher(this: TraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getCharSet();
end;

function TraceDatabaseConnectionImpl_getRemoteProtocolDispatcher(this: TraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getRemoteProtocol();
end;

function TraceDatabaseConnectionImpl_getRemoteAddressDispatcher(this: TraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getRemoteAddress();
end;

function TraceDatabaseConnectionImpl_getRemoteProcessIDDispatcher(this: TraceDatabaseConnection): Integer; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getRemoteProcessID();
end;

function TraceDatabaseConnectionImpl_getRemoteProcessNameDispatcher(this: TraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getRemoteProcessName();
end;

function TraceDatabaseConnectionImpl_getConnectionIDDispatcher(this: TraceDatabaseConnection): Int64; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getConnectionID();
end;

function TraceDatabaseConnectionImpl_getDatabaseNameDispatcher(this: TraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := TraceDatabaseConnectionImpl(this).getDatabaseName();
end;

var
  TraceDatabaseConnectionImpl_vTable: TraceDatabaseConnectionVTable;

constructor TraceDatabaseConnectionImpl.create;
begin
  vTable := TraceDatabaseConnectionImpl_vTable;
end;

function TraceTransactionImpl_getTransactionIDDispatcher(this: TraceTransaction): Int64; cdecl;
begin
  Result := TraceTransactionImpl(this).getTransactionID();
end;

function TraceTransactionImpl_getReadOnlyDispatcher(this: TraceTransaction): Boolean; cdecl;
begin
  Result := TraceTransactionImpl(this).getReadOnly();
end;

function TraceTransactionImpl_getWaitDispatcher(this: TraceTransaction): Integer; cdecl;
begin
  Result := TraceTransactionImpl(this).getWait();
end;

function TraceTransactionImpl_getIsolationDispatcher(this: TraceTransaction): Cardinal; cdecl;
begin
  Result := TraceTransactionImpl(this).getIsolation();
end;

function TraceTransactionImpl_getPerfDispatcher(this: TraceTransaction): PerformanceInfoPtr; cdecl;
begin
  Result := TraceTransactionImpl(this).getPerf();
end;

function TraceTransactionImpl_getInitialIDDispatcher(this: TraceTransaction): Int64; cdecl;
begin
  Result := TraceTransactionImpl(this).getInitialID();
end;

function TraceTransactionImpl_getPreviousIDDispatcher(this: TraceTransaction): Int64; cdecl;
begin
  Result := TraceTransactionImpl(this).getPreviousID();
end;

var
  TraceTransactionImpl_vTable: TraceTransactionVTable;

constructor TraceTransactionImpl.create;
begin
  vTable := TraceTransactionImpl_vTable;
end;

function TraceParamsImpl_getCountDispatcher(this: TraceParams): Cardinal; cdecl;
begin
  Result := TraceParamsImpl(this).getCount();
end;

function TraceParamsImpl_getParamDispatcher(this: TraceParams; idx: Cardinal): dscPtr; cdecl;
begin
  Result := TraceParamsImpl(this).getParam(idx);
end;

function TraceParamsImpl_getTextUTF8Dispatcher(this: TraceParams; Status: Status; idx: Cardinal): PAnsiChar; cdecl;
begin
  Result := TraceParamsImpl(this).getTextUTF8(Status, idx);
end;

var
  TraceParamsImpl_vTable: TraceParamsVTable;

constructor TraceParamsImpl.create;
begin
  vTable := TraceParamsImpl_vTable;
end;

function TraceStatementImpl_getStmtIDDispatcher(this: TraceStatement): Int64; cdecl;
begin
  Result := TraceStatementImpl(this).getStmtID();
end;

function TraceStatementImpl_getPerfDispatcher(this: TraceStatement): PerformanceInfoPtr; cdecl;
begin
  Result := TraceStatementImpl(this).getPerf();
end;

var
  TraceStatementImpl_vTable: TraceStatementVTable;

constructor TraceStatementImpl.create;
begin
  vTable := TraceStatementImpl_vTable;
end;

function TraceSQLStatementImpl_getStmtIDDispatcher(this: TraceSQLStatement): Int64; cdecl;
begin
  Result := TraceSQLStatementImpl(this).getStmtID();
end;

function TraceSQLStatementImpl_getPerfDispatcher(this: TraceSQLStatement): PerformanceInfoPtr; cdecl;
begin
  Result := TraceSQLStatementImpl(this).getPerf();
end;

function TraceSQLStatementImpl_getTextDispatcher(this: TraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := TraceSQLStatementImpl(this).getText();
end;

function TraceSQLStatementImpl_getPlanDispatcher(this: TraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := TraceSQLStatementImpl(this).getPlan();
end;

function TraceSQLStatementImpl_getInputsDispatcher(this: TraceSQLStatement): TraceParams; cdecl;
begin
  Result := TraceSQLStatementImpl(this).getInputs();
end;

function TraceSQLStatementImpl_getTextUTF8Dispatcher(this: TraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := TraceSQLStatementImpl(this).getTextUTF8();
end;

function TraceSQLStatementImpl_getExplainedPlanDispatcher(this: TraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := TraceSQLStatementImpl(this).getExplainedPlan();
end;

var
  TraceSQLStatementImpl_vTable: TraceSQLStatementVTable;

constructor TraceSQLStatementImpl.create;
begin
  vTable := TraceSQLStatementImpl_vTable;
end;

function TraceBLRStatementImpl_getStmtIDDispatcher(this: TraceBLRStatement): Int64; cdecl;
begin
  Result := TraceBLRStatementImpl(this).getStmtID();
end;

function TraceBLRStatementImpl_getPerfDispatcher(this: TraceBLRStatement): PerformanceInfoPtr; cdecl;
begin
  Result := TraceBLRStatementImpl(this).getPerf();
end;

function TraceBLRStatementImpl_getDataDispatcher(this: TraceBLRStatement): BytePtr; cdecl;
begin
  Result := TraceBLRStatementImpl(this).getData();
end;

function TraceBLRStatementImpl_getDataLengthDispatcher(this: TraceBLRStatement): Cardinal; cdecl;
begin
  Result := TraceBLRStatementImpl(this).getDataLength();
end;

function TraceBLRStatementImpl_getTextDispatcher(this: TraceBLRStatement): PAnsiChar; cdecl;
begin
  Result := TraceBLRStatementImpl(this).getText();
end;

var
  TraceBLRStatementImpl_vTable: TraceBLRStatementVTable;

constructor TraceBLRStatementImpl.create;
begin
  vTable := TraceBLRStatementImpl_vTable;
end;

function TraceDYNRequestImpl_getDataDispatcher(this: TraceDYNRequest): BytePtr; cdecl;
begin
  Result := TraceDYNRequestImpl(this).getData();
end;

function TraceDYNRequestImpl_getDataLengthDispatcher(this: TraceDYNRequest): Cardinal; cdecl;
begin
  Result := TraceDYNRequestImpl(this).getDataLength();
end;

function TraceDYNRequestImpl_getTextDispatcher(this: TraceDYNRequest): PAnsiChar; cdecl;
begin
  Result := TraceDYNRequestImpl(this).getText();
end;

var
  TraceDYNRequestImpl_vTable: TraceDYNRequestVTable;

constructor TraceDYNRequestImpl.create;
begin
  vTable := TraceDYNRequestImpl_vTable;
end;

function TraceContextVariableImpl_getNameSpaceDispatcher(this: TraceContextVariable): PAnsiChar; cdecl;
begin
  Result := TraceContextVariableImpl(this).getNameSpace();
end;

function TraceContextVariableImpl_getVarNameDispatcher(this: TraceContextVariable): PAnsiChar; cdecl;
begin
  Result := TraceContextVariableImpl(this).getVarName();
end;

function TraceContextVariableImpl_getVarValueDispatcher(this: TraceContextVariable): PAnsiChar; cdecl;
begin
  Result := TraceContextVariableImpl(this).getVarValue();
end;

var
  TraceContextVariableImpl_vTable: TraceContextVariableVTable;

constructor TraceContextVariableImpl.create;
begin
  vTable := TraceContextVariableImpl_vTable;
end;

function TraceProcedureImpl_getProcNameDispatcher(this: TraceProcedure): PAnsiChar; cdecl;
begin
  Result := TraceProcedureImpl(this).getProcName();
end;

function TraceProcedureImpl_getInputsDispatcher(this: TraceProcedure): TraceParams; cdecl;
begin
  Result := TraceProcedureImpl(this).getInputs();
end;

function TraceProcedureImpl_getPerfDispatcher(this: TraceProcedure): PerformanceInfoPtr; cdecl;
begin
  Result := TraceProcedureImpl(this).getPerf();
end;

function TraceProcedureImpl_getStmtIDDispatcher(this: TraceProcedure): Int64; cdecl;
begin
  Result := TraceProcedureImpl(this).getStmtID();
end;

function TraceProcedureImpl_getPlanDispatcher(this: TraceProcedure): PAnsiChar; cdecl;
begin
  Result := TraceProcedureImpl(this).getPlan();
end;

function TraceProcedureImpl_getExplainedPlanDispatcher(this: TraceProcedure): PAnsiChar; cdecl;
begin
  Result := TraceProcedureImpl(this).getExplainedPlan();
end;

var
  TraceProcedureImpl_vTable: TraceProcedureVTable;

constructor TraceProcedureImpl.create;
begin
  vTable := TraceProcedureImpl_vTable;
end;

function TraceFunctionImpl_getFuncNameDispatcher(this: TraceFunction): PAnsiChar; cdecl;
begin
  Result := TraceFunctionImpl(this).getFuncName();
end;

function TraceFunctionImpl_getInputsDispatcher(this: TraceFunction): TraceParams; cdecl;
begin
  Result := TraceFunctionImpl(this).getInputs();
end;

function TraceFunctionImpl_getResultDispatcher(this: TraceFunction): TraceParams; cdecl;
begin
  Result := TraceFunctionImpl(this).getResult();
end;

function TraceFunctionImpl_getPerfDispatcher(this: TraceFunction): PerformanceInfoPtr; cdecl;
begin
  Result := TraceFunctionImpl(this).getPerf();
end;

function TraceFunctionImpl_getStmtIDDispatcher(this: TraceFunction): Int64; cdecl;
begin
  Result := TraceFunctionImpl(this).getStmtID();
end;

function TraceFunctionImpl_getPlanDispatcher(this: TraceFunction): PAnsiChar; cdecl;
begin
  Result := TraceFunctionImpl(this).getPlan();
end;

function TraceFunctionImpl_getExplainedPlanDispatcher(this: TraceFunction): PAnsiChar; cdecl;
begin
  Result := TraceFunctionImpl(this).getExplainedPlan();
end;

var
  TraceFunctionImpl_vTable: TraceFunctionVTable;

constructor TraceFunctionImpl.create;
begin
  vTable := TraceFunctionImpl_vTable;
end;

function TraceTriggerImpl_getTriggerNameDispatcher(this: TraceTrigger): PAnsiChar; cdecl;
begin
  Result := TraceTriggerImpl(this).getTriggerName();
end;

function TraceTriggerImpl_getRelationNameDispatcher(this: TraceTrigger): PAnsiChar; cdecl;
begin
  Result := TraceTriggerImpl(this).getRelationName();
end;

function TraceTriggerImpl_getActionDispatcher(this: TraceTrigger): Integer; cdecl;
begin
  Result := TraceTriggerImpl(this).getAction();
end;

function TraceTriggerImpl_getWhichDispatcher(this: TraceTrigger): Integer; cdecl;
begin
  Result := TraceTriggerImpl(this).getWhich();
end;

function TraceTriggerImpl_getPerfDispatcher(this: TraceTrigger): PerformanceInfoPtr; cdecl;
begin
  Result := TraceTriggerImpl(this).getPerf();
end;

function TraceTriggerImpl_getStmtIDDispatcher(this: TraceTrigger): Int64; cdecl;
begin
  Result := TraceTriggerImpl(this).getStmtID();
end;

function TraceTriggerImpl_getPlanDispatcher(this: TraceTrigger): PAnsiChar; cdecl;
begin
  Result := TraceTriggerImpl(this).getPlan();
end;

function TraceTriggerImpl_getExplainedPlanDispatcher(this: TraceTrigger): PAnsiChar; cdecl;
begin
  Result := TraceTriggerImpl(this).getExplainedPlan();
end;

var
  TraceTriggerImpl_vTable: TraceTriggerVTable;

constructor TraceTriggerImpl.create;
begin
  vTable := TraceTriggerImpl_vTable;
end;

function TraceServiceConnectionImpl_getKindDispatcher(this: TraceServiceConnection): Cardinal; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getKind();
end;

function TraceServiceConnectionImpl_getProcessIDDispatcher(this: TraceServiceConnection): Integer; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getProcessID();
end;

function TraceServiceConnectionImpl_getUserNameDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getUserName();
end;

function TraceServiceConnectionImpl_getRoleNameDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getRoleName();
end;

function TraceServiceConnectionImpl_getCharSetDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getCharSet();
end;

function TraceServiceConnectionImpl_getRemoteProtocolDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getRemoteProtocol();
end;

function TraceServiceConnectionImpl_getRemoteAddressDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getRemoteAddress();
end;

function TraceServiceConnectionImpl_getRemoteProcessIDDispatcher(this: TraceServiceConnection): Integer; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getRemoteProcessID();
end;

function TraceServiceConnectionImpl_getRemoteProcessNameDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getRemoteProcessName();
end;

function TraceServiceConnectionImpl_getServiceIDDispatcher(this: TraceServiceConnection): Pointer; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getServiceID();
end;

function TraceServiceConnectionImpl_getServiceMgrDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getServiceMgr();
end;

function TraceServiceConnectionImpl_getServiceNameDispatcher(this: TraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := TraceServiceConnectionImpl(this).getServiceName();
end;

var
  TraceServiceConnectionImpl_vTable: TraceServiceConnectionVTable;

constructor TraceServiceConnectionImpl.create;
begin
  vTable := TraceServiceConnectionImpl_vTable;
end;

function TraceStatusVectorImpl_hasErrorDispatcher(this: TraceStatusVector): Boolean; cdecl;
begin
  Result := TraceStatusVectorImpl(this).hasError();
end;

function TraceStatusVectorImpl_hasWarningDispatcher(this: TraceStatusVector): Boolean; cdecl;
begin
  Result := TraceStatusVectorImpl(this).hasWarning();
end;

function TraceStatusVectorImpl_getStatusDispatcher(this: TraceStatusVector): Status; cdecl;
begin
  Result := TraceStatusVectorImpl(this).getStatus();
end;

function TraceStatusVectorImpl_getTextDispatcher(this: TraceStatusVector): PAnsiChar; cdecl;
begin
  Result := TraceStatusVectorImpl(this).getText();
end;

var
  TraceStatusVectorImpl_vTable: TraceStatusVectorVTable;

constructor TraceStatusVectorImpl.create;
begin
  vTable := TraceStatusVectorImpl_vTable;
end;

function TraceSweepInfoImpl_getOITDispatcher(this: TraceSweepInfo): Int64; cdecl;
begin
  Result := TraceSweepInfoImpl(this).getOIT();
end;

function TraceSweepInfoImpl_getOSTDispatcher(this: TraceSweepInfo): Int64; cdecl;
begin
  Result := TraceSweepInfoImpl(this).getOST();
end;

function TraceSweepInfoImpl_getOATDispatcher(this: TraceSweepInfo): Int64; cdecl;
begin
  Result := TraceSweepInfoImpl(this).getOAT();
end;

function TraceSweepInfoImpl_getNextDispatcher(this: TraceSweepInfo): Int64; cdecl;
begin
  Result := TraceSweepInfoImpl(this).getNext();
end;

function TraceSweepInfoImpl_getPerfDispatcher(this: TraceSweepInfo): PerformanceInfoPtr; cdecl;
begin
  Result := TraceSweepInfoImpl(this).getPerf();
end;

var
  TraceSweepInfoImpl_vTable: TraceSweepInfoVTable;

constructor TraceSweepInfoImpl.create;
begin
  vTable := TraceSweepInfoImpl_vTable;
end;

procedure TraceLogWriterImpl_addRefDispatcher(this: TraceLogWriter); cdecl;
begin
  TraceLogWriterImpl(this).addRef();
end;

function TraceLogWriterImpl_releaseDispatcher(this: TraceLogWriter): Integer; cdecl;
begin
  Result := TraceLogWriterImpl(this).release();
end;

function TraceLogWriterImpl_writeDispatcher(this: TraceLogWriter; buf: Pointer; size: Cardinal): Cardinal; cdecl;
begin
  Result := TraceLogWriterImpl(this).write(buf, size);
end;

function TraceLogWriterImpl_write_sDispatcher(this: TraceLogWriter; Status: Status; buf: Pointer; size: Cardinal): Cardinal; cdecl;
begin
  Result := TraceLogWriterImpl(this).write_s(Status, buf, size);
end;

var
  TraceLogWriterImpl_vTable: TraceLogWriterVTable;

constructor TraceLogWriterImpl.create;
begin
  vTable := TraceLogWriterImpl_vTable;
end;

function TraceInitInfoImpl_getConfigTextDispatcher(this: TraceInitInfo): PAnsiChar; cdecl;
begin
  Result := TraceInitInfoImpl(this).getConfigText();
end;

function TraceInitInfoImpl_getTraceSessionIDDispatcher(this: TraceInitInfo): Integer; cdecl;
begin
  Result := TraceInitInfoImpl(this).getTraceSessionID();
end;

function TraceInitInfoImpl_getTraceSessionNameDispatcher(this: TraceInitInfo): PAnsiChar; cdecl;
begin
  Result := TraceInitInfoImpl(this).getTraceSessionName();
end;

function TraceInitInfoImpl_getFirebirdRootDirectoryDispatcher(this: TraceInitInfo): PAnsiChar; cdecl;
begin
  Result := TraceInitInfoImpl(this).getFirebirdRootDirectory();
end;

function TraceInitInfoImpl_getDatabaseNameDispatcher(this: TraceInitInfo): PAnsiChar; cdecl;
begin
  Result := TraceInitInfoImpl(this).getDatabaseName();
end;

function TraceInitInfoImpl_getConnectionDispatcher(this: TraceInitInfo): TraceDatabaseConnection; cdecl;
begin
  Result := TraceInitInfoImpl(this).getConnection();
end;

function TraceInitInfoImpl_getLogWriterDispatcher(this: TraceInitInfo): TraceLogWriter; cdecl;
begin
  Result := TraceInitInfoImpl(this).getLogWriter();
end;

var
  TraceInitInfoImpl_vTable: TraceInitInfoVTable;

constructor TraceInitInfoImpl.create;
begin
  vTable := TraceInitInfoImpl_vTable;
end;

procedure TracePluginImpl_addRefDispatcher(this: TracePlugin); cdecl;
begin
  TracePluginImpl(this).addRef();
end;

function TracePluginImpl_releaseDispatcher(this: TracePlugin): Integer; cdecl;
begin
  Result := TracePluginImpl(this).release();
end;

function TracePluginImpl_trace_get_errorDispatcher(this: TracePlugin): PAnsiChar; cdecl;
begin
  Result := TracePluginImpl(this).trace_get_error();
end;

function TracePluginImpl_trace_attachDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; create_db: Boolean; att_result: Cardinal)
  : Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_attach(connection, create_db, att_result);
end;

function TracePluginImpl_trace_detachDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; drop_db: Boolean): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_detach(connection, drop_db);
end;

function TracePluginImpl_trace_transaction_startDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  tpb_length: Cardinal; tpb: BytePtr; tra_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_transaction_start(connection, Transaction, tpb_length, tpb, tra_result);
end;

function TracePluginImpl_trace_transaction_endDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  commit: Boolean; retain_context: Boolean; tra_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_transaction_end(connection, Transaction, commit, retain_context, tra_result);
end;

function TracePluginImpl_trace_proc_executeDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  procedure_: TraceProcedure; started: Boolean; proc_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_proc_execute(connection, Transaction, procedure_, started, proc_result);
end;

function TracePluginImpl_trace_trigger_executeDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  trigger: TraceTrigger; started: Boolean; trig_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_trigger_execute(connection, Transaction, trigger, started, trig_result);
end;

function TracePluginImpl_trace_set_contextDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  variable: TraceContextVariable): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_set_context(connection, Transaction, variable);
end;

function TracePluginImpl_trace_dsql_prepareDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  Statement: TraceSQLStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_dsql_prepare(connection, Transaction, Statement, time_millis, req_result);
end;

function TracePluginImpl_trace_dsql_freeDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Statement: TraceSQLStatement;
  option: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_dsql_free(connection, Statement, option);
end;

function TracePluginImpl_trace_dsql_executeDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  Statement: TraceSQLStatement; started: Boolean; req_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_dsql_execute(connection, Transaction, Statement, started, req_result);
end;

function TracePluginImpl_trace_blr_compileDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  Statement: TraceBLRStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_blr_compile(connection, Transaction, Statement, time_millis, req_result);
end;

function TracePluginImpl_trace_blr_executeDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  Statement: TraceBLRStatement; req_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_blr_execute(connection, Transaction, Statement, req_result);
end;

function TracePluginImpl_trace_dyn_executeDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  Request: TraceDYNRequest; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_dyn_execute(connection, Transaction, Request, time_millis, req_result);
end;

function TracePluginImpl_trace_service_attachDispatcher(this: TracePlugin; Service: TraceServiceConnection; att_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_service_attach(Service, att_result);
end;

function TracePluginImpl_trace_service_startDispatcher(this: TracePlugin; Service: TraceServiceConnection; switches_length: Cardinal;
  switches: PAnsiChar; start_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_service_start(Service, switches_length, switches, start_result);
end;

function TracePluginImpl_trace_service_queryDispatcher(this: TracePlugin; Service: TraceServiceConnection; send_item_length: Cardinal;
  send_items: BytePtr; recv_item_length: Cardinal; recv_items: BytePtr; query_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_service_query(Service, send_item_length, send_items, recv_item_length, recv_items, query_result);
end;

function TracePluginImpl_trace_service_detachDispatcher(this: TracePlugin; Service: TraceServiceConnection; detach_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_service_detach(Service, detach_result);
end;

function TracePluginImpl_trace_event_errorDispatcher(this: TracePlugin; connection: TraceConnection; Status: TraceStatusVector; function_: PAnsiChar)
  : Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_event_error(connection, Status, function_);
end;

function TracePluginImpl_trace_event_sweepDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; sweep: TraceSweepInfo;
  sweep_state: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_event_sweep(connection, sweep, sweep_state);
end;

function TracePluginImpl_trace_func_executeDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  function_: TraceFunction; started: Boolean; func_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_func_execute(connection, Transaction, function_, started, func_result);
end;

function TracePluginImpl_trace_dsql_restartDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; Transaction: TraceTransaction;
  Statement: TraceSQLStatement; number: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_dsql_restart(connection, Transaction, Statement, number);
end;

function TracePluginImpl_trace_proc_compileDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; procedure_: TraceProcedure;
  time_millis: Int64; proc_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_proc_compile(connection, procedure_, time_millis, proc_result);
end;

function TracePluginImpl_trace_func_compileDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; function_: TraceFunction;
  time_millis: Int64; func_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_func_compile(connection, function_, time_millis, func_result);
end;

function TracePluginImpl_trace_trigger_compileDispatcher(this: TracePlugin; connection: TraceDatabaseConnection; trigger: TraceTrigger;
  time_millis: Int64; trig_result: Cardinal): Boolean; cdecl;
begin
  Result := TracePluginImpl(this).trace_trigger_compile(connection, trigger, time_millis, trig_result);
end;

var
  TracePluginImpl_vTable: TracePluginVTable;

constructor TracePluginImpl.create;
begin
  vTable := TracePluginImpl_vTable;
end;

procedure TraceFactoryImpl_addRefDispatcher(this: TraceFactory); cdecl;
begin
  TraceFactoryImpl(this).addRef();
end;

function TraceFactoryImpl_releaseDispatcher(this: TraceFactory): Integer; cdecl;
begin
  Result := TraceFactoryImpl(this).release();
end;

procedure TraceFactoryImpl_setOwnerDispatcher(this: TraceFactory; r: ReferenceCounted); cdecl;
begin
  TraceFactoryImpl(this).setOwner(r);
end;

function TraceFactoryImpl_getOwnerDispatcher(this: TraceFactory): ReferenceCounted; cdecl;
begin
  Result := TraceFactoryImpl(this).getOwner();
end;

function TraceFactoryImpl_trace_needsDispatcher(this: TraceFactory): QWord; cdecl;
begin
  Result := TraceFactoryImpl(this).trace_needs();
end;

function TraceFactoryImpl_trace_createDispatcher(this: TraceFactory; Status: Status; init_info: TraceInitInfo): TracePlugin; cdecl;
begin
  Result := TraceFactoryImpl(this).trace_create(Status, init_info);
end;

var
  TraceFactoryImpl_vTable: TraceFactoryVTable;

constructor TraceFactoryImpl.create;
begin
  vTable := TraceFactoryImpl_vTable;
end;

procedure UdrFunctionFactoryImpl_disposeDispatcher(this: UdrFunctionFactory); cdecl;
begin
  UdrFunctionFactoryImpl(this).dispose();
end;

procedure UdrFunctionFactoryImpl_setupDispatcher(this: UdrFunctionFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
  inBuilder: MetadataBuilder; outBuilder: MetadataBuilder); cdecl;
begin
  UdrFunctionFactoryImpl(this).setup(Status, context, metadata, inBuilder, outBuilder);
end;

function UdrFunctionFactoryImpl_newItemDispatcher(this: UdrFunctionFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata)
  : ExternalFunction; cdecl;
begin
  Result := UdrFunctionFactoryImpl(this).newItem(Status, context, metadata);
end;

var
  UdrFunctionFactoryImpl_vTable: UdrFunctionFactoryVTable;

constructor UdrFunctionFactoryImpl.create;
begin
  vTable := UdrFunctionFactoryImpl_vTable;
end;

procedure UdrProcedureFactoryImpl_disposeDispatcher(this: UdrProcedureFactory); cdecl;
begin
  UdrProcedureFactoryImpl(this).dispose();
end;

procedure UdrProcedureFactoryImpl_setupDispatcher(this: UdrProcedureFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
  inBuilder: MetadataBuilder; outBuilder: MetadataBuilder); cdecl;
begin
  UdrProcedureFactoryImpl(this).setup(Status, context, metadata, inBuilder, outBuilder);
end;

function UdrProcedureFactoryImpl_newItemDispatcher(this: UdrProcedureFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata)
  : ExternalProcedure; cdecl;
begin
  Result := UdrProcedureFactoryImpl(this).newItem(Status, context, metadata);
end;

var
  UdrProcedureFactoryImpl_vTable: UdrProcedureFactoryVTable;

constructor UdrProcedureFactoryImpl.create;
begin
  vTable := UdrProcedureFactoryImpl_vTable;
end;

procedure UdrTriggerFactoryImpl_disposeDispatcher(this: UdrTriggerFactory); cdecl;
begin
  UdrTriggerFactoryImpl(this).dispose();
end;

procedure UdrTriggerFactoryImpl_setupDispatcher(this: UdrTriggerFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata;
  fieldsBuilder: MetadataBuilder); cdecl;
begin
  UdrTriggerFactoryImpl(this).setup(Status, context, metadata, fieldsBuilder);
end;

function UdrTriggerFactoryImpl_newItemDispatcher(this: UdrTriggerFactory; Status: Status; context: ExternalContext; metadata: RoutineMetadata)
  : ExternalTrigger; cdecl;
begin
  Result := UdrTriggerFactoryImpl(this).newItem(Status, context, metadata);
end;

var
  UdrTriggerFactoryImpl_vTable: UdrTriggerFactoryVTable;

constructor UdrTriggerFactoryImpl.create;
begin
  vTable := UdrTriggerFactoryImpl_vTable;
end;

function UdrPluginImpl_getMasterDispatcher(this: UdrPlugin): Master; cdecl;
begin
  Result := UdrPluginImpl(this).getMaster();
end;

procedure UdrPluginImpl_registerFunctionDispatcher(this: UdrPlugin; Status: Status; name: PAnsiChar; factory: UdrFunctionFactory); cdecl;
begin
  UdrPluginImpl(this).registerFunction(Status, name, factory);
end;

procedure UdrPluginImpl_registerProcedureDispatcher(this: UdrPlugin; Status: Status; name: PAnsiChar; factory: UdrProcedureFactory); cdecl;
begin
  UdrPluginImpl(this).registerProcedure(Status, name, factory);
end;

procedure UdrPluginImpl_registerTriggerDispatcher(this: UdrPlugin; Status: Status; name: PAnsiChar; factory: UdrTriggerFactory); cdecl;
begin
  UdrPluginImpl(this).registerTrigger(Status, name, factory);
end;

var
  UdrPluginImpl_vTable: UdrPluginVTable;

constructor UdrPluginImpl.create;
begin
  vTable := UdrPluginImpl_vTable;
end;

procedure DecFloat16Impl_toBcdDispatcher(this: DecFloat16; from: FB_DEC16Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr); cdecl;
begin
  DecFloat16Impl(this).toBcd(from, sign, bcd, exp);
end;

procedure DecFloat16Impl_toStringDispatcher(this: DecFloat16; Status: Status; from: FB_DEC16Ptr; bufferLength: Cardinal; buffer: PAnsiChar); cdecl;
begin
  DecFloat16Impl(this).toString(Status, from, bufferLength, buffer);
end;

procedure DecFloat16Impl_fromBcdDispatcher(this: DecFloat16; sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC16Ptr); cdecl;
begin
  DecFloat16Impl(this).fromBcd(sign, bcd, exp, to_);
end;

procedure DecFloat16Impl_fromStringDispatcher(this: DecFloat16; Status: Status; from: PAnsiChar; to_: FB_DEC16Ptr); cdecl;
begin
  DecFloat16Impl(this).fromString(Status, from, to_);
end;

var
  DecFloat16Impl_vTable: DecFloat16VTable;

constructor DecFloat16Impl.create;
begin
  vTable := DecFloat16Impl_vTable;
end;

procedure DecFloat34Impl_toBcdDispatcher(this: DecFloat34; from: FB_DEC34Ptr; sign: IntegerPtr; bcd: BytePtr; exp: IntegerPtr); cdecl;
begin
  DecFloat34Impl(this).toBcd(from, sign, bcd, exp);
end;

procedure DecFloat34Impl_toStringDispatcher(this: DecFloat34; Status: Status; from: FB_DEC34Ptr; bufferLength: Cardinal; buffer: PAnsiChar); cdecl;
begin
  DecFloat34Impl(this).toString(Status, from, bufferLength, buffer);
end;

procedure DecFloat34Impl_fromBcdDispatcher(this: DecFloat34; sign: Integer; bcd: BytePtr; exp: Integer; to_: FB_DEC34Ptr); cdecl;
begin
  DecFloat34Impl(this).fromBcd(sign, bcd, exp, to_);
end;

procedure DecFloat34Impl_fromStringDispatcher(this: DecFloat34; Status: Status; from: PAnsiChar; to_: FB_DEC34Ptr); cdecl;
begin
  DecFloat34Impl(this).fromString(Status, from, to_);
end;

var
  DecFloat34Impl_vTable: DecFloat34VTable;

constructor DecFloat34Impl.create;
begin
  vTable := DecFloat34Impl_vTable;
end;

procedure Int128Impl_toStringDispatcher(this: Int128; Status: Status; from: FB_I128Ptr; scale: Integer; bufferLength: Cardinal;
  buffer: PAnsiChar); cdecl;
begin
  Int128Impl(this).toString(Status, from, scale, bufferLength, buffer);
end;

procedure Int128Impl_fromStringDispatcher(this: Int128; Status: Status; scale: Integer; from: PAnsiChar; to_: FB_I128Ptr); cdecl;
begin
  Int128Impl(this).fromString(Status, scale, from, to_);
end;

var
  Int128Impl_vTable: Int128VTable;

constructor Int128Impl.create;
begin
  vTable := Int128Impl_vTable;
end;

function ReplicatedFieldImpl_getNameDispatcher(this: ReplicatedField): PAnsiChar; cdecl;
begin
  Result := ReplicatedFieldImpl(this).getName();
end;

function ReplicatedFieldImpl_getTypeDispatcher(this: ReplicatedField): Cardinal; cdecl;
begin
  Result := ReplicatedFieldImpl(this).getType();
end;

function ReplicatedFieldImpl_getSubTypeDispatcher(this: ReplicatedField): Integer; cdecl;
begin
  Result := ReplicatedFieldImpl(this).getSubType();
end;

function ReplicatedFieldImpl_getScaleDispatcher(this: ReplicatedField): Integer; cdecl;
begin
  Result := ReplicatedFieldImpl(this).getScale();
end;

function ReplicatedFieldImpl_getLengthDispatcher(this: ReplicatedField): Cardinal; cdecl;
begin
  Result := ReplicatedFieldImpl(this).getLength();
end;

function ReplicatedFieldImpl_getCharSetDispatcher(this: ReplicatedField): Cardinal; cdecl;
begin
  Result := ReplicatedFieldImpl(this).getCharSet();
end;

function ReplicatedFieldImpl_getDataDispatcher(this: ReplicatedField): Pointer; cdecl;
begin
  Result := ReplicatedFieldImpl(this).getData();
end;

var
  ReplicatedFieldImpl_vTable: ReplicatedFieldVTable;

constructor ReplicatedFieldImpl.create;
begin
  vTable := ReplicatedFieldImpl_vTable;
end;

function ReplicatedRecordImpl_getCountDispatcher(this: ReplicatedRecord): Cardinal; cdecl;
begin
  Result := ReplicatedRecordImpl(this).getCount();
end;

function ReplicatedRecordImpl_getFieldDispatcher(this: ReplicatedRecord; index: Cardinal): ReplicatedField; cdecl;
begin
  Result := ReplicatedRecordImpl(this).getField(index);
end;

function ReplicatedRecordImpl_getRawLengthDispatcher(this: ReplicatedRecord): Cardinal; cdecl;
begin
  Result := ReplicatedRecordImpl(this).getRawLength();
end;

function ReplicatedRecordImpl_getRawDataDispatcher(this: ReplicatedRecord): BytePtr; cdecl;
begin
  Result := ReplicatedRecordImpl(this).getRawData();
end;

var
  ReplicatedRecordImpl_vTable: ReplicatedRecordVTable;

constructor ReplicatedRecordImpl.create;
begin
  vTable := ReplicatedRecordImpl_vTable;
end;

procedure ReplicatedTransactionImpl_disposeDispatcher(this: ReplicatedTransaction); cdecl;
begin
  ReplicatedTransactionImpl(this).dispose();
end;

procedure ReplicatedTransactionImpl_prepareDispatcher(this: ReplicatedTransaction; Status: Status); cdecl;
begin
  ReplicatedTransactionImpl(this).prepare(Status);
end;

procedure ReplicatedTransactionImpl_commitDispatcher(this: ReplicatedTransaction; Status: Status); cdecl;
begin
  ReplicatedTransactionImpl(this).commit(Status);
end;

procedure ReplicatedTransactionImpl_rollbackDispatcher(this: ReplicatedTransaction; Status: Status); cdecl;
begin
  ReplicatedTransactionImpl(this).rollback(Status);
end;

procedure ReplicatedTransactionImpl_startSavepointDispatcher(this: ReplicatedTransaction; Status: Status); cdecl;
begin
  ReplicatedTransactionImpl(this).startSavepoint(Status);
end;

procedure ReplicatedTransactionImpl_releaseSavepointDispatcher(this: ReplicatedTransaction; Status: Status); cdecl;
begin
  ReplicatedTransactionImpl(this).releaseSavepoint(Status);
end;

procedure ReplicatedTransactionImpl_rollbackSavepointDispatcher(this: ReplicatedTransaction; Status: Status); cdecl;
begin
  ReplicatedTransactionImpl(this).rollbackSavepoint(Status);
end;

procedure ReplicatedTransactionImpl_insertRecordDispatcher(this: ReplicatedTransaction; Status: Status; name: PAnsiChar;
  record_: ReplicatedRecord); cdecl;
begin
  ReplicatedTransactionImpl(this).insertRecord(Status, name, record_);
end;

procedure ReplicatedTransactionImpl_updateRecordDispatcher(this: ReplicatedTransaction; Status: Status; name: PAnsiChar; orgRecord: ReplicatedRecord;
  newRecord: ReplicatedRecord); cdecl;
begin
  ReplicatedTransactionImpl(this).updateRecord(Status, name, orgRecord, newRecord);
end;

procedure ReplicatedTransactionImpl_deleteRecordDispatcher(this: ReplicatedTransaction; Status: Status; name: PAnsiChar;
  record_: ReplicatedRecord); cdecl;
begin
  ReplicatedTransactionImpl(this).deleteRecord(Status, name, record_);
end;

procedure ReplicatedTransactionImpl_executeSqlDispatcher(this: ReplicatedTransaction; Status: Status; sql: PAnsiChar); cdecl;
begin
  ReplicatedTransactionImpl(this).executeSql(Status, sql);
end;

procedure ReplicatedTransactionImpl_executeSqlIntlDispatcher(this: ReplicatedTransaction; Status: Status; charSet: Cardinal; sql: PAnsiChar); cdecl;
begin
  ReplicatedTransactionImpl(this).executeSqlIntl(Status, charSet, sql);
end;

var
  ReplicatedTransactionImpl_vTable: ReplicatedTransactionVTable;

constructor ReplicatedTransactionImpl.create;
begin
  vTable := ReplicatedTransactionImpl_vTable;
end;

procedure ReplicatedSessionImpl_addRefDispatcher(this: ReplicatedSession); cdecl;
begin
  ReplicatedSessionImpl(this).addRef();
end;

function ReplicatedSessionImpl_releaseDispatcher(this: ReplicatedSession): Integer; cdecl;
begin
  Result := ReplicatedSessionImpl(this).release();
end;

procedure ReplicatedSessionImpl_setOwnerDispatcher(this: ReplicatedSession; r: ReferenceCounted); cdecl;
begin
  ReplicatedSessionImpl(this).setOwner(r);
end;

function ReplicatedSessionImpl_getOwnerDispatcher(this: ReplicatedSession): ReferenceCounted; cdecl;
begin
  Result := ReplicatedSessionImpl(this).getOwner();
end;

function ReplicatedSessionImpl_initDispatcher(this: ReplicatedSession; Status: Status; Attachment: Attachment): Boolean; cdecl;
begin
  Result := ReplicatedSessionImpl(this).init(Status, Attachment);
end;

function ReplicatedSessionImpl_startTransactionDispatcher(this: ReplicatedSession; Status: Status; Transaction: Transaction; number: Int64)
  : ReplicatedTransaction; cdecl;
begin
  Result := ReplicatedSessionImpl(this).startTransaction(Status, Transaction, number);
end;

procedure ReplicatedSessionImpl_cleanupTransactionDispatcher(this: ReplicatedSession; Status: Status; number: Int64); cdecl;
begin
  ReplicatedSessionImpl(this).cleanupTransaction(Status, number);
end;

procedure ReplicatedSessionImpl_setSequenceDispatcher(this: ReplicatedSession; Status: Status; name: PAnsiChar; value: Int64); cdecl;
begin
  ReplicatedSessionImpl(this).setSequence(Status, name, value);
end;

var
  ReplicatedSessionImpl_vTable: ReplicatedSessionVTable;

constructor ReplicatedSessionImpl.create;
begin
  vTable := ReplicatedSessionImpl_vTable;
end;

procedure ProfilerPluginImpl_addRefDispatcher(this: ProfilerPlugin); cdecl;
begin
  ProfilerPluginImpl(this).addRef();
end;

function ProfilerPluginImpl_releaseDispatcher(this: ProfilerPlugin): Integer; cdecl;
begin
  Result := ProfilerPluginImpl(this).release();
end;

procedure ProfilerPluginImpl_setOwnerDispatcher(this: ProfilerPlugin; r: ReferenceCounted); cdecl;
begin
  ProfilerPluginImpl(this).setOwner(r);
end;

function ProfilerPluginImpl_getOwnerDispatcher(this: ProfilerPlugin): ReferenceCounted; cdecl;
begin
  Result := ProfilerPluginImpl(this).getOwner();
end;

procedure ProfilerPluginImpl_initDispatcher(this: ProfilerPlugin; Status: Status; Attachment: Attachment; ticksFrequency: QWord); cdecl;
begin
  ProfilerPluginImpl(this).init(Status, Attachment, ticksFrequency);
end;

function ProfilerPluginImpl_startSessionDispatcher(this: ProfilerPlugin; Status: Status; description: PAnsiChar; options: PAnsiChar;
  timestamp: ISC_TIMESTAMP_TZ): ProfilerSession; cdecl;
begin
  Result := ProfilerPluginImpl(this).startSession(Status, description, options, timestamp);
end;

procedure ProfilerPluginImpl_flushDispatcher(this: ProfilerPlugin; Status: Status); cdecl;
begin
  ProfilerPluginImpl(this).flush(Status);
end;

var
  ProfilerPluginImpl_vTable: ProfilerPluginVTable;

constructor ProfilerPluginImpl.create;
begin
  vTable := ProfilerPluginImpl_vTable;
end;

procedure ProfilerSessionImpl_disposeDispatcher(this: ProfilerSession); cdecl;
begin
  ProfilerSessionImpl(this).dispose();
end;

function ProfilerSessionImpl_getIdDispatcher(this: ProfilerSession): Int64; cdecl;
begin
  Result := ProfilerSessionImpl(this).getId();
end;

function ProfilerSessionImpl_getFlagsDispatcher(this: ProfilerSession): Cardinal; cdecl;
begin
  Result := ProfilerSessionImpl(this).getFlags();
end;

procedure ProfilerSessionImpl_cancelDispatcher(this: ProfilerSession; Status: Status); cdecl;
begin
  ProfilerSessionImpl(this).cancel(Status);
end;

procedure ProfilerSessionImpl_finishDispatcher(this: ProfilerSession; Status: Status; timestamp: ISC_TIMESTAMP_TZ); cdecl;
begin
  ProfilerSessionImpl(this).finish(Status, timestamp);
end;

procedure ProfilerSessionImpl_defineStatementDispatcher(this: ProfilerSession; Status: Status; statementId: Int64; parentStatementId: Int64;
  type_: PAnsiChar; packageName: PAnsiChar; routineName: PAnsiChar; sqlText: PAnsiChar); cdecl;
begin
  ProfilerSessionImpl(this).defineStatement(Status, statementId, parentStatementId, type_, packageName, routineName, sqlText);
end;

procedure ProfilerSessionImpl_defineCursorDispatcher(this: ProfilerSession; statementId: Int64; cursorId: Cardinal; name: PAnsiChar; line: Cardinal;
  column: Cardinal); cdecl;
begin
  ProfilerSessionImpl(this).defineCursor(statementId, cursorId, name, line, column);
end;

procedure ProfilerSessionImpl_defineRecordSourceDispatcher(this: ProfilerSession; statementId: Int64; cursorId: Cardinal; recSourceId: Cardinal;
  level: Cardinal; accessPath: PAnsiChar; parentRecSourceId: Cardinal); cdecl;
begin
  ProfilerSessionImpl(this).defineRecordSource(statementId, cursorId, recSourceId, level, accessPath, parentRecSourceId);
end;

procedure ProfilerSessionImpl_onRequestStartDispatcher(this: ProfilerSession; Status: Status; statementId: Int64; requestId: Int64;
  callerStatementId: Int64; callerRequestId: Int64; timestamp: ISC_TIMESTAMP_TZ); cdecl;
begin
  ProfilerSessionImpl(this).onRequestStart(Status, statementId, requestId, callerStatementId, callerRequestId, timestamp);
end;

procedure ProfilerSessionImpl_onRequestFinishDispatcher(this: ProfilerSession; Status: Status; statementId: Int64; requestId: Int64;
  timestamp: ISC_TIMESTAMP_TZ; stats: ProfilerStats); cdecl;
begin
  ProfilerSessionImpl(this).onRequestFinish(Status, statementId, requestId, timestamp, stats);
end;

procedure ProfilerSessionImpl_beforePsqlLineColumnDispatcher(this: ProfilerSession; statementId: Int64; requestId: Int64; line: Cardinal;
  column: Cardinal); cdecl;
begin
  ProfilerSessionImpl(this).beforePsqlLineColumn(statementId, requestId, line, column);
end;

procedure ProfilerSessionImpl_afterPsqlLineColumnDispatcher(this: ProfilerSession; statementId: Int64; requestId: Int64; line: Cardinal;
  column: Cardinal; stats: ProfilerStats); cdecl;
begin
  ProfilerSessionImpl(this).afterPsqlLineColumn(statementId, requestId, line, column, stats);
end;

procedure ProfilerSessionImpl_beforeRecordSourceOpenDispatcher(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
  recSourceId: Cardinal); cdecl;
begin
  ProfilerSessionImpl(this).beforeRecordSourceOpen(statementId, requestId, cursorId, recSourceId);
end;

procedure ProfilerSessionImpl_afterRecordSourceOpenDispatcher(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
  recSourceId: Cardinal; stats: ProfilerStats); cdecl;
begin
  ProfilerSessionImpl(this).afterRecordSourceOpen(statementId, requestId, cursorId, recSourceId, stats);
end;

procedure ProfilerSessionImpl_beforeRecordSourceGetRecordDispatcher(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
  recSourceId: Cardinal); cdecl;
begin
  ProfilerSessionImpl(this).beforeRecordSourceGetRecord(statementId, requestId, cursorId, recSourceId);
end;

procedure ProfilerSessionImpl_afterRecordSourceGetRecordDispatcher(this: ProfilerSession; statementId: Int64; requestId: Int64; cursorId: Cardinal;
  recSourceId: Cardinal; stats: ProfilerStats); cdecl;
begin
  ProfilerSessionImpl(this).afterRecordSourceGetRecord(statementId, requestId, cursorId, recSourceId, stats);
end;

var
  ProfilerSessionImpl_vTable: ProfilerSessionVTable;

constructor ProfilerSessionImpl.create;
begin
  vTable := ProfilerSessionImpl_vTable;
end;

function ProfilerStatsImpl_getElapsedTicksDispatcher(this: ProfilerStats): QWord; cdecl;
begin
  Result := ProfilerStatsImpl(this).getElapsedTicks();
end;

var
  ProfilerStatsImpl_vTable: ProfilerStatsVTable;

constructor ProfilerStatsImpl.create;
begin
  vTable := ProfilerStatsImpl_vTable;
end;

constructor FbException.create(Status: Status);
 var
  LErrorVector: NativeIntPtr;
  LErrorAnsi: AnsiString;
  LErrors: String;
begin
  LErrorAnsi := 'FbException';
  Status := Status.clone;
  LErrors := '';
  try
    LErrorVector := Status.getErrors();

    while True do
    begin
      if (LErrorVector^ <> isc_arg_gds) then
        Exit;
      Inc(LErrorVector);

      Code := Cardinal(LErrorVector^);
      Inc(LErrorVector);
      LErrorAnsi := '';

      while (LErrorVector^ = isc_arg_string) do
      begin
        Inc(LErrorVector);
        if LErrorAnsi > '' then
          LErrorAnsi := LErrorAnsi + ' ';
        LErrorAnsi := LErrorAnsi + PAnsiChar(LErrorVector^);
        Inc(LErrorVector);
      end;

      if LErrors > '' then
        LErrors := LErrors + #13#10;
      LErrors := LErrors + Format('code: %d, message: %s', [Code, String(LErrorAnsi)])
    end;
  finally
    if (LErrors = '') then
      LErrors := 'FbException';
    inherited create(LErrors);
  end;
//var
//  LErrorVector: NativeIntPtr;
//  LErrorArray: TVectorP absolute LErrorVector;
//  LErrorAnsi: AnsiString;
//  LData: PAnsiChar;
//begin
//  LErrorAnsi := 'FbException';
//  Self.Status := Status.clone;
//  try
//    LErrorVector := Status.getErrors();
//
//    if (LErrorArray[0] <> NativeIntPtr(isc_arg_gds)) then
//      Exit;
//
//    if LErrorArray[2] <> NativeIntPtr(isc_arg_string) then
//      Exit;
//
//    LData := PAnsiChar(LErrorArray[3]);
//    Code := Cardinal(LErrorArray[1]);
//
//    LErrorAnsi := AnsiString(LData);
//    Header := String(LErrorAnsi);
//
//    Inc(LData, Succ(Length(LErrorAnsi)));
//    LErrorAnsi := AnsiString(LData);
//    Message := String(LErrorAnsi);
//  finally
//    inherited create(Header + #13#10 + Message);
//  end;
end;

destructor FbException.Destroy();
begin
  Status.Free;
  inherited Destroy;
end;

function FbException.getStatus: Status;
begin
  Result := Status;
end;

class procedure FbException.checkException(Status: Status);
begin
  if ((Status.getState and Status.STATE_ERRORS) <> 0) then
    raise FbException.create(Status);
end;

class procedure FbException.catchException(Status: Status; e: Exception);
var
  statusVector: array [0 .. 4] of NativeIntPtr;
  msg: AnsiString;
begin
  if (not Assigned(Status)) then
    Exit;

  if (e.inheritsFrom(FbException)) then
    Status.setErrors(FbException(e).getStatus.getErrors)
  else
  begin
    msg := AnsiString(e.message);

    statusVector[0] := NativeIntPtr(isc_arg_gds);
    statusVector[1] := NativeIntPtr(isc_random);
    statusVector[2] := NativeIntPtr(isc_arg_string);
    statusVector[3] := NativeIntPtr(PAnsiChar(msg));
    statusVector[4] := NativeIntPtr(isc_arg_end);

    Status.setErrors(@statusVector);
  end
end;

class procedure FbException.setVersionError(Status: Status; interfaceName: AnsiString; currentVersion, expectedVersion: NativeInt);
var
  statusVector: array [0 .. 8] of NativeIntPtr;
begin
  statusVector[0] := NativeIntPtr(isc_arg_gds);
  statusVector[1] := NativeIntPtr(isc_interface_version_too_old);
  statusVector[2] := NativeIntPtr(isc_arg_number);
  statusVector[3] := NativeIntPtr(expectedVersion);
  statusVector[4] := NativeIntPtr(isc_arg_number);
  statusVector[5] := NativeIntPtr(currentVersion);
  statusVector[6] := NativeIntPtr(isc_arg_string);
  statusVector[7] := NativeIntPtr(PAnsiChar(interfaceName));
  statusVector[8] := NativeIntPtr(isc_arg_end);

  Status.setErrors(@statusVector);
end;

initialization

VersionedImpl_vTable := VersionedVTable.create;
VersionedImpl_vTable.version := 1;

ReferenceCountedImpl_vTable := ReferenceCountedVTable.create;
ReferenceCountedImpl_vTable.version := 2;
ReferenceCountedImpl_vTable.addRef := @ReferenceCountedImpl_addRefDispatcher;
ReferenceCountedImpl_vTable.release := @ReferenceCountedImpl_releaseDispatcher;

DisposableImpl_vTable := DisposableVTable.create;
DisposableImpl_vTable.version := 2;
DisposableImpl_vTable.dispose := @DisposableImpl_disposeDispatcher;

StatusImpl_vTable := StatusVTable.create;
StatusImpl_vTable.version := 3;
StatusImpl_vTable.dispose := @StatusImpl_disposeDispatcher;
StatusImpl_vTable.init := @StatusImpl_initDispatcher;
StatusImpl_vTable.getState := @StatusImpl_getStateDispatcher;
StatusImpl_vTable.setErrors2 := @StatusImpl_setErrors2Dispatcher;
StatusImpl_vTable.setWarnings2 := @StatusImpl_setWarnings2Dispatcher;
StatusImpl_vTable.setErrors := @StatusImpl_setErrorsDispatcher;
StatusImpl_vTable.setWarnings := @StatusImpl_setWarningsDispatcher;
StatusImpl_vTable.getErrors := @StatusImpl_getErrorsDispatcher;
StatusImpl_vTable.getWarnings := @StatusImpl_getWarningsDispatcher;
StatusImpl_vTable.clone := @StatusImpl_cloneDispatcher;

MasterImpl_vTable := MasterVTable.create;
MasterImpl_vTable.version := 2;
MasterImpl_vTable.getStatus := @MasterImpl_getStatusDispatcher;
MasterImpl_vTable.getDispatcher := @MasterImpl_getDispatcherDispatcher;
MasterImpl_vTable.getPluginManager := @MasterImpl_getPluginManagerDispatcher;
MasterImpl_vTable.getTimerControl := @MasterImpl_getTimerControlDispatcher;
MasterImpl_vTable.getDtc := @MasterImpl_getDtcDispatcher;
MasterImpl_vTable.registerAttachment := @MasterImpl_registerAttachmentDispatcher;
MasterImpl_vTable.registerTransaction := @MasterImpl_registerTransactionDispatcher;
MasterImpl_vTable.getMetadataBuilder := @MasterImpl_getMetadataBuilderDispatcher;
MasterImpl_vTable.serverMode := @MasterImpl_serverModeDispatcher;
MasterImpl_vTable.getUtilInterface := @MasterImpl_getUtilInterfaceDispatcher;
MasterImpl_vTable.getConfigManager := @MasterImpl_getConfigManagerDispatcher;
MasterImpl_vTable.getProcessExiting := @MasterImpl_getProcessExitingDispatcher;

PluginBaseImpl_vTable := PluginBaseVTable.create;
PluginBaseImpl_vTable.version := 3;
PluginBaseImpl_vTable.addRef := @PluginBaseImpl_addRefDispatcher;
PluginBaseImpl_vTable.release := @PluginBaseImpl_releaseDispatcher;
PluginBaseImpl_vTable.setOwner := @PluginBaseImpl_setOwnerDispatcher;
PluginBaseImpl_vTable.getOwner := @PluginBaseImpl_getOwnerDispatcher;

PluginSetImpl_vTable := PluginSetVTable.create;
PluginSetImpl_vTable.version := 3;
PluginSetImpl_vTable.addRef := @PluginSetImpl_addRefDispatcher;
PluginSetImpl_vTable.release := @PluginSetImpl_releaseDispatcher;
PluginSetImpl_vTable.getName := @PluginSetImpl_getNameDispatcher;
PluginSetImpl_vTable.getModuleName := @PluginSetImpl_getModuleNameDispatcher;
PluginSetImpl_vTable.getPlugin := @PluginSetImpl_getPluginDispatcher;
PluginSetImpl_vTable.next := @PluginSetImpl_nextDispatcher;
PluginSetImpl_vTable.set_ := @PluginSetImpl_set_Dispatcher;

ConfigEntryImpl_vTable := ConfigEntryVTable.create;
ConfigEntryImpl_vTable.version := 3;
ConfigEntryImpl_vTable.addRef := @ConfigEntryImpl_addRefDispatcher;
ConfigEntryImpl_vTable.release := @ConfigEntryImpl_releaseDispatcher;
ConfigEntryImpl_vTable.getName := @ConfigEntryImpl_getNameDispatcher;
ConfigEntryImpl_vTable.getValue := @ConfigEntryImpl_getValueDispatcher;
ConfigEntryImpl_vTable.getIntValue := @ConfigEntryImpl_getIntValueDispatcher;
ConfigEntryImpl_vTable.getBoolValue := @ConfigEntryImpl_getBoolValueDispatcher;
ConfigEntryImpl_vTable.getSubConfig := @ConfigEntryImpl_getSubConfigDispatcher;

ConfigImpl_vTable := ConfigVTable.create;
ConfigImpl_vTable.version := 3;
ConfigImpl_vTable.addRef := @ConfigImpl_addRefDispatcher;
ConfigImpl_vTable.release := @ConfigImpl_releaseDispatcher;
ConfigImpl_vTable.find := @ConfigImpl_findDispatcher;
ConfigImpl_vTable.findValue := @ConfigImpl_findValueDispatcher;
ConfigImpl_vTable.findPos := @ConfigImpl_findPosDispatcher;

FirebirdConfImpl_vTable := FirebirdConfVTable.create;
FirebirdConfImpl_vTable.version := 4;
FirebirdConfImpl_vTable.addRef := @FirebirdConfImpl_addRefDispatcher;
FirebirdConfImpl_vTable.release := @FirebirdConfImpl_releaseDispatcher;
FirebirdConfImpl_vTable.getKey := @FirebirdConfImpl_getKeyDispatcher;
FirebirdConfImpl_vTable.asInteger := @FirebirdConfImpl_asIntegerDispatcher;
FirebirdConfImpl_vTable.asString := @FirebirdConfImpl_asStringDispatcher;
FirebirdConfImpl_vTable.asBoolean := @FirebirdConfImpl_asBooleanDispatcher;
FirebirdConfImpl_vTable.getVersion := @FirebirdConfImpl_getVersionDispatcher;

PluginConfigImpl_vTable := PluginConfigVTable.create;
PluginConfigImpl_vTable.version := 3;
PluginConfigImpl_vTable.addRef := @PluginConfigImpl_addRefDispatcher;
PluginConfigImpl_vTable.release := @PluginConfigImpl_releaseDispatcher;
PluginConfigImpl_vTable.getConfigFileName := @PluginConfigImpl_getConfigFileNameDispatcher;
PluginConfigImpl_vTable.getDefaultConfig := @PluginConfigImpl_getDefaultConfigDispatcher;
PluginConfigImpl_vTable.getFirebirdConf := @PluginConfigImpl_getFirebirdConfDispatcher;
PluginConfigImpl_vTable.setReleaseDelay := @PluginConfigImpl_setReleaseDelayDispatcher;

PluginFactoryImpl_vTable := PluginFactoryVTable.create;
PluginFactoryImpl_vTable.version := 2;
PluginFactoryImpl_vTable.createPlugin := @PluginFactoryImpl_createPluginDispatcher;

PluginModuleImpl_vTable := PluginModuleVTable.create;
PluginModuleImpl_vTable.version := 3;
PluginModuleImpl_vTable.doClean := @PluginModuleImpl_doCleanDispatcher;
PluginModuleImpl_vTable.threadDetach := @PluginModuleImpl_threadDetachDispatcher;

PluginManagerImpl_vTable := PluginManagerVTable.create;
PluginManagerImpl_vTable.version := 2;
PluginManagerImpl_vTable.registerPluginFactory := @PluginManagerImpl_registerPluginFactoryDispatcher;
PluginManagerImpl_vTable.registerModule := @PluginManagerImpl_registerModuleDispatcher;
PluginManagerImpl_vTable.unregisterModule := @PluginManagerImpl_unregisterModuleDispatcher;
PluginManagerImpl_vTable.getPlugins := @PluginManagerImpl_getPluginsDispatcher;
PluginManagerImpl_vTable.getConfig := @PluginManagerImpl_getConfigDispatcher;
PluginManagerImpl_vTable.releasePlugin := @PluginManagerImpl_releasePluginDispatcher;

CryptKeyImpl_vTable := CryptKeyVTable.create;
CryptKeyImpl_vTable.version := 2;
CryptKeyImpl_vTable.setSymmetric := @CryptKeyImpl_setSymmetricDispatcher;
CryptKeyImpl_vTable.setAsymmetric := @CryptKeyImpl_setAsymmetricDispatcher;
CryptKeyImpl_vTable.getEncryptKey := @CryptKeyImpl_getEncryptKeyDispatcher;
CryptKeyImpl_vTable.getDecryptKey := @CryptKeyImpl_getDecryptKeyDispatcher;

ConfigManagerImpl_vTable := ConfigManagerVTable.create;
ConfigManagerImpl_vTable.version := 3;
ConfigManagerImpl_vTable.getDirectory := @ConfigManagerImpl_getDirectoryDispatcher;
ConfigManagerImpl_vTable.getFirebirdConf := @ConfigManagerImpl_getFirebirdConfDispatcher;
ConfigManagerImpl_vTable.getDatabaseConf := @ConfigManagerImpl_getDatabaseConfDispatcher;
ConfigManagerImpl_vTable.getPluginConfig := @ConfigManagerImpl_getPluginConfigDispatcher;
ConfigManagerImpl_vTable.getInstallDirectory := @ConfigManagerImpl_getInstallDirectoryDispatcher;
ConfigManagerImpl_vTable.getRootDirectory := @ConfigManagerImpl_getRootDirectoryDispatcher;
ConfigManagerImpl_vTable.getDefaultSecurityDb := @ConfigManagerImpl_getDefaultSecurityDbDispatcher;

EventCallbackImpl_vTable := EventCallbackVTable.create;
EventCallbackImpl_vTable.version := 3;
EventCallbackImpl_vTable.addRef := @EventCallbackImpl_addRefDispatcher;
EventCallbackImpl_vTable.release := @EventCallbackImpl_releaseDispatcher;
EventCallbackImpl_vTable.eventCallbackFunction := @EventCallbackImpl_eventCallbackFunctionDispatcher;

BlobImpl_vTable := BlobVTable.create;
BlobImpl_vTable.version := 4;
BlobImpl_vTable.addRef := @BlobImpl_addRefDispatcher;
BlobImpl_vTable.release := @BlobImpl_releaseDispatcher;
BlobImpl_vTable.getInfo := @BlobImpl_getInfoDispatcher;
BlobImpl_vTable.getSegment := @BlobImpl_getSegmentDispatcher;
BlobImpl_vTable.putSegment := @BlobImpl_putSegmentDispatcher;
BlobImpl_vTable.deprecatedCancel := @BlobImpl_deprecatedCancelDispatcher;
BlobImpl_vTable.deprecatedClose := @BlobImpl_deprecatedCloseDispatcher;
BlobImpl_vTable.seek := @BlobImpl_seekDispatcher;
BlobImpl_vTable.cancel := @BlobImpl_cancelDispatcher;
BlobImpl_vTable.close := @BlobImpl_closeDispatcher;

TransactionImpl_vTable := TransactionVTable.create;
TransactionImpl_vTable.version := 4;
TransactionImpl_vTable.addRef := @TransactionImpl_addRefDispatcher;
TransactionImpl_vTable.release := @TransactionImpl_releaseDispatcher;
TransactionImpl_vTable.getInfo := @TransactionImpl_getInfoDispatcher;
TransactionImpl_vTable.prepare := @TransactionImpl_prepareDispatcher;
TransactionImpl_vTable.deprecatedCommit := @TransactionImpl_deprecatedCommitDispatcher;
TransactionImpl_vTable.commitRetaining := @TransactionImpl_commitRetainingDispatcher;
TransactionImpl_vTable.deprecatedRollback := @TransactionImpl_deprecatedRollbackDispatcher;
TransactionImpl_vTable.rollbackRetaining := @TransactionImpl_rollbackRetainingDispatcher;
TransactionImpl_vTable.deprecatedDisconnect := @TransactionImpl_deprecatedDisconnectDispatcher;
TransactionImpl_vTable.join := @TransactionImpl_joinDispatcher;
TransactionImpl_vTable.validate := @TransactionImpl_validateDispatcher;
TransactionImpl_vTable.enterDtc := @TransactionImpl_enterDtcDispatcher;
TransactionImpl_vTable.commit := @TransactionImpl_commitDispatcher;
TransactionImpl_vTable.rollback := @TransactionImpl_rollbackDispatcher;
TransactionImpl_vTable.disconnect := @TransactionImpl_disconnectDispatcher;

MessageMetadataImpl_vTable := MessageMetadataVTable.create;
MessageMetadataImpl_vTable.version := 4;
MessageMetadataImpl_vTable.addRef := @MessageMetadataImpl_addRefDispatcher;
MessageMetadataImpl_vTable.release := @MessageMetadataImpl_releaseDispatcher;
MessageMetadataImpl_vTable.getCount := @MessageMetadataImpl_getCountDispatcher;
MessageMetadataImpl_vTable.getField := @MessageMetadataImpl_getFieldDispatcher;
MessageMetadataImpl_vTable.getRelation := @MessageMetadataImpl_getRelationDispatcher;
MessageMetadataImpl_vTable.getOwner := @MessageMetadataImpl_getOwnerDispatcher;
MessageMetadataImpl_vTable.getAlias := @MessageMetadataImpl_getAliasDispatcher;
MessageMetadataImpl_vTable.getType := @MessageMetadataImpl_getTypeDispatcher;
MessageMetadataImpl_vTable.isNullable := @MessageMetadataImpl_isNullableDispatcher;
MessageMetadataImpl_vTable.getSubType := @MessageMetadataImpl_getSubTypeDispatcher;
MessageMetadataImpl_vTable.getLength := @MessageMetadataImpl_getLengthDispatcher;
MessageMetadataImpl_vTable.getScale := @MessageMetadataImpl_getScaleDispatcher;
MessageMetadataImpl_vTable.getCharSet := @MessageMetadataImpl_getCharSetDispatcher;
MessageMetadataImpl_vTable.getOffset := @MessageMetadataImpl_getOffsetDispatcher;
MessageMetadataImpl_vTable.getNullOffset := @MessageMetadataImpl_getNullOffsetDispatcher;
MessageMetadataImpl_vTable.getBuilder := @MessageMetadataImpl_getBuilderDispatcher;
MessageMetadataImpl_vTable.getMessageLength := @MessageMetadataImpl_getMessageLengthDispatcher;
MessageMetadataImpl_vTable.getAlignment := @MessageMetadataImpl_getAlignmentDispatcher;
MessageMetadataImpl_vTable.getAlignedLength := @MessageMetadataImpl_getAlignedLengthDispatcher;

MetadataBuilderImpl_vTable := MetadataBuilderVTable.create;
MetadataBuilderImpl_vTable.version := 4;
MetadataBuilderImpl_vTable.addRef := @MetadataBuilderImpl_addRefDispatcher;
MetadataBuilderImpl_vTable.release := @MetadataBuilderImpl_releaseDispatcher;
MetadataBuilderImpl_vTable.setType := @MetadataBuilderImpl_setTypeDispatcher;
MetadataBuilderImpl_vTable.setSubType := @MetadataBuilderImpl_setSubTypeDispatcher;
MetadataBuilderImpl_vTable.setLength := @MetadataBuilderImpl_setLengthDispatcher;
MetadataBuilderImpl_vTable.setCharSet := @MetadataBuilderImpl_setCharSetDispatcher;
MetadataBuilderImpl_vTable.setScale := @MetadataBuilderImpl_setScaleDispatcher;
MetadataBuilderImpl_vTable.truncate := @MetadataBuilderImpl_truncateDispatcher;
MetadataBuilderImpl_vTable.moveNameToIndex := @MetadataBuilderImpl_moveNameToIndexDispatcher;
MetadataBuilderImpl_vTable.remove := @MetadataBuilderImpl_removeDispatcher;
MetadataBuilderImpl_vTable.addField := @MetadataBuilderImpl_addFieldDispatcher;
MetadataBuilderImpl_vTable.getMetadata := @MetadataBuilderImpl_getMetadataDispatcher;
MetadataBuilderImpl_vTable.setField := @MetadataBuilderImpl_setFieldDispatcher;
MetadataBuilderImpl_vTable.setRelation := @MetadataBuilderImpl_setRelationDispatcher;
MetadataBuilderImpl_vTable.setOwner := @MetadataBuilderImpl_setOwnerDispatcher;
MetadataBuilderImpl_vTable.setAlias := @MetadataBuilderImpl_setAliasDispatcher;

ResultSetImpl_vTable := ResultSetVTable.create;
ResultSetImpl_vTable.version := 5;
ResultSetImpl_vTable.addRef := @ResultSetImpl_addRefDispatcher;
ResultSetImpl_vTable.release := @ResultSetImpl_releaseDispatcher;
ResultSetImpl_vTable.fetchNext := @ResultSetImpl_fetchNextDispatcher;
ResultSetImpl_vTable.fetchPrior := @ResultSetImpl_fetchPriorDispatcher;
ResultSetImpl_vTable.fetchFirst := @ResultSetImpl_fetchFirstDispatcher;
ResultSetImpl_vTable.fetchLast := @ResultSetImpl_fetchLastDispatcher;
ResultSetImpl_vTable.fetchAbsolute := @ResultSetImpl_fetchAbsoluteDispatcher;
ResultSetImpl_vTable.fetchRelative := @ResultSetImpl_fetchRelativeDispatcher;
ResultSetImpl_vTable.isEof := @ResultSetImpl_isEofDispatcher;
ResultSetImpl_vTable.isBof := @ResultSetImpl_isBofDispatcher;
ResultSetImpl_vTable.getMetadata := @ResultSetImpl_getMetadataDispatcher;
ResultSetImpl_vTable.deprecatedClose := @ResultSetImpl_deprecatedCloseDispatcher;
ResultSetImpl_vTable.setDelayedOutputFormat := @ResultSetImpl_setDelayedOutputFormatDispatcher;
ResultSetImpl_vTable.close := @ResultSetImpl_closeDispatcher;
ResultSetImpl_vTable.getInfo := @ResultSetImpl_getInfoDispatcher;

StatementImpl_vTable := StatementVTable.create;
StatementImpl_vTable.version := 5;
StatementImpl_vTable.addRef := @StatementImpl_addRefDispatcher;
StatementImpl_vTable.release := @StatementImpl_releaseDispatcher;
StatementImpl_vTable.getInfo := @StatementImpl_getInfoDispatcher;
StatementImpl_vTable.getType := @StatementImpl_getTypeDispatcher;
StatementImpl_vTable.getPlan := @StatementImpl_getPlanDispatcher;
StatementImpl_vTable.getAffectedRecords := @StatementImpl_getAffectedRecordsDispatcher;
StatementImpl_vTable.getInputMetadata := @StatementImpl_getInputMetadataDispatcher;
StatementImpl_vTable.getOutputMetadata := @StatementImpl_getOutputMetadataDispatcher;
StatementImpl_vTable.execute := @StatementImpl_executeDispatcher;
StatementImpl_vTable.openCursor := @StatementImpl_openCursorDispatcher;
StatementImpl_vTable.setCursorName := @StatementImpl_setCursorNameDispatcher;
StatementImpl_vTable.deprecatedFree := @StatementImpl_deprecatedFreeDispatcher;
StatementImpl_vTable.getFlags := @StatementImpl_getFlagsDispatcher;
StatementImpl_vTable.getTimeout := @StatementImpl_getTimeoutDispatcher;
StatementImpl_vTable.setTimeout := @StatementImpl_setTimeoutDispatcher;
StatementImpl_vTable.createBatch := @StatementImpl_createBatchDispatcher;
StatementImpl_vTable.free := @StatementImpl_freeDispatcher;

BatchImpl_vTable := BatchVTable.create;
BatchImpl_vTable.version := 4;
BatchImpl_vTable.addRef := @BatchImpl_addRefDispatcher;
BatchImpl_vTable.release := @BatchImpl_releaseDispatcher;
BatchImpl_vTable.add := @BatchImpl_addDispatcher;
BatchImpl_vTable.addBlob := @BatchImpl_addBlobDispatcher;
BatchImpl_vTable.appendBlobData := @BatchImpl_appendBlobDataDispatcher;
BatchImpl_vTable.addBlobStream := @BatchImpl_addBlobStreamDispatcher;
BatchImpl_vTable.registerBlob := @BatchImpl_registerBlobDispatcher;
BatchImpl_vTable.execute := @BatchImpl_executeDispatcher;
BatchImpl_vTable.cancel := @BatchImpl_cancelDispatcher;
BatchImpl_vTable.getBlobAlignment := @BatchImpl_getBlobAlignmentDispatcher;
BatchImpl_vTable.getMetadata := @BatchImpl_getMetadataDispatcher;
BatchImpl_vTable.setDefaultBpb := @BatchImpl_setDefaultBpbDispatcher;
BatchImpl_vTable.deprecatedClose := @BatchImpl_deprecatedCloseDispatcher;
BatchImpl_vTable.close := @BatchImpl_closeDispatcher;
BatchImpl_vTable.getInfo := @BatchImpl_getInfoDispatcher;

BatchCompletionStateImpl_vTable := BatchCompletionStateVTable.create;
BatchCompletionStateImpl_vTable.version := 3;
BatchCompletionStateImpl_vTable.dispose := @BatchCompletionStateImpl_disposeDispatcher;
BatchCompletionStateImpl_vTable.getSize := @BatchCompletionStateImpl_getSizeDispatcher;
BatchCompletionStateImpl_vTable.getState := @BatchCompletionStateImpl_getStateDispatcher;
BatchCompletionStateImpl_vTable.findError := @BatchCompletionStateImpl_findErrorDispatcher;
BatchCompletionStateImpl_vTable.getStatus := @BatchCompletionStateImpl_getStatusDispatcher;

ReplicatorImpl_vTable := ReplicatorVTable.create;
ReplicatorImpl_vTable.version := 4;
ReplicatorImpl_vTable.addRef := @ReplicatorImpl_addRefDispatcher;
ReplicatorImpl_vTable.release := @ReplicatorImpl_releaseDispatcher;
ReplicatorImpl_vTable.process := @ReplicatorImpl_processDispatcher;
ReplicatorImpl_vTable.deprecatedClose := @ReplicatorImpl_deprecatedCloseDispatcher;
ReplicatorImpl_vTable.close := @ReplicatorImpl_closeDispatcher;

RequestImpl_vTable := RequestVTable.create;
RequestImpl_vTable.version := 4;
RequestImpl_vTable.addRef := @RequestImpl_addRefDispatcher;
RequestImpl_vTable.release := @RequestImpl_releaseDispatcher;
RequestImpl_vTable.receive := @RequestImpl_receiveDispatcher;
RequestImpl_vTable.send := @RequestImpl_sendDispatcher;
RequestImpl_vTable.getInfo := @RequestImpl_getInfoDispatcher;
RequestImpl_vTable.start := @RequestImpl_startDispatcher;
RequestImpl_vTable.startAndSend := @RequestImpl_startAndSendDispatcher;
RequestImpl_vTable.unwind := @RequestImpl_unwindDispatcher;
RequestImpl_vTable.deprecatedFree := @RequestImpl_deprecatedFreeDispatcher;
RequestImpl_vTable.free := @RequestImpl_freeDispatcher;

EventsImpl_vTable := EventsVTable.create;
EventsImpl_vTable.version := 4;
EventsImpl_vTable.addRef := @EventsImpl_addRefDispatcher;
EventsImpl_vTable.release := @EventsImpl_releaseDispatcher;
EventsImpl_vTable.deprecatedCancel := @EventsImpl_deprecatedCancelDispatcher;
EventsImpl_vTable.cancel := @EventsImpl_cancelDispatcher;

AttachmentImpl_vTable := AttachmentVTable.create;
AttachmentImpl_vTable.version := 5;
AttachmentImpl_vTable.addRef := @AttachmentImpl_addRefDispatcher;
AttachmentImpl_vTable.release := @AttachmentImpl_releaseDispatcher;
AttachmentImpl_vTable.getInfo := @AttachmentImpl_getInfoDispatcher;
AttachmentImpl_vTable.startTransaction := @AttachmentImpl_startTransactionDispatcher;
AttachmentImpl_vTable.reconnectTransaction := @AttachmentImpl_reconnectTransactionDispatcher;
AttachmentImpl_vTable.compileRequest := @AttachmentImpl_compileRequestDispatcher;
AttachmentImpl_vTable.transactRequest := @AttachmentImpl_transactRequestDispatcher;
AttachmentImpl_vTable.createBlob := @AttachmentImpl_createBlobDispatcher;
AttachmentImpl_vTable.openBlob := @AttachmentImpl_openBlobDispatcher;
AttachmentImpl_vTable.getSlice := @AttachmentImpl_getSliceDispatcher;
AttachmentImpl_vTable.putSlice := @AttachmentImpl_putSliceDispatcher;
AttachmentImpl_vTable.executeDyn := @AttachmentImpl_executeDynDispatcher;
AttachmentImpl_vTable.prepare := @AttachmentImpl_prepareDispatcher;
AttachmentImpl_vTable.execute := @AttachmentImpl_executeDispatcher;
AttachmentImpl_vTable.openCursor := @AttachmentImpl_openCursorDispatcher;
AttachmentImpl_vTable.queEvents := @AttachmentImpl_queEventsDispatcher;
AttachmentImpl_vTable.cancelOperation := @AttachmentImpl_cancelOperationDispatcher;
AttachmentImpl_vTable.ping := @AttachmentImpl_pingDispatcher;
AttachmentImpl_vTable.deprecatedDetach := @AttachmentImpl_deprecatedDetachDispatcher;
AttachmentImpl_vTable.deprecatedDropDatabase := @AttachmentImpl_deprecatedDropDatabaseDispatcher;
AttachmentImpl_vTable.getIdleTimeout := @AttachmentImpl_getIdleTimeoutDispatcher;
AttachmentImpl_vTable.setIdleTimeout := @AttachmentImpl_setIdleTimeoutDispatcher;
AttachmentImpl_vTable.getStatementTimeout := @AttachmentImpl_getStatementTimeoutDispatcher;
AttachmentImpl_vTable.setStatementTimeout := @AttachmentImpl_setStatementTimeoutDispatcher;
AttachmentImpl_vTable.createBatch := @AttachmentImpl_createBatchDispatcher;
AttachmentImpl_vTable.createReplicator := @AttachmentImpl_createReplicatorDispatcher;
AttachmentImpl_vTable.detach := @AttachmentImpl_detachDispatcher;
AttachmentImpl_vTable.dropDatabase := @AttachmentImpl_dropDatabaseDispatcher;

ServiceImpl_vTable := ServiceVTable.create;
ServiceImpl_vTable.version := 5;
ServiceImpl_vTable.addRef := @ServiceImpl_addRefDispatcher;
ServiceImpl_vTable.release := @ServiceImpl_releaseDispatcher;
ServiceImpl_vTable.deprecatedDetach := @ServiceImpl_deprecatedDetachDispatcher;
ServiceImpl_vTable.query := @ServiceImpl_queryDispatcher;
ServiceImpl_vTable.start := @ServiceImpl_startDispatcher;
ServiceImpl_vTable.detach := @ServiceImpl_detachDispatcher;
ServiceImpl_vTable.cancel := @ServiceImpl_cancelDispatcher;

ProviderImpl_vTable := ProviderVTable.create;
ProviderImpl_vTable.version := 4;
ProviderImpl_vTable.addRef := @ProviderImpl_addRefDispatcher;
ProviderImpl_vTable.release := @ProviderImpl_releaseDispatcher;
ProviderImpl_vTable.setOwner := @ProviderImpl_setOwnerDispatcher;
ProviderImpl_vTable.getOwner := @ProviderImpl_getOwnerDispatcher;
ProviderImpl_vTable.attachDatabase := @ProviderImpl_attachDatabaseDispatcher;
ProviderImpl_vTable.createDatabase := @ProviderImpl_createDatabaseDispatcher;
ProviderImpl_vTable.attachServiceManager := @ProviderImpl_attachServiceManagerDispatcher;
ProviderImpl_vTable.shutdown := @ProviderImpl_shutdownDispatcher;
ProviderImpl_vTable.setDbCryptCallback := @ProviderImpl_setDbCryptCallbackDispatcher;

DtcStartImpl_vTable := DtcStartVTable.create;
DtcStartImpl_vTable.version := 3;
DtcStartImpl_vTable.dispose := @DtcStartImpl_disposeDispatcher;
DtcStartImpl_vTable.addAttachment := @DtcStartImpl_addAttachmentDispatcher;
DtcStartImpl_vTable.addWithTpb := @DtcStartImpl_addWithTpbDispatcher;
DtcStartImpl_vTable.start := @DtcStartImpl_startDispatcher;

DtcImpl_vTable := DtcVTable.create;
DtcImpl_vTable.version := 2;
DtcImpl_vTable.join := @DtcImpl_joinDispatcher;
DtcImpl_vTable.startBuilder := @DtcImpl_startBuilderDispatcher;

AuthImpl_vTable := AuthVTable.create;
AuthImpl_vTable.version := 4;
AuthImpl_vTable.addRef := @AuthImpl_addRefDispatcher;
AuthImpl_vTable.release := @AuthImpl_releaseDispatcher;
AuthImpl_vTable.setOwner := @AuthImpl_setOwnerDispatcher;
AuthImpl_vTable.getOwner := @AuthImpl_getOwnerDispatcher;

WriterImpl_vTable := WriterVTable.create;
WriterImpl_vTable.version := 2;
WriterImpl_vTable.reset := @WriterImpl_resetDispatcher;
WriterImpl_vTable.add := @WriterImpl_addDispatcher;
WriterImpl_vTable.setType := @WriterImpl_setTypeDispatcher;
WriterImpl_vTable.setDb := @WriterImpl_setDbDispatcher;

ServerBlockImpl_vTable := ServerBlockVTable.create;
ServerBlockImpl_vTable.version := 2;
ServerBlockImpl_vTable.getLogin := @ServerBlockImpl_getLoginDispatcher;
ServerBlockImpl_vTable.getData := @ServerBlockImpl_getDataDispatcher;
ServerBlockImpl_vTable.putData := @ServerBlockImpl_putDataDispatcher;
ServerBlockImpl_vTable.newKey := @ServerBlockImpl_newKeyDispatcher;

ClientBlockImpl_vTable := ClientBlockVTable.create;
ClientBlockImpl_vTable.version := 4;
ClientBlockImpl_vTable.addRef := @ClientBlockImpl_addRefDispatcher;
ClientBlockImpl_vTable.release := @ClientBlockImpl_releaseDispatcher;
ClientBlockImpl_vTable.getLogin := @ClientBlockImpl_getLoginDispatcher;
ClientBlockImpl_vTable.getPassword := @ClientBlockImpl_getPasswordDispatcher;
ClientBlockImpl_vTable.getData := @ClientBlockImpl_getDataDispatcher;
ClientBlockImpl_vTable.putData := @ClientBlockImpl_putDataDispatcher;
ClientBlockImpl_vTable.newKey := @ClientBlockImpl_newKeyDispatcher;
ClientBlockImpl_vTable.getAuthBlock := @ClientBlockImpl_getAuthBlockDispatcher;

ServerImpl_vTable := ServerVTable.create;
ServerImpl_vTable.version := 6;
ServerImpl_vTable.addRef := @ServerImpl_addRefDispatcher;
ServerImpl_vTable.release := @ServerImpl_releaseDispatcher;
ServerImpl_vTable.setOwner := @ServerImpl_setOwnerDispatcher;
ServerImpl_vTable.getOwner := @ServerImpl_getOwnerDispatcher;
ServerImpl_vTable.authenticate := @ServerImpl_authenticateDispatcher;
ServerImpl_vTable.setDbCryptCallback := @ServerImpl_setDbCryptCallbackDispatcher;

ClientImpl_vTable := ClientVTable.create;
ClientImpl_vTable.version := 5;
ClientImpl_vTable.addRef := @ClientImpl_addRefDispatcher;
ClientImpl_vTable.release := @ClientImpl_releaseDispatcher;
ClientImpl_vTable.setOwner := @ClientImpl_setOwnerDispatcher;
ClientImpl_vTable.getOwner := @ClientImpl_getOwnerDispatcher;
ClientImpl_vTable.authenticate := @ClientImpl_authenticateDispatcher;

UserFieldImpl_vTable := UserFieldVTable.create;
UserFieldImpl_vTable.version := 2;
UserFieldImpl_vTable.entered := @UserFieldImpl_enteredDispatcher;
UserFieldImpl_vTable.specified := @UserFieldImpl_specifiedDispatcher;
UserFieldImpl_vTable.setEntered := @UserFieldImpl_setEnteredDispatcher;

CharUserFieldImpl_vTable := CharUserFieldVTable.create;
CharUserFieldImpl_vTable.version := 3;
CharUserFieldImpl_vTable.entered := @CharUserFieldImpl_enteredDispatcher;
CharUserFieldImpl_vTable.specified := @CharUserFieldImpl_specifiedDispatcher;
CharUserFieldImpl_vTable.setEntered := @CharUserFieldImpl_setEnteredDispatcher;
CharUserFieldImpl_vTable.get := @CharUserFieldImpl_getDispatcher;
CharUserFieldImpl_vTable.set_ := @CharUserFieldImpl_set_Dispatcher;

IntUserFieldImpl_vTable := IntUserFieldVTable.create;
IntUserFieldImpl_vTable.version := 3;
IntUserFieldImpl_vTable.entered := @IntUserFieldImpl_enteredDispatcher;
IntUserFieldImpl_vTable.specified := @IntUserFieldImpl_specifiedDispatcher;
IntUserFieldImpl_vTable.setEntered := @IntUserFieldImpl_setEnteredDispatcher;
IntUserFieldImpl_vTable.get := @IntUserFieldImpl_getDispatcher;
IntUserFieldImpl_vTable.set_ := @IntUserFieldImpl_set_Dispatcher;

UserImpl_vTable := UserVTable.create;
UserImpl_vTable.version := 2;
UserImpl_vTable.operation := @UserImpl_operationDispatcher;
UserImpl_vTable.userName := @UserImpl_userNameDispatcher;
UserImpl_vTable.password := @UserImpl_passwordDispatcher;
UserImpl_vTable.firstName := @UserImpl_firstNameDispatcher;
UserImpl_vTable.lastName := @UserImpl_lastNameDispatcher;
UserImpl_vTable.middleName := @UserImpl_middleNameDispatcher;
UserImpl_vTable.comment := @UserImpl_commentDispatcher;
UserImpl_vTable.attributes := @UserImpl_attributesDispatcher;
UserImpl_vTable.active := @UserImpl_activeDispatcher;
UserImpl_vTable.admin := @UserImpl_adminDispatcher;
UserImpl_vTable.clear := @UserImpl_clearDispatcher;

ListUsersImpl_vTable := ListUsersVTable.create;
ListUsersImpl_vTable.version := 2;
ListUsersImpl_vTable.list := @ListUsersImpl_listDispatcher;

LogonInfoImpl_vTable := LogonInfoVTable.create;
LogonInfoImpl_vTable.version := 3;
LogonInfoImpl_vTable.name := @LogonInfoImpl_nameDispatcher;
LogonInfoImpl_vTable.role := @LogonInfoImpl_roleDispatcher;
LogonInfoImpl_vTable.networkProtocol := @LogonInfoImpl_networkProtocolDispatcher;
LogonInfoImpl_vTable.remoteAddress := @LogonInfoImpl_remoteAddressDispatcher;
LogonInfoImpl_vTable.AuthBlock := @LogonInfoImpl_authBlockDispatcher;
LogonInfoImpl_vTable.Attachment := @LogonInfoImpl_attachmentDispatcher;
LogonInfoImpl_vTable.Transaction := @LogonInfoImpl_transactionDispatcher;

ManagementImpl_vTable := ManagementVTable.create;
ManagementImpl_vTable.version := 4;
ManagementImpl_vTable.addRef := @ManagementImpl_addRefDispatcher;
ManagementImpl_vTable.release := @ManagementImpl_releaseDispatcher;
ManagementImpl_vTable.setOwner := @ManagementImpl_setOwnerDispatcher;
ManagementImpl_vTable.getOwner := @ManagementImpl_getOwnerDispatcher;
ManagementImpl_vTable.start := @ManagementImpl_startDispatcher;
ManagementImpl_vTable.execute := @ManagementImpl_executeDispatcher;
ManagementImpl_vTable.commit := @ManagementImpl_commitDispatcher;
ManagementImpl_vTable.rollback := @ManagementImpl_rollbackDispatcher;

AuthBlockImpl_vTable := AuthBlockVTable.create;
AuthBlockImpl_vTable.version := 2;
AuthBlockImpl_vTable.getType := @AuthBlockImpl_getTypeDispatcher;
AuthBlockImpl_vTable.getName := @AuthBlockImpl_getNameDispatcher;
AuthBlockImpl_vTable.getPlugin := @AuthBlockImpl_getPluginDispatcher;
AuthBlockImpl_vTable.getSecurityDb := @AuthBlockImpl_getSecurityDbDispatcher;
AuthBlockImpl_vTable.getOriginalPlugin := @AuthBlockImpl_getOriginalPluginDispatcher;
AuthBlockImpl_vTable.next := @AuthBlockImpl_nextDispatcher;
AuthBlockImpl_vTable.first := @AuthBlockImpl_firstDispatcher;

WireCryptPluginImpl_vTable := WireCryptPluginVTable.create;
WireCryptPluginImpl_vTable.version := 5;
WireCryptPluginImpl_vTable.addRef := @WireCryptPluginImpl_addRefDispatcher;
WireCryptPluginImpl_vTable.release := @WireCryptPluginImpl_releaseDispatcher;
WireCryptPluginImpl_vTable.setOwner := @WireCryptPluginImpl_setOwnerDispatcher;
WireCryptPluginImpl_vTable.getOwner := @WireCryptPluginImpl_getOwnerDispatcher;
WireCryptPluginImpl_vTable.getKnownTypes := @WireCryptPluginImpl_getKnownTypesDispatcher;
WireCryptPluginImpl_vTable.setKey := @WireCryptPluginImpl_setKeyDispatcher;
WireCryptPluginImpl_vTable.encrypt := @WireCryptPluginImpl_encryptDispatcher;
WireCryptPluginImpl_vTable.decrypt := @WireCryptPluginImpl_decryptDispatcher;
WireCryptPluginImpl_vTable.getSpecificData := @WireCryptPluginImpl_getSpecificDataDispatcher;
WireCryptPluginImpl_vTable.setSpecificData := @WireCryptPluginImpl_setSpecificDataDispatcher;

CryptKeyCallbackImpl_vTable := CryptKeyCallbackVTable.create;
CryptKeyCallbackImpl_vTable.version := 3;
CryptKeyCallbackImpl_vTable.callback := @CryptKeyCallbackImpl_callbackDispatcher;
CryptKeyCallbackImpl_vTable.afterAttach := @CryptKeyCallbackImpl_afterAttachDispatcher;
CryptKeyCallbackImpl_vTable.dispose := @CryptKeyCallbackImpl_disposeDispatcher;

KeyHolderPluginImpl_vTable := KeyHolderPluginVTable.create;
KeyHolderPluginImpl_vTable.version := 5;
KeyHolderPluginImpl_vTable.addRef := @KeyHolderPluginImpl_addRefDispatcher;
KeyHolderPluginImpl_vTable.release := @KeyHolderPluginImpl_releaseDispatcher;
KeyHolderPluginImpl_vTable.setOwner := @KeyHolderPluginImpl_setOwnerDispatcher;
KeyHolderPluginImpl_vTable.getOwner := @KeyHolderPluginImpl_getOwnerDispatcher;
KeyHolderPluginImpl_vTable.keyCallback := @KeyHolderPluginImpl_keyCallbackDispatcher;
KeyHolderPluginImpl_vTable.keyHandle := @KeyHolderPluginImpl_keyHandleDispatcher;
KeyHolderPluginImpl_vTable.useOnlyOwnKeys := @KeyHolderPluginImpl_useOnlyOwnKeysDispatcher;
KeyHolderPluginImpl_vTable.chainHandle := @KeyHolderPluginImpl_chainHandleDispatcher;

DbCryptInfoImpl_vTable := DbCryptInfoVTable.create;
DbCryptInfoImpl_vTable.version := 3;
DbCryptInfoImpl_vTable.addRef := @DbCryptInfoImpl_addRefDispatcher;
DbCryptInfoImpl_vTable.release := @DbCryptInfoImpl_releaseDispatcher;
DbCryptInfoImpl_vTable.getDatabaseFullPath := @DbCryptInfoImpl_getDatabaseFullPathDispatcher;

DbCryptPluginImpl_vTable := DbCryptPluginVTable.create;
DbCryptPluginImpl_vTable.version := 5;
DbCryptPluginImpl_vTable.addRef := @DbCryptPluginImpl_addRefDispatcher;
DbCryptPluginImpl_vTable.release := @DbCryptPluginImpl_releaseDispatcher;
DbCryptPluginImpl_vTable.setOwner := @DbCryptPluginImpl_setOwnerDispatcher;
DbCryptPluginImpl_vTable.getOwner := @DbCryptPluginImpl_getOwnerDispatcher;
DbCryptPluginImpl_vTable.setKey := @DbCryptPluginImpl_setKeyDispatcher;
DbCryptPluginImpl_vTable.encrypt := @DbCryptPluginImpl_encryptDispatcher;
DbCryptPluginImpl_vTable.decrypt := @DbCryptPluginImpl_decryptDispatcher;
DbCryptPluginImpl_vTable.setInfo := @DbCryptPluginImpl_setInfoDispatcher;

ExternalContextImpl_vTable := ExternalContextVTable.create;
ExternalContextImpl_vTable.version := 2;
ExternalContextImpl_vTable.getMaster := @ExternalContextImpl_getMasterDispatcher;
ExternalContextImpl_vTable.getEngine := @ExternalContextImpl_getEngineDispatcher;
ExternalContextImpl_vTable.getAttachment := @ExternalContextImpl_getAttachmentDispatcher;
ExternalContextImpl_vTable.getTransaction := @ExternalContextImpl_getTransactionDispatcher;
ExternalContextImpl_vTable.getUserName := @ExternalContextImpl_getUserNameDispatcher;
ExternalContextImpl_vTable.getDatabaseName := @ExternalContextImpl_getDatabaseNameDispatcher;
ExternalContextImpl_vTable.getClientCharSet := @ExternalContextImpl_getClientCharSetDispatcher;
ExternalContextImpl_vTable.obtainInfoCode := @ExternalContextImpl_obtainInfoCodeDispatcher;
ExternalContextImpl_vTable.getInfo := @ExternalContextImpl_getInfoDispatcher;
ExternalContextImpl_vTable.setInfo := @ExternalContextImpl_setInfoDispatcher;

ExternalResultSetImpl_vTable := ExternalResultSetVTable.create;
ExternalResultSetImpl_vTable.version := 3;
ExternalResultSetImpl_vTable.dispose := @ExternalResultSetImpl_disposeDispatcher;
ExternalResultSetImpl_vTable.fetch := @ExternalResultSetImpl_fetchDispatcher;

ExternalFunctionImpl_vTable := ExternalFunctionVTable.create;
ExternalFunctionImpl_vTable.version := 3;
ExternalFunctionImpl_vTable.dispose := @ExternalFunctionImpl_disposeDispatcher;
ExternalFunctionImpl_vTable.getCharSet := @ExternalFunctionImpl_getCharSetDispatcher;
ExternalFunctionImpl_vTable.execute := @ExternalFunctionImpl_executeDispatcher;

ExternalProcedureImpl_vTable := ExternalProcedureVTable.create;
ExternalProcedureImpl_vTable.version := 3;
ExternalProcedureImpl_vTable.dispose := @ExternalProcedureImpl_disposeDispatcher;
ExternalProcedureImpl_vTable.getCharSet := @ExternalProcedureImpl_getCharSetDispatcher;
ExternalProcedureImpl_vTable.open := @ExternalProcedureImpl_openDispatcher;

ExternalTriggerImpl_vTable := ExternalTriggerVTable.create;
ExternalTriggerImpl_vTable.version := 3;
ExternalTriggerImpl_vTable.dispose := @ExternalTriggerImpl_disposeDispatcher;
ExternalTriggerImpl_vTable.getCharSet := @ExternalTriggerImpl_getCharSetDispatcher;
ExternalTriggerImpl_vTable.execute := @ExternalTriggerImpl_executeDispatcher;

RoutineMetadataImpl_vTable := RoutineMetadataVTable.create;
RoutineMetadataImpl_vTable.version := 2;
RoutineMetadataImpl_vTable.getPackage := @RoutineMetadataImpl_getPackageDispatcher;
RoutineMetadataImpl_vTable.getName := @RoutineMetadataImpl_getNameDispatcher;
RoutineMetadataImpl_vTable.getEntryPoint := @RoutineMetadataImpl_getEntryPointDispatcher;
RoutineMetadataImpl_vTable.getBody := @RoutineMetadataImpl_getBodyDispatcher;
RoutineMetadataImpl_vTable.getInputMetadata := @RoutineMetadataImpl_getInputMetadataDispatcher;
RoutineMetadataImpl_vTable.getOutputMetadata := @RoutineMetadataImpl_getOutputMetadataDispatcher;
RoutineMetadataImpl_vTable.getTriggerMetadata := @RoutineMetadataImpl_getTriggerMetadataDispatcher;
RoutineMetadataImpl_vTable.getTriggerTable := @RoutineMetadataImpl_getTriggerTableDispatcher;
RoutineMetadataImpl_vTable.getTriggerType := @RoutineMetadataImpl_getTriggerTypeDispatcher;

ExternalEngineImpl_vTable := ExternalEngineVTable.create;
ExternalEngineImpl_vTable.version := 4;
ExternalEngineImpl_vTable.addRef := @ExternalEngineImpl_addRefDispatcher;
ExternalEngineImpl_vTable.release := @ExternalEngineImpl_releaseDispatcher;
ExternalEngineImpl_vTable.setOwner := @ExternalEngineImpl_setOwnerDispatcher;
ExternalEngineImpl_vTable.getOwner := @ExternalEngineImpl_getOwnerDispatcher;
ExternalEngineImpl_vTable.open := @ExternalEngineImpl_openDispatcher;
ExternalEngineImpl_vTable.openAttachment := @ExternalEngineImpl_openAttachmentDispatcher;
ExternalEngineImpl_vTable.closeAttachment := @ExternalEngineImpl_closeAttachmentDispatcher;
ExternalEngineImpl_vTable.makeFunction := @ExternalEngineImpl_makeFunctionDispatcher;
ExternalEngineImpl_vTable.makeProcedure := @ExternalEngineImpl_makeProcedureDispatcher;
ExternalEngineImpl_vTable.makeTrigger := @ExternalEngineImpl_makeTriggerDispatcher;

TimerImpl_vTable := TimerVTable.create;
TimerImpl_vTable.version := 3;
TimerImpl_vTable.addRef := @TimerImpl_addRefDispatcher;
TimerImpl_vTable.release := @TimerImpl_releaseDispatcher;
TimerImpl_vTable.handler := @TimerImpl_handlerDispatcher;

TimerControlImpl_vTable := TimerControlVTable.create;
TimerControlImpl_vTable.version := 2;
TimerControlImpl_vTable.start := @TimerControlImpl_startDispatcher;
TimerControlImpl_vTable.stop := @TimerControlImpl_stopDispatcher;

VersionCallbackImpl_vTable := VersionCallbackVTable.create;
VersionCallbackImpl_vTable.version := 2;
VersionCallbackImpl_vTable.callback := @VersionCallbackImpl_callbackDispatcher;

UtilImpl_vTable := UtilVTable.create;
UtilImpl_vTable.version := 4;
UtilImpl_vTable.getFbVersion := @UtilImpl_getFbVersionDispatcher;
UtilImpl_vTable.loadBlob := @UtilImpl_loadBlobDispatcher;
UtilImpl_vTable.dumpBlob := @UtilImpl_dumpBlobDispatcher;
UtilImpl_vTable.getPerfCounters := @UtilImpl_getPerfCountersDispatcher;
UtilImpl_vTable.executeCreateDatabase := @UtilImpl_executeCreateDatabaseDispatcher;
UtilImpl_vTable.decodeDate := @UtilImpl_decodeDateDispatcher;
UtilImpl_vTable.decodeTime := @UtilImpl_decodeTimeDispatcher;
UtilImpl_vTable.encodeDate := @UtilImpl_encodeDateDispatcher;
UtilImpl_vTable.encodeTime := @UtilImpl_encodeTimeDispatcher;
UtilImpl_vTable.formatStatus := @UtilImpl_formatStatusDispatcher;
UtilImpl_vTable.getClientVersion := @UtilImpl_getClientVersionDispatcher;
UtilImpl_vTable.getXpbBuilder := @UtilImpl_getXpbBuilderDispatcher;
UtilImpl_vTable.setOffsets := @UtilImpl_setOffsetsDispatcher;
UtilImpl_vTable.getDecFloat16 := @UtilImpl_getDecFloat16Dispatcher;
UtilImpl_vTable.getDecFloat34 := @UtilImpl_getDecFloat34Dispatcher;
UtilImpl_vTable.decodeTimeTz := @UtilImpl_decodeTimeTzDispatcher;
UtilImpl_vTable.decodeTimeStampTz := @UtilImpl_decodeTimeStampTzDispatcher;
UtilImpl_vTable.encodeTimeTz := @UtilImpl_encodeTimeTzDispatcher;
UtilImpl_vTable.encodeTimeStampTz := @UtilImpl_encodeTimeStampTzDispatcher;
UtilImpl_vTable.getInt128 := @UtilImpl_getInt128Dispatcher;
UtilImpl_vTable.decodeTimeTzEx := @UtilImpl_decodeTimeTzExDispatcher;
UtilImpl_vTable.decodeTimeStampTzEx := @UtilImpl_decodeTimeStampTzExDispatcher;

OffsetsCallbackImpl_vTable := OffsetsCallbackVTable.create;
OffsetsCallbackImpl_vTable.version := 2;
OffsetsCallbackImpl_vTable.setOffset := @OffsetsCallbackImpl_setOffsetDispatcher;

XpbBuilderImpl_vTable := XpbBuilderVTable.create;
XpbBuilderImpl_vTable.version := 3;
XpbBuilderImpl_vTable.dispose := @XpbBuilderImpl_disposeDispatcher;
XpbBuilderImpl_vTable.clear := @XpbBuilderImpl_clearDispatcher;
XpbBuilderImpl_vTable.removeCurrent := @XpbBuilderImpl_removeCurrentDispatcher;
XpbBuilderImpl_vTable.insertInt := @XpbBuilderImpl_insertIntDispatcher;
XpbBuilderImpl_vTable.insertBigInt := @XpbBuilderImpl_insertBigIntDispatcher;
XpbBuilderImpl_vTable.insertBytes := @XpbBuilderImpl_insertBytesDispatcher;
XpbBuilderImpl_vTable.insertString := @XpbBuilderImpl_insertStringDispatcher;
XpbBuilderImpl_vTable.insertTag := @XpbBuilderImpl_insertTagDispatcher;
XpbBuilderImpl_vTable.isEof := @XpbBuilderImpl_isEofDispatcher;
XpbBuilderImpl_vTable.moveNext := @XpbBuilderImpl_moveNextDispatcher;
XpbBuilderImpl_vTable.rewind := @XpbBuilderImpl_rewindDispatcher;
XpbBuilderImpl_vTable.findFirst := @XpbBuilderImpl_findFirstDispatcher;
XpbBuilderImpl_vTable.findNext := @XpbBuilderImpl_findNextDispatcher;
XpbBuilderImpl_vTable.getTag := @XpbBuilderImpl_getTagDispatcher;
XpbBuilderImpl_vTable.getLength := @XpbBuilderImpl_getLengthDispatcher;
XpbBuilderImpl_vTable.getInt := @XpbBuilderImpl_getIntDispatcher;
XpbBuilderImpl_vTable.getBigInt := @XpbBuilderImpl_getBigIntDispatcher;
XpbBuilderImpl_vTable.getString := @XpbBuilderImpl_getStringDispatcher;
XpbBuilderImpl_vTable.getBytes := @XpbBuilderImpl_getBytesDispatcher;
XpbBuilderImpl_vTable.getBufferLength := @XpbBuilderImpl_getBufferLengthDispatcher;
XpbBuilderImpl_vTable.getBuffer := @XpbBuilderImpl_getBufferDispatcher;

TraceConnectionImpl_vTable := TraceConnectionVTable.create;
TraceConnectionImpl_vTable.version := 2;
TraceConnectionImpl_vTable.getKind := @TraceConnectionImpl_getKindDispatcher;
TraceConnectionImpl_vTable.getProcessID := @TraceConnectionImpl_getProcessIDDispatcher;
TraceConnectionImpl_vTable.getUserName := @TraceConnectionImpl_getUserNameDispatcher;
TraceConnectionImpl_vTable.getRoleName := @TraceConnectionImpl_getRoleNameDispatcher;
TraceConnectionImpl_vTable.getCharSet := @TraceConnectionImpl_getCharSetDispatcher;
TraceConnectionImpl_vTable.getRemoteProtocol := @TraceConnectionImpl_getRemoteProtocolDispatcher;
TraceConnectionImpl_vTable.getRemoteAddress := @TraceConnectionImpl_getRemoteAddressDispatcher;
TraceConnectionImpl_vTable.getRemoteProcessID := @TraceConnectionImpl_getRemoteProcessIDDispatcher;
TraceConnectionImpl_vTable.getRemoteProcessName := @TraceConnectionImpl_getRemoteProcessNameDispatcher;

TraceDatabaseConnectionImpl_vTable := TraceDatabaseConnectionVTable.create;
TraceDatabaseConnectionImpl_vTable.version := 3;
TraceDatabaseConnectionImpl_vTable.getKind := @TraceDatabaseConnectionImpl_getKindDispatcher;
TraceDatabaseConnectionImpl_vTable.getProcessID := @TraceDatabaseConnectionImpl_getProcessIDDispatcher;
TraceDatabaseConnectionImpl_vTable.getUserName := @TraceDatabaseConnectionImpl_getUserNameDispatcher;
TraceDatabaseConnectionImpl_vTable.getRoleName := @TraceDatabaseConnectionImpl_getRoleNameDispatcher;
TraceDatabaseConnectionImpl_vTable.getCharSet := @TraceDatabaseConnectionImpl_getCharSetDispatcher;
TraceDatabaseConnectionImpl_vTable.getRemoteProtocol := @TraceDatabaseConnectionImpl_getRemoteProtocolDispatcher;
TraceDatabaseConnectionImpl_vTable.getRemoteAddress := @TraceDatabaseConnectionImpl_getRemoteAddressDispatcher;
TraceDatabaseConnectionImpl_vTable.getRemoteProcessID := @TraceDatabaseConnectionImpl_getRemoteProcessIDDispatcher;
TraceDatabaseConnectionImpl_vTable.getRemoteProcessName := @TraceDatabaseConnectionImpl_getRemoteProcessNameDispatcher;
TraceDatabaseConnectionImpl_vTable.getConnectionID := @TraceDatabaseConnectionImpl_getConnectionIDDispatcher;
TraceDatabaseConnectionImpl_vTable.getDatabaseName := @TraceDatabaseConnectionImpl_getDatabaseNameDispatcher;

TraceTransactionImpl_vTable := TraceTransactionVTable.create;
TraceTransactionImpl_vTable.version := 3;
TraceTransactionImpl_vTable.getTransactionID := @TraceTransactionImpl_getTransactionIDDispatcher;
TraceTransactionImpl_vTable.getReadOnly := @TraceTransactionImpl_getReadOnlyDispatcher;
TraceTransactionImpl_vTable.getWait := @TraceTransactionImpl_getWaitDispatcher;
TraceTransactionImpl_vTable.getIsolation := @TraceTransactionImpl_getIsolationDispatcher;
TraceTransactionImpl_vTable.getPerf := @TraceTransactionImpl_getPerfDispatcher;
TraceTransactionImpl_vTable.getInitialID := @TraceTransactionImpl_getInitialIDDispatcher;
TraceTransactionImpl_vTable.getPreviousID := @TraceTransactionImpl_getPreviousIDDispatcher;

TraceParamsImpl_vTable := TraceParamsVTable.create;
TraceParamsImpl_vTable.version := 3;
TraceParamsImpl_vTable.getCount := @TraceParamsImpl_getCountDispatcher;
TraceParamsImpl_vTable.getParam := @TraceParamsImpl_getParamDispatcher;
TraceParamsImpl_vTable.getTextUTF8 := @TraceParamsImpl_getTextUTF8Dispatcher;

TraceStatementImpl_vTable := TraceStatementVTable.create;
TraceStatementImpl_vTable.version := 2;
TraceStatementImpl_vTable.getStmtID := @TraceStatementImpl_getStmtIDDispatcher;
TraceStatementImpl_vTable.getPerf := @TraceStatementImpl_getPerfDispatcher;

TraceSQLStatementImpl_vTable := TraceSQLStatementVTable.create;
TraceSQLStatementImpl_vTable.version := 3;
TraceSQLStatementImpl_vTable.getStmtID := @TraceSQLStatementImpl_getStmtIDDispatcher;
TraceSQLStatementImpl_vTable.getPerf := @TraceSQLStatementImpl_getPerfDispatcher;
TraceSQLStatementImpl_vTable.getText := @TraceSQLStatementImpl_getTextDispatcher;
TraceSQLStatementImpl_vTable.getPlan := @TraceSQLStatementImpl_getPlanDispatcher;
TraceSQLStatementImpl_vTable.getInputs := @TraceSQLStatementImpl_getInputsDispatcher;
TraceSQLStatementImpl_vTable.getTextUTF8 := @TraceSQLStatementImpl_getTextUTF8Dispatcher;
TraceSQLStatementImpl_vTable.getExplainedPlan := @TraceSQLStatementImpl_getExplainedPlanDispatcher;

TraceBLRStatementImpl_vTable := TraceBLRStatementVTable.create;
TraceBLRStatementImpl_vTable.version := 3;
TraceBLRStatementImpl_vTable.getStmtID := @TraceBLRStatementImpl_getStmtIDDispatcher;
TraceBLRStatementImpl_vTable.getPerf := @TraceBLRStatementImpl_getPerfDispatcher;
TraceBLRStatementImpl_vTable.getData := @TraceBLRStatementImpl_getDataDispatcher;
TraceBLRStatementImpl_vTable.getDataLength := @TraceBLRStatementImpl_getDataLengthDispatcher;
TraceBLRStatementImpl_vTable.getText := @TraceBLRStatementImpl_getTextDispatcher;

TraceDYNRequestImpl_vTable := TraceDYNRequestVTable.create;
TraceDYNRequestImpl_vTable.version := 2;
TraceDYNRequestImpl_vTable.getData := @TraceDYNRequestImpl_getDataDispatcher;
TraceDYNRequestImpl_vTable.getDataLength := @TraceDYNRequestImpl_getDataLengthDispatcher;
TraceDYNRequestImpl_vTable.getText := @TraceDYNRequestImpl_getTextDispatcher;

TraceContextVariableImpl_vTable := TraceContextVariableVTable.create;
TraceContextVariableImpl_vTable.version := 2;
TraceContextVariableImpl_vTable.getNameSpace := @TraceContextVariableImpl_getNameSpaceDispatcher;
TraceContextVariableImpl_vTable.getVarName := @TraceContextVariableImpl_getVarNameDispatcher;
TraceContextVariableImpl_vTable.getVarValue := @TraceContextVariableImpl_getVarValueDispatcher;

TraceProcedureImpl_vTable := TraceProcedureVTable.create;
TraceProcedureImpl_vTable.version := 3;
TraceProcedureImpl_vTable.getProcName := @TraceProcedureImpl_getProcNameDispatcher;
TraceProcedureImpl_vTable.getInputs := @TraceProcedureImpl_getInputsDispatcher;
TraceProcedureImpl_vTable.getPerf := @TraceProcedureImpl_getPerfDispatcher;
TraceProcedureImpl_vTable.getStmtID := @TraceProcedureImpl_getStmtIDDispatcher;
TraceProcedureImpl_vTable.getPlan := @TraceProcedureImpl_getPlanDispatcher;
TraceProcedureImpl_vTable.getExplainedPlan := @TraceProcedureImpl_getExplainedPlanDispatcher;

TraceFunctionImpl_vTable := TraceFunctionVTable.create;
TraceFunctionImpl_vTable.version := 3;
TraceFunctionImpl_vTable.getFuncName := @TraceFunctionImpl_getFuncNameDispatcher;
TraceFunctionImpl_vTable.getInputs := @TraceFunctionImpl_getInputsDispatcher;
TraceFunctionImpl_vTable.getResult := @TraceFunctionImpl_getResultDispatcher;
TraceFunctionImpl_vTable.getPerf := @TraceFunctionImpl_getPerfDispatcher;
TraceFunctionImpl_vTable.getStmtID := @TraceFunctionImpl_getStmtIDDispatcher;
TraceFunctionImpl_vTable.getPlan := @TraceFunctionImpl_getPlanDispatcher;
TraceFunctionImpl_vTable.getExplainedPlan := @TraceFunctionImpl_getExplainedPlanDispatcher;

TraceTriggerImpl_vTable := TraceTriggerVTable.create;
TraceTriggerImpl_vTable.version := 3;
TraceTriggerImpl_vTable.getTriggerName := @TraceTriggerImpl_getTriggerNameDispatcher;
TraceTriggerImpl_vTable.getRelationName := @TraceTriggerImpl_getRelationNameDispatcher;
TraceTriggerImpl_vTable.getAction := @TraceTriggerImpl_getActionDispatcher;
TraceTriggerImpl_vTable.getWhich := @TraceTriggerImpl_getWhichDispatcher;
TraceTriggerImpl_vTable.getPerf := @TraceTriggerImpl_getPerfDispatcher;
TraceTriggerImpl_vTable.getStmtID := @TraceTriggerImpl_getStmtIDDispatcher;
TraceTriggerImpl_vTable.getPlan := @TraceTriggerImpl_getPlanDispatcher;
TraceTriggerImpl_vTable.getExplainedPlan := @TraceTriggerImpl_getExplainedPlanDispatcher;

TraceServiceConnectionImpl_vTable := TraceServiceConnectionVTable.create;
TraceServiceConnectionImpl_vTable.version := 3;
TraceServiceConnectionImpl_vTable.getKind := @TraceServiceConnectionImpl_getKindDispatcher;
TraceServiceConnectionImpl_vTable.getProcessID := @TraceServiceConnectionImpl_getProcessIDDispatcher;
TraceServiceConnectionImpl_vTable.getUserName := @TraceServiceConnectionImpl_getUserNameDispatcher;
TraceServiceConnectionImpl_vTable.getRoleName := @TraceServiceConnectionImpl_getRoleNameDispatcher;
TraceServiceConnectionImpl_vTable.getCharSet := @TraceServiceConnectionImpl_getCharSetDispatcher;
TraceServiceConnectionImpl_vTable.getRemoteProtocol := @TraceServiceConnectionImpl_getRemoteProtocolDispatcher;
TraceServiceConnectionImpl_vTable.getRemoteAddress := @TraceServiceConnectionImpl_getRemoteAddressDispatcher;
TraceServiceConnectionImpl_vTable.getRemoteProcessID := @TraceServiceConnectionImpl_getRemoteProcessIDDispatcher;
TraceServiceConnectionImpl_vTable.getRemoteProcessName := @TraceServiceConnectionImpl_getRemoteProcessNameDispatcher;
TraceServiceConnectionImpl_vTable.getServiceID := @TraceServiceConnectionImpl_getServiceIDDispatcher;
TraceServiceConnectionImpl_vTable.getServiceMgr := @TraceServiceConnectionImpl_getServiceMgrDispatcher;
TraceServiceConnectionImpl_vTable.getServiceName := @TraceServiceConnectionImpl_getServiceNameDispatcher;

TraceStatusVectorImpl_vTable := TraceStatusVectorVTable.create;
TraceStatusVectorImpl_vTable.version := 2;
TraceStatusVectorImpl_vTable.hasError := @TraceStatusVectorImpl_hasErrorDispatcher;
TraceStatusVectorImpl_vTable.hasWarning := @TraceStatusVectorImpl_hasWarningDispatcher;
TraceStatusVectorImpl_vTable.getStatus := @TraceStatusVectorImpl_getStatusDispatcher;
TraceStatusVectorImpl_vTable.getText := @TraceStatusVectorImpl_getTextDispatcher;

TraceSweepInfoImpl_vTable := TraceSweepInfoVTable.create;
TraceSweepInfoImpl_vTable.version := 2;
TraceSweepInfoImpl_vTable.getOIT := @TraceSweepInfoImpl_getOITDispatcher;
TraceSweepInfoImpl_vTable.getOST := @TraceSweepInfoImpl_getOSTDispatcher;
TraceSweepInfoImpl_vTable.getOAT := @TraceSweepInfoImpl_getOATDispatcher;
TraceSweepInfoImpl_vTable.getNext := @TraceSweepInfoImpl_getNextDispatcher;
TraceSweepInfoImpl_vTable.getPerf := @TraceSweepInfoImpl_getPerfDispatcher;

TraceLogWriterImpl_vTable := TraceLogWriterVTable.create;
TraceLogWriterImpl_vTable.version := 4;
TraceLogWriterImpl_vTable.addRef := @TraceLogWriterImpl_addRefDispatcher;
TraceLogWriterImpl_vTable.release := @TraceLogWriterImpl_releaseDispatcher;
TraceLogWriterImpl_vTable.write := @TraceLogWriterImpl_writeDispatcher;
TraceLogWriterImpl_vTable.write_s := @TraceLogWriterImpl_write_sDispatcher;

TraceInitInfoImpl_vTable := TraceInitInfoVTable.create;
TraceInitInfoImpl_vTable.version := 2;
TraceInitInfoImpl_vTable.getConfigText := @TraceInitInfoImpl_getConfigTextDispatcher;
TraceInitInfoImpl_vTable.getTraceSessionID := @TraceInitInfoImpl_getTraceSessionIDDispatcher;
TraceInitInfoImpl_vTable.getTraceSessionName := @TraceInitInfoImpl_getTraceSessionNameDispatcher;
TraceInitInfoImpl_vTable.getFirebirdRootDirectory := @TraceInitInfoImpl_getFirebirdRootDirectoryDispatcher;
TraceInitInfoImpl_vTable.getDatabaseName := @TraceInitInfoImpl_getDatabaseNameDispatcher;
TraceInitInfoImpl_vTable.getConnection := @TraceInitInfoImpl_getConnectionDispatcher;
TraceInitInfoImpl_vTable.getLogWriter := @TraceInitInfoImpl_getLogWriterDispatcher;

TracePluginImpl_vTable := TracePluginVTable.create;
TracePluginImpl_vTable.version := 5;
TracePluginImpl_vTable.addRef := @TracePluginImpl_addRefDispatcher;
TracePluginImpl_vTable.release := @TracePluginImpl_releaseDispatcher;
TracePluginImpl_vTable.trace_get_error := @TracePluginImpl_trace_get_errorDispatcher;
TracePluginImpl_vTable.trace_attach := @TracePluginImpl_trace_attachDispatcher;
TracePluginImpl_vTable.trace_detach := @TracePluginImpl_trace_detachDispatcher;
TracePluginImpl_vTable.trace_transaction_start := @TracePluginImpl_trace_transaction_startDispatcher;
TracePluginImpl_vTable.trace_transaction_end := @TracePluginImpl_trace_transaction_endDispatcher;
TracePluginImpl_vTable.trace_proc_execute := @TracePluginImpl_trace_proc_executeDispatcher;
TracePluginImpl_vTable.trace_trigger_execute := @TracePluginImpl_trace_trigger_executeDispatcher;
TracePluginImpl_vTable.trace_set_context := @TracePluginImpl_trace_set_contextDispatcher;
TracePluginImpl_vTable.trace_dsql_prepare := @TracePluginImpl_trace_dsql_prepareDispatcher;
TracePluginImpl_vTable.trace_dsql_free := @TracePluginImpl_trace_dsql_freeDispatcher;
TracePluginImpl_vTable.trace_dsql_execute := @TracePluginImpl_trace_dsql_executeDispatcher;
TracePluginImpl_vTable.trace_blr_compile := @TracePluginImpl_trace_blr_compileDispatcher;
TracePluginImpl_vTable.trace_blr_execute := @TracePluginImpl_trace_blr_executeDispatcher;
TracePluginImpl_vTable.trace_dyn_execute := @TracePluginImpl_trace_dyn_executeDispatcher;
TracePluginImpl_vTable.trace_service_attach := @TracePluginImpl_trace_service_attachDispatcher;
TracePluginImpl_vTable.trace_service_start := @TracePluginImpl_trace_service_startDispatcher;
TracePluginImpl_vTable.trace_service_query := @TracePluginImpl_trace_service_queryDispatcher;
TracePluginImpl_vTable.trace_service_detach := @TracePluginImpl_trace_service_detachDispatcher;
TracePluginImpl_vTable.trace_event_error := @TracePluginImpl_trace_event_errorDispatcher;
TracePluginImpl_vTable.trace_event_sweep := @TracePluginImpl_trace_event_sweepDispatcher;
TracePluginImpl_vTable.trace_func_execute := @TracePluginImpl_trace_func_executeDispatcher;
TracePluginImpl_vTable.trace_dsql_restart := @TracePluginImpl_trace_dsql_restartDispatcher;
TracePluginImpl_vTable.trace_proc_compile := @TracePluginImpl_trace_proc_compileDispatcher;
TracePluginImpl_vTable.trace_func_compile := @TracePluginImpl_trace_func_compileDispatcher;
TracePluginImpl_vTable.trace_trigger_compile := @TracePluginImpl_trace_trigger_compileDispatcher;

TraceFactoryImpl_vTable := TraceFactoryVTable.create;
TraceFactoryImpl_vTable.version := 4;
TraceFactoryImpl_vTable.addRef := @TraceFactoryImpl_addRefDispatcher;
TraceFactoryImpl_vTable.release := @TraceFactoryImpl_releaseDispatcher;
TraceFactoryImpl_vTable.setOwner := @TraceFactoryImpl_setOwnerDispatcher;
TraceFactoryImpl_vTable.getOwner := @TraceFactoryImpl_getOwnerDispatcher;
TraceFactoryImpl_vTable.trace_needs := @TraceFactoryImpl_trace_needsDispatcher;
TraceFactoryImpl_vTable.trace_create := @TraceFactoryImpl_trace_createDispatcher;

UdrFunctionFactoryImpl_vTable := UdrFunctionFactoryVTable.create;
UdrFunctionFactoryImpl_vTable.version := 3;
UdrFunctionFactoryImpl_vTable.dispose := @UdrFunctionFactoryImpl_disposeDispatcher;
UdrFunctionFactoryImpl_vTable.setup := @UdrFunctionFactoryImpl_setupDispatcher;
UdrFunctionFactoryImpl_vTable.newItem := @UdrFunctionFactoryImpl_newItemDispatcher;

UdrProcedureFactoryImpl_vTable := UdrProcedureFactoryVTable.create;
UdrProcedureFactoryImpl_vTable.version := 3;
UdrProcedureFactoryImpl_vTable.dispose := @UdrProcedureFactoryImpl_disposeDispatcher;
UdrProcedureFactoryImpl_vTable.setup := @UdrProcedureFactoryImpl_setupDispatcher;
UdrProcedureFactoryImpl_vTable.newItem := @UdrProcedureFactoryImpl_newItemDispatcher;

UdrTriggerFactoryImpl_vTable := UdrTriggerFactoryVTable.create;
UdrTriggerFactoryImpl_vTable.version := 3;
UdrTriggerFactoryImpl_vTable.dispose := @UdrTriggerFactoryImpl_disposeDispatcher;
UdrTriggerFactoryImpl_vTable.setup := @UdrTriggerFactoryImpl_setupDispatcher;
UdrTriggerFactoryImpl_vTable.newItem := @UdrTriggerFactoryImpl_newItemDispatcher;

UdrPluginImpl_vTable := UdrPluginVTable.create;
UdrPluginImpl_vTable.version := 2;
UdrPluginImpl_vTable.getMaster := @UdrPluginImpl_getMasterDispatcher;
UdrPluginImpl_vTable.registerFunction := @UdrPluginImpl_registerFunctionDispatcher;
UdrPluginImpl_vTable.registerProcedure := @UdrPluginImpl_registerProcedureDispatcher;
UdrPluginImpl_vTable.registerTrigger := @UdrPluginImpl_registerTriggerDispatcher;

DecFloat16Impl_vTable := DecFloat16VTable.create;
DecFloat16Impl_vTable.version := 2;
DecFloat16Impl_vTable.toBcd := @DecFloat16Impl_toBcdDispatcher;
DecFloat16Impl_vTable.toString := @DecFloat16Impl_toStringDispatcher;
DecFloat16Impl_vTable.fromBcd := @DecFloat16Impl_fromBcdDispatcher;
DecFloat16Impl_vTable.fromString := @DecFloat16Impl_fromStringDispatcher;

DecFloat34Impl_vTable := DecFloat34VTable.create;
DecFloat34Impl_vTable.version := 2;
DecFloat34Impl_vTable.toBcd := @DecFloat34Impl_toBcdDispatcher;
DecFloat34Impl_vTable.toString := @DecFloat34Impl_toStringDispatcher;
DecFloat34Impl_vTable.fromBcd := @DecFloat34Impl_fromBcdDispatcher;
DecFloat34Impl_vTable.fromString := @DecFloat34Impl_fromStringDispatcher;

Int128Impl_vTable := Int128VTable.create;
Int128Impl_vTable.version := 2;
Int128Impl_vTable.toString := @Int128Impl_toStringDispatcher;
Int128Impl_vTable.fromString := @Int128Impl_fromStringDispatcher;

ReplicatedFieldImpl_vTable := ReplicatedFieldVTable.create;
ReplicatedFieldImpl_vTable.version := 2;
ReplicatedFieldImpl_vTable.getName := @ReplicatedFieldImpl_getNameDispatcher;
ReplicatedFieldImpl_vTable.getType := @ReplicatedFieldImpl_getTypeDispatcher;
ReplicatedFieldImpl_vTable.getSubType := @ReplicatedFieldImpl_getSubTypeDispatcher;
ReplicatedFieldImpl_vTable.getScale := @ReplicatedFieldImpl_getScaleDispatcher;
ReplicatedFieldImpl_vTable.getLength := @ReplicatedFieldImpl_getLengthDispatcher;
ReplicatedFieldImpl_vTable.getCharSet := @ReplicatedFieldImpl_getCharSetDispatcher;
ReplicatedFieldImpl_vTable.getData := @ReplicatedFieldImpl_getDataDispatcher;

ReplicatedRecordImpl_vTable := ReplicatedRecordVTable.create;
ReplicatedRecordImpl_vTable.version := 2;
ReplicatedRecordImpl_vTable.getCount := @ReplicatedRecordImpl_getCountDispatcher;
ReplicatedRecordImpl_vTable.getField := @ReplicatedRecordImpl_getFieldDispatcher;
ReplicatedRecordImpl_vTable.getRawLength := @ReplicatedRecordImpl_getRawLengthDispatcher;
ReplicatedRecordImpl_vTable.getRawData := @ReplicatedRecordImpl_getRawDataDispatcher;

ReplicatedTransactionImpl_vTable := ReplicatedTransactionVTable.create;
ReplicatedTransactionImpl_vTable.version := 3;
ReplicatedTransactionImpl_vTable.dispose := @ReplicatedTransactionImpl_disposeDispatcher;
ReplicatedTransactionImpl_vTable.prepare := @ReplicatedTransactionImpl_prepareDispatcher;
ReplicatedTransactionImpl_vTable.commit := @ReplicatedTransactionImpl_commitDispatcher;
ReplicatedTransactionImpl_vTable.rollback := @ReplicatedTransactionImpl_rollbackDispatcher;
ReplicatedTransactionImpl_vTable.startSavepoint := @ReplicatedTransactionImpl_startSavepointDispatcher;
ReplicatedTransactionImpl_vTable.releaseSavepoint := @ReplicatedTransactionImpl_releaseSavepointDispatcher;
ReplicatedTransactionImpl_vTable.rollbackSavepoint := @ReplicatedTransactionImpl_rollbackSavepointDispatcher;
ReplicatedTransactionImpl_vTable.insertRecord := @ReplicatedTransactionImpl_insertRecordDispatcher;
ReplicatedTransactionImpl_vTable.updateRecord := @ReplicatedTransactionImpl_updateRecordDispatcher;
ReplicatedTransactionImpl_vTable.deleteRecord := @ReplicatedTransactionImpl_deleteRecordDispatcher;
ReplicatedTransactionImpl_vTable.executeSql := @ReplicatedTransactionImpl_executeSqlDispatcher;
ReplicatedTransactionImpl_vTable.executeSqlIntl := @ReplicatedTransactionImpl_executeSqlIntlDispatcher;

ReplicatedSessionImpl_vTable := ReplicatedSessionVTable.create;
ReplicatedSessionImpl_vTable.version := 4;
ReplicatedSessionImpl_vTable.addRef := @ReplicatedSessionImpl_addRefDispatcher;
ReplicatedSessionImpl_vTable.release := @ReplicatedSessionImpl_releaseDispatcher;
ReplicatedSessionImpl_vTable.setOwner := @ReplicatedSessionImpl_setOwnerDispatcher;
ReplicatedSessionImpl_vTable.getOwner := @ReplicatedSessionImpl_getOwnerDispatcher;
ReplicatedSessionImpl_vTable.init := @ReplicatedSessionImpl_initDispatcher;
ReplicatedSessionImpl_vTable.startTransaction := @ReplicatedSessionImpl_startTransactionDispatcher;
ReplicatedSessionImpl_vTable.cleanupTransaction := @ReplicatedSessionImpl_cleanupTransactionDispatcher;
ReplicatedSessionImpl_vTable.setSequence := @ReplicatedSessionImpl_setSequenceDispatcher;

ProfilerPluginImpl_vTable := ProfilerPluginVTable.create;
ProfilerPluginImpl_vTable.version := 4;
ProfilerPluginImpl_vTable.addRef := @ProfilerPluginImpl_addRefDispatcher;
ProfilerPluginImpl_vTable.release := @ProfilerPluginImpl_releaseDispatcher;
ProfilerPluginImpl_vTable.setOwner := @ProfilerPluginImpl_setOwnerDispatcher;
ProfilerPluginImpl_vTable.getOwner := @ProfilerPluginImpl_getOwnerDispatcher;
ProfilerPluginImpl_vTable.init := @ProfilerPluginImpl_initDispatcher;
ProfilerPluginImpl_vTable.startSession := @ProfilerPluginImpl_startSessionDispatcher;
ProfilerPluginImpl_vTable.flush := @ProfilerPluginImpl_flushDispatcher;

ProfilerSessionImpl_vTable := ProfilerSessionVTable.create;
ProfilerSessionImpl_vTable.version := 3;
ProfilerSessionImpl_vTable.dispose := @ProfilerSessionImpl_disposeDispatcher;
ProfilerSessionImpl_vTable.getId := @ProfilerSessionImpl_getIdDispatcher;
ProfilerSessionImpl_vTable.getFlags := @ProfilerSessionImpl_getFlagsDispatcher;
ProfilerSessionImpl_vTable.cancel := @ProfilerSessionImpl_cancelDispatcher;
ProfilerSessionImpl_vTable.finish := @ProfilerSessionImpl_finishDispatcher;
ProfilerSessionImpl_vTable.defineStatement := @ProfilerSessionImpl_defineStatementDispatcher;
ProfilerSessionImpl_vTable.defineCursor := @ProfilerSessionImpl_defineCursorDispatcher;
ProfilerSessionImpl_vTable.defineRecordSource := @ProfilerSessionImpl_defineRecordSourceDispatcher;
ProfilerSessionImpl_vTable.onRequestStart := @ProfilerSessionImpl_onRequestStartDispatcher;
ProfilerSessionImpl_vTable.onRequestFinish := @ProfilerSessionImpl_onRequestFinishDispatcher;
ProfilerSessionImpl_vTable.beforePsqlLineColumn := @ProfilerSessionImpl_beforePsqlLineColumnDispatcher;
ProfilerSessionImpl_vTable.afterPsqlLineColumn := @ProfilerSessionImpl_afterPsqlLineColumnDispatcher;
ProfilerSessionImpl_vTable.beforeRecordSourceOpen := @ProfilerSessionImpl_beforeRecordSourceOpenDispatcher;
ProfilerSessionImpl_vTable.afterRecordSourceOpen := @ProfilerSessionImpl_afterRecordSourceOpenDispatcher;
ProfilerSessionImpl_vTable.beforeRecordSourceGetRecord := @ProfilerSessionImpl_beforeRecordSourceGetRecordDispatcher;
ProfilerSessionImpl_vTable.afterRecordSourceGetRecord := @ProfilerSessionImpl_afterRecordSourceGetRecordDispatcher;

ProfilerStatsImpl_vTable := ProfilerStatsVTable.create;
ProfilerStatsImpl_vTable.version := 2;
ProfilerStatsImpl_vTable.getElapsedTicks := @ProfilerStatsImpl_getElapsedTicksDispatcher;

finalization

VersionedImpl_vTable.Destroy;
ReferenceCountedImpl_vTable.Destroy;
DisposableImpl_vTable.Destroy;
StatusImpl_vTable.Destroy;
MasterImpl_vTable.Destroy;
PluginBaseImpl_vTable.Destroy;
PluginSetImpl_vTable.Destroy;
ConfigEntryImpl_vTable.Destroy;
ConfigImpl_vTable.Destroy;
FirebirdConfImpl_vTable.Destroy;
PluginConfigImpl_vTable.Destroy;
PluginFactoryImpl_vTable.Destroy;
PluginModuleImpl_vTable.Destroy;
PluginManagerImpl_vTable.Destroy;
CryptKeyImpl_vTable.Destroy;
ConfigManagerImpl_vTable.Destroy;
EventCallbackImpl_vTable.Destroy;
BlobImpl_vTable.Destroy;
TransactionImpl_vTable.Destroy;
MessageMetadataImpl_vTable.Destroy;
MetadataBuilderImpl_vTable.Destroy;
ResultSetImpl_vTable.Destroy;
StatementImpl_vTable.Destroy;
BatchImpl_vTable.Destroy;
BatchCompletionStateImpl_vTable.Destroy;
ReplicatorImpl_vTable.Destroy;
RequestImpl_vTable.Destroy;
EventsImpl_vTable.Destroy;
AttachmentImpl_vTable.Destroy;
ServiceImpl_vTable.Destroy;
ProviderImpl_vTable.Destroy;
DtcStartImpl_vTable.Destroy;
DtcImpl_vTable.Destroy;
AuthImpl_vTable.Destroy;
WriterImpl_vTable.Destroy;
ServerBlockImpl_vTable.Destroy;
ClientBlockImpl_vTable.Destroy;
ServerImpl_vTable.Destroy;
ClientImpl_vTable.Destroy;
UserFieldImpl_vTable.Destroy;
CharUserFieldImpl_vTable.Destroy;
IntUserFieldImpl_vTable.Destroy;
UserImpl_vTable.Destroy;
ListUsersImpl_vTable.Destroy;
LogonInfoImpl_vTable.Destroy;
ManagementImpl_vTable.Destroy;
AuthBlockImpl_vTable.Destroy;
WireCryptPluginImpl_vTable.Destroy;
CryptKeyCallbackImpl_vTable.Destroy;
KeyHolderPluginImpl_vTable.Destroy;
DbCryptInfoImpl_vTable.Destroy;
DbCryptPluginImpl_vTable.Destroy;
ExternalContextImpl_vTable.Destroy;
ExternalResultSetImpl_vTable.Destroy;
ExternalFunctionImpl_vTable.Destroy;
ExternalProcedureImpl_vTable.Destroy;
ExternalTriggerImpl_vTable.Destroy;
RoutineMetadataImpl_vTable.Destroy;
ExternalEngineImpl_vTable.Destroy;
TimerImpl_vTable.Destroy;
TimerControlImpl_vTable.Destroy;
VersionCallbackImpl_vTable.Destroy;
UtilImpl_vTable.Destroy;
OffsetsCallbackImpl_vTable.Destroy;
XpbBuilderImpl_vTable.Destroy;
TraceConnectionImpl_vTable.Destroy;
TraceDatabaseConnectionImpl_vTable.Destroy;
TraceTransactionImpl_vTable.Destroy;
TraceParamsImpl_vTable.Destroy;
TraceStatementImpl_vTable.Destroy;
TraceSQLStatementImpl_vTable.Destroy;
TraceBLRStatementImpl_vTable.Destroy;
TraceDYNRequestImpl_vTable.Destroy;
TraceContextVariableImpl_vTable.Destroy;
TraceProcedureImpl_vTable.Destroy;
TraceFunctionImpl_vTable.Destroy;
TraceTriggerImpl_vTable.Destroy;
TraceServiceConnectionImpl_vTable.Destroy;
TraceStatusVectorImpl_vTable.Destroy;
TraceSweepInfoImpl_vTable.Destroy;
TraceLogWriterImpl_vTable.Destroy;
TraceInitInfoImpl_vTable.Destroy;
TracePluginImpl_vTable.Destroy;
TraceFactoryImpl_vTable.Destroy;
UdrFunctionFactoryImpl_vTable.Destroy;
UdrProcedureFactoryImpl_vTable.Destroy;
UdrTriggerFactoryImpl_vTable.Destroy;
UdrPluginImpl_vTable.Destroy;
DecFloat16Impl_vTable.Destroy;
DecFloat34Impl_vTable.Destroy;
Int128Impl_vTable.Destroy;
ReplicatedFieldImpl_vTable.Destroy;
ReplicatedRecordImpl_vTable.Destroy;
ReplicatedTransactionImpl_vTable.Destroy;
ReplicatedSessionImpl_vTable.Destroy;
ProfilerPluginImpl_vTable.Destroy;
ProfilerSessionImpl_vTable.Destroy;
ProfilerStatsImpl_vTable.Destroy;

end.
