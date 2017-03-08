SELECT 
       znfmd630.t$fili$c             FILIAL,
       NVL(tcmcs031.t$dsca,
           'Pedido Interno')         MARCA,
       cast(replace(replace(own_mis.filtro_mis(znsls400.t$nomf$c ),';',''),'"','')   as varchar(100))
                                     NOME_DESTINATARIO,
       znfmd640_ETR.DATA_OCORRENCIA  DATA_EXPEDICAO,
       znfmd630.t$docn$c             NUME_NOTA,
       znfmd630.t$seri$c             NUME_SERIE,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_EMISSAO_NF,
       cisli940.t$fdty$l             NUME_TIPO_DOCUMENTO,
       FGET.                         DESC_TIPO_DOCUMENTO,
       znsls401.t$pecl$c             NUME_PEDIDO,
       znfmd630.t$pecl$c             NUME_ENTREGA,
       znfmd630.t$qvol$c             QTDE_VOLUMES,
       znsls401.t$itpe$c             NUME_TIPO_ENTREGA_NOME,
       znsls002.t$dsca$c             DESC_TIPO_ENTREGA_NOME,
       znsls401.t$itml$c             ITEM,
       cast(replace(replace(own_mis.filtro_mis(tcibd001.t$dscb$c),';',''),'"','')   as varchar(100))
                                     DESCRICAO_ITEM,
       tcmcs023.t$dsca               DEPTO,
       (znsls401.t$qtve$c * tcibd001.t$wght)  
                                     PESO_REAL_ITEM,
       znfmd630.t$wght$c             PESO_REAL_TOTAL,
      (whwmd400.t$dpth * whwmd400.t$wdth * whwmd400.t$hght * znfmd061.t$cuba$c)
                                     PESO_CUBADO_ITEM,
       (whwmd400.t$dpth * whwmd400.t$wdth * whwmd400.t$hght)
                                     VOLUME_ITEM,
       znfmd061.t$cuba$c             FATOR_CUBAGEM,
       cisli941.t$gamt$l             ITEM_VALOR,
       znfmd630.t$vlfc$c             FRETE_GTE,
       znsls401.t$vlfr$c             FRETE_SITE,
       cisli941.t$amnt$l             VLR_TOTAL_ITEM,
       cast(replace(replace(own_mis.filtro_mis(tccom130t.t$dsca),';',''),'"','')   as varchar(100))
                                     TRANSP_NOME,
       znsls401.t$cepe$c             CEP,
       znsls401.t$cide$c             CIDADE,
       znsls401.t$ufen$c             UF,
       ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640_ENT.t$date$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
           from BAANDB.tznfmd640301 znfmd640_ENT
          where znfmd640_ENT.t$fili$c = znfmd630.t$fili$c
            and znfmd640_ENT.t$etiq$c = znfmd630.t$etiq$c
            and znfmd640_ENT.t$coci$c = 'ENT'
            and ROWNUM = 1 )         DATA_ENTREGA,

       znfmd067.t$fate$c             FILIAL_TRANSPORTADORA,
       CASE WHEN regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') IS NULL
              THEN '00000000000000'
            WHEN LENGTH(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
              THEN '00000000000000'
            ELSE regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')
       END                           CNPJ_TRANSPORTADORA,

       CASE WHEN TRUNC(znfmd630.t$dtco$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
              Then null
            Else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'),
                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
       END                           DATA_CORRIGIDA,

       znsls401.t$pztr$c             PRAZO_ENTREGA,
       cisli941.t$dqua$l             QTDE_FATURADA,
       znsls401.t$qtve$c             QTDE_PEDIDO_ITEM,

       znsls401.t$pzcd$c             PRAZO_CD,
       
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'),
                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)

                                     DATA_COMPRA,

       znfmd630.t$cono$c             COD_CONTRATO,
       cast(replace(replace(own_mis.filtro_mis(znfmd060.t$cdes$c),';',''),'"','')   as varchar(100))
                                     DESC_CONTRATO,
       cast(replace(replace(own_mis.filtro_mis(znfmd060.t$refe$c),';',''),'"','')   as varchar(100))
                                     ID_EXT_CONTRATO,

       CASE WHEN TRUNC(znfmd630.t$dtpe$c) = '01/01/1970'
              THEN NULL
            ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
       END                           DATA_PREVISTA_ENTREGA,
       
           (select b.t$desc$c                          
            from  baandb.tznsls402301 a,
                  baandb.tzncmg007301 b
            where a.t$ncia$c = znsls400.t$ncia$c
              and a.t$uneg$c = znsls400.t$uneg$c
              and a.t$pecl$c = znsls400.t$pecl$c
              and a.t$sqpd$c = znsls400.t$sqpd$c
              and a.t$sequ$c = 1
              and b.t$mpgt$c = a.t$idmp$c)
                                      MEIO_PAGTO,
      znsls400.t$vlfr$c                                           FRETE_SITE_TOTAL,
      (cisli941.t$gamt$l - cisli941.t$tldm$l - cisli943.TOTAL)    RECEITA_LIQUIDA,
      znfmd637.t$amnt$c                                           VALOR_ICMS_FRETE

FROM       ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640_ETR.t$udat$c),
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE)                                    DATA_OCORRENCIA,
                    Max(znfmd640_ETR.t$etiq$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640_ETR.t$udat$c ) t$etiq$c,
                    znfmd630.t$pecl$c,
                    znfmd640_ETR.t$fili$c
               from BAANDB.tznfmd640301 znfmd640_ETR
         inner join baandb.tznfmd630301 znfmd630
                 on znfmd640_ETR.t$fili$c = znfmd630.t$fili$c
                and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c
              where znfmd640_ETR.t$coct$c = 'ETR'
                and znfmd640_ETR.T$TORG$C = 1
           group by znfmd630.t$pecl$c,
                    znfmd640_ETR.t$fili$c ) znfmd640_ETR

INNER JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fili$c = znfmd640_ETR.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_ETR.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_ETR.t$pecl$c

INNER JOIN ( select a1.t$ncia$c,
                    a1.t$uneg$c,
                    a1.t$pecl$c,
                    a1.t$sqpd$c,
                    a1.t$entr$c,
                    a1.t$sequ$c,
                    a1.t$orno$c
               from baandb.tznsls004301 a1
           group by a1.t$ncia$c,
                    a1.t$uneg$c,
                    a1.t$pecl$c,
                    a1.t$sqpd$c,
                    a1.t$entr$c,
                    a1.t$sequ$c,
                    a1.t$orno$c ) znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c

 LEFT JOIN baandb.tznsls400301  znsls400
        ON znsls400.t$ncia$c = znsls004.t$ncia$c
       AND znsls400.t$uneg$c = znsls004.T$UNEG$c
       AND znsls400.t$pecl$c = znsls004.T$pecl$c
       AND znsls400.t$sqpd$c = znsls004.T$sqpd$c

LEFT JOIN baandb.tznsls401301 znsls401
       ON znsls401.t$ncia$c = znsls004.t$ncia$c
      AND znsls401.t$uneg$c = znsls004.t$uneg$c
      AND znsls401.t$pecl$c = znsls004.t$pecl$c
      AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
      AND znsls401.t$entr$c = znsls004.t$entr$c
      AND znsls401.t$sequ$c = znsls004.t$sequ$c

 INNER JOIN ( select a.t$slso,
                     a.t$pono,
                     a.t$fire$l,
                     a.t$line$l
              from baandb.tcisli245301 a
              where a.t$ortp = 1
                and a.t$koor = 3
              group by a.t$slso,
                       a.t$pono,
                       a.t$fire$l,
                       a.t$line$l ) cisli245
         ON cisli245.t$slso = znsls401.t$orno$c
        AND cisli245.t$pono = znsls401.t$pono$c
      
INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$fire$l = cisli245.t$fire$l
       AND cisli941.t$line$l = cisli245.t$line$l

LEFT JOIN ( select  a.t$fire$l,
                    a.t$line$l,
                    sum(a.t$amnt$l) TOTAL
            from baandb.tcisli943301 a 
            where a.t$brty$l IN (1,5,6)    --ICMS, PIS, COFINS
            group by a.t$fire$l,
                     a.t$line$l ) cisli943
       ON cisli943.t$fire$l = cisli941.t$fire$l
      AND cisli943.t$line$l = cisli941.t$line$l

LEFT JOIN baandb.ttcibd001301 tcibd001
       ON tcibd001.t$item = znsls401.t$itml$c
       
LEFT JOIN baandb.ttcmcs023301 tcmcs023
       ON tcmcs023.t$citg = tcibd001.t$citg
       
LEFT JOIN baandb.twhwmd400301 whwmd400
       ON whwmd400.t$item = tcibd001.t$item

 LEFT JOIN baandb.ttdsls400301  tdsls400
        ON tdsls400.t$orno = znsls401.t$orno$c

 LEFT JOIN baandb.ttccom130301  tccom130
        ON tccom130.t$cadr = tdsls400.t$stad

 LEFT JOIN baandb.tznint002301  znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c

 LEFT JOIN baandb.ttcmcs031301  tcmcs031
        ON znint002.t$cbrn$c = tcmcs031.t$cbrn

 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = NVL(znsls401.t$itpe$c, 16)

 LEFT JOIN baandb.tznfmd067301  znfmd067
        ON znfmd067.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd067.t$cono$c = znfmd630.t$cono$c
       AND znfmd067.t$fili$c = znfmd630.t$fili$c

 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tccom130t
        ON tccom130t.t$cfrw = znfmd630.t$cfrw$c

 LEFT JOIN baandb.tcisli940301  cisli940
        ON cisli940.t$fire$l = znfmd630.t$fire$c

 LEFT JOIN ( SELECT d.t$cnst CODE_STAT,
                    l.t$desc DESC_TIPO_DOCUMENTO
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
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
                                           from baandb.tttadv401000 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) || '|' ||
                    rpad(l.t$rele,2) || '|' ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) FGET
        ON cisli940.t$fdty$l = FGET.CODE_STAT

 LEFT JOIN BAANDB.tznfmd060301 znfmd060
        ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd060.t$cono$c = znfmd630.t$cono$c
        
 LEFT JOIN baandb.tznsls000601 znsls000
        ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
  
 LEFT JOIN baandb.tznfmd637301 znfmd637
        ON znfmd637.t$txre$c = znfmd630.t$txre$c
       AND znfmd637.t$line$c = znfmd630.t$line$c
       AND znfmd637.t$brty$c = 1  --ICMS
       
 LEFT JOIN ( select a.t$cfrw$c,
                    a.t$cono$c,
                    a.t$cuba$c
              from baandb.tznfmd061301 a 
              group by  a.t$cfrw$c,
                        a.t$cono$c,
                        a.t$cuba$c ) znfmd061
        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd061.t$cono$c = znfmd630.t$cono$c
 
Where cisli940.t$fdty$l = 1     --Venda com pedido
  and Trunc(znfmd640_ETR.DATA_OCORRENCIA)
           BETWEEN :DtExpIni
               AND :DtExpFim
  AND NVL(znsls401.t$itpe$c, 16) IN (:TipoEntrega)
  AND ((:Transportadora = 'T') or (znfmd630.t$cfrw$c = :Transportadora))
       
ORDER BY FILIAL, NUME_ENTREGA
