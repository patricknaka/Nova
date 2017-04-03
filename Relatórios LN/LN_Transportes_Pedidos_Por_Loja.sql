select znsls401.t$entr$c                                                    ENTREGA
         , CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')						 
               AT time zone 'America/Sao_Paulo') AS DATE)                       DATA_EXPEDICAO

         , cisli940.t$docn$l                                                    NF
         , cisli940.t$seri$l                                                    SERIE
         , tcemm030.t$euca                                                      FILIAL
         , substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),1,8) || '/' || 
           substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),9,4) || '-' ||
           substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),13,2)       ENTIDADE_FISCAL_REDESPACHO
         , tccom130.t$nama                                                      NOME_LOJA
         , ( select sum(cisli956.t$quan$l) t$quan$l
               from baandb.tcisli956301 cisli956
              where cisli956.t$fire$l = cisli940.t$fire$l )                     QTD_VOLUMES_PEDIDO
              
      FROM baandb.tznsls400301 znsls400

INNER JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$ncia$c = znsls400.t$ncia$c
       AND znsls401.t$uneg$c = znsls400.t$uneg$c
       AND znsls401.t$pecl$c = znsls400.t$pecl$c
       AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
       AND znsls401.t$pono$c = 10

INNER JOIN baandb.tznsls410301 znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls410.t$entr$c = znsls401.t$entr$c

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c, a.T$SEQU$C,
                    max(a.t$orno$c) KEEP (DENSE_RANK LAST ORDER BY a.t$date$c) t$orno$c
               from baandb.tznsls004301 a
              where a.t$orig$c != 3  --insucesso de entrega
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c, a.T$SEQU$C,
                    a.t$entr$c ) znsls004
        ON znsls004.t$ncia$c = znsls401.t$ncia$c
       AND znsls004.t$uneg$c = znsls401.t$uneg$c
       AND znsls004.t$pecl$c = znsls401.t$pecl$c
       AND znsls004.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls004.t$entr$c = znsls401.t$entr$c
       AND znsls004.T$SEQU$C = znsls401.T$SEQU$C

 LEFT JOIN baandb.tcisli245301 cisli245
        ON cisli245.t$slso = znsls004.t$orno$c
       AND cisli245.t$pono = 10
       AND cisli245.t$slcp = 301
       AND cisli245.t$ortp = 1
       AND cisli245.t$koor = 3
       AND cisli245.t$sqnb = 0
       AND cisli245.t$oset = 0
 
INNER JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l

 LEFT JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = cisli940.t$cofc$l
 
 LEFT JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid
 
 LEFT JOIN ( select a.t$ftyp$l,
                    a.t$fovn$l,
                    a.t$comp$d,
                    min(a.t$nama) t$nama
               from baandb.ttccom130301 a
           group by a.t$ftyp$l,
                    a.t$fovn$l,
                    a.t$comp$d ) tccom130
        ON tccom130.t$fovn$l = substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),1,8) || '/' || 
                               substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),9,4) || '-' ||
                               substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),13,2)
       AND tccom130.t$comp$d = substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),1,8) || '/' || 
                               substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),9,4) || '-' ||
                               substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),13,2)
       AND tccom130.t$ftyp$l = 'PJ'

     WHERE znsls410.t$poco$c = 'ETR'
       AND znsls401.t$eftr$c > 0
       AND znsls401.t$iitm$c = 'P'
       AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')						 
                     AT time zone 'America/Sao_Paulo') AS DATE))
           Between :DataExpedicaoDe
               And :DataExpedicaoAte
   AND tcemm030.t$eunt in (:Filial)
   AND (    (znsls400.t$pecl$c in (:Pedido) and :Todos = 1  )
         or (:Todos = 0) )