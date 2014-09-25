SELECT  
  WMSADMIN.DB_ALIAS                                           PLANTA,
  RECEIPT.RECEIPTKEY                                          ASN,
	SKU.SKU												      ITEM,
     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                        
           THEN 'SIM'                                         
           ELSE 'N�O'                                         
      END                                                     REDO_IN_MINUCIOSO,    
  CODELKUP.LONG_VALUE                                         NRCA_TP_NOTA,
  COUNT(Distinct RECEIPT.SUPPLIERCODE)                        NUM_FORNS,
  MIN(RECEIPT.ADDDATE)                                        H_ENTRADA,
  MIN(RSH.ADDDATE)                                            INICIO_EFETIVO,
  numtodsinterval( MIN(RSH.ADDDATE)-                          
                   MIN(RECEIPT.ADDDATE), 'DAY' )              TPREP,
  MIN(RECEIPTDETAIL.DATERECEIVED)                             HL,
  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-           
                   MIN(RSH.ADDDATE), 'DAY' )                  TREC,
  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-           
                   MIN(RSH2.ADDDATE), 'DAY' )                 TTOT,
  DEPARTSECTORSKU.DEPART_NAME                                 DPTO,
  DEPARTSECTORSKU.SECTOR_NAME                                 SETOR,
  COUNT(distinct RECEIPTDETAIL.TOID)                          GRUPOS,
  SUM(RECEIPTDETAIL.QTYRECEIVED)                              QT,
  SUM(RECEIPTDETAIL.CUBE)                                     M3,
  COUNT(RECEIPTDETAIL.SKU)                                    NU_ITENS
    
FROM WMWHSE4.RECEIPT,
     WMWHSE4.RECEIPTDETAIL,
     WMWHSE4.SKU,
     WMWHSE4.CODELKUP,
   
   ( SELECT A1.RECEIPTKEY, 
            A1.RECEIPTLINENUMBER,
            MIN(A1.ADDDATE) ADDDATE 
       FROM WMWHSE4.RECEIPTDETAILSTATUSHISTORY A1
      WHERE A1.STATUS > '4'
   GROUP BY A1.RECEIPTKEY, 
            A1.RECEIPTLINENUMBER ) RSH,
   
   ( SELECT A1.RECEIPTKEY, 
            A1.RECEIPTLINENUMBER,
            MIN(A1.ADDDATE) ADDDATE 
       FROM WMWHSE4.RECEIPTDETAILSTATUSHISTORY A1
      WHERE A1.STATUS > '0'
   GROUP BY A1.RECEIPTKEY, 
            A1.RECEIPTLINENUMBER ) RSH2,
      
     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,
     WMSADMIN.PL_DB             WMSADMIN

WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY
  AND SKU.SKU = RECEIPTDETAIL.SKU  
  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)
  AND CODELKUP.LISTNAME = 'RECEIPTYPE'
  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY
  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER
  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY
  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER
  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID
  
HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between :DataEntradaDe
   AND :DataEntradaAte
   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between :DataLiquidadoDe
   AND :DataLiquidadoAte
  
GROUP BY RECEIPT.RECEIPTKEY,
         SKU.SKU,
         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'
                THEN 'SIM' 
              ELSE   'N�O' 
          END,
         CODELKUP.LONG_VALUE,
         DEPARTSECTORSKU.DEPART_NAME,
         DEPARTSECTORSKU.SECTOR_NAME,
         WMSADMIN.DB_ALIAS

"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM " + Parameters!Table.Value + ".RECEIPT,                                                       " &
"     " + Parameters!Table.Value + ".RECEIPTDETAIL,                                                 " &
"     " + Parameters!Table.Value + ".SKU,                                                           " &
"     " + Parameters!Table.Value + ".CODELKUP,                                                      " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM " + Parameters!Table.Value + ".RECEIPTDETAILSTATUSHISTORY A1                           " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM " + Parameters!Table.Value + ".RECEIPTDETAILSTATUSHISTORY A1                           " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         "

-- Query com UNION ************************************************************************************

"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM WMWHSE1.RECEIPT,                                                                              " &
"     WMWHSE1.RECEIPTDETAIL,                                                                        " &
"     WMWHSE1.SKU,                                                                                  " &
"     WMWHSE1.CODELKUP,                                                                             " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE1.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE1.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         " &
"                                                                                                   " &
"Union                                                                                              " &
"                                                                                                   " &
"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM WMWHSE2.RECEIPT,                                                                              " &
"     WMWHSE2.RECEIPTDETAIL,                                                                        " &
"     WMWHSE2.SKU,                                                                                  " &
"     WMWHSE2.CODELKUP,                                                                             " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE2.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE2.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         " &
"                                                                                                   " &
"Union                                                                                              " &
"                                                                                                   " &
"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM WMWHSE3.RECEIPT,                                                                              " &
"     WMWHSE3.RECEIPTDETAIL,                                                                        " &
"     WMWHSE3.SKU,                                                                                  " &
"     WMWHSE3.CODELKUP,                                                                             " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE3.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE3.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         " &
"                                                                                                   " &
"Union                                                                                              " &
"                                                                                                   " &
"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM WMWHSE4.RECEIPT,                                                                              " &
"     WMWHSE4.RECEIPTDETAIL,                                                                        " &
"     WMWHSE4.SKU,                                                                                  " &
"     WMWHSE4.CODELKUP,                                                                             " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE4.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE4.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         " &
"                                                                                                   " &
"Union                                                                                              " &
"                                                                                                   " &
"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM WMWHSE5.RECEIPT,                                                                              " &
"     WMWHSE5.RECEIPTDETAIL,                                                                        " &
"     WMWHSE5.SKU,                                                                                  " &
"     WMWHSE5.CODELKUP,                                                                             " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE5.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE5.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         " &
"                                                                                                   " &
"Union                                                                                              " &
"                                                                                                   " &
"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM WMWHSE6.RECEIPT,                                                                              " &
"     WMWHSE6.RECEIPTDETAIL,                                                                        " &
"     WMWHSE6.SKU,                                                                                  " &
"     WMWHSE6.CODELKUP,                                                                             " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE6.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE6.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         " &
"                                                                                                   " &
"Union                                                                                              " &
"                                                                                                   " &
"SELECT                                                                                             " &
"  WMSADMIN.DB_ALIAS                                          PLANTA,                               " &
"  RECEIPT.RECEIPTKEY                                         ASN,                                  " &
"  SKU.SKU                                                    ITEM,                                 " &
"     CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                             " &
"           THEN 'SIM'                                                                              " &
"           ELSE 'N�O'                                                                              " &
"      END                                                    REDO_IN_MINUCIOSO,                    " &
"  CODELKUP.LONG_VALUE                                        NRCA_TP_NOTA,                         " &
"  COUNT(Distinct RECEIPT.SUPPLIERCODE)                       NUM_FORNS,                            " &
"  MIN(RECEIPT.ADDDATE)                                       H_ENTRADA,                            " &
"  MIN(RSH.ADDDATE)                                           INICIO_EFETIVO,                       " &
"  numtodsinterval( MIN(RSH.ADDDATE)-                                                               " &
"                   MIN(RECEIPT.ADDDATE), 'DAY' )             TPREP,                                " &
"  MIN(RECEIPTDETAIL.DATERECEIVED)                            HL,                                   " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH.ADDDATE), 'DAY' )                 TREC,                                 " &
"  numtodsinterval( MAX(RECEIPTDETAIL.DATERECEIVED)-                                                " &
"                   MIN(RSH2.ADDDATE), 'DAY' )                TTOT,                                 " &
"  DEPARTSECTORSKU.DEPART_NAME                                DPTO,                                 " &
"  DEPARTSECTORSKU.SECTOR_NAME                                SETOR,                                " &
"  COUNT(distinct RECEIPTDETAIL.TOID)                         GRUPOS,                               " &
"  SUM(RECEIPTDETAIL.QTYRECEIVED)                             QT,                                   " &
"  SUM(RECEIPTDETAIL.CUBE)                                    M3,                                   " &
"  COUNT(RECEIPTDETAIL.SKU)                                   NU_ITENS                              " &
"                                                                                                   " &
"FROM WMWHSE7.RECEIPT,                                                                              " &
"     WMWHSE7.RECEIPTDETAIL,                                                                        " &
"     WMWHSE7.SKU,                                                                                  " &
"     WMWHSE7.CODELKUP,                                                                             " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE7.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '4'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH,                                                            " &
"                                                                                                   " &
"   ( SELECT A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER,                                                                  " &
"            MIN(A1.ADDDATE) ADDDATE                                                                " &
"       FROM WMWHSE7.RECEIPTDETAILSTATUSHISTORY A1                                                  " &
"      WHERE A1.STATUS > '0'                                                                        " &
"   GROUP BY A1.RECEIPTKEY,                                                                         " &
"            A1.RECEIPTLINENUMBER ) RSH2,                                                           " &
"                                                                                                   " &
"     ENTERPRISE.DEPARTSECTORSKU DEPARTSECTORSKU,                                                   " &
"     WMSADMIN.PL_DB             WMSADMIN                                                           " &
"                                                                                                   " &
"WHERE RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                                " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                                  " &
"  AND TO_CHAR(CODELKUP.CODE) = TO_CHAR(RECEIPT.TYPE)                                               " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                             " &
"  AND RSH.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                    " &
"  AND RSH.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                      " &
"  AND RSH2.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                                                   " &
"  AND RSH2.RECEIPTLINENUMBER = RECEIPTDETAIL.RECEIPTLINENUMBER                                     " &
"  AND TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)                                   " &
"  AND UPPER(WMSADMIN.DB_LOGID) = RECEIPT.WHSEID                                                    " &
"                                                                                                   " &
"HAVING Trunc(MIN(RECEIPT.ADDDATE)) Between '" + Parameters!DataEntradaDe.Value + "'                " &
"   AND '" + Parameters!DataEntradaAte.Value + "'                                                   " &
"   AND Trunc(MIN(RECEIPTDETAIL.DATERECEIVED)) Between '" + Parameters!DataLiquidadoDe.Value + "'   " &
"   AND '" + Parameters!DataLiquidadoAte.Value + "'                                                 " &
"                                                                                                   " &
"GROUP BY RECEIPT.RECEIPTKEY,                                                                       " &
"         SKU.SKU,                                                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                         " &
"                THEN 'SIM'                                                                         " &
"              ELSE   'N�O'                                                                         " &
"          END,                                                                                     " &
"         CODELKUP.LONG_VALUE,                                                                      " &
"         DEPARTSECTORSKU.DEPART_NAME,                                                              " &
"         DEPARTSECTORSKU.SECTOR_NAME,                                                              " &
"         WMSADMIN.DB_ALIAS                                                                         " &
"                                                                                                   " &
"ORDER BY PLANTA                                                                                    "