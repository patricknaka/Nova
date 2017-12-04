--SELECT /*+ use_concat parallel(32) no_cpu_costing */ 
SELECT /*+ use_concat no_cpu_costing */ 
      distinct
       cast(znfmd630.t$fili$c as numeric(10,0))                           FILIAL,
       NVL(tcmcs031.t$dsca,
           'Pedido Interno')                                              MARCA,
       cast(replace(replace(own_mis.filtro_mis(znsls400.t$nomf$c),';',''),'"','')   as varchar(100)) 
                                                                          NOME_DESTINATARIO,
       znfmd640_ETR.DATA_OCORRENCIA                                       DATA_EXPEDICAO,
       znfmd630.t$docn$c                                                  NUME_NOTA,
       znfmd630.t$seri$c                                                  NUME_SERIE,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)
                                                                          DATA_EMISSAO_NF,
       cisli940.t$fdty$l                                                  NUME_TIPO_DOCUMENTO,
        ( SELECT l.t$desc
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
                                            and l1.t$cpac = l.t$cpac ) 
                AND d.t$cnst = cisli940.t$fdty$l )
                                                                          DESC_TIPO_DOCUMENTO,
       znsls401.t$pecl$c                                                  NUME_PEDIDO,
       znfmd630.t$pecl$c                                                  NUME_ENTREGA,
       znsls401.t$sequ$c,
       cast(znfmd630.t$qvol$c as numeric(15,0))                           QTDE_VOLUMES,
       znsls401.t$itpe$c                                                  NUME_TIPO_ENTREGA_NOME,
       znsls002.t$dsca$c                                                  DESC_TIPO_ENTREGA_NOME,
       cast(ltrim(rtrim(znsls401.t$itml$c)) as varchar(15)) as            ITEM,  
       cast(replace(replace(own_mis.filtro_mis(tcibd001.t$dscb$c ),';',''),'"','')   as varchar(100)) as            
                                                                          DESCRICAO_ITEM,
       tcmcs023.t$dsca                                                    DEPTO,
       cast( (abs(znsls401.t$qtve$c) * tcibd001.t$wght) as numeric(15,4)) PESO_REAL_ITEM,          
       znfmd630.t$wght$c                                                  PESO_REAL_TOTAL,
       cast((whwmd400.t$dpth * whwmd400.t$wdth * whwmd400.t$hght * NVL(NVL(znfmd061.t$cuba$c,znfmd061_2.t$cuba$c),znmcs080.t$cuba$c)) as numeric(15,4)) 
                                                                          PESO_CUBADO_ITEM,                                     
       cast((whwmd400.t$dpth * whwmd400.t$wdth * whwmd400.t$hght) as numeric(15,4))                   
                                                                          VOLUME_ITEM, 
       NVL(NVL(znfmd061.t$cuba$c,znfmd061_2.t$cuba$c),znmcs080.t$cuba$c)  FATOR_CUBAGEM,
       cisli941.t$gamt$l                                                  ITEM_VALOR,
       znfmd630.t$vlfc$c                                                  FRETE_CUSTO,
       znsls401.t$vlfr$c                                                  FRETE_SITE,
       cisli941.t$amnt$l                                                  VLR_TOTAL_ITEM,
       cast(replace(replace(own_mis.filtro_mis(tccom130t.t$dsca),';',''),'"','')   as varchar(100))   
                                                                          TRANSP_NOME,
       znsls401.t$cepe$c                                                  CEP,
       znsls401.t$cide$c                                                  CIDADE,
       znsls401.t$ufen$c                                                  UF,
       ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640_ENT.t$date$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
           from BAANDB.tznfmd640301 znfmd640_ENT
          where znfmd640_ENT.t$fili$c = znfmd630.t$fili$c
            and znfmd640_ENT.t$etiq$c = znfmd630.t$etiq$c
            and znfmd640_ENT.t$coci$c = 'ENT'
            and ROWNUM = 1 )                                              DATA_ENTREGA,

       znfmd067.t$fate$c                                                  FILIAL_TRANSPORTADORA,
       CASE WHEN regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') IS NULL
              THEN '00000000000000'
            WHEN LENGTH(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
              THEN '00000000000000'
            ELSE regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')
       END                                                                CNPJ_TRANSPORTADORA,

       CASE WHEN TRUNC(znfmd630.t$dtco$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
              Then null
            Else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'),
                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
       END                                                                DATA_CORRIGIDA,
       cast(znsls401.t$pztr$c as numeric(10,0))                           PRAZO_ENTREGA,
       cast(cisli941.t$dqua$l as numeric(10,0))                           QTDE_FATURADA,
       cast(abs(znsls401.t$qtve$c)  as numeric(10,0))                     QTDE_PEDIDO_ITEM,
       cast( znsls401.t$pzcd$c as numeric(10,0))                          PRAZO_CD,       
       
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'),
                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                                                          DATA_COMPRA,

       znfmd630.t$cono$c                                                  COD_CONTRATO,
       cast(replace(replace(own_mis.filtro_mis(znfmd060.t$cdes$c),';',''),'"','')   as varchar(100))  
                                                                          DESC_CONTRATO,
       cast(replace(replace(own_mis.filtro_mis(znfmd060.t$refe$c),';',''),'"','')   as varchar(100))  
                                                                          ID_EXT_CONTRATO,
       CASE WHEN TRUNC(znfmd630.t$dtpe$c) = '01/01/1970'
              THEN NULL
            ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
       END                                                                DATA_PREVISTA_ENTREGA,
       
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
      znsls400.t$vlfr$c                                                   FRETE_SITE_TOTAL,
      cast((cisli941.t$gamt$l - cisli941.t$tldm$l - cisli943.TOTAL) as numeric(20,4))    
                                                                          RECEITA_LIQUIDA,      
      znfmd637.t$amnt$c                                                   VALOR_ICMS_FRETE,
      znfmd637_PIS.t$amnt$c                                               VALOR_PIS_FRETE,
      znfmd637_COFINS.t$amnt$c                                            VALOR_COFINS_FRETE,
      znmcs030.t$dsca$c                                                   SETOR,
      znmcs031.t$dsca$c                                                   FAMILIA,
      znfmd630.t$orno$c                                                   ORDEM_VENDA,
      znsls410.PT_CONTR                                                   ULT_OCORR,
      znmcs002.t$desc$c                                                   DESC_ULT_OCORR,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_OCORR,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
                                                                          DATA_ULT_OCORR,
                                                                          
      Round(CMV.t$amnt$l,4)                                               VL_CMV,
--      ICMS.t$amnt$l                                                       VL_ICMS,
      Round(PIS.t$amnt$l,4)                                               VL_PIS,
      Round(COFINS.t$amnt$l,4)                                            VL_COFINS,
      Round(cisli941.t$ldam$l * cisli941.t$dqua$l,4)                      DESCONTO,
      GARANTIA.t$itml$c                                                   ITEM_GARANTIA,
      GARANTIA.t$vlun$c                                                   VALOR_GARANTIA,

      SEGURO.t$itml$c                                                     ITEM_SEGURO,
      SEGURO.t$vlun$c                                                     VALOR_SEGURO,
      
      ROUND(znsls492_1.t$trbd$c*100, 4)                                   TAXA_CARTAO_1,
      ROUND(znsls492_1.t$vltx$c, 4)                                       VALOR_TAXA_1,
      case when znsls492_2.t$sequ$c > znsls492_1.t$sequ$c then
          ROUND(znsls492_2.t$trbd$c*100, 4)
      else 0 end                                                          TAXA_CARTAO_2,
      case when znsls492_2.t$sequ$c > znsls492_1.t$sequ$c then
          ROUND(znsls492_2.t$vltx$c, 4)
      else 0 end                                                          VALOR_TAXA_2,      
      NFTC.t$docn$l                                                       NF_FATURA,
      NFTC.t$seri$l                                                       SERIE_FATURA,
      Round(ICMS.t$amnt$l,4)                                              VL_ICMS,
      Round(ICMS.t$vpbr$l,4)                                              VL_FUNDO_COMB_POBREZA,
      Round(ICMS.t$vest$l,4)                                              VL_ESTADO_DESTINO,
      Round(ICMS.t$oest$l,4)                                              VL_ESTADO_ORIGEM,
      Round(ICMS_ST.t$amnt$l,4)                                           VL_ICMS_ST,
      
      cisli940.t$fire$l                                                   REF_FISCAL
      
FROM       ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640_ETR.t$udat$c),
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE)        DATA_OCORRENCIA,
                    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd630.t$date$c),          --DATA EMISSAO NF
                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                          AT time zone 'America/Sao_Paulo') AS DATE))     DATA_FILTRO,
                    Max(znfmd640_ETR.t$etiq$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640_ETR.t$udat$c ) t$etiq$c,
                    znfmd630.t$pecl$c,
                    znfmd640_ETR.t$fili$c
               from BAANDB.tznfmd640301 znfmd640_ETR
                inner join baandb.tznfmd630301 znfmd630
                        on znfmd640_ETR.t$fili$c = znfmd630.t$fili$c
                       and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c
                       and znfmd630.t$torg$c = 1
                where znfmd640_ETR.t$coct$c = 'ETR'
                  and znfmd640_ETR.T$TORG$C = 1
--                and znfmd630.t$date$c between trunc(to_date(:data_ini)) and trunc(to_date(:data_fim))+1.99999
                  and znfmd630.t$pecl$c = '12294111303'
           group by znfmd630.t$pecl$c,
                    znfmd640_ETR.t$fili$c ) znfmd640_ETR

LEFT JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fili$c = znfmd640_ETR.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_ETR.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_ETR.t$pecl$c
       AND znfmd630.t$torg$c = 1

INNER JOIN baandb.tznsls004301 znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c

INNER JOIN baandb.tznsls000301 znsls000
        ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
        
INNER JOIN baandb.ttdsls401301 tdsls401
        ON tdsls401.t$orno = znsls004.t$orno$c
       AND tdsls401.t$pono = znsls004.t$pono$c
       AND tdsls401.t$item not in (znsls000.t$itmd$c, znsls000.t$itmf$c, znsls000.t$itjl$c)
       
LEFT JOIN baandb.tznsls400301  znsls400
       ON znsls400.t$ncia$c = znsls004.t$ncia$c
      AND znsls400.t$uneg$c = znsls004.T$UNEG$c
      AND znsls400.t$sqpd$c = znsls004.T$sqpd$c
      AND znsls400.t$pecl$c = znsls004.T$pecl$c

LEFT JOIN baandb.tznsls401301 znsls401
       ON znsls401.t$ncia$c = znsls004.t$ncia$c
      AND znsls401.t$uneg$c = znsls004.t$uneg$c
      AND znsls401.t$sequ$c = znsls004.t$sequ$c
      AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
      AND znsls401.t$pecl$c = znsls004.t$pecl$c
      AND znsls401.t$entr$c = znsls004.t$entr$c

INNER JOIN baandb.tcisli245301 cisli245
        ON cisli245.t$slcp = 301
       AND cisli245.t$oset = 0
       AND cisli245.t$ortp = 1
       AND cisli245.t$koor = 3
       AND cisli245.t$pono = tdsls401.t$pono
       AND cisli245.t$slso = tdsls401.t$orno
       
INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$line$l = cisli245.t$line$l
       AND cisli941.t$fire$l = cisli245.t$fire$l
       
LEFT JOIN baandb.tcisli940301  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c

LEFT JOIN ( select  a.t$fire$l,
                    a.t$line$l,
                    sum(a.t$amnt$l) TOTAL
            from baandb.tcisli943301 a 
            where a.t$brty$l IN (1,5,6)    --ICMS, PIS, COFINS
            group by a.t$fire$l,
                     a.t$line$l ) cisli943
      ON cisli943.t$line$l = cisli941.t$line$l
     AND cisli943.t$fire$l = cisli941.t$fire$l

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
        ON znfmd067.t$cfrw$c = cisli940.t$cfrw$l
       AND znfmd067.t$cono$c = znfmd630.t$cono$c
       AND znfmd067.t$fili$c = znfmd630.t$fili$c

 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tccom130t
        ON tccom130t.t$cfrw = cisli940.t$cfrw$l

 LEFT JOIN BAANDB.tznfmd060301 znfmd060
        ON znfmd060.t$cfrw$c = cisli940.t$cfrw$l      --A transportadora da ordem de frete pode nao ser a correta. SDP 1390455
       AND znfmd060.t$cono$c = znfmd630.t$cono$c
        
 LEFT JOIN baandb.tznfmd637301 znfmd637
        ON znfmd637.t$txre$c = znfmd630.t$txre$c
       AND znfmd637.t$line$c = znfmd630.t$line$c
       AND znfmd637.t$brty$c = 1  --ICMS
   
  LEFT JOIN baandb.tznfmd062301 znfmd062
         ON znsls401.t$cepe$c != 0
        AND znsls401.t$cepe$c between znfmd062.t$cepd$c and znfmd062.t$cepa$c
        AND znfmd062.t$cono$c = znfmd630.t$cono$c
        AND znfmd062.t$cfrw$c = cisli940.t$cfrw$l
   
  LEFT JOIN baandb.tznfmd061301 znfmd061
         ON znfmd061.t$creg$c = znfmd062.t$creg$c
        AND znfmd061.t$cono$c = znfmd630.t$cono$c
        AND znfmd061.t$cfrw$c = cisli940.t$cfrw$l
        AND znfmd061.t$cuba$c > 1

  LEFT JOIN ( select  a.t$cfrw$c,
                      a.t$cono$c,
                      max(a.t$cuba$c) t$cuba$c
              from baandb.tznfmd061301 a
              group by a.t$cfrw$c,
                       a.t$cono$c ) znfmd061_2
         ON znfmd061_2.t$cono$c = znfmd630.t$cono$c
        AND znfmd061_2.t$cfrw$c = cisli940.t$cfrw$l
 
  LEFT JOIN baandb.tznmcs080301 znmcs080
         ON znmcs080.t$cfrw$c = cisli940.t$cfrw$l
         
  LEFT JOIN baandb.tznfmd637301 znfmd637_PIS
        ON znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
       AND znfmd637_PIS.t$line$c = znfmd630.t$line$c
       AND znfmd637_PIS.t$brty$c = 5  --PIS
       
   LEFT JOIN baandb.tznfmd637301 znfmd637_COFINS
        ON znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
       AND znfmd637_COFINS.t$line$c = znfmd630.t$line$c
       AND znfmd637_COFINS.t$brty$c = 6  --COFINS
    
   LEFT JOIN baandb.tznmcs030301 znmcs030
          ON znmcs030.t$citg$c = tcibd001.t$citg
         AND znmcs030.t$seto$c = tcibd001.t$seto$c
         
   LEFT JOIN baandb.tznmcs031301 znmcs031
          ON znmcs031.t$citg$c = tcibd001.t$citg
         AND znmcs031.t$seto$c = tcibd001.t$seto$c
         AND znmcs031.t$fami$c = tcibd001.t$fami$c

  LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$dtoc$c) DATA_OCORR,
                    max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) PT_CONTR
               from baandb.tznsls410301 a
               group by a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls410.t$entr$c = znsls401.t$entr$c

  LEFT JOIN baandb.tznmcs002301 znmcs002
         ON znmcs002.t$poco$c = znsls410.PT_CONTR

  LEFT JOIN baandb.tcisli943301 ICMS
         ON ICMS.t$fire$l = cisli941.t$fire$l
        AND ICMS.t$line$l = cisli941.t$line$l
        AND ICMS.t$brty$l = 1

  LEFT JOIN baandb.tcisli943301 PIS
         ON PIS.t$fire$l = cisli941.t$fire$l
        AND PIS.t$line$l = cisli941.t$line$l
        AND PIS.t$brty$l = 5        

  LEFT JOIN baandb.tcisli943301 COFINS
         ON COFINS.t$fire$l = cisli941.t$fire$l
        AND COFINS.t$line$l = cisli941.t$line$l
        AND COFINS.t$brty$l = 6        

  LEFT JOIN ( select  a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$itml$c,
                      a.t$igar$c,
                      a.t$vlun$c
              from baandb.tznsls401301 a 
              inner join baandb.ttcibd001301 b
                      on b.t$item = a.t$itml$c
              inner join baandb.tznisa002301 c
                      on c.t$npcl$c = b.t$npcl$c       
              where c.t$nptp$c = 'G' ) GARANTIA
         ON GARANTIA.t$ncia$c = znsls401.t$ncia$c
        AND GARANTIA.t$uneg$c = znsls401.t$uneg$c
        AND GARANTIA.t$pecl$c = znsls401.t$pecl$c
        AND GARANTIA.t$sqpd$c = znsls401.t$sqpd$c
        AND GARANTIA.t$entr$c = znsls401.t$entr$c
        AND GARANTIA.t$igar$c = znsls401.t$itml$c

  LEFT JOIN ( select  a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$itml$c,
                      a.t$igar$c,
                      a.t$vlun$c
              from baandb.tznsls401301 a 
              inner join baandb.ttcibd001301 b
                      on b.t$item = a.t$itml$c
              inner join baandb.tznisa002301 c
                      on c.t$npcl$c = b.t$npcl$c       
              where c.t$nptp$c in ('H','Q') ) SEGURO
         ON SEGURO.t$ncia$c = znsls401.t$ncia$c
        AND SEGURO.t$uneg$c = znsls401.t$uneg$c
        AND SEGURO.t$pecl$c = znsls401.t$pecl$c
        AND SEGURO.t$sqpd$c = znsls401.t$sqpd$c
        AND SEGURO.t$entr$c = znsls401.t$entr$c
        AND SEGURO.t$igar$c = znsls401.t$itml$c

  LEFT JOIN ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$idmp$c,
                     min(a.t$sequ$c) t$sequ$c
              from baandb.tznsls402301 a 
              where a.t$idmp$c in (1,12,15)
              group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$idmp$c ) znsls402_1
         ON znsls402_1.t$ncia$c = znsls401.t$ncia$c
        AND znsls402_1.t$uneg$c = znsls401.t$uneg$c
        AND znsls402_1.t$pecl$c = znsls401.t$pecl$c
        AND znsls402_1.t$sqpd$c = znsls401.t$sqpd$c
            
  LEFT JOIN BAANDB.TZNSLS492301 znsls492_1
         ON znsls492_1.t$ncia$c = znsls402_1.t$ncia$c
        AND znsls492_1.t$uneg$c = znsls402_1.t$uneg$c
        AND znsls492_1.t$pecl$c = znsls402_1.t$pecl$c
        AND znsls492_1.t$sqpd$c = znsls402_1.t$sqpd$c
        AND znsls492_1.t$idmp$c = znsls402_1.t$idmp$c
        AND znsls492_1.t$sequ$c = znsls402_1.t$sequ$c
 
   LEFT JOIN ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$idmp$c,
                     max(a.t$sequ$c) t$sequ$c
              from baandb.tznsls402301 a 
              where a.t$idmp$c in (1,12,15)
              group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$idmp$c ) znsls402_2
         ON znsls402_2.t$ncia$c = znsls401.t$ncia$c
        AND znsls402_2.t$uneg$c = znsls401.t$uneg$c
        AND znsls402_2.t$pecl$c = znsls401.t$pecl$c
        AND znsls402_2.t$sqpd$c = znsls401.t$sqpd$c
            
  LEFT JOIN BAANDB.TZNSLS492301 znsls492_2
         ON znsls492_2.t$ncia$c = znsls402_2.t$ncia$c
        AND znsls492_2.t$uneg$c = znsls402_2.t$uneg$c
        AND znsls492_2.t$pecl$c = znsls402_2.t$pecl$c
        AND znsls492_2.t$sqpd$c = znsls402_2.t$sqpd$c
        AND znsls492_2.t$idmp$c = znsls402_2.t$idmp$c
        AND znsls492_2.t$sequ$c = znsls402_2.t$sequ$c
      
  LEFT JOIN ( select  a.t$orno,
                      a.t$pono,
                      sum(b.t$amnt$1) t$amnt$l
              from baandb.twhina114301 a, 
                   baandb.twhina115301 b
              where b.t$item = a.t$ITEM
                and b.T$CWAR = a.t$cwar
                and b.T$TRDT = a.t$TRDT
                and b.t$seqn = a.t$SEQN
                and b.T$INWP = a.t$INWP
                and b.T$SERN = a.t$SERN
                and a.t$koor = 3   --Ordem de Venda
             group by a.t$orno, a.t$pono ) CMV
        ON CMV.t$orno = tdsls401.t$orno
       AND CMV.t$pono = tdsls401.t$pono

  LEFT JOIN baandb.tcisli941301 NFTL     --Nota Fiscal Triangular - Linha
         ON NFTL.t$fire$l = cisli941.t$refr$l
        AND NFTL.t$line$l = cisli941.t$rfdl$l
        
  LEFT JOIN baandb.tcisli940301 NFTC    --Nota Fiscal Triangula - Capa
         ON NFTC.t$fire$l = NFTL.t$fire$l

  LEFT JOIN baandb.tcisli943301 ICMS_ST
         ON ICMS_ST.t$fire$l = cisli941.t$fire$l
        AND ICMS_ST.t$line$l = cisli941.t$line$l
        AND ICMS_ST.t$brty$l = 2
        
WHERE cisli940.t$fdty$l IN (1,15)     --Venda com pedido, Remessa Triangular
  and znsls401.t$iitm$c = 'P'
--  AND znfmd640_ETR.DATA_FILTRO
--      between :data_ini and :data_fim
      
--order by cisli940.t$docn$l
