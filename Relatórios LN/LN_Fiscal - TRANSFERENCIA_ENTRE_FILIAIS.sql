select 
  distinct 
    301                         CIA,
    tcemm122.t$grid             CodFilial,
    tccom130a.t$fovn$l          Filial,
    cisli940.t$docn$l           Nota_Fiscal,
    cisli940.t$seri$l           Serie,
    whinh200.t$otyp             Tipo_de_Ordem,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                Data_de_Emissao,

    cisli940.t$stat$l           Status_da_NF,
    Status_da_NF.               DESCR_Status_da_NF,  -- Descrição do staus da NF
    
    tccom130b.t$fovn$l          CNPJ,
    tccom100.t$nama             Nome_do_Parceiro,
    tccom130a.t$cste            UF,
    cisli940.t$ccfo$l           CFOP,
    cisli940.t$gamt$l           Valor_Mercadoria,
  
    ( select whinh250.t$logn 
        from baandb.twhinh250301 whinh250 
       where whinh250.t$oorg = whinh200.t$oorg
         and whinh250.t$orno = whinh200.t$orno
         and whinh250.t$oset = whinh200.t$oset 
         and whinh250.T$trdt = ( select min(a.t$trdt) 
                                   from baandb.twhinh250301 a 
                                  where whinh250.t$oorg = a.t$oorg
                                    and whinh250.t$orno = a.t$orno
                                    and whinh250.t$oset = a.t$oset ) ) 
                                Usuario,
    cisli940.t$fire$l           Referencia_Fiscal,
    whinh200.t$hsta             Status_da_Referencia,
    
    Status_Ordem_Armazem.       DESCR_Status_Ordem_Armazem,
    cisli940.t$cnfe$l           Chave_de_Acesso,
	
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                Data_Entrada,
								
    tdrec940.t$fire$l           Ref_Fiscal_Entrada,  
    tdrec940.t$stat$l           CODE_STAT_REC,            --Status ref. Fiscal 
    STAT_REC.                   DESCR_CODE_STAT_REC       --Status ref. Fiscal    
    
from       baandb.tcisli940301 cisli940

inner join baandb.tcisli245301 cisli245
        on cisli245.t$fire$l = cisli940.t$fire$l

inner join baandb.twhinh200301 whinh200
        on whinh200.t$orno = cisli245.t$slso 
       and whinh200.t$oset = cisli245.t$oset
     
inner join baandb.ttccom130301 tccom130a
        on tccom130a.t$cadr  = cisli940.t$sfra$l 

inner join baandb.ttcemm122301 tcemm122
        on tcemm122.t$bupa   = tccom130a.t$cadr

inner join baandb.ttccom130301 tccom130b
        on tccom130b.t$cadr  = cisli940.t$stoa$l

inner join baandb.ttccom100301 tccom100
        on tccom100.t$bpid   = cisli940.t$stbp$l

 left join baandb.ttdrec947301 tdrec947 
        on tdrec947.t$orno$l = whinh200.t$orno 
       and tdrec947.t$seqn$l = whinh200.t$oset
     
 left join baandb.ttdrec940301 tdrec940 
        on tdrec940.t$fire$l = tdrec947.t$fire$l 
 	  
 left join ( SELECT l.t$desc DESCR_Status_da_NF,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'ci'
                AND d.t$cdom = 'sli.stat'
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
                                            and l1.t$cpac = l.t$cpac ) ) Status_da_NF
        on Status_da_NF.t$cnst = cisli940.t$stat$l
 	   
 left join ( SELECT l.t$desc DESCR_Status_Ordem_Armazem,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'wh'
                AND d.t$cdom = 'inh.hsta'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'wh'
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
                                            and l1.t$cpac = l.t$cpac ) ) Status_Ordem_Armazem
        on Status_Ordem_Armazem.t$cnst = whinh200.t$hsta
 
 left join ( SELECT l.t$desc DESCR_CODE_STAT_REC,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'td'
                AND d.t$cdom = 'rec.stat.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'td'
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
                                            and l1.t$cpac = l.t$cpac ) ) STAT_REC
        on STAT_REC.t$cnst = tdrec940.t$stat$l
			  
where tdrec940.t$rfdt$l = 4
  and cisli940.t$fdty$l = 4 

  and Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) 
      Between :EmissaoDe 
          And :EmissaoAte
  and tcemm122.t$grid In (:Filial)
  and cisli940.t$ccfo$l In (:CFOP)
  and cisli940.t$stat$l In (:StatusNF)