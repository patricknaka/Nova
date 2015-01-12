SELECT  
  znfmd630.t$fili$c  NUME_FILIAL,
  znfmd630.t$ncar$c  NUME_CARGA,
  znfmd630.t$pecl$c  NUME_ENTREGA,
  tccom110.t$cbtp    TIPO_PARCE,
  tccom130.t$cste    CODE_ESTAD,
  tccom130.t$fovn$l  CPF_CNPJ,
  cisli940.t$itbn$l  NOME_CLIEN,
  tccom130.t$ccit    CODE_MUNIC,
  znfmd630.t$docn$c  NUME_NF,
  znfmd630.t$seri$c  SERI_NF,
  cisli940.t$amnt$l  VALO_NF,
  cisli940.t$ccfo$l  CFOP
  
FROM       baandb.tcisli940301 cisli940

INNER JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid  = cisli940.t$bpid$l

INNER JOIN baandb.ttccom110301 tccom110
        ON tccom110.t$ofbp = tccom100.t$bpid

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr  = cisli940.t$itoa$l

INNER JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fire$c = cisli940.t$fire$l
		
WHERE (tccom110.t$cbtp LIKE '901' OR tccom110.t$cbtp LIKE '902')
  AND ( (znfmd630.t$ncar$c IN (:NumCarga)) OR (:NumCargaFiltrar = 1) )
  AND ( (znfmd630.t$pecl$c IN (:NumEntrega)) OR (:NumEntregaFiltrar = 1) )