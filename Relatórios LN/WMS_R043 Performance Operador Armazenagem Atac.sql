=IIF(Parameters!Table.Value <> "AAA", 

"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       " + Parameters!Table.Value + ".TASKDETAIL TD       " &
"INNER JOIN " + Parameters!Table.Value + ".SKU SK              " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN " + Parameters!Table.Value + ".TASKMANAGERUSER TU  " & 
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN " + Parameters!Table.Value + ".LOC FL              " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN " + Parameters!Table.Value + ".LOC TL              " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"ORDER BY DESCR_PLANTA, DATA_ARMAZ                             "

,

"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       WMWHSE1.TASKDETAIL TD                              " &
"INNER JOIN WMWHSE1.SKU SK                                     " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN WMWHSE1.TASKMANAGERUSER TU                         " &
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN WMWHSE1.LOC FL                                     " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN WMWHSE1.LOC TL                                     " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"                                                              " &
"UNION                                                         " &
"                                                              " &
"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       WMWHSE2.TASKDETAIL TD                              " &
"INNER JOIN WMWHSE2.SKU SK                                     " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN WMWHSE2.TASKMANAGERUSER TU                         " &
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN WMWHSE2.LOC FL                                     " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN WMWHSE2.LOC TL                                     " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"                                                              " &
"UNION                                                         " &
"                                                              " &
"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       WMWHSE3.TASKDETAIL TD                              " &
"INNER JOIN WMWHSE3.SKU SK                                     " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN WMWHSE3.TASKMANAGERUSER TU                         " &
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN WMWHSE3.LOC FL                                     " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN WMWHSE3.LOC TL                                     " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"                                                              " &
"UNION                                                         " &
"                                                              " &
"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       WMWHSE4.TASKDETAIL TD                              " &
"INNER JOIN WMWHSE4.SKU SK                                     " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN WMWHSE4.TASKMANAGERUSER TU                         " &
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN WMWHSE4.LOC FL                                     " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN WMWHSE4.LOC TL                                     " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"                                                              " &
"UNION                                                         " &
"                                                              " &
"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       WMWHSE5.TASKDETAIL TD                              " &
"INNER JOIN WMWHSE5.SKU SK                                     " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN WMWHSE5.TASKMANAGERUSER TU                         " &
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN WMWHSE5.LOC FL                                     " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN WMWHSE5.LOC TL                                     " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"                                                              " &
"UNION                                                         " &
"                                                              " &
"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       WMWHSE6.TASKDETAIL TD                              " &
"INNER JOIN WMWHSE6.SKU SK                                     " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN WMWHSE6.TASKMANAGERUSER TU                         " &
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN WMWHSE6.LOC FL                                     " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN WMWHSE6.LOC TL                                     " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"                                                              " &
"UNION                                                         " &
"                                                              " &
"SELECT                                                        " &
"  TD.WHSEID                  ID_PLANTA,                       " &
"  CL.UDF2                    DESCR_PLANTA,                    " &
"  TRUNC(TD.STARTTIME, 'DD')  DATA_ARMAZ,                      " &
"  TD.STARTTIME               HORA_INICIO,                     " &
"  TD.ENDTIME                 HORA_FIM,                        " &
"  TD.EDITWHO                 OPERADOR,                        " &
"  SUBSTR( TU.USR_NAME,4, INSTR(TU.USR_NAME, ',')-4 )          " &
"                             NOME_OP,                         " &
"  TD.TASKDETAILKEY           ORDEM_MOV,                       " &
"  TD.SKU                     ID_ITEM,                         " &
"  SK.DESCR                   DESCR_ITEM,                      " &
"  TD.QTY                     QTD,                             " &
"  TD.FROMLOC                 ID_LOC_ORIG,                     " &
"  FL.PUTAWAYZONE             LOCAL_ORIG,                      " &
"  TD.TOLOC                   ID_LOC_DEST,                     " &
"  TL.PUTAWAYZONE             LOCAL_DEST                       " &
"FROM       WMWHSE7.TASKDETAIL TD                              " &
"INNER JOIN WMWHSE7.SKU SK                                     " &
"        ON SK.SKU = TD.SKU                                    " &
"INNER JOIN ENTERPRISE.CODELKUP CL                             " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                         " &
"       AND CL.LISTNAME = 'SCHEMA'                             " &
" LEFT JOIN WMWHSE7.TASKMANAGERUSER TU                         " &
"        ON TU.USERKEY = TD.EDITWHO                            " &
" LEFT JOIN WMWHSE7.LOC FL                                     " &
"        ON FL.LOC = TD.FROMLOC                                " &
" LEFT JOIN WMWHSE7.LOC TL                                     " &
"       ON TL.LOC = TD.TOLOC                                   " &
"WHERE TD.TASKTYPE = 'PA'                                      " &
"  AND TD.STATUS = '9'                                         " &
"  AND TRUNC(TD.STARTTIME, 'DD')                               " &
"      between '" + Parameters!DataDe.Value + "'               " &
"          and '" + Parameters!DataAte.Value + "'              " &
"ORDER BY DESCR_PLANTA, DATA_ARMAZ                             "
)