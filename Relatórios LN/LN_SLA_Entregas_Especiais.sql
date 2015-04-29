SELECT  DISTINCT

  znfmd630.t$fili$c                     FILIAL,                                 --01
  znfmd001.T$dsca$c                     DESC_FILIAL,
  znsls401.t$uneg$c                     MARCA,                                  --03
  znint002.t$desc$c                     DESC_MARCA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(EXPEDICAO.DATA_OCURR,          
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone 'America/Sao_Paulo') AS DATE)
                                        DATA_EXPEDICAO,                         --04
  cisli940.t$docn$l                     NOTA,                                   --05
  cisli940.t$seri$l                     SERIE,                                  --05
  cisli940.t$fdty$l                     TIPO,                                   --06
  iFDTY.                                DESC_TIPO_NOTA,         
  znsls401.t$pecl$c                     PEDIDO,                                 --07
  znsls401.t$entr$c                     ENTREGA,                                --08
  NVL(FMD610.VOLUMES,CISLI941.QTDE)     VOLUMES,                                --09
  znsls401.t$itpe$c                     TIPO_ENTREGA,                           --10
  znsls002.t$dsca$c                     DESC_TIPO_ENTREGA,
  cisli940.t$gwgt$l                     PESO,                                   --11
  whwmd400.t$hght *
  whwmd400.t$wdth *
  whwmd400.t$dpth                       VOLUME,                                 --12
  cisli940.t$gamt$l                     VALOR_SEM_FRETE,                        --13
  znfmd630.t$vlfc$c                     FRETE_CIA,                              --14
  znfmd630.t$vlfr$c                     FRETE_CLIENTE,                          --15
  znsls401.t$vlfr$c                     FRETE_SITE,                             --16
  cisli940.t$amnt$l                     VALOR_TOTAL_NOTA,                       --17
  cisli940.t$lipl$l                     PLACA,                                  --18
  EXPEDICAO.DATA_OCORR                  DATA_EXPEDICAO,                         --19
                                        DATA_PREVISTA,                          --20    ??????????
                                        DATA_CORRIGIDA,                         --21    ??????????
  cisli940.t$gamt$l                     VALOR_MERCADORIA,                       --22
  znsls401.t$itpe$c                     TPO_ENTREGA,                            --23
                                        DATA_AGENDAMENTO,                       --24
  cisli940.t$amnt$l                     VALOR_TOTAL_NOTA,                       --25
  cisli940.t$lipl$l                     PLACA,                                  --26
  znfmd630.t$cfrw$c                     TRANSPORTADOR,                          --27
  tcmcs080.t$dsca                       DESC_TRANSP,
  znsls401.t$cepe$c                     CEP,                                    --28
  znsls401.t$cide$c                     CIDADE,                                 --29
  znsls401.t$ufen$c                     UF,                                     --30
  ENTREGA.DATA_OCORR                    DATA_ENTREGA,                           --31
  znsls400.t$idca$c                     CANAL,                                  --32
                                        SITUACAO,                               --33    ???????????
  znsls401.t$mgrt$c                     ROTA,                                   --34
  znfmd630.t$fili$c                     FILIAL_TRANSP,                          --35
  znfmd001.T$dsca$c                     DESC_FILIAL,
                                        PRACA,                                  --36    ???????????
                                        TIPO_VENDA,                             --37    ???????????
  tccom130tr.t$fovn$l                   ID_TRANSP,                              --38
  znfmd062.t$dzon$c                     NOME_REGIAO,                            --39
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep, 
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone 'America/Sao_Paulo') AS DATE)
                                        DATA_PROMETIDA,                         --40
  znsls401.t$idpa$c                     PERIODO,                                --41
                                        DATA_AJUSTADA,                          --42    ??????????
                                        CONTRATO,                               --43    ??????????
  znsls410.PT_CONTR                     ID_OCORRENCIA,                          --44
  znmcs002.t$desc$c                     DESCR_OCORRENCIA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_OCORR, 
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone 'America/Sao_Paulo') AS DATE)
                                        DATA_OCORRENCIA,
  znsls410.ETIQ                         ETIQUETA
        
FROM  baandb.tznsls401301 znsls401

  LEFT JOIN baandb.tznfmd630301 znfmd630
         ON znfmd630.t$orno$c=znsls401.t$orno$c
        
  LEFT JOIN baandb.tcisli245301 cisli245
         ON cisli245.t$slcp=301
        AND cisli245.t$ortp=1
        AND cisli245.t$koor=3
        AND cisli245.t$slso=znsls401.t$orno$c
        AND cisli245.t$pono=znsls401.t$pono$c
        
  LEFT JOIN baandb.tcisli940301 cisli940
         ON cisli940.t$fire$l=cisli245.t$fire$l
         
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410301 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
    
 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR
 
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410301 znsls410
               where znsls410.t$poco$c = 'ETR'
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) EXPEDICAO
        ON EXPEDICAO.t$ncia$c = znsls401.t$ncia$c
       AND EXPEDICAO.t$uneg$c = znsls401.t$uneg$c
       AND EXPEDICAO.t$pecl$c = znsls401.t$pecl$c
       AND EXPEDICAO.t$sqpd$c = znsls401.t$sqpd$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410301 znsls410
               where znsls410.t$poco$c = 'ENT'
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) ENTREGA
        ON ENTREGA.t$ncia$c = znsls401.t$ncia$c
       AND ENTREGA.t$uneg$c = znsls401.t$uneg$c
       AND ENTREGA.t$pecl$c = znsls401.t$pecl$c
       AND ENTREGA.t$sqpd$c = znsls401.t$sqpd$c
        
 LEFT JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw=znfmd630.t$cfrw$c
        
 LEFT JOIN baandb.tznfmd001301 znfmd001
         ON znfmd001.t$fili$c=znfmd630.t$fili$c

 LEFT JOIN baandb.tznsls002301  znsls002
        ON znsls002.t$tpen$c=znsls401.t$itpe$c
        
 LEFT JOIN baandb.tznint002301  znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c
 
 LEFT JOIN baandb.twhwmd400301  whwmd400
        ON whwmd400.t$item = cisli941.t$item$l
   
 LEFT JOIN ( select  COUNT(znfmd610.t$etiq$c)  VOLUMES,
                        znfmd610.t$cnfe$c
              from    baandb.tznfmd610301 znfmd610
              group by znfmd610.t$cnfe$c )  FMD610
              ON   FMD610.t$cnfe$c = cisli940.t$cnfe$l
 
 LEFT JOIN baandb.tznfmd001301 znfmd001
         ON znfmd001.t$fili$c=znfmd630.t$fili$c
         
 LEFT JOIN ( select  znfmd062.t$creg$c,
                      znfmd062.t$cfrw$c,
                      znfmd062.t$cono$c,
                      znfmd062.t$cepd$c,
                      znfmd062.t$cepa$c
              from    baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062
          ON  znfmd062.t$cfrw$c=znfmd630.t$cfrw$c
         AND  znfmd062.t$cono$c=znfmd630.t$cono$c
         AND  znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c
         AND  znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c
  
  LEFT JOIN baandb.tznfmd061301 znfmd061
         ON znfmd061.t$cfrw$c=znfmd630.t$cfrw$c
        AND znfmd061.t$cono$c=znfmd630.t$cono$c
        AND znfmd061.t$creg$c=znfmd062.t$creg$c
 
 LEFT JOIN baandb.ttccom130301 tccom130tr
        ON tccom130tr.t$cadr = tcmcs080.t$cadr$l
        
 LEFT JOIN (SELECT d.t$cnst CODE_TIPO_NOTA, 
                   l.t$desc DESC_TIPO_NOTA
              FROM baandb.tttadv401000 d, 
                   baandb.tttadv140000 l 
             WHERE d.t$cpac = 'ci' 
               AND d.t$cdom = 'sli.tdff.l'
               AND l.t$clan = 'p'
               AND l.t$cpac = 'ci'
               AND l.t$clab = d.t$za_clab
               AND rpad(d.t$vers,4) ||
                   rpad(d.t$rele,2) ||
                   rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom )
               AND rpad(l.t$vers,4) ||
                   rpad(l.t$rele,2) ||
                   rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac )) iFDTY
        ON iFDTY.CODE_TIPO_NOTA=cisli940.t$fdty$l

        
--ORDER BY ENTREGA
