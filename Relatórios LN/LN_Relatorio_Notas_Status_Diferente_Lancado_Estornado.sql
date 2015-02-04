SELECT DISTINCT

cisli940.t$docn$l           NF,
cisli940.t$seri$l           SERIE,
tcemm030.t$euca             FILIAL,
cisli940.t$fire$l           REF_FISCAL,
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$datg$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)  
                            DATA_GERACAO_NF,
tccom130.t$fovn$l           CNPJ_CLIENTE,
tccom130.t$nama             CLIENTE,
cisli941.t$ccfo$l           CFOP,
' '                         SEQ_CFOP,       --Não existe no Ln
FGET.STATUS_NF              SITUACAO_NF,
cisli941.t$item$l           ID_ITEM,
cisli941.t$desc$l           DESCRICAO,
cisli941.t$dqua$l           QTD,
cisli941.t$pric$l           PRECO_UNIT,
cisli941.t$amnt$l           VL_TOTAL

FROM baandb.tcisli941301  cisli941

INNER JOIN baandb.tcisli940301  cisli940
        ON cisli940.t$fire$l=cisli941.t$fire$l

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr=cisli940.t$itoa$l
        
LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$loco=301
      AND tcemm124.t$dtyp=1
      AND tcemm124.t$cwoc=cisli940.t$cofc$l
      
LEFT JOIN baandb.ttcemm030301 tcemm030
       ON tcemm030.t$eunt=tcemm124.t$grid
       
       LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc STATUS_NF
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
                                                  and l1.t$cpac = l.t$cpac ) ) FGET
              ON cisli940.t$doty$l = FGET.CNST
              
WHERE cisli940.t$stat$l!=6
AND   cisli940.t$stat$l!=101
