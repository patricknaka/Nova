SELECT znfmd630.t$fili$c             FILIAL,
       NVL(tcmcs031.t$dsca,
           'Pedido Interno')         MARCA,
       own_mis.filtro_mis(znsls400.t$nomf$c) NOME_DESTINATARIO,
       znfmd640_ETR.DATA_OCORRENCIA  DATA_EXPEDICAO,
       znfmd630.t$docn$c             NUME_NOTA,
       znfmd630.t$seri$c             NUME_SERIE,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_EMISSAO_NF,
       tdsls400.t$orno               ORDEM_VENDA,
       cisli940.t$fdty$l             NUME_TIPO_DOCUMENTO,
       FGET.                         DESC_TIPO_DOCUMENTO,
       znsls401.t$pecl$c             NUME_PEDIDO,
       znfmd630.t$pecl$c             NUME_ENTREGA,
       znfmd630.t$qvol$c             QTDE_VOLUMES,
       znsls401.t$itpe$c             NUME_TIPO_ENTREGA_NOME,
       znsls002.t$dsca$c             DESC_TIPO_ENTREGA_NOME,
       znfmd610.t$wght$c             PESO,
       znfmd610.t$cube$c             ITEM_CUBAGEM,
       znfmd630.t$vlmr$c             ITEM_VALOR,
       znfmd630.t$vlfc$c             FRETE_GTE,
       cisli940.t$fght$l             FRETE_NF,
       znsls401.t$vlfr$c             FRETE_SITE,
       cisli940.t$amnt$l             VLR_TOTAL_NF,
       cisli940.t$lipl$l             PLACA,
       tccom130t.t$dsca              TRANSP_NOME,
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
       znsls400.t$idca$c             CANAL_VENDA,
       CASE WHEN znfmd630.t$stat$c = 2
              THEN 'Fechado'
            ELSE   'Aberto'
        END                          SITUACAO_ENTREGA,
       znfmd067.t$fate$c             FILIAL_TRANSPORTADORA,
       cisli940.t$styp$l             TIPO_VENDA,
       CASE WHEN regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') IS NULL
              THEN '00000000000000'
            WHEN LENGTH(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
              THEN '00000000000000'
            ELSE regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')
       END                           CNPJ_TRANSPORTADORA,

       ( select znfmd061.t$dzon$c
           from baandb.tznfmd062301 znfmd062,
                baandb.tznfmd061301 znfmd061
          where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c
            and znfmd062.t$cono$c = znfmd630.t$cono$c
            and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
            and znfmd061.t$cono$c = znfmd062.t$cono$c
            and znfmd061.t$creg$c = znfmd062.t$creg$c
            and tccom130.t$pstc between znfmd062.t$cepd$c
                                    and znfmd062.t$cepa$c
            and rownum = 1 )REGIAO,
       CASE WHEN ZNSLS401.T$IDPA$C = '1'
              THEN 'Manhã'
            WHEN ZNSLS401.T$IDPA$C = '2'
              THEN 'Tarde'
            WHEN ZNSLS401.T$IDPA$C = '3'
              THEN 'Noite'
            ELSE ''
       END                           PERIODO,

       tdsls401.t$prdt               DATA_PROMETIDA,

       CASE WHEN TRUNC(znfmd630.t$dtco$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
              Then null
            Else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'),
                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
       END                           DATA_CORRIGIDA,
       znfmd640.t$coci$c             ULTIMA_OCORRENCIA,
       znfmd640.t$desc$c             OCORRENCIA,
       znfmd640.t$date$c             DATA_OCORRENCIA,
       znsls401.t$pztr$c             PRAZO_ENTREGA,
       
       nvl( ( select sum(cisli941.t$dqua$l)
                from baandb.tcisli941301 cisli941
               where cisli941.t$fire$l = cisli940.t$fire$l
                 and cisli941.t$item$l not in ( select a.t$itjl$c
                                                  from baandb.tznsls000301 a
                                                 where a.t$indt$c = ( select min(b.t$indt$c)
                                                                        from baandb.tznsls000301 b )
                                             UNION ALL
                                                select a.t$itmd$c
                                                  from baandb.tznsls000301 a
                                                 where a.t$indt$c = ( select min(b.t$indt$c)
                                                                        from baandb.tznsls000301 b )
                                             UNION ALL
                                                select a.t$itmf$c
                                                 from baandb.tznsls000301 a
                                                 where a.t$indt$c = ( select min(b.t$indt$c)
                                                                        from baandb.tznsls000301 b ) ) ), 0 )
                                     QTDE_FATURADA,
       znfmd610.t$qvol$c             QTDE_ITEM,
       znsls401.t$qtve$c             QTDE_PEDIDO,
       own_mis.filtro_mis(znsls401.t$obet$c) ETIQUETA_TRANSPORTADORA,

       znsls401.t$pzcd$c             PRAZO_CD,
       tdsls401.t$ddta               DATA_LIMITE_EXPEDICAO,

       tdsls401.t$odat               DATA_COMPRA,

       CASE WHEN TRUNC(znsls401.t$dtap$c) = '01/01/1970'
              THEN NULL
            ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtap$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
       END                           DATA_APROVACAO_PAGTO,

       znfmd630.t$cono$c             COD_CONTRATO,
       znfmd060.t$cdes$c             DESC_CONTRATO,
       znfmd060.t$refe$c             ID_EXT_CONTRATO,

       CASE WHEN TRUNC(znfmd630.t$dtpe$c) = '01/01/1970'
              THEN NULL
            ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
       END                           DATA_PREVISTA_ENTREGA,

       znfmd630.t$ncar$c             NRO_CARGA,
       znfmd630.t$etiq$c             ETIQUETA,
       CRIACAO_WMS.DATA_OCORRENCIA   DATA_WMS

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
                    a1.t$orno$c
               from baandb.tznsls004301 a1
           group by a1.t$ncia$c,
                    a1.t$uneg$c,
                    a1.t$pecl$c,
                    a1.t$sqpd$c,
                    a1.t$entr$c,
                    a1.t$orno$c ) znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c

 LEFT JOIN ( select e.t$ncia$c,
                    e.t$uneg$c,
                    e.t$pecl$c,
                    e.t$sqpd$c,
                    e.t$entr$c,
                    e.t$orno$c,
                    e.t$itpe$c,
                    e.t$obet$c,
                    e.t$pztr$c,
                    e.t$pzcd$c,
                    e.t$dtap$c,
                    e.t$cepe$c,
                    e.t$cide$c,
                    e.t$ufen$c,
                    min(e.t$dtep$c) t$dtep$c,
                    sum(e.t$vlun$c) t$vlun$c,
                    sum(e.t$vlfr$c) t$vlfr$c,
                    min(e.t$idpa$c) t$idpa$c,
                    min(e.t$dtre$c) t$dtre$c,
                    min(e.t$pzfo$c) t$pzfo$c,
                    sum(e.t$qtve$c) t$qtve$c
               from baandb.tznsls401301 e
              where e.t$iitm$c = 'P'
           group by e.t$ncia$c,
                    e.t$uneg$c,
                    e.t$pecl$c,
                    e.t$sqpd$c,
                    e.t$entr$c,
                    e.t$orno$c,
                    e.t$itpe$c,
                    e.t$obet$c,
                    e.t$pztr$c,
                    e.t$pzcd$c,
                    e.t$dtap$c,
                    e.t$cepe$c,
                    e.t$cide$c,
                    e.t$ufen$c ) znsls401
        ON znsls401.t$ncia$c = znsls004.t$ncia$c
       AND znsls401.t$uneg$c = znsls004.t$uneg$c
       AND znsls401.t$pecl$c = znsls004.t$pecl$c
       AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
       AND znsls401.t$entr$c = znsls004.t$entr$c

 LEFT JOIN baandb.ttdsls400301  tdsls400
        ON tdsls400.t$orno = znsls401.t$orno$c

 LEFT JOIN ( select CASE WHEN Trunc(Max(tdsls401.t$prdt)) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                           THEN NULL
                         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tdsls401.t$prdt), 'DD-MON-YYYY HH24:MI:SS'),
                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                    END                                                t$prdt,
                    
                    CASE WHEN Trunc(Max(tdsls401.t$ddta)) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                           THEN NULL
                         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tdsls401.t$ddta), 'DD-MON-YYYY HH24:MI:SS'),
                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                    END                                                t$ddta,
                    
                    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tdsls401.t$odat),
                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                            AT time zone 'America/Sao_Paulo') AS DATE) t$odat,
                    tdsls401.t$orno
               from baandb.ttdsls401301  tdsls401
           group by tdsls401.t$orno ) tdsls401
        ON tdsls401.t$orno = tdsls400.t$orno

 LEFT JOIN baandb.ttccom130301  tccom130
        ON tccom130.t$cadr = tdsls400.t$stad

 LEFT JOIN baandb.tznsls400301  znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.T$UNEG$c
       AND znsls400.t$pecl$c = znsls401.T$pecl$c
       AND znsls400.t$sqpd$c = znsls401.T$sqpd$c

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
		
 LEFT JOIN ( select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    znmcs002.t$desc$c,
                    max(znfmd640.t$coci$c) t$coci$c,
                    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$date$c),
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE)  t$date$c
               from baandb.tznfmd640301 znfmd640
         inner join baandb.tznmcs002301 znmcs002
                 on znmcs002.t$poco$c = znfmd640.t$coci$c
              where (znfmd640.t$date$c, znfmd640.t$udat$c) = ( select max(oc.t$date$c) t$date$c, 
                                                                      max(oc.t$udat$c)  KEEP (DENSE_RANK LAST ORDER BY oc.t$date$c ) t$udat$c
                                                                 from baandb.tznfmd640301 oc
                                                                where oc.t$fili$c = znfmd640.t$fili$c
                                                                  and oc.t$etiq$c = znfmd640.t$etiq$c )
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    znmcs002.t$desc$c ) znfmd640 
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c

 LEFT JOIN ( select znsls410.t$poco$c      CODE_OCORRENCIA
                  , CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znsls410.t$dtoc$c),
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE) DATA_OCORRENCIA
                  , znsls410.t$ncia$c
                  , znsls410.t$uneg$c
                  , znsls410.t$pecl$c
                  , znsls410.t$sqpd$c
                  , znsls410.t$entr$c
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'WMS'
           group by znsls410.t$poco$c
                  , znsls410.t$ncia$c
                  , znsls410.t$uneg$c
                  , znsls410.t$pecl$c
                  , znsls410.t$sqpd$c
                  , znsls410.t$entr$c ) CRIACAO_WMS
        ON CRIACAO_WMS.t$ncia$c = znsls004.t$ncia$c
       AND CRIACAO_WMS.t$uneg$c = znsls004.t$uneg$c
       AND CRIACAO_WMS.t$pecl$c = znsls004.t$pecl$c
       AND CRIACAO_WMS.t$sqpd$c = znsls004.t$sqpd$c
       AND CRIACAO_WMS.t$entr$c = znsls004.t$entr$c

 LEFT JOIN baandb.tznfmd610301  znfmd610
        ON znfmd610.t$fili$c = znfmd630.t$fili$c
       AND znfmd610.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd610.t$ngai$c = znfmd630.t$ngai$c
       AND znfmd610.t$etiq$c = znfmd630.t$etiq$c

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

     WHERE cisli940.t$fdty$l != 14
     
       AND Trunc(znfmd640_ETR.DATA_OCORRENCIA)
           BETWEEN :DtExpIni
               AND :DtExpFim
       AND NVL(znsls401.t$itpe$c, 16) IN (:TipoEntrega)
       AND ((:Transportadora = 'T') or (znfmd630.t$cfrw$c = :Transportadora))
       
ORDER BY FILIAL, NUME_ENTREGA