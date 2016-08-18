select 
        znsls400.t$nomf$c     NOME_CADASTRO,
        znsls401.t$nome$c     NOME_DESTINATARIO,
        znsls401.t$loge$c     END_ENTREGA,
        znsls401.t$nume$c     NUMERO_ENTR,
        znsls401.t$come$c     COMPLEMENTO_ENTR,
        znsls401.t$baie$c     BAIRRO_ENTR,
        znsls401.t$refe$c     REFERENCIA_ENTR,
        znsls401.t$cepe$c     CEP_ENTR,
        znsls401.t$cide$c     CIDADE_ENTR,
        znsls401.t$paie$c     PAIS_ENTR,
        znsls400.t$logf$c     END_FAT,
        znsls400.t$numf$c     NUMERO_FAT,
        znsls400.t$comf$c     COMPLEMENTO_FAT,
        znsls400.t$baif$c     BAIRRO_FAT,
        znsls400.t$reff$c     REFERENCIA_FAT,
        znsls400.t$cepf$c     CEP_FAT,
        znsls400.t$cidf$c     CIDADE_FAT,
        znsls400.t$paif$c     PAIS_FAT,
        cisli940.t$docn$l     NR_NF,
        cisli940.t$seri$l     SERIE_NF,
        znfmd630.t$cfrw$c     COD_TRANSPORTADORA,
        tcmcs080.t$dsca       NOME_TRANSPORTADORA,
        znsls401.t$uneg$c     UN_NEGOCIO,
        znsls401.t$pecl$c     PEDIDO,
        znsls401.t$entr$c     ENTREGA,
        znsls410.t$poco$c     ULT_PONTO,
        znmcs002.t$desc$c     DESC_ULT_PONTO,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                              DT_ENTR_PROMETIDA,
        case when trunc(znfmd630.t$dtco$c) < TO_DATE('01-01-1980', 'DD-MM-YYYY') then
            null
        else
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE) end
                              DT_AJUSTADA_ENTREGA,
        znsls401.valor        VL_ENTREGA                              

FROM  ( select        a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$orno$c,
                      a.t$dtep$c,
                      a.t$nome$c,  
                      a.t$loge$c,    
                      a.t$nume$c,
                      a.t$come$c,
                      a.t$baie$c,
                      a.t$refe$c,
                      a.t$cepe$c,
                      a.t$cide$c,
                      a.t$paie$c,
                      sum(a.t$qtve$c * a.t$vlun$c) valor
              from    baandb.tznsls401301 a
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c,
                        a.t$orno$c,
                        a.t$dtep$c,
                        a.t$nome$c,  
                        a.t$loge$c,    
                        a.t$nume$c,
                        a.t$come$c,
                        a.t$baie$c,
                        a.t$refe$c,
                        a.t$cepe$c,
                        a.t$cide$c,
                        a.t$paie$c) znsls401

left join ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$orno$c) KEEP (DENSE_RANK LAST ORDER BY a.t$date$c) t$orno$c
--                    max(a.t$pono$c) KEEP (DENSE_RANK LAST ORDER BY a.t$date$c) t$pono$c
              from  baandb.tznsls004301 a
              where a.t$orig$c not in (3)   --insucesso de entrega
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c ) znsls004
        on  znsls004.t$ncia$c = znsls401.t$ncia$c
       and  znsls004.t$uneg$c = znsls401.t$uneg$c
       and  znsls004.t$pecl$c = znsls401.t$pecl$c
       and  znsls004.t$entr$c = znsls401.t$entr$c

inner join  ( select a.t$fire$l,
                     a.t$slso
              from baandb.tcisli245301 a
              where a.t$ortp = 1 
                and a.t$koor = 3
              group by a.t$fire$l,
                       a.t$slso ) cisli245
        on cisli245.t$slso = NVL(znsls004.t$orno$c, znsls401.t$orno$c)

inner join baandb.tcisli940301 cisli940
        on cisli940.t$fire$l = cisli245.t$fire$l
       
inner join baandb.tznsls400301 znsls400
        on znsls400.t$ncia$c = znsls401.t$ncia$c
       and znsls400.t$uneg$c = znsls401.t$uneg$c
       and znsls400.t$pecl$c = znsls401.t$pecl$c
       and znsls400.t$sqpd$c = znsls401.t$sqpd$c
        
left join ( select a.t$orno$c,
                    a.t$pecl$c,
                    a.t$fire$c,
                    a.t$dtco$c,
                    a.t$fili$c,
                    a.t$cfrw$c,
                    min(a.t$etiq$c) t$etiq$c
             from   baandb.tznfmd630301 a 
             group by a.t$orno$c,
                      a.t$pecl$c,
                      a.t$fire$c,
                      a.t$dtco$c,
                      a.t$fili$c,
                      a.t$cfrw$c ) znfmd630
       on TO_CHAR(znfmd630.t$pecl$c) = TO_CHAR(znsls401.t$entr$c)
       and znfmd630.t$fire$c = cisli940.t$fire$l

left join baandb.ttcmcs080301 tcmcs080
       on tcmcs080.t$cfrw = znfmd630.t$cfrw$c
       
left join  ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$entr$c,
                    a.t$sqpd$c,
                    max(a.t$dtoc$c) t$dtoc$c,
                    max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
               from baandb.tznsls410301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$entr$c,
                    a.t$sqpd$c ) znsls410
        on znsls410.t$ncia$c = znsls401.t$ncia$c
       and znsls410.t$uneg$c = znsls401.t$uneg$c
       and znsls410.t$pecl$c = znsls401.t$pecl$c
       and znsls410.t$entr$c = znsls401.t$entr$c
       and znsls410.t$sqpd$c = znsls401.t$sqpd$c

left join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = znsls410.t$poco$c
       
where not exists ( select *
                   from baandb.tznfmd640301 a
                   where a.t$fili$c = znfmd630.t$fili$c
                   and   a.t$etiq$c = znfmd630.t$etiq$c
                   and   a.t$coci$c = 'ENT' )
and znsls401.valor > 0
        
