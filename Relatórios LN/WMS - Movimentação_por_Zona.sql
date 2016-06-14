SELECT ORDERS.WHSEID                 ID_FILIAL,
       wmsCODE.UDF2                  NOME_FILIAL,
       znsls401.T$ENTR$C             ID_ENTREGA, ORDERS.ORDERKEY,
       ORDERDETAIL.SKU               ID_ITEM,
       tcmcs023.t$dsca               DEPARTAMENTO,
       znmcs030.t$dsca$c             SETOR,
       tcibd001.t$dscb$c             DESCR_ITEM,
       tccom130a.t$fovn$l            CNPJ_FORNECEDOR,
       tccom130a.t$nama              NOME_FORNECEDOR,
       LOC.PUTAWAYZONE               ZONA,
       Trim(PZ.DESCR)                DESCR_ZONA,
       TASKDETAIL.FROMLOC            LOCAL_INICIO,
       TASKDETAIL.EDITWHO            USUARIO_NOME_SEPARACAO,
       ORDERDETAIL.ORIGINALQTY       PECAS,
       ORDERS.NOVASTATUS             STATUS_PEDIDO,
       STATUSSETUP.DESCRIPTION       DESCR_STATUS_PEDIDO,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(HISTORY.ADDDATE,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE)
                                     DATA_STATUS

FROM       WMWHSE5.ORDERDETAIL ORDERDETAIL

INNER JOIN baandb.tznsls401301@pln01 znsls401
        ON ORDERDETAIL.SALESORDERDOCUMENT = znsls401.t$orno$c
       AND ORDERDETAIL.SALESORDERLINE = znsls401.t$pono$c

INNER JOIN WMWHSE5.ORDERS ORDERS
        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY

INNER JOIN ( SELECT h.orderkey     orderkey, 
                    h.status       status,
                    MAX(h.adddate) adddate
               FROM  WMWHSE5.ORDERSTATUSHISTORY h 
           GROUP BY h.orderkey, 
                    h.status ) HISTORY
        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY
       AND HISTORY.STATUS = ORDERS.NOVASTATUS

 LEFT JOIN WMWHSE5.TASKDETAIL TASKDETAIL
        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY
       AND TASKDETAIL.SKU = ORDERDETAIL.SKU

 LEFT JOIN WMWHSE5.LOC LOC
        ON LOC.LOC = TASKDETAIL.FROMLOC

 LEFT JOIN WMWHSE5.PUTAWAYZONE PZ
        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE

 LEFT JOIN WMWHSE5.SKU SKU
        ON SKU.SKU = ORDERDETAIL.SKU

 LEFT JOIN ( select A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               from ENTERPRISE.CODELKUP A
              where A.LISTNAME = 'SCHEMA' ) wmsCODE
        ON wmsCODE.UDF1 = ORDERS.WHSEID
    
 LEFT JOIN baandb.ttcibd001301@pln01 tcibd001
        ON Trim(tcibd001.t$item) = ORDERDETAIL.SKU

 LEFT JOIN baandb.ttcmcs023301@pln01 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
    
 LEFT JOIN baandb.tznmcs030301@pln01 znmcs030
        ON znmcs030.t$seto$c = tcibd001.t$seto$c
       AND znmcs030.t$citg$c = tcibd001.t$citg
     
 LEFT JOIN baandb.ttdipu001301@pln01 tdipu001
        ON tdipu001.t$item = tcibd001.t$item

 LEFT JOIN baandb.ttccom100301@pln01 tccom100
        ON tccom100.t$bpid = tdipu001.t$otbp

 LEFT JOIN baandb.ttccom130301@pln01 tccom130a
        ON tccom130a.t$cadr = tccom100.t$cadr
        
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP STATUSSETUP 
        ON STATUSSETUP.CODE = ORDERS.NOVASTATUS
        
WHERE TASKDETAIL.TASKTYPE = 'PK'
  AND TASKDETAIL.STATUS = 9
  AND ORDERS.NOVASTATUS not in (95, 98, 100)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(HISTORY.ADDDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataRegistroDe
          And :DataRegistroAte
  AND ORDERS.NOVASTATUS IN (:StatusNF)
  AND ((:Depto = '000') OR (tcmcs023.t$citg = :Depto))
  AND ((:Setor = '000') OR (znmcs030.t$seto$c = :Setor))
  

=

" SELECT ORDERS.WHSEID                 ID_FILIAL,  " &
"        wmsCODE.UDF2                  NOME_FILIAL,  " &
"        znsls401.T$ENTR$C             ID_ENTREGA, ORDERS.ORDERKEY,  " &
"        ORDERDETAIL.SKU               ID_ITEM,  " &
"        tcmcs023.t$dsca               DEPARTAMENTO,  " &
"        znmcs030.t$dsca$c             SETOR,  " &
"        tcibd001.t$dscb$c             DESCR_ITEM,  " &
"        tccom130a.t$fovn$l            CNPJ_FORNECEDOR,  " &
"        tccom130a.t$nama              NOME_FORNECEDOR,  " &
"        LOC.PUTAWAYZONE               ZONA,  " &
"        Trim(PZ.DESCR)                DESCR_ZONA,  " &
"        TASKDETAIL.FROMLOC            LOCAL_INICIO,  " &
"        TASKDETAIL.EDITWHO            USUARIO_NOME_SEPARACAO,  " &
"        ORDERDETAIL.ORIGINALQTY       PECAS,  " &
"        ORDERS.NOVASTATUS             STATUS_PEDIDO,  " &
"        STATUSSETUP.DESCRIPTION       DESCR_STATUS_PEDIDO,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(HISTORY.ADDDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone sessiontimezone) AS DATE)  " &
"                                      DATA_STATUS  " &
"  " &
" FROM       " + Parameters!Compania.Value + ".ORDERDETAIL ORDERDETAIL  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON ORDERDETAIL.SALESORDERDOCUMENT = znsls401.t$orno$c  " &
"        AND ORDERDETAIL.SALESORDERLINE = znsls401.t$pono$c  " &
"  " &
" INNER JOIN " + Parameters!Compania.Value + ".ORDERS ORDERS  " &
"         ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" INNER JOIN ( SELECT h.orderkey     orderkey,  " &
"                     h.status       status,  " &
"                     MAX(h.adddate) adddate  " &
"                FROM " + Parameters!Compania.Value + ".ORDERSTATUSHISTORY h  " &
"            GROUP BY h.orderkey,  " &
"                     h.status ) HISTORY  " &
"         ON HISTORY.ORDERKEY = ORDERS.ORDERKEY  " &
"        AND HISTORY.STATUS = ORDERS.NOVASTATUS  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".TASKDETAIL TASKDETAIL  " &
"         ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"        AND TASKDETAIL.SKU = ORDERDETAIL.SKU  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".LOC LOC  " &
"         ON LOC.LOC = TASKDETAIL.FROMLOC  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".PUTAWAYZONE PZ  " &
"         ON PZ.PUTAWAYZONE =  LOC.PUTAWAYZONE  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".SKU SKU  " &
"         ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
"  LEFT JOIN ( select A.LONG_VALUE,  " &
"                     UPPER(A.UDF1) UDF1,  " &
"                     A.UDF2  " &
"                from ENTERPRISE.CODELKUP A  " &
"               where A.LISTNAME = 'SCHEMA' ) wmsCODE  " &
"         ON wmsCODE.UDF1 = ORDERS.WHSEID  " &
"  " &
"  LEFT JOIN baandb.ttcibd001301@pln01 tcibd001  " &
"         ON Trim(tcibd001.t$item) = ORDERDETAIL.SKU  " &
"  " &
"  LEFT JOIN baandb.ttcmcs023301@pln01 tcmcs023  " &
"         ON tcmcs023.t$citg = tcibd001.t$citg  " &
"  " &
"  LEFT JOIN baandb.tznmcs030301@pln01 znmcs030  " &
"         ON znmcs030.t$seto$c = tcibd001.t$seto$c  " &
"        AND znmcs030.t$citg$c = tcibd001.t$citg  " &
"  " &
"  LEFT JOIN baandb.ttdipu001301@pln01 tdipu001  " &
"         ON tdipu001.t$item   = tcibd001.t$item  " &
"  " &
"  LEFT JOIN baandb.ttccom100301@pln01 tccom100  " &
"         ON tccom100.t$bpid   = tdipu001.t$otbp  " &
"  " &
"  LEFT JOIN baandb.ttccom130301@pln01 tccom130a  " &
"         ON tccom130a.t$cadr  = tccom100.t$cadr  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".ORDERSTATUSSETUP STATUSSETUP  " &
"         ON STATUSSETUP.CODE = ORDERS.NOVASTATUS  " &
"  " &
" WHERE TASKDETAIL.TASKTYPE = 'PK'  " &
"   AND TASKDETAIL.STATUS = 9  " &
"   AND ORDERS.NOVASTATUS not in (95, 98, 100)  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(HISTORY.ADDDATE,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataRegistroDe  " &
"           And :DataRegistroAte  " &
"   AND ORDERS.NOVASTATUS IN (:StatusNF)  " &
"   AND ((:Depto = '000') OR (tcmcs023.t$citg = :Depto))  " &
"   AND ((:Setor = '000') OR (znmcs030.t$seto$c = :Setor))  "