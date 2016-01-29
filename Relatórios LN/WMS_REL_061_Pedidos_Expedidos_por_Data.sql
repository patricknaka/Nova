SELECT
 DISTINCT
   WMSADMIN.DB_ALIAS                    PLANTA,
   ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,
   ORDERS.ORDERKEY                      PEDIDO,
   znsls401.t$uneg$c                    ID_UNINEG,
   ORDERS.SUSR4                         UNINEG,
   znsls400.t$dtin$c                    DT_COMPRA,
   ORDERS.ADDDATE                       DT_REGISTRO,
   subStr( tu.usr_name,4,
           inStr(tu.usr_name, ',')-4 )  OPERADOR,
   ORDERDETAIL.SKU                      ID_ITEM,
   DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,
   SKU.DESCR                            NOME,
   znsls400.t$idca$c                    CANAL,
   ORDERS.C_VAT                         MEGA_ROTA,
   ORDERS.C_CITY                        CIDADE,
   ORDERS.C_STATE                       ESTADO,
   TASKDETAIL.TASKDETAILKEY             PROGRAMA,
   WAVEDETAIL.WAVEKEY                   ONDA,
   CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA,
   ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,
   ORDERS.CARRIERCODE                   ID_TRANSP,
   ORDERS.CARRIERNAME                   NOME_TRANSP,

   ( select o.T$COCT$C
       from BAANDB.TZNFMD640301@pln01 o
      where o.T$date$c = ( select max(o1.T$date$c)
                             from BAANDB.TZNFMD640301@pln01 o1
                            where o1.T$ETIQ$C = o.T$ETIQ$C)
                               AND o.T$ETIQ$C = znfmd630.T$ETIQ$C
                               AND rownum = 1 )
                                        OCORRENCIA,

   ( select c.t$dsci$c
       from BAANDB.TZNFMD640301@pln01 o,
            BAANDB.TZNFMD030301@pln01 c
      where o.T$date$c = ( select max(o1.T$date$c)
                             from BAANDB.TZNFMD640301@pln01 o1
                            where o1.T$ETIQ$C = o.T$ETIQ$C)
                               AND o.T$ETIQ$C = znfmd630.T$ETIQ$C
                               AND c.t$ocin$c = o.T$COCI$C
                               AND rownum = 1)
                                        NOME_OCOR,

   ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,
   ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,
   ORDERS.INVOICENUMBER                 NR_NF,
   ORDERS.LANE                          SERIE_NF,
   znsls400.t$idli$c                    ID_LISTA_CASAMENTO,
   znsls400.t$emaf$c                    EMAIL_CLIENTE,
   ORDERDETAIL.UOM                      UNIMEDIDA,
   whwmd400.t$hght                      ALTURA,
   whwmd400.t$wdth                      LARGURA,
   whwmd400.t$dpth                      COMPRIMENTO,
   SKU.STDNETWGT                        PESO_UNITARIO,
   SKU.STDGROSSWGT                      PESO_BRUTO,
   ORDERDETAIL.ORIGINALQTY              QUANTIDADE,
   znsls401.t$vlun$c                    VALOR_ITEM,
   znfmd630.t$ncar$c                    CARGA,
   tdsls400.t$fdty$l                    OPERACAO,
   OPERACAO.                            DESC_OPERACAO

FROM       WMWHSE5.ORDERS

INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401
        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT

INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400
        ON tdsls400.t$orno = znsls401.t$orno$c

 LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c

 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630
        ON znfmd630.t$orno$c = znsls401.t$orno$c

 LEFT JOIN WMWHSE5.CAGEIDDETAIL
        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY

 LEFT JOIN WMWHSE5.CAGEID
        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID

 LEFT JOIN WMWHSE5.ORDERDETAIL
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY

 LEFT JOIN WMWHSE5.TASKDETAIL  TASKDETAIL
        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY
       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER
       AND TASKDETAIL.TASKTYPE = 'PK'

INNER JOIN WMSADMIN.PL_DB    WMSADMIN
         ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID

 LEFT JOIN WMWHSE5.taskmanageruser tu
        ON tu.userkey = TASKDETAIL.EDITWHO

 LEFT JOIN WMWHSE5.WAVEDETAIL  WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY

 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS

 LEFT JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400
        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)

 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU
        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)

 LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,
                    l.t$desc DESC_OPERACAO
               FROM baandb.tttadv401000@pln01 d,
                    baandb.tttadv140000@pln01 l
              WHERE d.t$cpac = 'ci'
                AND d.t$cdom = 'sli.tdff.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) || '|' ||
                    rpad(d.t$rele,2) || '|' ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv401000@pln01 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) || '|' ||
                    rpad(l.t$rele,2) || '|' ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000@pln01 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO
        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO

WHERE Trunc(ORDERS.ADDDATE) 
      Between :DataRegistroDe
          AND :DataRegistroAte

  
  
=IIF(Parameters!Table.Value <> "AAA", 

"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &
"  " &
"FROM       " + Parameters!Table.Value + ".ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "

,

"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &
"  " &
"FROM       WMWHSE1.ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN WMWHSE1.CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE1.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN WMWHSE1.ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE1.TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN WMWHSE1.taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN WMWHSE1.WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN WMWHSE1.SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "  &
"  " &
"Union  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &
"  " &
"FROM       WMWHSE2.ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN WMWHSE2.CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE2.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN WMWHSE2.ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE2.TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN WMWHSE2.taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN WMWHSE2.WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN WMWHSE2.SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "  &
"  " &
"Union  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &
"  " &
"FROM       WMWHSE3.ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN WMWHSE3.CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE3.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN WMWHSE3.ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE3.TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN WMWHSE3.taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN WMWHSE3.WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN WMWHSE3.SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "  &
"  " &
"Union  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &
"  " &
"FROM       WMWHSE4.ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN WMWHSE4.CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE4.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN WMWHSE4.ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE4.TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN WMWHSE4.taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN WMWHSE4.WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN WMWHSE4.SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "  &
"  " &
"Union  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &

"  " &
"FROM       WMWHSE5.ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN WMWHSE5.CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE5.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN WMWHSE5.ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE5.TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN WMWHSE5.taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN WMWHSE5.WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN WMWHSE5.SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "  &
"  " &
"Union  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &
"  " &
"FROM       WMWHSE6.ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN WMWHSE6.CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE6.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN WMWHSE6.ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE6.TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN WMWHSE6.taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN WMWHSE6.WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN WMWHSE6.SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "  &
"  " &
"Union  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    WMSADMIN.DB_ALIAS                    PLANTA,  " &
"    ORDERS.SCHEDULEDSHIPDATE             DT_LIMITE,  " &
"    ORDERS.ORDERKEY                      PEDIDO,  " &
"    znsls401.t$uneg$c                    ID_UNINEG,  " &
"    ORDERS.SUSR4                         UNINEG,  " &
"    znsls400.t$dtin$c                    DT_COMPRA,  " &
"    ORDERS.ADDDATE                       DT_REGISTRO,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',')-4 )  OPERADOR,  " &
"    ORDERDETAIL.SKU                      ID_ITEM,  " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"    SKU.DESCR                            NOME,  " &
"    znsls400.t$idca$c                    CANAL,  " &
"    ORDERS.C_VAT                         MEGA_ROTA,  " &
"    ORDERS.C_CITY                        CIDADE,  " &
"    ORDERS.C_STATE                       ESTADO,  " &
"    TASKDETAIL.TASKDETAILKEY             PROGRAMA,  " &
"    WAVEDETAIL.WAVEKEY                   ONDA,  " &
"    CAGEID.CLOSEDATE                     DT_FECHA_GAIOLA," &
"    ORDERS.ACTUALSHIPDATE                DT_LIQUIDADO,  " &
"    ORDERS.CARRIERCODE                   ID_TRANSP,  " &
"    ORDERS.CARRIERNAME                   NOME_TRANSP,  " &
"  " &
"    ( select o.T$COCT$C  " &
"        from BAANDB.TZNFMD640301@pln01 o  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and rownum = 1 )  " &
"                                         OCORRENCIA,  " &
"  " &
"    ( select c.t$dsci$c  " &
"        from BAANDB.TZNFMD640301@pln01 o,  " &
"             BAANDB.TZNFMD030301@pln01 c  " &
"       where o.T$date$c = ( select max(o1.T$date$c)  " &
"                              from BAANDB.TZNFMD640301@pln01 o1  " &
"                             where o1.T$ETIQ$C = o.T$ETIQ$C)  " &
"                               and o.T$ETIQ$C = znfmd630.T$ETIQ$C  " &
"                               and c.t$ocin$c = o.T$COCI$C  " &
"                               and rownum = 1)  " &
"                                         NOME_OCOR,  " &
"  " &
"    ORDERSTATUSSETUP.DESCRIPTION         ULT_EVENTO,  " &
"    ORDERS.SCHEDULEDDELVDATE             DT_ENTREGA1,  " &
"    ORDERS.INVOICENUMBER                 NR_NF,  " &
"    ORDERS.LANE                          SERIE_NF,  " &
"    znsls400.t$idli$c                    ID_LISTA_CASAMENTO,  " &
"    znsls400.t$emaf$c                    EMAIL_CLIENTE,  " &
"    ORDERDETAIL.UOM                      UNIMEDIDA,  " &
"    whwmd400.t$hght                      ALTURA,  " &
"    whwmd400.t$wdth                      LARGURA,  " &
"    whwmd400.t$dpth                      COMPRIMENTO,  " &
"    SKU.STDNETWGT                        PESO_UNITARIO,  " &
"    SKU.STDGROSSWGT                      PESO_BRUTO,  " &
"    ORDERDETAIL.ORIGINALQTY              QUANTIDADE,  " &
"    znsls401.t$vlun$c                    VALOR_ITEM,  " &
"    znfmd630.t$ncar$c                    CARGA,  " &
"    tdsls400.t$fdty$l                    OPERACAO,  " &
"    OPERACAO.                            DESC_OPERACAO " &
"  " &
"FROM       WMWHSE7.ORDERS  " &
"  " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401  " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
" LEFT JOIN BAANDB.TZNSLS400301@pln01 znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"INNER JOIN BAANDB.ttdsls400301@pln01 tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630  " &
"        ON znfmd630.t$orno$c = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN WMWHSE7.CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE7.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN WMWHSE7.ORDERDETAIL  " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE7.TASKDETAIL  TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"       AND TASKDETAIL.TASKTYPE = 'PK'  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN  " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID  " &
"  " &
" LEFT JOIN WMWHSE7.taskmanageruser tu  " &
"        ON tu.userkey = TASKDETAIL.EDITWHO  " &
"  " &
" LEFT JOIN WMWHSE7.WAVEDETAIL  WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS  " &
"  " &
" LEFT JOIN WMWHSE7.SKU  " &
"        ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400  " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)  " &
"  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  " &
"        ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP) " &
"  " &
" LEFT JOIN ( SELECT d.t$cnst CODE_OPERACAO,  " &
"                    l.t$desc DESC_OPERACAO  " &
"               FROM baandb.tttadv401000@pln01 d,  " &
"                    baandb.tttadv140000@pln01 l  " &
"              WHERE d.t$cpac = 'ci'  " &
"                AND d.t$cdom = 'sli.tdff.l'  " &
"                AND l.t$clan = 'p'  " &
"                AND l.t$cpac = 'ci'  " &
"                AND l.t$clab = d.t$za_clab  " &
"                AND rpad(d.t$vers,4) || '|' ||  " &
"                    rpad(d.t$rele,2) || '|' ||  " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv401000@pln01 l1  " &
"                                          where l1.t$cpac = d.t$cpac  " &
"                                            and l1.t$cdom = d.t$cdom )  " &
"                AND rpad(l.t$vers,4) || '|' ||  " &
"                    rpad(l.t$rele,2) || '|' ||  " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||  " &
"                                                    rpad(l1.t$rele,2) || '|' ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                           from baandb.tttadv140000@pln01 l1  " &
"                                          where l1.t$clab = l.t$clab  " &
"                                            and l1.t$clan = l.t$clan  " &
"                                            and l1.t$cpac = l.t$cpac ) ) OPERACAO  " &
"        ON tdsls400.t$fdty$l = OPERACAO.CODE_OPERACAO  " &
"  " &
"WHERE Trunc(ORDERS.ADDDATE)  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND tdsls400.t$fdty$l IN (" + JOIN(Parameters!Operacao.Value, ", ") + ")  "  &
"  " &
"ORDER BY PLANTA  "

)