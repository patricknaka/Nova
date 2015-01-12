SELECT DISTINCT
       ENT.UDF2                   ID_PLANTA,
       RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,
       RECEIPTDETAIL.TOID         ID_OM,
       RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,
       RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,
       RECEIPTDETAIL.SKU          ID_ITEM,
       SKU.DESCR                  DESC_ITEM,
       SKU.SKUGROUP               ID_DEPTO, 
       DEPART.DEPART_NAME         DEPTO_NOME,
       SKU.SKUGROUP2              ID_SETOR,
       DEPART.SECTOR_NAME         SETOR_NOME,
       CODELKUP.description       TIPO_ITEM,
       TASKDETAIL.TOLOC           LOCAL,
       LOC.LOGICALLOCATION        DESCRICAO,
       RECEIPTDETAIL.QTYRECEIVED  QT_REC,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE) 
                                  DT_ENT_RT,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE) 
                                  DT_SAID_RT
	   
FROM       WMWHSE5.TASKDETAIL

INNER JOIN WMWHSE5.RECEIPTDETAIL 
        ON RECEIPTDETAIL.RECEIPTKEY || RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY
		
INNER JOIN WMWHSE5.RECEIPT
        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY
		
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = RECEIPTDETAIL.SKU

 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART 
        ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  
       AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2) 
	   
INNER JOIN WMWHSE5.LOC
        ON LOC.LOC = TASKDETAIL.TOLOC
		
 LEFT JOIN ENTERPRISE.CODELKUP ENT 
        ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)
        
 LEFT JOIN WMWHSE5.CODELKUP
        ON CODELKUP.CODE = SKU.BOMITEMTYPE
	   
WHERE TASKDETAIL.STATUS = 9 
  AND TASKDETAIL.TASKTYPE = 'PA'
  AND ENT.LISTNAME = 'SCHEMA'
  AND CODELKUP.LISTNAME = 'EANTYPE'
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE))
      Between :DataEntradaDe
          And :DataEntradaAte  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE))
      Between :DataSaidaDe
          And :DataSaidaAte


=IIF(Parameters!Table.Value <> "AAA",
		  
" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       " + Parameters!Table.Value + ".TASKDETAIL                         " &
"                                                                              " &
" INNER JOIN " + Parameters!Table.Value + ".RECEIPTDETAIL                      " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN " + Parameters!Table.Value + ".RECEIPT                            " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN " + Parameters!Table.Value + ".SKU                                " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN " + Parameters!Table.Value + ".LOC                                " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN " + Parameters!Table.Value + ".CODELKUP                           " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"ORDER BY ID_PLANTA, ID_RECDOC                                                 "

,

" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       WMWHSE1.TASKDETAIL                                                " &
"                                                                              " &
" INNER JOIN WMWHSE1.RECEIPTDETAIL                                             " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN WMWHSE1.RECEIPT                                                   " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN WMWHSE1.SKU                                                       " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN WMWHSE1.LOC                                                       " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN WMWHSE1.CODELKUP                                                  " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"Union                                                                         " &
" 	                                                                           " &
" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       WMWHSE2.TASKDETAIL                                                " &
"                                                                              " &
" INNER JOIN WMWHSE2.RECEIPTDETAIL                                             " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN WMWHSE2.RECEIPT                                                   " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN WMWHSE2.SKU                                                       " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN WMWHSE2.LOC                                                       " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN WMWHSE2.CODELKUP                                                  " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"Union                                                                         " &
" 	                                                                           " &
" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       WMWHSE3.TASKDETAIL                                                " &
"                                                                              " &
" INNER JOIN WMWHSE3.RECEIPTDETAIL                                             " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN WMWHSE3.RECEIPT                                                   " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN WMWHSE3.SKU                                                       " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN WMWHSE3.LOC                                                       " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN WMWHSE3.CODELKUP                                                  " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"Union                                                                         " &
" 	                                                                           " &
" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       WMWHSE4.TASKDETAIL                                                " &
"                                                                              " &
" INNER JOIN WMWHSE4.RECEIPTDETAIL                                             " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN WMWHSE4.RECEIPT                                                   " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN WMWHSE4.SKU                                                       " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN WMWHSE4.LOC                                                       " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN WMWHSE4.CODELKUP                                                  " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"Union                                                                         " &
" 	                                                                           " &
" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       WMWHSE5.TASKDETAIL                                                " &
"                                                                              " &
" INNER JOIN WMWHSE5.RECEIPTDETAIL                                             " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN WMWHSE5.RECEIPT                                                   " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN WMWHSE5.SKU                                                       " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN WMWHSE5.LOC                                                       " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN WMWHSE5.CODELKUP                                                  " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"Union                                                                         " &
" 	                                                                           " &
" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       WMWHSE6.TASKDETAIL                                                " &
"                                                                              " &
" INNER JOIN WMWHSE6.RECEIPTDETAIL                                             " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN WMWHSE6.RECEIPT                                                   " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN WMWHSE6.SKU                                                       " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN WMWHSE6.LOC                                                       " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN WMWHSE6.CODELKUP                                                  " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"Union                                                                         " &
" 	                                                                           " &
" SELECT DISTINCT                                                              " &
"        ENT.UDF2                   ID_PLANTA,                                 " &
"        RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                                 " &
"        RECEIPTDETAIL.TOID         ID_OM,                                     " &
"        RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                            " &
"        RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                          " &
"        RECEIPTDETAIL.SKU          ID_ITEM,                                   " &
"        SKU.DESCR                  DESC_ITEM,                                 " &
"        SKU.SKUGROUP               ID_DEPTO,                                  " &
"        DEPART.DEPART_NAME         DEPTO_NOME,                                " &
"        SKU.SKUGROUP2              ID_SETOR,                                  " &
"        DEPART.SECTOR_NAME         SETOR_NOME,                                " &
"        CODELKUP.description       TIPO_ITEM,                                 " &
"        TASKDETAIL.TOLOC           LOCAL,                                     " &
"        LOC.LOGICALLOCATION        DESCRICAO,                                 " &
"        RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                    " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,        " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_ENT_RT,                                 " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE)                            " &
"                                   DT_SAID_RT                                 " &
" 	                                                                           " &
" FROM       WMWHSE7.TASKDETAIL                                                " &
"                                                                              " &
" INNER JOIN WMWHSE7.RECEIPTDETAIL                                             " &
"         ON RECEIPTDETAIL.RECEIPTKEY ||                                       " &
"            RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY            " &
" 		                                                                       " &
" INNER JOIN WMWHSE7.RECEIPT                                                   " &
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                     " &
" 		                                                                       " &
" INNER JOIN WMWHSE7.SKU                                                       " &
"         ON SKU.SKU = RECEIPTDETAIL.SKU                                       " &
"                                                                              " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                                " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                 " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)                " &
" 	                                                                           " &
" INNER JOIN WMWHSE7.LOC                                                       " &
"         ON LOC.LOC = TASKDETAIL.TOLOC                                        " &
" 		                                                                       " &
"  LEFT JOIN ENTERPRISE.CODELKUP ENT                                           " &
"         ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                           " &
"                                                                              " &
"  LEFT JOIN WMWHSE7.CODELKUP                                                  " &
"         ON CODELKUP.CODE = SKU.BOMITEMTYPE                                   " &
" 	                                                                           " &
" WHERE TASKDETAIL.STATUS = 9                                                  " &
"   AND TASKDETAIL.TASKTYPE = 'PA'                                             " &
"   AND ENT.LISTNAME = 'SCHEMA'                                                " &
"   AND CODELKUP.LISTNAME = 'EANTYPE'                                          " &
"                                                                              " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataEntradaDe.Value + "'                        " &
"           And '"+ Parameters!DataEntradaAte.Value + "'                       " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,           " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"            AT time zone sessiontimezone) AS DATE))                           " &
"       Between '"+ Parameters!DataSaidaDe.Value + "'                          " &
"           And '"+ Parameters!DataSaidaAte.Value + "'                         " &
" 	                                                                           " &
"ORDER BY ID_PLANTA, ID_RECDOC                                                 "

)