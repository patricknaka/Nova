=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       " + Parameters!Table.Value + ".TASKDETAIL  TD         " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN " + Parameters!Table.Value + ".SKU SK                 " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS OC              " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN " + Parameters!Table.Value + ".STORER ST              " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN " + Parameters!Table.Value + ".LOC LC                 " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN " + Parameters!Table.Value + ".PUTAWAYZONE PZ         " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"	BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"ORDER BY DESCR_PLANTA, DT_SITUACAO                               "
                                                                  
,                                                                 

"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       WMWHSE1.TASKDETAIL  TD                                " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN WMWHSE1.SKU SK                                        " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN WMWHSE1.ORDERS OC                                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN WMWHSE1.STORER ST                                     " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN WMWHSE1.LOC LC                                        " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN WMWHSE1.PUTAWAYZONE PZ                                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"   BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"                                                                 " &
"UNION                                                            " &
"                                                                 " &
"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       WMWHSE2.TASKDETAIL  TD                                " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN WMWHSE2.SKU SK                                        " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN WMWHSE2.ORDERS OC                                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN WMWHSE2.STORER ST                                     " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN WMWHSE2.LOC LC                                        " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN WMWHSE2.PUTAWAYZONE PZ                                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"	BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"                                                                 " &
"UNION                                                            " &
"                                                                 " &
"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       WMWHSE3.TASKDETAIL  TD                                " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN WMWHSE3.SKU SK                                        " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN WMWHSE3.ORDERS OC                                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN WMWHSE3.STORER ST                                     " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN WMWHSE3.LOC LC                                        " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN WMWHSE3.PUTAWAYZONE PZ                                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"	BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"                                                                 " &
"UNION                                                            " &
"                                                                 " &
"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       WMWHSE4.TASKDETAIL  TD                                " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN WMWHSE4.SKU SK                                        " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN WMWHSE4.ORDERS OC                                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN WMWHSE4.STORER ST                                     " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN WMWHSE4.LOC LC                                        " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN WMWHSE4.PUTAWAYZONE PZ                                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"	BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"                                                                 " &
"UNION                                                            " &
"                                                                 " &
"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       WMWHSE5.TASKDETAIL  TD                                " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN WMWHSE5.SKU SK                                        " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN WMWHSE5.ORDERS OC                                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN WMWHSE5.STORER ST                                     " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN WMWHSE5.LOC LC                                        " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN WMWHSE5.PUTAWAYZONE PZ                                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"	BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"                                                                 " &
"UNION                                                            " &
"                                                                 " &
"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       WMWHSE6.TASKDETAIL  TD                                " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN WMWHSE6.SKU SK                                        " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN WMWHSE6.ORDERS OC                                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN WMWHSE6.STORER ST                                     " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN WMWHSE6.LOC LC                                        " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN WMWHSE6.PUTAWAYZONE PZ                                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"	BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"                                                                 " &
"UNION                                                            " &
"                                                                 " &
"SELECT                                                           " &
"  TD.WHSEID       ID_PLANTA,                                     " &
"  CL.UDF2         DESCR_PLANTA,                                  " &
"  OC.ORDERKEY     ORDEM_WMS,                                     " &
"  LN.T$ENTR$C     ENTREGA,                                       " &
"  TD.SKU          ID_ITEM,                                       " &
"  SK.DESCR        DESCR_ITEM,                                    " &
"  SK.SUSR5        ID_SKU,                                        " &
"  ST.COMPANY      FORNECEDOR,                                    " &
"  TD.FROMLOC      ID_LOCAL_ROM,                                  " &
"  LC.PUTAWAYZONE  CLASSE_LOCAL,                                  " &
"  Trim(PZ.DESCR)  DESC_LOCAL,                                    " &
"  TD.TOLOC        ID_CLA_LOC,                                    " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                 " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                  DT_SITUACAO                                    " &
"FROM       WMWHSE7.TASKDETAIL  TD                                " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                            " &
"INNER JOIN WMWHSE7.SKU SK                                        " &
"        ON SK.SKU = TD.SKU                                       " &
"INNER JOIN WMWHSE7.ORDERS OC                                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                             " &
" LEFT JOIN (select a.t$orno$c,                                   " &
"                   a.t$entr$c                                    " &
"              from baandb.tznsls004301@pln01 a                   " &
"          group by a.t$orno$c,                                   " &
"                   a.t$entr$c) LN                                " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                    " &
" LEFT JOIN WMWHSE7.STORER ST                                     " &
"        ON ST.STORERKEY = SK.SUSR5                               " &
"       AND ST.WHSEID =  SK.WHSEID                                " &
"       AND ST.TYPE = 5                                           " &
" LEFT JOIN WMWHSE7.LOC LC                                        " &
"        ON LC.LOC = TD.FROMLOC                                   " &
" LEFT JOIN WMWHSE7.PUTAWAYZONE PZ                                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                       " &
"WHERE TD.TASKTYPE = 'PK'                                         " &
"  AND TD.STATUS = '9'                                            " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,       " &
"   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"    AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"	BETWEEN '" + Parameters!DataSituacaoDe.Value + "'             " &
"        AND '" + Parameters!DataSituacaoAte.Value + "'           " &
"                                                                 " &
"ORDER BY DESCR_PLANTA, DT_SITUACAO                               "
)