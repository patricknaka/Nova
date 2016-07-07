    select tcmcs080.t$cfrw                                   Cod_transp,
           Prec.t$fovn$l                                     CNPJ,
           Prec.t$fids$l                                     NOME,
           Prec.t$fire$l                                     PRE_REC,
           Prec.t$frec$l                                     REC_FIS,
           logrec.t$seqn$c                                   LINHA_ERRO,
           LOGREC.t$mess$c                                   DESCRICAO,
           prec.t$docn$l   N_CTE,
           prec.t$seri$l   S_CTE,
           prec.t$cnfe$l   CTE,
           ordf.t$orno$c   Ordem,
           substr(ordf.t$pecl$c,0,length(ordf.t$pecl$c)-2)   PEDIDO,
           ordf.t$docn$c                                     N_NF,
           ordf.t$seri$c                                     S_NF,
           refc.t$cnfe$l                                     NFE,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,  
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
               AT time zone 'America/Sao_Paulo') AS DATE)    DT_EMISSAO_PRE_REC,
          
           ULT_OCOR.PONTO                                    STATUS

      from baandb.tznnfe004301 logrec
  
inner join baandb.tbrnfe940301 Prec
        on  Prec.t$fire$l = logrec.t$fire$c
        
inner join baandb.tbrnfe944301 refc
        on refc.t$fire$l = Prec.t$fire$l
        
left join baandb.tznfmd630301 ordf
        on ordf.t$cnfe$c = refc.t$cnfe$l

inner join baandb.ttccom130301 tccom130
        on tccom130.t$fovn$l = Prec.t$fovn$l
       
inner join baandb.ttcmcs080301 tcmcs080
        on tcmcs080.t$cadr$l = tccom130.t$cadr

 left join ( SELECT znfmd640d.t$coci$c  PONTO,
                    znfmd640d.t$date$c  DT,
                    znfmd640d.t$udat$c  DT_PROC,
                    znfmd640d.t$ulog$c  LOGIN_PROC,
                    znfmd640d.t$fili$c,
                    znfmd640d.t$etiq$c
               FROM BAANDB.tznfmd640301 znfmd640d
              WHERE znfmd640d.t$coci$c = ( select max(znfmd640x.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640x.t$date$c,  znfmd640x.t$udat$c)
                                             from BAANDB.tznfmd640301 znfmd640x
                                            where znfmd640x.t$fili$c = znfmd640d.t$fili$c                                        
                                              and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c ) ) ULT_OCOR
        on ULT_OCOR.t$fili$c = ordf.t$fili$c
       and ULT_OCOR.t$etiq$c = ordf.t$etiq$c 
	       

	   where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
                     AT time zone 'America/Sao_Paulo') AS DATE)) 
	       Between :DataEmissaoDe 
               And :DataEmissaoAte
	   and ((:CodTranspTodos = 1) OR (TRIM(tcmcs080.t$cfrw) IN (:CodTransp) AND (:CodTranspTodos = 0)))
