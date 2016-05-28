    select tcmcs080.t$cfrw                                   Cod_transp,
           Prec.t$fovn$l                                     CNPJ,
           Prec.t$fids$l                                     NOME,
           Prec.t$fire$l                                     PRE_REC,
           Prec.t$frec$l                                     REC_FIS,
           logrec.t$seqn$c                                   LINHA_ERRO,
           MAX(logrec.t$mess$c || 
               ' - LINHA 2 - ' ||
               ( select distinct LOGREC_S.t$mess$c DESCRICAO
                   from baandb.tznnfe004301        LOGREC_S
                  where Prec.t$fire$l = logrec_S.t$fire$c
                    and logrec_S.t$line$c = 1
                    and rownum = 1 ))             DESCRICAO,
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
        
inner join baandb.tznfmd630301 ordf
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
	       
	 where logrec.t$line$c = 0
	   and Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
                     AT time zone 'America/Sao_Paulo') AS DATE)) 
	       Between :DataEmissaoDe 
               And :DataEmissaoAte
	   and ((:CodTranspTodos = 1) OR (TRIM(tcmcs080.t$cfrw) IN (:CodTransp) AND (:CodTranspTodos = 0)))

  group by tcmcs080.t$cfrw,
           Prec.t$fovn$l,
           Prec.t$fids$l,
           Prec.t$fire$l,
           Prec.t$frec$l,
           --logrec.t$line$c, -- SPD 1129123
           --logrec.t$mess$c, -- SPD 1129123
           prec.t$docn$l,
           prec.t$seri$l,
           prec.t$cnfe$l,
           ordf.t$orno$c,
           ordf.t$pecl$c,
           ordf.t$docn$c,
           ordf.t$seri$c,
           refc.t$cnfe$l,
           logrec.t$seqn$c,
           prec.t$idat$l,
           ULT_OCOR.PONTO
 
  order by prec.t$fire$l desc
  
  
=

"     select tcmcs080.t$cfrw                                   Cod_transp,  " &
"            Prec.t$fovn$l                                     CNPJ,  " &
"            Prec.t$fids$l                                     NOME,  " &
"            Prec.t$fire$l                                     PRE_REC,  " &
"            Prec.t$frec$l                                     REC_FIS,  " &
"            logrec.t$seqn$c                                   LINHA_ERRO,  " &
"            MAX(logrec.t$mess$c ||  " &
"                ' - LINHA 2 - ' ||  " &
"                ( select distinct LOGREC_S.t$mess$c DESCRICAO  " &
"                    from baandb.tznnfe004" + Parameters!Compania.Value + "        LOGREC_S  " &
"                   where Prec.t$fire$l = logrec_S.t$fire$c  " &
"                     and logrec_S.t$line$c = 1  " &
"                     and rownum = 1 ))             DESCRICAO,  " &
"            prec.t$docn$l   N_CTE,  " &
"            prec.t$seri$l   S_CTE,  " &
"            prec.t$cnfe$l   CTE,  " &
"            ordf.t$orno$c   Ordem,  " &
"            substr(ordf.t$pecl$c,0,length(ordf.t$pecl$c)-2)   PEDIDO,  " &
"            ordf.t$docn$c                                     N_NF,  " &
"            ordf.t$seri$c                                     S_NF,  " &
"            refc.t$cnfe$l                                     NFE,  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE)    DT_EMISSAO_PRE_REC,  " &
"  " &
"            ULT_OCOR.PONTO                                    STATUS  " &
"  " &
"       from baandb.tznnfe004" + Parameters!Compania.Value + " logrec  " &
"  " &
" inner join baandb.tbrnfe940" + Parameters!Compania.Value + " Prec  " &
"         on  Prec.t$fire$l = logrec.t$fire$c  " &
"  " &
" inner join baandb.tbrnfe944" + Parameters!Compania.Value + " refc  " &
"         on refc.t$fire$l = Prec.t$fire$l  " &
"  " &
" inner join baandb.tznfmd630" + Parameters!Compania.Value + " ordf  " &
"         on ordf.t$cnfe$c = refc.t$cnfe$l  " &
"  " &
" inner join baandb.ttccom130" + Parameters!Compania.Value + " tccom130  " &
"         on tccom130.t$fovn$l = Prec.t$fovn$l  " &
"  " &
" inner join baandb.ttcmcs080" + Parameters!Compania.Value + " tcmcs080  " &
"         on tcmcs080.t$cadr$l = tccom130.t$cadr  " &
"  " &
"  left join ( SELECT znfmd640d.t$coci$c  PONTO,  " &
"                     znfmd640d.t$date$c  DT,  " &
"                     znfmd640d.t$udat$c  DT_PROC,  " &
"                     znfmd640d.t$ulog$c  LOGIN_PROC,  " &
"                     znfmd640d.t$fili$c,  " &
"                     znfmd640d.t$etiq$c  " &
"                FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640d  " &
"               WHERE znfmd640d.t$coci$c = ( select max(znfmd640x.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640x.t$date$c,  znfmd640x.t$udat$c)  " &
"                                              from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640x  " &
"                                             where znfmd640x.t$fili$c = znfmd640d.t$fili$c  " &
"                                               and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c ) ) ULT_OCOR  " &
"         on ULT_OCOR.t$fili$c = ordf.t$fili$c  " &
"        and ULT_OCOR.t$etiq$c = ordf.t$etiq$c  " &
" 	  " &
" 	 where logrec.t$line$c = 0  " &
" 	   and Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,  " &
"                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                      AT time zone 'America/Sao_Paulo') AS DATE))  " &
" 	       Between :DataEmissaoDe  " &
"                And :DataEmissaoAte  " &
" 	   and ((:CodTranspTodos = 1) OR (TRIM(tcmcs080.t$cfrw) IN (:CodTransp) AND (:CodTranspTodos = 0)))  " &
"  " &
"   group by tcmcs080.t$cfrw,  " &
"            Prec.t$fovn$l,  " &
"            Prec.t$fids$l,  " &
"            Prec.t$fire$l,  " &
"            Prec.t$frec$l,  " &
"            prec.t$docn$l,  " &
"            prec.t$seri$l,  " &
"            prec.t$cnfe$l,  " &
"            ordf.t$orno$c,  " &
"            ordf.t$pecl$c,  " &
"            ordf.t$docn$c,  " &
"            ordf.t$seri$c,  " &
"            refc.t$cnfe$l,  " &
"            logrec.t$seqn$c,  " &
"            prec.t$idat$l,  " &
"            ULT_OCOR.PONTO  " &
"  " &
"   order by prec.t$fire$l desc  "