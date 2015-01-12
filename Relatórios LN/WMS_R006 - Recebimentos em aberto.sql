SELECT pl.UDF2                             PLANTA, 
       min(rd.DATERECEIVED)                REDO_DT_ENTRADA,
       rd.RECEIPTKEY                       ASN,
       CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
              THEN 'SIM' 
            ELSE   'NÃO' 
        END                                IN_MINUCIOSO,
       tpnt.DESCRIPTION                    TP_NOTA,
       stnt.DESCRIPTION                    SITUACAO,
       rc.TRAILERKEY                       ID_CAMINHAO,
       rc.TRAILERNUMBER                    PLACA_VEICULO,
       rc.DOOR                             LOCAL_DESCR,
       COUNT(DISTINCT rd.SUSR1)            NUM_NFS,
       SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,
       SUM(rd.QTYRECEIVED)                 QT_REC
	   
FROM       WMWHSE5.RECEIPTDETAIL rd

INNER JOIN WMWHSE5.SKU sku
        ON sku.SKU = rd.SKU
		
INNER JOIN WMWHSE5.RECEIPT rc
        ON rc.RECEIPTKEY = rd.RECEIPTKEY
		
 LEFT JOIN ( select clkp.code         COD, 
                    trans.description
               from WMWHSE5.codelkup clkp
         inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
              where clkp.listname = 'RECEIPTYPE'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null ) tpnt
        ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)
		
 LEFT JOIN ( select clkp.code         COD, 
                    trans.description
               from WMWHSE5.codelkup clkp
         inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
              where clkp.listname = 'RECSTATUS'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null ) stnt 
        ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)

INNER JOIN ENTERPRISE.CODELKUP pl 
        ON UPPER(pl.UDF1) = rd.WHSEID
       AND pl.LISTNAME = 'SCHEMA'
	   
WHERE TO_NUMBER(rc.STATUS) < 9 

GROUP BY pl.UDF2,
         rd.RECEIPTKEY,
         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
                THEN 'SIM' 
              ELSE 'NÃO' 
          END,     
         tpnt.DESCRIPTION,     
         stnt.DESCRIPTION,     
         rc.TRAILERNUMBER,     
         rc.TRAILERKEY,      
         rc.DOOR   



		 
=IIF(Parameters!Table.Value <> "AAA",

" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       "+ Parameters!Table.Value + ".RECEIPTDETAIL rd               " &
"                                                                         " &
" INNER JOIN "+ Parameters!Table.Value + ".SKU sku                        " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN "+ Parameters!Table.Value + ".RECEIPT rc                     " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from "+ Parameters!Table.Value + ".codelkup clkp         " &
"          inner join "+ Parameters!Table.Value + ".translationlist trans " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from "+ Parameters!Table.Value + ".codelkup clkp         " &
"          inner join "+ Parameters!Table.Value + ".translationlist trans " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"ORDER BY PLANTA, REDO_DT_ENTRADA                                         "

,		 

" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       WMWHSE1.RECEIPTDETAIL rd                                     " &
"                                                                         " &
" INNER JOIN WMWHSE1.SKU sku                                              " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN WMWHSE1.RECEIPT rc                                           " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE1.codelkup clkp                               " &
"          inner join WMWHSE1.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE1.codelkup clkp                               " &
"          inner join WMWHSE1.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       WMWHSE2.RECEIPTDETAIL rd                                     " &
"                                                                         " &
" INNER JOIN WMWHSE2.SKU sku                                              " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN WMWHSE2.RECEIPT rc                                           " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE2.codelkup clkp                               " &
"          inner join WMWHSE2.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE2.codelkup clkp                               " &
"          inner join WMWHSE2.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       WMWHSE3.RECEIPTDETAIL rd                                     " &
"                                                                         " &
" INNER JOIN WMWHSE3.SKU sku                                              " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN WMWHSE3.RECEIPT rc                                           " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE3.codelkup clkp                               " &
"          inner join WMWHSE3.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE3.codelkup clkp                               " &
"          inner join WMWHSE3.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       WMWHSE4.RECEIPTDETAIL rd                                     " &
"                                                                         " &
" INNER JOIN WMWHSE4.SKU sku                                              " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN WMWHSE4.RECEIPT rc                                           " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE4.codelkup clkp                               " &
"          inner join WMWHSE4.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE4.codelkup clkp                               " &
"          inner join WMWHSE4.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       WMWHSE5.RECEIPTDETAIL rd                                     " &
"                                                                         " &
" INNER JOIN WMWHSE5.SKU sku                                              " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN WMWHSE5.RECEIPT rc                                           " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE5.codelkup clkp                               " &
"          inner join WMWHSE5.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE5.codelkup clkp                               " &
"          inner join WMWHSE5.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       WMWHSE6.RECEIPTDETAIL rd                                     " &
"                                                                         " &
" INNER JOIN WMWHSE6.SKU sku                                              " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN WMWHSE6.RECEIPT rc                                           " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE6.codelkup clkp                               " &
"          inner join WMWHSE6.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE6.codelkup clkp                               " &
"          inner join WMWHSE6.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
" SELECT pl.UDF2                             PLANTA,                      " &
"        min(rd.DATERECEIVED)                REDO_DT_ENTRADA,             " &
"        rd.RECEIPTKEY                       ASN,                         " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                " &
"               THEN 'SIM'                                                " &
"             ELSE   'NÃO'                                                " &
"         END                                IN_MINUCIOSO,                " &
"        tpnt.DESCRIPTION                    TP_NOTA,                     " &
"        stnt.DESCRIPTION                    SITUACAO,                    " &
"        rc.TRAILERKEY                       ID_CAMINHAO,                 " &
"        rc.TRAILERNUMBER                    PLACA_VEICULO,               " &
"        rc.DOOR                             LOCAL_DESCR,                 " &
"        COUNT(DISTINCT rd.SUSR1)            NUM_NFS,                     " &
"        SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,                    " &
"        SUM(rd.QTYRECEIVED)                 QT_REC                       " &
" 	                                                                      " &
" FROM       WMWHSE7.RECEIPTDETAIL rd                                     " &
"                                                                         " &
" INNER JOIN WMWHSE7.SKU sku                                              " &
"         ON sku.SKU = rd.SKU                                             " &
" 		                                                                  " &
" INNER JOIN WMWHSE7.RECEIPT rc                                           " &
"         ON rc.RECEIPTKEY = rd.RECEIPTKEY                                " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE7.codelkup clkp                               " &
"          inner join WMWHSE7.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECEIPTYPE'                        " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) tpnt                  " &
"         ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)                         " &
" 		                                                                  " &
"  LEFT JOIN ( select clkp.code         COD,                              " &
"                     trans.description                                   " &
"                from WMWHSE7.codelkup clkp                               " &
"          inner join WMWHSE7.translationlist trans                       " &
"                  on trans.code = clkp.code                              " &
"                 and trans.joinkey1 = clkp.listname                      " &
"               where clkp.listname = 'RECSTATUS'                         " &
"                 and trans.locale = 'pt'                                 " &
"                 and trans.tblname = 'CODELKUP'                          " &
"                 and Trim(clkp.code) is not null ) stnt                  " &
"         ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)                       " &
"                                                                         " &
" INNER JOIN ENTERPRISE.CODELKUP pl                                       " &
"         ON UPPER(pl.UDF1) = rd.WHSEID                                   " &
"        AND pl.LISTNAME = 'SCHEMA'                                       " &
" 	                                                                      " &
" WHERE TO_NUMBER(rc.STATUS) < 9                                          " &
"                                                                         " &
" GROUP BY pl.UDF2,                                                       " &
"          rd.RECEIPTKEY,                                                 " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                              " &
"                 THEN 'SIM'                                              " &
"               ELSE 'NÃO'                                                " &
"           END,                                                          " &
"          tpnt.DESCRIPTION,                                              " &
"          stnt.DESCRIPTION,                                              " &
"          rc.TRAILERNUMBER,                                              " &
"          rc.TRAILERKEY,                                                 " &
"          rc.DOOR                                                        " &
"                                                                         " &
"ORDER BY PLANTA, REDO_DT_ENTRADA                                         "

)