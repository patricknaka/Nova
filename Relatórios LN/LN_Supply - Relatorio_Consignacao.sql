SELECT
  DISTINCT
      cisli953.t$fire$l  REM_REF_FISCAL,
      cisli940.t$sfcp$l  REM_COMPANHIA,
      tcemm030.t$euca    REM_FILIAL,
      cisli953.t$data$l  REM_DATA_EMISSAO,
      cisli953.t$bfov$l  REM_CNPJ,
      cisli940.t$fids$l  REM_NOME_FORNEC,
      cisli953.t$lfir$l  REF_FISCAL_SIMBOLICA,
      cisli940.t$docn$l  SIM_REF_FISCAL,
      cisli940.t$seri$l  SIM_SERIE,
      cisli940.t$date$l  SIM_DATA_EMISSAO,
      cisli953.t$orno$l  SIM_ORDEM_VENDA,
      cisli940.t$stat$l  SIM_STATUS, 
      iTABLE.            DESC_STAT,
      tdrec940.t$docn$l  REM_NF,
      tdrec940.t$seri$l  REM_SERIE,
      cisli940.t$gamt$l  REM_PRECO_SEM_IMPOSTO,
      cisli940.t$amnt$l  REM_PRECO_COM_IMPOSTO

FROM  baandb.tcisli940301  cisli940,    
      baandb.tcisli941301  cisli941,
      baandb.ttdrec940301  tdrec940,
      baandb.ttdrec941301  tdrec941,
      baandb.tcisli953301  cisli953,  
      baandb.ttccom100301  tccom100,                   
      baandb.ttccom130301  tccom130,
      baandb.ttcemm030301  tcemm030,
      baandb.ttcemm124301  tcemm124,

     ( SELECT d.t$cnst CODE_STAT, 
              l.t$desc DESC_STAT
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
                                      and l1.t$cpac = l.t$cpac ) ) iTABLE    

WHERE tdrec940.t$fire$l = cisli953.t$fire$l
  AND cisli953.t$lfir$l = cisli940.t$fire$l
  AND cisli941.t$fire$l = cisli940.t$fire$l
  AND cisli941.t$refr$l = tdrec941.t$fire$l 
  AND cisli941.t$rfdl$l = tdrec941.t$line$l
  AND tdrec941.t$fire$l = tdrec940.t$fire$l
  AND tccom100.t$bpid   = cisli940.t$itbp$l
  AND tccom130.t$cadr   = cisli940.t$itoa$l
  AND tcemm124.t$cwoc   = cisli940.t$cofc$l 
  AND tcemm030.t$eunt   = tcemm124.t$grid
  AND cisli940.t$stat$l = iTABLE.CODE_STAT
  
  AND tcemm124.t$dtyp   = 2
  AND cisli953.t$fdty$l = 24 
  AND cisli953.t$rfdt$l = 33
  
  AND tcemm030.t$euca = NVL(:Depto, tcemm030.t$euca)
  AND cisli953.t$bfov$l = NVL(:CNPJ, cisli953.t$bfov$l)
  AND cisli953.t$data$l BETWEEN :DtEmissaoDe AND :DtEmissaoAte