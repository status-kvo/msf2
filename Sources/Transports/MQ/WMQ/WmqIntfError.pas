unit WmqIntfError;

{$IFDEF FPC}
  {$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses
  SysUtils;

function MqIErrorDescriptionGet(const aErrorCode: nativeint): string;

implementation

function MqIErrorDescriptionGet(const aErrorCode: nativeint): string;
begin
  case aErrorCode of
    0:
      Result := 'MQRC_NONE';
    900:
      Result := 'MQRC_APPL_FIRST';
    999:
      Result := 'MQRC_APPL_LAST';
    2001:
      Result := 'MQRC_ALIAS_BASE_Q_TYPE_ERROR';
    2002:
      Result := 'MQRC_ALREADY_CONNECTED';
    2003:
      Result := 'MQRC_BACKED_OUT';
    2004:
      Result := 'MQRC_BUFFER_ERROR';
    2005:
      Result := 'MQRC_BUFFER_LENGTH_ERROR';
    2006:
      Result := 'MQRC_CHAR_ATTR_LENGTH_ERROR';
    2007:
      Result := 'MQRC_CHAR_ATTRS_ERROR';
    2008:
      Result := 'MQRC_CHAR_ATTRS_TOO_SHORT';
    2009:
      Result := 'MQRC_CONNECTION_BROKEN';
    2010:
      Result := 'MQRC_DATA_LENGTH_ERROR';
    2011:
      Result := 'MQRC_DYNAMIC_Q_NAME_ERROR';
    2012:
      Result := 'MQRC_ENVIRONMENT_ERROR';
    2013:
      Result := 'MQRC_EXPIRY_ERROR';
    2014:
      Result := 'MQRC_FEEDBACK_ERROR';
    2016:
      Result := 'MQRC_GET_INHIBITED';
    2017:
      Result := 'MQRC_HANDLE_NOT_AVAILABLE';
    2018:
      Result := 'MQRC_HCONN_ERROR';
    2019:
      Result := 'MQRC_HOBJ_ERROR';
    2020:
      Result := 'MQRC_INHIBIT_VALUE_ERROR';
    2021:
      Result := 'MQRC_INT_ATTR_COUNT_ERROR';
    2022:
      Result := 'MQRC_INT_ATTR_COUNT_TOO_SMALL';
    2023:
      Result := 'MQRC_INT_ATTRS_ARRAY_ERROR';
    2024:
      Result := 'MQRC_SYNCPOINT_LIMIT_REACHED';
    2025:
      Result := 'MQRC_MAX_CONNS_LIMIT_REACHED';
    2026:
      Result := 'MQRC_MD_ERROR';
    2027:
      Result := 'MQRC_MISSING_REPLY_TO_Q';
    2029:
      Result := 'MQRC_MSG_TYPE_ERROR';
    2030:
      Result := 'MQRC_MSG_TOO_BIG_FOR_Q';
    2031:
      Result := 'MQRC_MSG_TOO_BIG_FOR_Q_MGR';
    2033:
      Result := 'MQRC_NO_MSG_AVAILABLE';
    2034:
      Result := 'MQRC_NO_MSG_UNDER_CURSOR';
    2035:
      Result := 'MQRC_NOT_AUTHORIZED';
    2036:
      Result := 'MQRC_NOT_OPEN_FOR_BROWSE';
    2037:
      Result := 'MQRC_NOT_OPEN_FOR_INPUT';
    2038:
      Result := 'MQRC_NOT_OPEN_FOR_INQUIRE';
    2039:
      Result := 'MQRC_NOT_OPEN_FOR_OUTPUT';
    2040:
      Result := 'MQRC_NOT_OPEN_FOR_SET';
    2041:
      Result := 'MQRC_OBJECT_CHANGED';
    2042:
      Result := 'MQRC_OBJECT_IN_USE';
    2043:
      Result := 'MQRC_OBJECT_TYPE_ERROR';
    2044:
      Result := 'MQRC_OD_ERROR';
    2045:
      Result := 'MQRC_OPTION_NOT_VALID_FOR_TYPE';
    2046:
      Result := 'MQRC_OPTIONS_ERROR';
    2047:
      Result := 'MQRC_PERSISTENCE_ERROR';
    2048:
      Result := 'MQRC_PERSISTENT_NOT_ALLOWED';
    2049:
      Result := 'MQRC_PRIORITY_EXCEEDS_MAXIMUM';
    2050:
      Result := 'MQRC_PRIORITY_ERROR';
    2051:
      Result := 'MQRC_PUT_INHIBITED';
    2052:
      Result := 'MQRC_Q_DELETED';
    2053:
      Result := 'MQRC_Q_FULL';
    2055:
      Result := 'MQRC_Q_NOT_EMPTY';
    2056:
      Result := 'MQRC_Q_SPACE_NOT_AVAILABLE';
    2057:
      Result := 'MQRC_Q_TYPE_ERROR';
    2058:
      Result := 'MQRC_Q_MGR_NAME_ERROR';
    2059:
      Result := 'MQRC_Q_MGR_NOT_AVAILABLE';
    2061:
      Result := 'MQRC_REPORT_OPTIONS_ERROR';
    2062:
      Result := 'MQRC_SECOND_MARK_NOT_ALLOWED';
    2063:
      Result := 'MQRC_SECURITY_ERROR';
    2065:
      Result := 'MQRC_SELECTOR_COUNT_ERROR';
    2066:
      Result := 'MQRC_SELECTOR_LIMIT_EXCEEDED';
    2067:
      Result := 'MQRC_SELECTOR_ERROR';
    2068:
      Result := 'MQRC_SELECTOR_NOT_FOR_TYPE';
    2069:
      Result := 'MQRC_SIGNAL_OUTSTANDING';
    2070:
      Result := 'MQRC_SIGNAL_REQUEST_ACCEPTED';
    2071:
      Result := 'MQRC_STORAGE_NOT_AVAILABLE';
    2072:
      Result := 'MQRC_SYNCPOINT_NOT_AVAILABLE';
    2075:
      Result := 'MQRC_TRIGGER_CONTROL_ERROR';
    2076:
      Result := 'MQRC_TRIGGER_DEPTH_ERROR';
    2077:
      Result := 'MQRC_TRIGGER_MSG_PRIORITY_ERR';
    2078:
      Result := 'MQRC_TRIGGER_TYPE_ERROR';
    2079:
      Result := 'MQRC_TRUNCATED_MSG_ACCEPTED';
    2080:
      Result := 'MQRC_TRUNCATED_MSG_FAILED';
    2082:
      Result := 'MQRC_UNKNOWN_ALIAS_BASE_Q';
    2085:
      Result := 'MQRC_UNKNOWN_OBJECT_NAME';
    2086:
      Result := 'MQRC_UNKNOWN_OBJECT_Q_MGR';
    2087:
      Result := 'MQRC_UNKNOWN_REMOTE_Q_MGR';
    2090:
      Result := 'MQRC_WAIT_INTERVAL_ERROR';
    2091:
      Result := 'MQRC_XMIT_Q_TYPE_ERROR';
    2092:
      Result := 'MQRC_XMIT_Q_USAGE_ERROR';
    2093:
      Result := 'MQRC_NOT_OPEN_FOR_PASS_ALL';
    2094:
      Result := 'MQRC_NOT_OPEN_FOR_PASS_IDENT';
    2095:
      Result := 'MQRC_NOT_OPEN_FOR_SET_ALL';
    2096:
      Result := 'MQRC_NOT_OPEN_FOR_SET_IDENT';
    2097:
      Result := 'MQRC_CONTEXT_HANDLE_ERROR';
    2098:
      Result := 'MQRC_CONTEXT_NOT_AVAILABLE';
    2099:
      Result := 'MQRC_SIGNAL1_ERROR';
    2100:
      Result := 'MQRC_OBJECT_ALREADY_EXISTS';
    2101:
      Result := 'MQRC_OBJECT_DAMAGED';
    2102:
      Result := 'MQRC_RESOURCE_PROBLEM';
    2103:
      Result := 'MQRC_ANOTHER_Q_MGR_CONNECTED';
    2104:
      Result := 'MQRC_UNKNOWN_REPORT_OPTION';
    2105:
      Result := 'MQRC_STORAGE_CLASS_ERROR';
    2106:
      Result := 'MQRC_COD_NOT_VALID_FOR_XCF_Q';
    2107:
      Result := 'MQRC_XWAIT_CANCELED';
    2108:
      Result := 'MQRC_XWAIT_ERROR';
    2109:
      Result := 'MQRC_SUPPRESSED_BY_EXIT';
    2110:
      Result := 'MQRC_FORMAT_ERROR';
    2111:
      Result := 'MQRC_SOURCE_CCSID_ERROR';
    2112:
      Result := 'MQRC_SOURCE_INTEGER_ENC_ERROR';
    2113:
      Result := 'MQRC_SOURCE_DECIMAL_ENC_ERROR';
    2114:
      Result := 'MQRC_SOURCE_FLOAT_ENC_ERROR';
    2115:
      Result := 'MQRC_TARGET_CCSID_ERROR';
    2116:
      Result := 'MQRC_TARGET_INTEGER_ENC_ERROR';
    2117:
      Result := 'MQRC_TARGET_DECIMAL_ENC_ERROR';
    2118:
      Result := 'MQRC_TARGET_FLOAT_ENC_ERROR';
    2119:
      Result := 'MQRC_NOT_CONVERTED';
    2120:
      Result := 'MQRC_CONVERTED_MSG_TOO_BIG';
    2121:
      Result := 'MQRC_NO_EXTERNAL_PARTICIPANTS';
    2122:
      Result := 'MQRC_PARTICIPANT_NOT_AVAILABLE';
    2123:
      Result := 'MQRC_OUTCOME_MIXED';
    2124:
      Result := 'MQRC_OUTCOME_PENDING';
    2125:
      Result := 'MQRC_BRIDGE_STARTED';
    2126:
      Result := 'MQRC_BRIDGE_STOPPED';
    2127:
      Result := 'MQRC_ADAPTER_STORAGE_SHORTAGE';
    2128:
      Result := 'MQRC_UOW_IN_PROGRESS';
    2129:
      Result := 'MQRC_ADAPTER_CONN_LOAD_ERROR';
    2130:
      Result := 'MQRC_ADAPTER_SERV_LOAD_ERROR';
    2131:
      Result := 'MQRC_ADAPTER_DEFS_ERROR';
    2132:
      Result := 'MQRC_ADAPTER_DEFS_LOAD_ERROR';
    2133:
      Result := 'MQRC_ADAPTER_CONV_LOAD_ERROR';
    2134:
      Result := 'MQRC_BO_ERROR';
    2135:
      Result := 'MQRC_DH_ERROR';
    2136:
      Result := 'MQRC_MULTIPLE_REASONS';
    2137:
      Result := 'MQRC_OPEN_FAILED';
    2138:
      Result := 'MQRC_ADAPTER_DISC_LOAD_ERROR';
    2139:
      Result := 'MQRC_CNO_ERROR';
    2140:
      Result := 'MQRC_CICS_WAIT_FAILED';
    2141:
      Result := 'MQRC_DLH_ERROR';
    2142:
      Result := 'MQRC_HEADER_ERROR';
    2143:
      Result := 'MQRC_SOURCE_LENGTH_ERROR';
    2144:
      Result := 'MQRC_TARGET_LENGTH_ERROR';
    2145:
      Result := 'MQRC_SOURCE_BUFFER_ERROR';
    2146:
      Result := 'MQRC_TARGET_BUFFER_ERROR';
    2148:
      Result := 'MQRC_IIH_ERROR';
    2149:
      Result := 'MQRC_PCF_ERROR';
    2150:
      Result := 'MQRC_DBCS_ERROR';
    2152:
      Result := 'MQRC_OBJECT_NAME_ERROR';
    2153:
      Result := 'MQRC_OBJECT_Q_MGR_NAME_ERROR';
    2154:
      Result := 'MQRC_RECS_PRESENT_ERROR';
    2155:
      Result := 'MQRC_OBJECT_RECORDS_ERROR';
    2156:
      Result := 'MQRC_RESPONSE_RECORDS_ERROR';
    2157:
      Result := 'MQRC_ASID_MISMATCH';
    2158:
      Result := 'MQRC_PMO_RECORD_FLAGS_ERROR';
    2159:
      Result := 'MQRC_PUT_MSG_RECORDS_ERROR';
    2160:
      Result := 'MQRC_CONN_ID_IN_USE';
    2161:
      Result := 'MQRC_Q_MGR_QUIESCING';
    2162:
      Result := 'MQRC_Q_MGR_STOPPING';
    2163:
      Result := 'MQRC_DUPLICATE_RECOV_COORD';
    2173:
      Result := 'MQRC_PMO_ERROR';
    2183:
      Result := 'MQRC_API_EXIT_LOAD_ERROR';
    2184:
      Result := 'MQRC_REMOTE_Q_NAME_ERROR';
    2185:
      Result := 'MQRC_INCONSISTENT_PERSISTENCE';
    2186:
      Result := 'MQRC_GMO_ERROR';
    2187:
      Result := 'MQRC_CICS_BRIDGE_RESTRICTION';
    2188:
      Result := 'MQRC_STOPPED_BY_CLUSTER_EXIT';
    2189:
      Result := 'MQRC_CLUSTER_RESOLUTION_ERROR';
    2190:
      Result := 'MQRC_CONVERTED_STRING_TOO_BIG';
    2191:
      Result := 'MQRC_TMC_ERROR';
    2192:
      Result := 'MQRC_PAGESET_FULL';
    2193:
      Result := 'MQRC_PAGESET_ERROR';
    2194:
      Result := 'MQRC_NAME_NOT_VALID_FOR_TYPE';
    2195:
      Result := 'MQRC_UNEXPECTED_ERROR';
    2196:
      Result := 'MQRC_UNKNOWN_XMIT_Q';
    2197:
      Result := 'MQRC_UNKNOWN_DEF_XMIT_Q';
    2198:
      Result := 'MQRC_DEF_XMIT_Q_TYPE_ERROR';
    2199:
      Result := 'MQRC_DEF_XMIT_Q_USAGE_ERROR';
    2201:
      Result := 'MQRC_NAME_IN_USE';
    2202:
      Result := 'MQRC_CONNECTION_QUIESCING';
    2203:
      Result := 'MQRC_CONNECTION_STOPPING';
    2204:
      Result := 'MQRC_ADAPTER_NOT_AVAILABLE';
    2206:
      Result := 'MQRC_MSG_ID_ERROR';
    2207:
      Result := 'MQRC_CORREL_ID_ERROR';
    2208:
      Result := 'MQRC_FILE_SYSTEM_ERROR';
    2209:
      Result := 'MQRC_NO_MSG_LOCKED';
    2210:
      Result := 'MQRC_SOAP_DOTNET_ERROR';
    2211:
      Result := 'MQRC_SOAP_AXIS_ERROR';
    2212:
      Result := 'MQRC_SOAP_URL_ERROR';
    2217:
      Result := 'MQRC_CONNECTION_NOT_AUTHORIZED';
    2218:
      Result := 'MQRC_MSG_TOO_BIG_FOR_CHANNEL';
    2219:
      Result := 'MQRC_CALL_IN_PROGRESS';
    2220:
      Result := 'MQRC_RMH_ERROR';
    2222:
      Result := 'MQRC_Q_MGR_ACTIVE';
    2223:
      Result := 'MQRC_Q_MGR_NOT_ACTIVE';
    2224:
      Result := 'MQRC_Q_DEPTH_HIGH';
    2225:
      Result := 'MQRC_Q_DEPTH_LOW';
    2226:
      Result := 'MQRC_Q_SERVICE_INTERVAL_HIGH';
    2227:
      Result := 'MQRC_Q_SERVICE_INTERVAL_OK';
    2228:
      Result := 'MQRC_RFH_HEADER_FIELD_ERROR';
    2229:
      Result := 'MQRC_RAS_PROPERTY_ERROR';
    2232:
      Result := 'MQRC_UNIT_OF_WORK_NOT_STARTED';
    2233:
      Result := 'MQRC_CHANNEL_AUTO_DEF_OK';
    2234:
      Result := 'MQRC_CHANNEL_AUTO_DEF_ERROR';
    2235:
      Result := 'MQRC_CFH_ERROR';
    2236:
      Result := 'MQRC_CFIL_ERROR';
    2237:
      Result := 'MQRC_CFIN_ERROR';
    2238:
      Result := 'MQRC_CFSL_ERROR';
    2239:
      Result := 'MQRC_CFST_ERROR';
    2241:
      Result := 'MQRC_INCOMPLETE_GROUP';
    2242:
      Result := 'MQRC_INCOMPLETE_MSG';
    2243:
      Result := 'MQRC_INCONSISTENT_CCSIDS';
    2244:
      Result := 'MQRC_INCONSISTENT_ENCODINGS';
    2245:
      Result := 'MQRC_INCONSISTENT_UOW';
    2246:
      Result := 'MQRC_INVALID_MSG_UNDER_CURSOR';
    2247:
      Result := 'MQRC_MATCH_OPTIONS_ERROR';
    2248:
      Result := 'MQRC_MDE_ERROR';
    2249:
      Result := 'MQRC_MSG_FLAGS_ERROR';
    2250:
      Result := 'MQRC_MSG_SEQ_NUMBER_ERROR';
    2251:
      Result := 'MQRC_OFFSET_ERROR';
    2252:
      Result := 'MQRC_ORIGINAL_LENGTH_ERROR';
    2253:
      Result := 'MQRC_SEGMENT_LENGTH_ZERO';
    2255:
      Result := 'MQRC_UOW_NOT_AVAILABLE';
    2256:
      Result := 'MQRC_WRONG_GMO_VERSION';
    2257:
      Result := 'MQRC_WRONG_MD_VERSION';
    2258:
      Result := 'MQRC_GROUP_ID_ERROR';
    2259:
      Result := 'MQRC_INCONSISTENT_BROWSE';
    2260:
      Result := 'MQRC_XQH_ERROR';
    2261:
      Result := 'MQRC_SRC_ENV_ERROR';
    2262:
      Result := 'MQRC_SRC_NAME_ERROR';
    2263:
      Result := 'MQRC_DEST_ENV_ERROR';
    2264:
      Result := 'MQRC_DEST_NAME_ERROR';
    2265:
      Result := 'MQRC_TM_ERROR';
    2266:
      Result := 'MQRC_CLUSTER_EXIT_ERROR';
    2267:
      Result := 'MQRC_CLUSTER_EXIT_LOAD_ERROR';
    2268:
      Result := 'MQRC_CLUSTER_PUT_INHIBITED';
    2269:
      Result := 'MQRC_CLUSTER_RESOURCE_ERROR';
    2270:
      Result := 'MQRC_NO_DESTINATIONS_AVAILABLE';
    2271:
      Result := 'MQRC_CONN_TAG_IN_USE';
    2272:
      Result := 'MQRC_PARTIALLY_CONVERTED';
    2273:
      Result := 'MQRC_CONNECTION_ERROR';
    2274:
      Result := 'MQRC_OPTION_ENVIRONMENT_ERROR';
    2277:
      Result := 'MQRC_CD_ERROR';
    2278:
      Result := 'MQRC_CLIENT_CONN_ERROR';
    2279:
      Result := 'MQRC_CHANNEL_STOPPED_BY_USER';
    2280:
      Result := 'MQRC_HCONFIG_ERROR';
    2281:
      Result := 'MQRC_FUNCTION_ERROR';
    2282:
      Result := 'MQRC_CHANNEL_STARTED';
    2283:
      Result := 'MQRC_CHANNEL_STOPPED';
    2284:
      Result := 'MQRC_CHANNEL_CONV_ERROR';
    2285:
      Result := 'MQRC_SERVICE_NOT_AVAILABLE';
    2286:
      Result := 'MQRC_INITIALIZATION_FAILED';
    2287:
      Result := 'MQRC_TERMINATION_FAILED';
    2288:
      Result := 'MQRC_UNKNOWN_Q_NAME';
    2289:
      Result := 'MQRC_SERVICE_ERROR';
    2290:
      Result := 'MQRC_Q_ALREADY_EXISTS';
    2291:
      Result := 'MQRC_USER_ID_NOT_AVAILABLE';
    2292:
      Result := 'MQRC_UNKNOWN_ENTITY';
    2294:
      Result := 'MQRC_UNKNOWN_REF_OBJECT';
    2295:
      Result := 'MQRC_CHANNEL_ACTIVATED';
    2296:
      Result := 'MQRC_CHANNEL_NOT_ACTIVATED';
    2297:
      Result := 'MQRC_UOW_CANCELED';
    2298:
      Result := 'MQRC_FUNCTION_NOT_SUPPORTED';
    2299:
      Result := 'MQRC_SELECTOR_TYPE_ERROR';
    2300:
      Result := 'MQRC_COMMAND_TYPE_ERROR';
    2301:
      Result := 'MQRC_MULTIPLE_INSTANCE_ERROR';
    2302:
      Result := 'MQRC_SYSTEM_ITEM_NOT_ALTERABLE';
    2303:
      Result := 'MQRC_BAG_CONVERSION_ERROR';
    2304:
      Result := 'MQRC_SELECTOR_OUT_OF_RANGE';
    2305:
      Result := 'MQRC_SELECTOR_NOT_UNIQUE';
    2306:
      Result := 'MQRC_INDEX_NOT_PRESENT';
    2307:
      Result := 'MQRC_STRING_ERROR';
    2308:
      Result := 'MQRC_ENCODING_NOT_SUPPORTED';
    2309:
      Result := 'MQRC_SELECTOR_NOT_PRESENT';
    2310:
      Result := 'MQRC_OUT_SELECTOR_ERROR';
    2311:
      Result := 'MQRC_STRING_TRUNCATED';
    2312:
      Result := 'MQRC_SELECTOR_WRONG_TYPE';
    2313:
      Result := 'MQRC_INCONSISTENT_ITEM_TYPE';
    2314:
      Result := 'MQRC_INDEX_ERROR';
    2315:
      Result := 'MQRC_SYSTEM_BAG_NOT_ALTERABLE';
    2316:
      Result := 'MQRC_ITEM_COUNT_ERROR';
    2317:
      Result := 'MQRC_FORMAT_NOT_SUPPORTED';
    2318:
      Result := 'MQRC_SELECTOR_NOT_SUPPORTED';
    2319:
      Result := 'MQRC_ITEM_VALUE_ERROR';
    2320:
      Result := 'MQRC_HBAG_ERROR';
    2321:
      Result := 'MQRC_PARAMETER_MISSING';
    2322:
      Result := 'MQRC_CMD_SERVER_NOT_AVAILABLE';
    2323:
      Result := 'MQRC_STRING_LENGTH_ERROR';
    2324:
      Result := 'MQRC_INQUIRY_COMMAND_ERROR';
    2325:
      Result := 'MQRC_NESTED_BAG_NOT_SUPPORTED';
    2326:
      Result := 'MQRC_BAG_WRONG_TYPE';
    2327:
      Result := 'MQRC_ITEM_TYPE_ERROR';
    2328:
      Result := 'MQRC_SYSTEM_BAG_NOT_DELETABLE';
    2329:
      Result := 'MQRC_SYSTEM_ITEM_NOT_DELETABLE';
    2330:
      Result := 'MQRC_CODED_CHAR_SET_ID_ERROR';
    2331:
      Result := 'MQRC_MSG_TOKEN_ERROR';
    2332:
      Result := 'MQRC_MISSING_WIH';
    2333:
      Result := 'MQRC_WIH_ERROR';
    2334:
      Result := 'MQRC_RFH_ERROR';
    2335:
      Result := 'MQRC_RFH_STRING_ERROR';
    2336:
      Result := 'MQRC_RFH_COMMAND_ERROR';
    2337:
      Result := 'MQRC_RFH_PARM_ERROR';
    2338:
      Result := 'MQRC_RFH_DUPLICATE_PARM';
    2339:
      Result := 'MQRC_RFH_PARM_MISSING';
    2340:
      Result := 'MQRC_CHAR_CONVERSION_ERROR';
    2341:
      Result := 'MQRC_UCS2_CONVERSION_ERROR';
    2342:
      Result := 'MQRC_DB2_NOT_AVAILABLE';
    2343:
      Result := 'MQRC_OBJECT_NOT_UNIQUE';
    2344:
      Result := 'MQRC_CONN_TAG_NOT_RELEASED';
    2345:
      Result := 'MQRC_CF_NOT_AVAILABLE';
    2346:
      Result := 'MQRC_CF_STRUC_IN_USE';
    2347:
      Result := 'MQRC_CF_STRUC_LIST_HDR_IN_USE';
    2348:
      Result := 'MQRC_CF_STRUC_AUTH_FAILED';
    2349:
      Result := 'MQRC_CF_STRUC_ERROR';
    2350:
      Result := 'MQRC_CONN_TAG_NOT_USABLE';
    2351:
      Result := 'MQRC_GLOBAL_UOW_CONFLICT';
    2352:
      Result := 'MQRC_LOCAL_UOW_CONFLICT';
    2353:
      Result := 'MQRC_HANDLE_IN_USE_FOR_UOW';
    2354:
      Result := 'MQRC_UOW_ENLISTMENT_ERROR';
    2355:
      Result := 'MQRC_UOW_MIX_NOT_SUPPORTED';
    2356:
      Result := 'MQRC_WXP_ERROR';
    2357:
      Result := 'MQRC_CURRENT_RECORD_ERROR';
    2358:
      Result := 'MQRC_NEXT_OFFSET_ERROR';
    2359:
      Result := 'MQRC_NO_RECORD_AVAILABLE';
    2360:
      Result := 'MQRC_OBJECT_LEVEL_INCOMPATIBLE';
    2361:
      Result := 'MQRC_NEXT_RECORD_ERROR';
    2362:
      Result := 'MQRC_BACKOUT_THRESHOLD_REACHED';
    2363:
      Result := 'MQRC_MSG_NOT_MATCHED';
    2364:
      Result := 'MQRC_JMS_FORMAT_ERROR';
    2365:
      Result := 'MQRC_SEGMENTS_NOT_SUPPORTED';
    2366:
      Result := 'MQRC_WRONG_CF_LEVEL';
    2367:
      Result := 'MQRC_CONFIG_CREATE_OBJECT';
    2368:
      Result := 'MQRC_CONFIG_CHANGE_OBJECT';
    2369:
      Result := 'MQRC_CONFIG_DELETE_OBJECT';
    2370:
      Result := 'MQRC_CONFIG_REFRESH_OBJECT';
    2371:
      Result := 'MQRC_CHANNEL_SSL_ERROR';
    2373:
      Result := 'MQRC_CF_STRUC_FAILED';
    2374:
      Result := 'MQRC_API_EXIT_ERROR';
    2375:
      Result := 'MQRC_API_EXIT_INIT_ERROR';
    2376:
      Result := 'MQRC_API_EXIT_TERM_ERROR';
    2377:
      Result := 'MQRC_EXIT_REASON_ERROR';
    2378:
      Result := 'MQRC_RESERVED_VALUE_ERROR';
    2379:
      Result := 'MQRC_NO_DATA_AVAILABLE';
    2380:
      Result := 'MQRC_SCO_ERROR';
    2381:
      Result := 'MQRC_KEY_REPOSITORY_ERROR';
    2382:
      Result := 'MQRC_CRYPTO_HARDWARE_ERROR';
    2383:
      Result := 'MQRC_AUTH_INFO_REC_COUNT_ERROR';
    2384:
      Result := 'MQRC_AUTH_INFO_REC_ERROR';
    2385:
      Result := 'MQRC_AIR_ERROR';
    2386:
      Result := 'MQRC_AUTH_INFO_TYPE_ERROR';
    2387:
      Result := 'MQRC_AUTH_INFO_CONN_NAME_ERROR';
    2388:
      Result := 'MQRC_LDAP_USER_NAME_ERROR';
    2389:
      Result := 'MQRC_LDAP_USER_NAME_LENGTH_ERR';
    2390:
      Result := 'MQRC_LDAP_PASSWORD_ERROR';
    2391:
      Result := 'MQRC_SSL_ALREADY_INITIALIZED';
    2392:
      Result := 'MQRC_SSL_CONFIG_ERROR';
    2393:
      Result := 'MQRC_SSL_INITIALIZATION_ERROR';
    2394:
      Result := 'MQRC_Q_INDEX_TYPE_ERROR';
    2395:
      Result := 'MQRC_CFBS_ERROR';
    2396:
      Result := 'MQRC_SSL_NOT_ALLOWED';
    2397:
      Result := 'MQRC_JSSE_ERROR';
    2398:
      Result := 'MQRC_SSL_PEER_NAME_MISMATCH';
    2399:
      Result := 'MQRC_SSL_PEER_NAME_ERROR';
    2400:
      Result := 'MQRC_UNSUPPORTED_CIPHER_SUITE';
    2401:
      Result := 'MQRC_SSL_CERTIFICATE_REVOKED';
    2402:
      Result := 'MQRC_SSL_CERT_STORE_ERROR';
    2406:
      Result := 'MQRC_CLIENT_EXIT_LOAD_ERROR';
    2407:
      Result := 'MQRC_CLIENT_EXIT_ERROR';
    2409:
      Result := 'MQRC_SSL_KEY_RESET_ERROR';
    2411:
      Result := 'MQRC_LOGGER_STATUS';
    2412:
      Result := 'MQRC_COMMAND_MQSC';
    2413:
      Result := 'MQRC_COMMAND_PCF';
    2414:
      Result := 'MQRC_CFIF_ERROR';
    2415:
      Result := 'MQRC_CFSF_ERROR';
    2416:
      Result := 'MQRC_CFGR_ERROR';
    2417:
      Result := 'MQRC_MSG_NOT_ALLOWED_IN_GROUP';
    2418:
      Result := 'MQRC_FILTER_OPERATOR_ERROR';
    2419:
      Result := 'MQRC_NESTED_SELECTOR_ERROR';
    2420:
      Result := 'MQRC_EPH_ERROR';
    2421:
      Result := 'MQRC_RFH_FORMAT_ERROR';
    2422:
      Result := 'MQRC_CFBF_ERROR';
    2423:
      Result := 'MQRC_CLIENT_CHANNEL_CONFLICT';
    2424:
      Result := 'MQRC_SD_ERROR';
    2425:
      Result := 'MQRC_TOPIC_STRING_ERROR';
    2426:
      Result := 'MQRC_STS_ERROR';
    2428:
      Result := 'MQRC_NO_SUBSCRIPTION';
    2429:
      Result := 'MQRC_SUBSCRIPTION_IN_USE';
    2430:
      Result := 'MQRC_STAT_TYPE_ERROR';
    2431:
      Result := 'MQRC_SUB_USER_DATA_ERROR';
    2432:
      Result := 'MQRC_SUB_ALREADY_EXISTS';
    2434:
      Result := 'MQRC_IDENTITY_MISMATCH';
    2435:
      Result := 'MQRC_ALTER_SUB_ERROR';
    2436:
      Result := 'MQRC_DURABILITY_NOT_ALLOWED';
    2437:
      Result := 'MQRC_NO_RETAINED_MSG';
    2438:
      Result := 'MQRC_SRO_ERROR';
    2440:
      Result := 'MQRC_SUB_NAME_ERROR';
    2441:
      Result := 'MQRC_OBJECT_STRING_ERROR';
    2442:
      Result := 'MQRC_PROPERTY_NAME_ERROR';
    2443:
      Result := 'MQRC_SEGMENTATION_NOT_ALLOWED';
    2444:
      Result := 'MQRC_CBD_ERROR';
    2445:
      Result := 'MQRC_CTLO_ERROR';
    2446:
      Result := 'MQRC_NO_CALLBACKS_ACTIVE';
    2448:
      Result := 'MQRC_CALLBACK_NOT_REGISTERED';
    2452:
      Result := 'MQRC_CALLBACK_ERROR';
    2453:
      Result := 'MQRC_CALLBACK_STILL_ACTIVE';
    2457:
      Result := 'MQRC_OPTIONS_CHANGED';
    2458:
      Result := 'MQRC_READ_AHEAD_MSGS';
    2459:
      Result := 'MQRC_SELECTOR_SYNTAX_ERROR';
    2460:
      Result := 'MQRC_HMSG_ERROR';
    2461:
      Result := 'MQRC_CMHO_ERROR';
    2462:
      Result := 'MQRC_DMHO_ERROR';
    2463:
      Result := 'MQRC_SMPO_ERROR';
    2464:
      Result := 'MQRC_IMPO_ERROR';
    2465:
      Result := 'MQRC_PROPERTY_NAME_TOO_BIG';
    2466:
      Result := 'MQRC_PROP_VALUE_NOT_CONVERTED';
    2467:
      Result := 'MQRC_PROP_TYPE_NOT_SUPPORTED';
    2469:
      Result := 'MQRC_PROPERTY_VALUE_TOO_BIG';
    2470:
      Result := 'MQRC_PROP_CONV_NOT_SUPPORTED';
    2471:
      Result := 'MQRC_PROPERTY_NOT_AVAILABLE';
    2472:
      Result := 'MQRC_PROP_NUMBER_FORMAT_ERROR';
    2473:
      Result := 'MQRC_PROPERTY_TYPE_ERROR';
    2478:
      Result := 'MQRC_PROPERTIES_TOO_BIG';
    2479:
      Result := 'MQRC_PUT_NOT_RETAINED';
    2480:
      Result := 'MQRC_ALIAS_TARGTYPE_CHANGED';
    2481:
      Result := 'MQRC_DMPO_ERROR';
    2482:
      Result := 'MQRC_PD_ERROR';
    2483:
      Result := 'MQRC_CALLBACK_TYPE_ERROR';
    2484:
      Result := 'MQRC_CBD_OPTIONS_ERROR';
    2485:
      Result := 'MQRC_MAX_MSG_LENGTH_ERROR';
    2486:
      Result := 'MQRC_CALLBACK_ROUTINE_ERROR';
    2487:
      Result := 'MQRC_CALLBACK_LINK_ERROR';
    2488:
      Result := 'MQRC_OPERATION_ERROR';
    2489:
      Result := 'MQRC_BMHO_ERROR';
    2490:
      Result := 'MQRC_UNSUPPORTED_PROPERTY';
    2492:
      Result := 'MQRC_PROP_NAME_NOT_CONVERTED';
    2494:
      Result := 'MQRC_GET_ENABLED';
    2495:
      Result := 'MQRC_MODULE_NOT_FOUND';
    2496:
      Result := 'MQRC_MODULE_INVALID';
    2497:
      Result := 'MQRC_MODULE_ENTRY_NOT_FOUND';
    2498:
      Result := 'MQRC_MIXED_CONTENT_NOT_ALLOWED';
    2499:
      Result := 'MQRC_MSG_HANDLE_IN_USE';
    2500:
      Result := 'MQRC_HCONN_ASYNC_ACTIVE';
    2501:
      Result := 'MQRC_MHBO_ERROR';
    2502:
      Result := 'MQRC_PUBLICATION_FAILURE';
    2503:
      Result := 'MQRC_SUB_INHIBITED';
    2504:
      Result := 'MQRC_SELECTOR_ALWAYS_FALSE';
    2507:
      Result := 'MQRC_XEPO_ERROR';
    2509:
      Result := 'MQRC_DURABILITY_NOT_ALTERABLE';
    2510:
      Result := 'MQRC_TOPIC_NOT_ALTERABLE';
    2512:
      Result := 'MQRC_SUBLEVEL_NOT_ALTERABLE';
    2513:
      Result := 'MQRC_PROPERTY_NAME_LENGTH_ERR';
    2514:
      Result := 'MQRC_DUPLICATE_GROUP_SUB';
    2515:
      Result := 'MQRC_GROUPING_NOT_ALTERABLE';
    2516:
      Result := 'MQRC_SELECTOR_INVALID_FOR_TYPE';
    2517:
      Result := 'MQRC_HOBJ_QUIESCED';
    2518:
      Result := 'MQRC_HOBJ_QUIESCED_NO_MSGS';
    2519:
      Result := 'MQRC_SELECTION_STRING_ERROR';
    2520:
      Result := 'MQRC_RES_OBJECT_STRING_ERROR';
    2521:
      Result := 'MQRC_CONNECTION_SUSPENDED';
    2522:
      Result := 'MQRC_INVALID_DESTINATION';
    2523:
      Result := 'MQRC_INVALID_SUBSCRIPTION';
    2524:
      Result := 'MQRC_SELECTOR_NOT_ALTERABLE';
    2525:
      Result := 'MQRC_RETAINED_MSG_Q_ERROR';
    2526:
      Result := 'MQRC_RETAINED_NOT_DELIVERED';
    2527:
      Result := 'MQRC_RFH_RESTRICTED_FORMAT_ERR';
    2528:
      Result := 'MQRC_CONNECTION_STOPPED';
    2529:
      Result := 'MQRC_ASYNC_UOW_CONFLICT';
    2530:
      Result := 'MQRC_ASYNC_XA_CONFLICT';
    2531:
      Result := 'MQRC_PUBSUB_INHIBITED';
    2532:
      Result := 'MQRC_MSG_HANDLE_COPY_FAILURE';
    2533:
      Result := 'MQRC_DEST_CLASS_NOT_ALTERABLE';
    2534:
      Result := 'MQRC_OPERATION_NOT_ALLOWED';
    2535:
      Result := 'MQRC_ACTION_ERROR';
    2537:
      Result := 'MQRC_CHANNEL_NOT_AVAILABLE';
    2538:
      Result := 'MQRC_HOST_NOT_AVAILABLE';
    2539:
      Result := 'MQRC_CHANNEL_CONFIG_ERROR';
    2540:
      Result := 'MQRC_UNKNOWN_CHANNEL_NAME';
    2541:
      Result := 'MQRC_LOOPING_PUBLICATION';
    2550:
      Result := 'MQRC_NO_SUBS_MATCHED';
    2551:
      Result := 'MQRC_SELECTION_NOT_AVAILABLE';
    2554:
      Result := 'MQRC_CONTENT_ERROR';
    2555:
      Result := 'MQRC_RECONNECT_Q_MGR_REQD';
    2556:
      Result := 'MQRC_RECONNECT_TIMED_OUT';
    6100:
      Result := 'MQRC_REOPEN_EXCL_INPUT_ERROR';
    6101:
      Result := 'MQRC_REOPEN_INQUIRE_ERROR';
    6102:
      Result := 'MQRC_REOPEN_SAVED_CONTEXT_ERR';
    6103:
      Result := 'MQRC_REOPEN_TEMPORARY_Q_ERROR';
    6104:
      Result := 'MQRC_ATTRIBUTE_LOCKED';
    6105:
      Result := 'MQRC_CURSOR_NOT_VALID';
    6106:
      Result := 'MQRC_ENCODING_ERROR';
    6107:
      Result := 'MQRC_STRUC_ID_ERROR';
    6108:
      Result := 'MQRC_NULL_POINTER';
    6109:
      Result := 'MQRC_NO_CONNECTION_REFERENCE';
    6110:
      Result := 'MQRC_NO_BUFFER';
    6111:
      Result := 'MQRC_BINARY_DATA_LENGTH_ERROR';
    6112:
      Result := 'MQRC_BUFFER_NOT_AUTOMATIC';
    6113:
      Result := 'MQRC_INSUFFICIENT_BUFFER';
    6114:
      Result := 'MQRC_INSUFFICIENT_DATA';
    6115:
      Result := 'MQRC_DATA_TRUNCATED';
    6116:
      Result := 'MQRC_ZERO_LENGTH';
    6117:
      Result := 'MQRC_NEGATIVE_LENGTH';
    6118:
      Result := 'MQRC_NEGATIVE_OFFSET';
    6119:
      Result := 'MQRC_INCONSISTENT_FORMAT';
    6120:
      Result := 'MQRC_INCONSISTENT_OBJECT_STATE';
    6121:
      Result := 'MQRC_CONTEXT_OBJECT_NOT_VALID';
    6122:
      Result := 'MQRC_CONTEXT_OPEN_ERROR';
    6123:
      Result := 'MQRC_STRUC_LENGTH_ERROR';
    6124:
      Result := 'MQRC_NOT_CONNECTED';
    6125:
      Result := 'MQRC_NOT_OPEN';
    6126:
      Result := 'MQRC_DISTRIBUTION_LIST_EMPTY';
    6127:
      Result := 'MQRC_INCONSISTENT_OPEN_OPTIONS';
    6128:
      Result := 'MQRC_WRONG_VERSION';
    6129:
      Result := 'MQRC_REFERENCE_ERROR';
  else
    raise Exception.CreateFmt('Неизвестный код ошибки %d', [aErrorCode])
  end;
end;

end.
