select Q1.*
  from ( SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE1.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
         
FROM       WMWHSE1.ORDERS a
         
INNER JOIN WMWHSE1.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE1.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE1.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'
             
 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE1.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE1.CAGEID cg, 
                    WMWHSE1.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c, 
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c

INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE1.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE1.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE1.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE1.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE1.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null

  
UNION 

SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE2.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
         
FROM       WMWHSE2.ORDERS a
         
INNER JOIN WMWHSE2.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE2.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE2.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'
           
 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE2.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE2.CAGEID cg, 
                    WMWHSE2.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c, 
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c
             
INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE2.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE2.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE2.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE2.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE2.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null

  
UNION 
  
SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE3.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
     
FROM       WMWHSE3.ORDERS a
         
INNER JOIN WMWHSE3.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE3.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE3.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE3.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE3.CAGEID cg, 
                    WMWHSE3.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c
             
INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE3.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE3.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE3.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE3.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE3.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null

	   
UNION 

SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE4.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
         
FROM       WMWHSE4.ORDERS a
         
INNER JOIN WMWHSE4.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE4.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE4.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE4.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE4.CAGEID cg, 
                    WMWHSE4.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c, 
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c
             
INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE4.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE4.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE4.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE4.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE4.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null
	   
UNION 

SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE5.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
         
FROM       WMWHSE5.ORDERS a
         
INNER JOIN WMWHSE5.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE5.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE5.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE5.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE5.CAGEID cg, 
                    WMWHSE5.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c
             
INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE5.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE5.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE5.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE5.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE5.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null
	   
UNION 

SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE6.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
         
FROM       WMWHSE6.ORDERS a
         
INNER JOIN WMWHSE6.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE6.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE6.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE6.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE6.CAGEID cg, 
                    WMWHSE6.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c
             
INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE6.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE6.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE6.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE6.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE6.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null
	   
UNION 

SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE7.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
         
FROM       WMWHSE7.ORDERS a
         
INNER JOIN WMWHSE7.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE7.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE7.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE7.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE7.CAGEID cg, 
                    WMWHSE7.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c
             
INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE7.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE7.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE7.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE7.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE7.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null

UNION     --JUNDIAI

SELECT 
      schm.UDF2                       PLANTA,
      znsls401.t$entr$c               ENTREGA,
      a.referencedocument             NRO_ORDEM_DE_VENDA,
      a.orderkey                      PEDIDO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.SCHEDULEDSHIPDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  
                                       LIMITE_EXPEDICAO,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN 'Estorno'
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN 'Expedicao_concluida'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN 'Entregue_Doca'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN 'Inicio_Picking'
            ELSE   'Picking_Completo'
        END                            ULTIMO_EVENTO,
        
      sq2.loc                          DOCA_SAIDA,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
              CASE WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
                     THEN a.editdate
                   WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' THEN
                     sq2.closedate
                   WHEN sq2.status = 5 and a.status >  = '55' THEN
                     sq2.editdate
                   WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' THEN
                     sq2.adddate
                   WHEN a.INVOICESTATUS = '1' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '3' and a.status >  = '55' THEN
                     a.editdate
                   WHEN a.INVOICESTATUS = '4' and a.status >  = '55' THEN
                     a.editdate
                   ELSE NVL( ( SELECT MIN(h.adddate)
                                 FROM WMWHSE8.ORDERSTATUSHISTORY h
                                WHERE h.orderkey = a.orderkey
                                  AND h.status = a.status ), a.editdate ) 
               END, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone 'America/Sao_Paulo') AS DATE)        
                                       DATA_ULTIMO_EVENTO,                                       
 

      a.EDITWHO                        ULTIMO_USUARIO_OPERADOR,
      sq2.CAGEID                       GAIOLA,
      znfmd630.t$cfrw$c                TRANSPORTADOR,
       a.carriername                    TRANSPORTADOR_NOME,
       a.C_VAT                          MEGA_ROTA,
       ( select sa.t$dsca$c 
           from BAANDB.TZNSLS002301@pln01 sa
          where sa.t$tpen$c = NVL(Trim(znsls401.t$itpe$c), 16) ) 
                                        TIPO_ENTREGA,                                        
       od.ORIGINALQTY                   ITEM_QUANTIDADE,
       OX.NOTES1                       ETIQUETA,      
       NVL(Trim(znsls401.t$itpe$c), 16)tipo_entrega_nome,              
       a.carriercode                   transp_cod,
       a.c_address1                    destinatario_nome,
       a.whseid                        cd_filial,
       znfmd630.t$wght$c               peso_tarifado,
       CASE WHEN (a.status = '02' or a.status = '09' or a.status = '04' or a.status = '00') and w.wavekey is null 
              THEN '10'
            WHEN (a.INVOICESTATUS = '2' and a.status >  = '55') or a.status = '100' 
              THEN '41' 
            WHEN (a.status >  = '95' or sq2.status = 6) 
              THEN '39'
            WHEN (sq2.status = 3 or sq2.status = 4) and a.status >  = '55' 
              THEN '32'
            WHEN sq2.status = 5 and a.status >  = '55' 
              THEN '34'
            WHEN sq2.orderid IS NOT NULL and sq2.status = 2 and a.status >  = '55' 
              THEN '31'
            WHEN a.INVOICESTATUS = '1' and a.status >  = '55' 
              THEN '20'
            WHEN a.INVOICESTATUS = '3' and a.status >  = '55' 
              THEN '22'
            WHEN a.INVOICESTATUS = '4' and a.status >  = '55' 
              THEN '28'
            WHEN (a.status< = '22') and w.wavekey is not null 
              THEN '12'
            WHEN (a.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
              THEN '14'
            WHEN (a.status = '29' and (sq1.InPicking > 0 or sq1.PartPicked > 0)) 
              THEN '16'
            ELSE   '18'
        END                            evento_cod
          
FROM       WMWHSE8.ORDERS a
         
INNER JOIN WMWHSE8.ORDERDETAIL od 
        ON od.orderkey = a.orderkey
   
INNER JOIN WMWHSE8.sku sku 
        ON od.sku = sku.sku
    
 LEFT JOIN WMWHSE8.OrderDetailXvas OX
        ON  OX.ORDERKEY = od.ORDERKEY
       AND OX.ORDERLINENUMBER = od.ORDERLINENUMBER 
       AND OX.UDF1 = 'SHIPPINGID'

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON ltrim(rtrim(whwmd400.t$item)) = sku.sku
           
 LEFT JOIN ( select wv.orderkey,
                    max(wv.wavekey) wavekey
               from WMWHSE8.wavedetail wv
           group by wv.orderkey ) w
        ON w.orderkey = a.orderkey
           
 INNER JOIN ( select distinct 
                    cd.orderid, 
                    cg.CAGEID,
                    cg.loc,
                    max(cg.status) status,
                    max(cg.closedate) closedate,
                    max(cd.adddate) adddate,
                    max(cg.editdate) editdate
               from WMWHSE8.CAGEID cg, 
                    WMWHSE8.CAGEIDDETAIL cd 
              where cd.CAGEID = cg.CAGEID 
           group by cd.orderid, 
                    cg.CAGEID,
                    cg.loc ) sq2 
        ON sq2.orderid = a.orderkey
           
 LEFT JOIN BAANDB.TZNFMD630301@pln01 znfmd630 
        ON  znfmd630.t$orno$c = a.REFERENCEDOCUMENT
       AND znfmd630.t$ngai$c = sq2.cageid
 
 LEFT JOIN ( select 
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c, 
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c,
                    sum(sq401.t$vlun$c * sq401.t$qtve$c) t$vlun$c,
                    max(sq401.t$dtep$c) t$dtep$c
               from BAANDB.TZNSLS401301@pln01 sq401,
                    baandb.tznsls004301@pln01 znsls004
              where sq401.t$ncia$c = znsls004.t$ncia$c
                and sq401.t$uneg$c = znsls004.t$uneg$c
                and sq401.t$pecl$c = znsls004.t$pecl$c
                and sq401.t$sqpd$c = znsls004.t$sqpd$c
                and sq401.t$entr$c = znsls004.t$entr$c
                and sq401.t$sequ$c = znsls004.t$sequ$c 
           group by
                    znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c, 
                    znsls004.t$orno$c,
                    sq401.t$itpe$c,
                    sq401.t$obet$c,
                    sq401.t$idpa$c) znsls401  
        ON znsls401.t$orno$c = a.referencedocument

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$poco$c
            from  baandb.tznsls410301@pln01 a
            where a.t$poco$c = 'ETR' ) znsls410
      ON znsls410.t$ncia$c = znsls401.t$ncia$c
     AND znsls410.t$uneg$c = znsls401.t$uneg$c
     AND znsls410.t$pecl$c = znsls401.t$pecl$c
     AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
     AND znsls410.t$entr$c = znsls401.t$entr$c
             
INNER JOIN enterprise.codelkup schm
        ON UPPER(schm.UDF1) = a.whseid
              
INNER JOIN ( SELECT o1.orderkey, 
                  ( select count(*) 
                      from WMWHSE8.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '29' ) Released, 
                  ( select count(*) 
                      from WMWHSE8.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '51' ) InPicking, 
                  ( select count(*) 
                      from WMWHSE8.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '52' ) PartPicked, 
                  ( select count(*) 
                      from WMWHSE8.orderdetail od1 
                     where od1.orderkey = o1.orderkey 
                       and od1.status = '55' ) PickedComplete 
               FROM WMWHSE8.orders o1 ) sq1
        ON sq1.orderkey = a.orderkey
              
WHERE schm.listname = 'SCHEMA' 
--  AND a.status NOT IN ('98', '99')
and (a.status >  = '95' or sq2.status = 6)          --expedição concluída
  AND CASE WHEN a.FISCALDECISION like 'CANCELADO%' 
             THEN 1
           ELSE 0 
       END = 0
and znsls410.t$poco$c is null

 ) Q1

WHERE Q1.DATA_ULTIMO_EVENTO between :DataUltDe and :DataUltAte
  and Q1.evento_cod                  IN (:Evento)         -- Evento
  AND Q1.tipo_entrega_nome           IN (:TipoEntrega)    -- Tipo de Entrega
  and Q1.cd_filial                   IN (:Filial)         -- Planta
  AND NVL(Trim(Q1.mega_rota), 'SMR') IN (:Rota)           -- Mega Rota
  AND Q1.transp_cod                  IN (:Transportadora) -- Transportadora
