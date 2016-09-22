select   
           Prec.t$fire$l                             PRE_REC,
           tcmcs080.t$cfrw                           Cod_transp,
           Prec.t$fovn$l                             CNPJ,
           Prec.t$fids$l                             NOME,
           Prec.t$fire$l                             PRE_REC,
           Prec.t$frec$l                             REC_FIS,    
           CASE Prec.t$stpr$c
           WHEN 2  THEN 'ABERTO'
           WHEN 3 THEN 'NF COM ERRO' END    STATUS_REC,
            '1'                   LINHA_ERRO,
           ' - LINHA 1 - ' ||

( select distinct LOGREC_S.t$mess$c DESCRICAO
            from baandb.tznnfe004301 LOGREC_S
           Where LOGREC_S.t$line$c = 0
             and LOGREC_S.t$seqn$c = 1
             and Prec.t$fire$l = logrec_S.t$fire$c                  
             and rownum = 1 )   || ' - LINHA 2 - ' ||

( select distinct LOGREC_S.t$mess$c DESCRICAO
            from baandb.tznnfe004301 LOGREC_S
           Where LOGREC_S.t$line$c = 0
             and LOGREC_S.t$seqn$c = 2
             and Prec.t$fire$l = logrec_S.t$fire$c                  
             and rownum = 1 )   || ' - LINHA 3 - ' ||

( select distinct LOGREC_S.t$mess$c DESCRICAO
            from baandb.tznnfe004301 LOGREC_S
           Where LOGREC_S.t$line$c = 1
             and LOGREC_S.t$seqn$c = 1
             and Prec.t$fire$l = logrec_S.t$fire$c                  
             and rownum = 1 )   || ' - LINHA 4 - ' ||
             
( select distinct LOGREC_S.t$mess$c DESCRICAO
            from baandb.tznnfe004301 LOGREC_S
           Where LOGREC_S.t$line$c = 1
             and LOGREC_S.t$seqn$c = 2
             and Prec.t$fire$l = logrec_S.t$fire$c                  
             and rownum = 1 )   DESCRICAO, 
           prec.t$docn$l   N_CTE,
           prec.t$seri$l   S_CTE,
           prec.t$cnfe$l   CTE,
           nvl(ordf.t$orno$c,cisli245.t$slso)                 Ordem,
           --ordf.t$pecl$c,
           --znsls004.t$pecl$c,
           nvl(substr(ordf.t$pecl$c,0,length(ordf.t$pecl$c)-2), znsls004.t$pecl$c)
                                                             PEDIDO,
           nvl(ordf.t$docn$c,cisli940.t$docn$l)              N_NF,
           ordf.t$docn$c,
           cisli940.t$docn$l,
           nvl(ordf.t$seri$c,cisli940.t$seri$l)              S_NF,
           refc.t$cnfe$l                                     NFE,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,  
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
               AT time zone 'America/Sao_Paulo') AS DATE)    DT_EMISSAO_PRE_REC,
          
           ULT_OCOR.PONTO                                    STATUS,
           prec.t$gtam$l                                     VALOR_CTE

      from baandb.tbrnfe940301 Prec
            
inner join ( select rnfe944.t$fire$l
                  , min(rnfe944.t$cnfe$l) t$cnfe$l
              from baandb.tbrnfe944301 rnfe944 
          group by rnfe944.t$fire$l ) refc
        on refc.t$fire$l = Prec.t$fire$l

left join baandb.tcisli940301 cisli940
       on cisli940.t$cnfe$l = refc.t$cnfe$l
      and cisli940.t$cnfe$l != ' '
       
left join ( select a.t$fire$l,
                   a.t$slso
              from baandb.tcisli245301 a
             where a.t$ortp = 1
               and a.t$koor = 3
          group by a.t$fire$l,
                   a.t$slso ) cisli245
       on cisli245.t$fire$l = cisli940.t$fire$l

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   min(a.t$pecl$c) t$pecl$c,
                   a.t$orno$c
              from baandb.tznsls004301 a
          group by a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$orno$c ) znsls004
        on znsls004.t$orno$c = cisli245.t$slso
       
left join ( select a.t$fire$c,
                   a.t$cnfe$c,
                   a.t$orno$c,
                   A.T$TORG$C,
                   a.t$docn$c,
                   a.t$seri$c,
                   a.t$fili$c,
                   min(a.t$pecl$c) t$pecl$c,
                   min(a.t$etiq$c) t$etiq$c
              from baandb.tznfmd630301 a 
             group by a.t$fire$c,
                      a.t$cnfe$c,
                      a.t$orno$c,
                      a.t$docn$c,
                      a.T$TORG$C,
                      a.t$seri$c,
                      a.t$fili$c) ordf
        on ordf.t$cnfe$c = refc.t$cnfe$l
        AND PREC.T$TORG$C = ORDF.T$TORG$C
        AND ordf.t$cnfe$c != ' '
       
inner join baandb.ttccom130301 tccom130
        on tccom130.t$fovn$l = Prec.t$fovn$l
       
inner join baandb.ttcmcs080301 tcmcs080
        on tcmcs080.t$cadr$l = tccom130.t$cadr


left join ( SELECT max(znfmd640d.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640d.t$date$c,  znfmd640d.t$udat$c)  PONTO,
                    MAX(znfmd640d.t$date$c)  DT,
                    MAX(znfmd640d.t$udat$c)  DT_PROC,
                    znfmd640d.t$fili$c,
                    znfmd640d.t$etiq$c
               FROM BAANDB.tznfmd640301 znfmd640d
           GROUP BY znfmd640d.t$fili$c,
                    znfmd640d.t$etiq$c ) ULT_OCOR
        on ULT_OCOR.t$fili$c = ordf.t$fili$c
       and ULT_OCOR.t$etiq$c = ordf.t$etiq$c 
       
         where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
                     AT time zone 'America/Sao_Paulo') AS DATE)) 
                       Between :DataEmissaoDe 
                   And :DataEmissaoAte
                   and ((:CodTranspTodos = 1) OR (TRIM(tcmcs080.t$cfrw) IN (:CodTransp) AND (:CodTranspTodos = 0)))
                   and Prec.t$stpr$c in (2,3)
