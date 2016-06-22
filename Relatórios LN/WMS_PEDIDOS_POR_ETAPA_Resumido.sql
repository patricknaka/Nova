    SELECT WMSADMIN.PL_DB.DB_ALIAS            DSC_PLANTA,

           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_LIMITE,
           ORDERS.ORDERKEY                    PEDIDO,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_REGISTRO,
           ORDERS.type                        COD_TIPO_PEDIDO,
           TIPO_PEDIDO.                       DSC_TIPO_PEDIDO,
           tsl.description                    EVENTO,
	       
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERINVOICEAUDIT.EDITDATE,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_ULT_EVENTO,
	       								   
           ORDERINVOICEAUDIT.EDITWHO          OPERADOR,
           ORDERDETAIL.SKU                    ITEM,
           SKU.DESCR                          NOME_ITEM,
           NVL(ORDERS.C_VAT, 'N/A')           MEGA_ROTA,
           ORDERSTATUSSETUP.DESCRIPTION       SITUACAO_PEDIDO,
           WAVEDETAIL.WAVEKEY                 ONDA,
           ORDERS.ASSIGNMENT                  PROGRAMA,
           ORDERS.CARRIERCODE                 ID_TRANSPORTADORA,
           ORDERS.CARRIERNAME                 TRANSPORTADORA,
           SLS002.T$TPEN$C                    TIPO_ENTREGA,
           NVL(ORDERS.SUSR1, 'Não aplicável') DSC_TIPO_ENTREGA,
           ORDERS.INVOICENUMBER               NOTA,
           ORDERS.LANE                        SERIE,
           CAGEIDDETAIL.CAGEID                CARGA,
           CASE WHEN SKU.SUSR2 = '2'
                  THEN 'PESADO'
                ELSE   'LEVE'
           END                                TP_TRANSPORTE

FROM       WMWHSE8.ORDERS

INNER JOIN WMWHSE8.ORDERDETAIL
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY

INNER JOIN WMWHSE8.SKU
        ON SKU.SKU = ORDERDETAIL.SKU

 LEFT JOIN WMWHSE8.CODELKUP cc
        ON cc.listname = 'NOVAORDSTS'
       AND cc.code = orders.novastatus

 LEFT JOIN WMWHSE8.TRANSLATIONLIST tsl
        ON tsl.tblname = 'CODELKUP'
       AND tsl.locale = 'pt'
       AND tsl.code = cc.code
       AND tsl.joinkey1 = cc.listname

 LEFT JOIN WMWHSE8.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS

 LEFT JOIN WMWHSE8.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY

 LEFT JOIN WMWHSE8.CAGEIDDETAIL
        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY

 LEFT JOIN WMWHSE8.CAGEID
        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID

 LEFT JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID

 LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002
        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))

 LEFT JOIN ( select a.ORDERNUMBER, 
                    a.EDITDATE, 
                    a.EDITWHO
               from WMWHSE8.ORDERINVOICEAUDIT a
              where a.EDITDATE = ( select max(b.EDITDATE)
                                     from WMWHSE8.ORDERINVOICEAUDIT b
                                    where a.ORDERNUMBER = b.ORDERNUMBER ) ) ORDERINVOICEAUDIT
        ON ORDERINVOICEAUDIT.ORDERNUMBER = ORDERDETAIL.ORDERKEY

 LEFT JOIN ( select clkp.code          COD_TIPO_PEDIDO,
                    NVL(trans.description,
                    clkp.description)  DSC_TIPO_PEDIDO
               from WMWHSE8.codelkup clkp
          left join WMWHSE8.translationlist trans
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP'
              where clkp.listname = 'ORDERTYPE'
                and Trim(clkp.code) is not null  ) TIPO_PEDIDO
      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.TYPE

WHERE ORDERS.NOVASTATUS not in (95, 98, 100)
  AND NVL(SLS002.T$TPEN$C, 0) IN (:TipoEntrega)
  AND ORDERS.NOVASTATUS IN (:Eventos)
  AND NVL(ORDERS.C_VAT, 'N/A') IN (:MegaRota)  
  
ORDER BY ORDERS.ORDERKEY


=

"     SELECT WMSADMIN.PL_DB.DB_ALIAS            DSC_PLANTA,  " &
"  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"               AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                               DATA_LIMITE,  " &
"            ORDERS.ORDERKEY                    PEDIDO,  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                               DATA_REGISTRO,  " &
"            ORDERS.type                        COD_TIPO_PEDIDO,  " &
"            TIPO_PEDIDO.                       DSC_TIPO_PEDIDO,  " &
"            tsl.description                    EVENTO,  " &
"  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERINVOICEAUDIT.EDITDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                               DATA_ULT_EVENTO,  " &
"  " &
"            ORDERINVOICEAUDIT.EDITWHO          OPERADOR,  " &
"            ORDERDETAIL.SKU                    ITEM,  " &
"            SKU.DESCR                          NOME_ITEM,  " &
"            NVL(ORDERS.C_VAT, 'N/A')           MEGA_ROTA,  " &
"            ORDERSTATUSSETUP.DESCRIPTION       SITUACAO_PEDIDO,  " &
"            WAVEDETAIL.WAVEKEY                 ONDA,  " &
"            ORDERS.ASSIGNMENT                  PROGRAMA,  " &
"            ORDERS.CARRIERCODE                 ID_TRANSPORTADORA,  " &
"            ORDERS.CARRIERNAME                 TRANSPORTADORA,  " &
"            SLS002.T$TPEN$C                    TIPO_ENTREGA,  " &
"            NVL(ORDERS.SUSR1, 'Não aplicável') DSC_TIPO_ENTREGA,  " &
"            ORDERS.INVOICENUMBER               NOTA,  " &
"            ORDERS.LANE                        SERIE,  " &
"            CAGEIDDETAIL.CAGEID                CARGA,  " &
"            CASE WHEN SKU.SUSR2 = '2'  " &
"                   THEN 'PESADO'  " &
"                 ELSE   'LEVE'  " &
"            END                                TP_TRANSPORTE  " &
"  " &
" FROM       " + Parameters!Compania.Value +  ".ORDERS  " &
"  " &
" INNER JOIN " + Parameters!Compania.Value +  ".ORDERDETAIL  " &
"         ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" INNER JOIN " + Parameters!Compania.Value +  ".SKU  " &
"         ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value +  ".CODELKUP cc  " &
"         ON cc.listname = 'NOVAORDSTS'  " &
"        AND cc.code = orders.novastatus  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value +  ".TRANSLATIONLIST tsl  " &
"         ON tsl.tblname = 'CODELKUP'  " &
"        AND tsl.locale = 'pt'  " &
"        AND tsl.code = cc.code  " &
"        AND tsl.joinkey1 = cc.listname  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value +  ".ORDERSTATUSSETUP  " &
"         ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value +  ".WAVEDETAIL  " &
"         ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value +  ".CAGEIDDETAIL  " &
"         ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY  " &
"  " &
"  LEFT JOIN " + Parameters!Compania.Value +  ".CAGEID  " &
"         ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
"  LEFT JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID  " &
"  " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"         ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  " &
"  LEFT JOIN ( select a.ORDERNUMBER,  " &
"                     a.EDITDATE,  " &
"                     a.EDITWHO  " &
"                from " + Parameters!Compania.Value +  ".ORDERINVOICEAUDIT a  " &
"               where a.EDITDATE = ( select max(b.EDITDATE)  " &
"                                      from " + Parameters!Compania.Value +  ".ORDERINVOICEAUDIT b  " &
"                                     where a.ORDERNUMBER = b.ORDERNUMBER ) ) ORDERINVOICEAUDIT  " &
"         ON ORDERINVOICEAUDIT.ORDERNUMBER = ORDERDETAIL.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO_PEDIDO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO_PEDIDO  " &
"                from " + Parameters!Compania.Value +  ".codelkup clkp  " &
"           left join " + Parameters!Compania.Value +  ".translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'ORDERTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_PEDIDO  " &
"       ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.TYPE  " &
"  " &
" WHERE ORDERS.NOVASTATUS not in (95, 98, 100)  " &
"   AND NVL(SLS002.T$TPEN$C, 0) IN (:TipoEntrega)  " &
"   AND ORDERS.NOVASTATUS IN (:Eventos)  " &
"   AND NVL(ORDERS.C_VAT, 'N/A') IN (:MegaRota)    " &
"  " &
" ORDER BY ORDERS.ORDERKEY  "
