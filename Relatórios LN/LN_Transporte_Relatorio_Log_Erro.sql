select ordf.t$cfrw$c   Cod_transp,
       Prec.t$fovn$l   CNPJ,
       Prec.t$fids$l   NOME,
       Prec.t$fire$l   PRE_REC,
       Prec.t$frec$l   REC_FIS,
       logrec.t$seqn$c LINHA_ERRO,
       logrec.t$mess$c DESCRICAO,
       prec.t$docn$l   N_CTE,
       prec.t$seri$l   S_CTE,
       prec.t$cnfe$l   CTE,
       ordf.t$orno$c   Ordem,
       substr(ordf.t$pecl$c,0,length(ordf.t$pecl$c)-2)   Pedido,
       ordf.t$docn$c   N_NF,
       ordf.t$seri$c   S_NF,
       refc.t$cnfe$l   NFE,
     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,  
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
      AT time zone 'America/Sao_Paulo') AS DATE)    DT_EMISSAO_PRE_REC

  from baandb.tznnfe004301 logrec
  
       inner join baandb.tbrnfe940301 Prec
               on  Prec.t$fire$l = logrec.t$fire$c
               
       inner join baandb.tbrnfe944301 refc
               on refc.t$fire$l = Prec.t$fire$l
               
       inner join baandb.tznfmd630301 ordf
               on ordf.t$cnfe$c = refc.t$cnfe$l
	WHERE TRUNC(     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,  
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
      AT time zone 'America/Sao_Paulo') AS DATE)) 
	  BETWEEN :DataEmissaoDe AND :DataEmissaoAte
	  AND ((:CodTranspTodos = 1) OR (TRIM(ordf.t$cfrw$c) IN (:CodTransp) AND (:CodTranspTodos = 0)))
         GROUP BY ordf.t$cfrw$c,
                  Prec.t$fovn$l,
                  Prec.t$fids$l,
                  Prec.t$fire$l,
                  Prec.t$frec$l,
                  logrec.t$line$c,
                  logrec.t$mess$c,
                  prec.t$docn$l,
                  prec.t$seri$l,
                  prec.t$cnfe$l,
                  ordf.t$orno$c,
                  ordf.t$pecl$c,
                  ordf.t$docn$c,
                  ordf.t$seri$c,
                  refc.t$cnfe$l,
                  logrec.t$seqn$c,
                  prec.t$idat$l

order by prec.t$fire$l desc
