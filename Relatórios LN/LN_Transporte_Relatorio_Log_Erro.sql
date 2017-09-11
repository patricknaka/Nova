select   
           tcmcs080.t$cfrw                           Cod_transp,
           Prec.t$fovn$l                             CNPJ,
           Prec.t$fids$l                             NOME,
           Prec.t$fire$l                             PRE_REC,
           
           Prec.t$frec$l                             REC_FIS,
     --    logrec.t$seqn$c                           LINHA_ERRO,
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
           
           nvl(substr(ordf.t$pecl$c,0,length(ordf.t$pecl$c)-2), znsls004.t$pecl$c)
                                                             PEDIDO,
           nvl(ordf.t$pecl$c, znsls004.t$entr$c)             ENTREGA,                                                              
           nvl(ordf.t$docn$c,cisli940.t$docn$l)              N_NF,
           nvl(ordf.t$seri$c,cisli940.t$seri$l)              S_NF,
           refc.t$cnfe$l                                     NFE,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,  
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
               AT time zone 'America/Sao_Paulo') AS DATE)    DT_EMISSAO_PRE_REC,
          
           ULT_OCOR.PONTO                                    STATUS,
           prec.t$gtam$l                                     VALOR_CTE,
           ORIGEM_ORDEM_FRETE.STATUS                         ORIGEM_ORDEM_FRETE,
           ORIGEM_ORDEM_FRETE.t$cnst,
		   case when ordf.t$stat$c = '1' then 'Aberto'
				when ordf.t$stat$c = '2' then 'Fechado'
				else '' end 								 STATUS_ORDEM_FRETE,
(select MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C)t$poco$c
   from baandb.tznsls410301 znsls410
  where znsls410.t$ncia$c = znsls004.t$ncia$c
    AND znsls410.t$uneg$c = znsls004.t$uneg$c
    AND to_char(znsls410.t$pecl$c) = nvl(substr(to_char(ordf.t$pecl$c),0,length(to_char(ordf.t$pecl$c))-2), znsls004.t$pecl$c)
    AND znsls410.t$sqpd$c = znsls004.t$sqpd$c
    AND to_char(znsls410.t$entr$c) = nvl(to_char(ordf.t$pecl$c), znsls004.t$entr$c)
    AND znsls410.T$ORNO$c =  nvl(ordf.t$orno$c,cisli245.t$slso) 
    ) ULTIMO_PONTO,
    ordf.t$fili$c        FILIAL,
    Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
                     AT time zone 'America/Sao_Paulo') AS DATE)) DATA_PROMETIDA,
                     
                     
      CTE_CTRC.DESCR             CTE_CTRC,
      CASE WHEN PREC.t$sige$c = 1 THEN
       'SIM'
       ELSE 
       'NAO'
      END                        SIGE
        
--           prec.t$fdot$l       ENTRADA_SAIDA
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
                   a.t$entr$c,
                   min(a.t$pecl$c) t$pecl$c,
                   a.t$orno$c,
                   a.t$sqpd$c
              from baandb.tznsls004301 a
          group by a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$entr$c,
                   a.t$orno$c,
                   a.t$sqpd$c) znsls004
        on znsls004.t$orno$c = cisli245.t$slso
 
 
 LEFT JOIN BAANDB.tznsls401301 znsls401           
  ON	ZNSLS004.T$NCIA$C	=	znsls401.T$NCIA$C
					AND ZNSLS004.T$UNEG$C	=	znsls401.T$UNEG$C
					AND ZNSLS004.T$PECL$C	=	znsls401.T$PECL$C
          AND ZNSLS004.T$SQPD$C	=	znsls401.T$SQPD$C
          AND ZNSLS004.T$ENTR$C	=	znsls401.T$ENTR$C            
              
left join ( select a.t$fire$c,
                   a.t$cnfe$c,
                   a.t$orno$c,
                   A.T$TORG$C,
                   a.t$docn$c,
                   a.T$PFIR$C,
                   a.t$seri$c,
                   a.t$fili$c,
	   a.t$stat$c,
                   min(a.t$pecl$c) t$pecl$c,
                   min(a.t$etiq$c) t$etiq$c
              from baandb.tznfmd630301 a 
             group by a.t$fire$c,
                      a.t$cnfe$c,
                      a.t$orno$c,
                      a.T$PFIR$C,
                      a.t$docn$c,
                      a.T$TORG$C,
                      a.t$seri$c,
                      a.t$fili$c,
	      a.t$stat$c) ordf
        on ordf.t$cnfe$c = refc.t$cnfe$l
  --       and ordf.t$orno$c = cisli245.t$SLSO
       and ordf.t$cnfe$c != ' '
       and ordf.T$PFIR$C = Prec.t$fire$l
LEFT JOIN (select l.t$desc STATUS,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'zn'
                and d.t$cdom = 'mcs.trans.c'
                and l.t$clan = 'p'
                and l.t$cpac = 'zn'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac )) ORIGEM_ORDEM_FRETE      
         ON ORDF.t$torg$c =  ORIGEM_ORDEM_FRETE.t$cnst                                 
       
inner join baandb.ttccom130301 tccom130
        on tccom130.t$fovn$l = Prec.t$fovn$l
       
inner join baandb.ttcmcs080301 tcmcs080
        on tcmcs080.t$cadr$l = tccom130.t$cadr


left join ( SELECT max(znfmd640d.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640d.t$date$c,  znfmd640d.t$udat$c)  PONTO,
                    MAX(znfmd640d.t$date$c)  DT,
                    MAX(znfmd640d.t$udat$c)  DT_PROC,
                    znfmd640d.t$fili$c,
                    znfmd640d.t$etiq$c,
                    znfmd640d.t$torg$c
               FROM BAANDB.tznfmd640301 znfmd640d
           GROUP BY znfmd640d.t$fili$c,
                    znfmd640d.t$etiq$c,
                    znfmd640d.t$torg$c ) ULT_OCOR
        on ULT_OCOR.t$fili$c = ordf.t$fili$c
       and ULT_OCOR.t$etiq$c = ordf.t$etiq$c 
       and ULT_OCOR.t$torg$c = ordf.t$torg$c    
       
       
left join ( select l.t$desc DESCR,  
                   d.t$cnst
              from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             where d.t$cpac = 'tc'
               and d.t$cdom = 'yesno'
               and l.t$clan = 'p'
               and l.t$cpac = 'tc'
               and l.t$clab = d.t$za_clab
               and rpad(d.t$vers,4) ||
                   rpad(d.t$rele,2) ||
                   rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom )
               and rpad(l.t$vers,4) ||
                   rpad(l.t$rele,2) ||
                   rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac ) ) CTE_CTRC
       on CTE_CTRC.t$cnst = PREC.t$coct$c       

     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(prec.t$idat$l,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
                     AT time zone 'America/Sao_Paulo') AS DATE)) 
                       Between :DataEmissaoDe 
                   And :DataEmissaoAte
                    and Prec.t$stpr$c in ('2','3')
     and ((:CodTranspTodos = 1) OR (TRIM(tcmcs080.t$cfrw) IN (:CodTransp) AND (:CodTranspTodos = 0)))
