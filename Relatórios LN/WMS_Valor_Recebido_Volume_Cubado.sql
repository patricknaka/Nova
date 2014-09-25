SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL, 
    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,
    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,
    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,
    
    SUM( ( SELECT REC942A.T$AMNT$L 
             FROM BAANDB.TTDREC942201@dln01 REC942A
            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l
              AND REC942A.T$LINE$L = REC941.T$LINE$l
              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,

    SUM( ( SELECT REC942B.T$AMNT$L 
             FROM BAANDB.TTDREC942201@dln01 REC942B
            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l
              AND REC942B.T$LINE$L = REC941.T$LINE$l
              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,

    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO
  
FROM WMWHSE4.SKU,
     WMWHSE4.RECEIPT,
     WMWHSE4.RECEIPTDETAIL,
     WMSADMIN.PL_DB,
     BAANDB.TTDREC941201@dln01 REC941,
     BAANDB.TTDREC947201@dln01 REC947
   
WHERE RECEIPT.STATUS IN (9,11)
  AND SKU.SKU = RECEIPTDETAIL.SKU
  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID
  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY
  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT
  AND REC941.T$FIRE$L = REC947.T$FIRE$L
  AND REC941.T$LINE$L = REC947.T$LINE$L
  
--  AND (   (TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy') = :Recebido) 
--       OR (:Recebido is null) )

  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || :RecebidoDe) 
                                     And ( To_Char(LAST_DAY('01/' || :RecebidoAte), 'dd/MM/yyyy') )  )
        OR :RecebidoDe Is Null OR :RecebidoAte Is Null )

GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')

ORDER BY TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')


"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM " + Parameters!Table.Value + ".SKU,                                                   " &
"     " + Parameters!Table.Value + ".RECEIPT,                                               " &
"     " + Parameters!Table.Value + ".RECEIPTDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"ORDER BY TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                                           " 
                                                                                          

-- Query com UNION **************************************************************************


"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM WMWHSE1.SKU,                                                                          " &
"     WMWHSE1.RECEIPT,                                                                      " &
"     WMWHSE1.RECEIPTDETAIL,                                                                " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"Union                                                                                      " &
"                                                                                           " &
"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM WMWHSE2.SKU,                                                                          " &
"     WMWHSE2.RECEIPT,                                                                      " &
"     WMWHSE2.RECEIPTDETAIL,                                                                " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"Union                                                                                      " &
"                                                                                           " &
"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM WMWHSE3.SKU,                                                                          " &
"     WMWHSE3.RECEIPT,                                                                      " &
"     WMWHSE3.RECEIPTDETAIL,                                                                " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"Union                                                                                      " &
"                                                                                           " &
"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM WMWHSE4.SKU,                                                                          " &
"     WMWHSE4.RECEIPT,                                                                      " &
"     WMWHSE4.RECEIPTDETAIL,                                                                " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"Union                                                                                      " &
"                                                                                           " &
"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM WMWHSE5.SKU,                                                                          " &
"     WMWHSE5.RECEIPT,                                                                      " &
"     WMWHSE5.RECEIPTDETAIL,                                                                " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"Union                                                                                      " &
"                                                                                           " &
"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM WMWHSE6.SKU,                                                                          " &
"     WMWHSE6.RECEIPT,                                                                      " &
"     WMWHSE6.RECEIPTDETAIL,                                                                " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"Union                                                                                      " &
"                                                                                           " &
"SELECT                                                                                     " &
"  DISTINCT                                                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                              " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,                          " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,                      " &
"                                                                                           " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942A                                        " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,                           " &
"                                                                                           " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                                         " &
"             FROM BAANDB.TTDREC942201@dln01 REC942B                                        " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                                       " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                                       " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,                       " &
"                                                                                           " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO                        " &
"	                                                                                        " &
"FROM WMWHSE7.SKU,                                                                          " &
"     WMWHSE7.RECEIPT,                                                                      " &
"     WMWHSE7.RECEIPTDETAIL,                                                                " &
"     WMSADMIN.PL_DB,                                                                       " &
"     BAANDB.TTDREC941201@dln01 REC941,                                                     " &
"     BAANDB.TTDREC947201@dln01 REC947                                                      " &
"	                                                                                        " &
"WHERE RECEIPT.STATUS IN (9,11)                                                             " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                          " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                      " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                        " &
"  AND REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                                          " &
"  AND REC941.T$FIRE$L = REC947.T$FIRE$L                                                    " &
"  AND REC941.T$LINE$L = REC947.T$LINE$L                                                    " &
"                                                                                           " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                  " &
"                                                                                           " &
"ORDER BY FILIAL, MESANO                                                                    " 