SELECT
  DISTINCT
    301                CODE_CIA,
    tcemm122.T$grid    UNID_EMPRESARIAL,
    ( select a.t$fovn$l 
        from baandb.ttccom130301 a 
       where a.t$cadr = tdrec940.t$sfra$l ) 
                       NUME_FILIAL,
    tdrec940.t$date$l  DATA_APROV,  
    tdrec940.t$fire$l  REFE_FISCAL,                 
    tdrec940.t$stat$l  STAT_REFFISC,  DESC_DOMAIN_STAT.DESC_STAT,
    tdrec947.t$orno$l  TIPO_ORDEM,  
    tdrec940.t$fovn$l  CNPJ_FORN,
    tdrec940.t$fids$l  NOME_PARCE,
    tdrec940.t$opfc$l  NUME_CFOP,
    tdrec940.t$docn$l  NUME_NF,
    tdrec940.t$seri$l  SERI_NF,
    tdrec940.t$tfda$l  VALO_TOTAL,
    whinh300.t$recd$c  RECDOC_WMS,
    tdrec940.t$lipl$l  PLAC_VEIC,
    tdrec940.t$logn$l  CODE_USUA,
    tdrec940.t$cnfe$l  CHAV_ACESS,
    tdrec940.t$fdtc$l  COD_TIPO_DOCFIS,
    ( select d.t$dsca$l 
        from baandb.ttcmcs966301 d 
       where d.t$fdtc$l = tdrec940.t$fdtc$l )
                       DESC_TIPO_DOCFIS
					 
FROM      baandb.ttdrec940301   tdrec940  
LEFT JOIN baandb.twhinh300301  whinh300
       ON whinh300.t$fire$c = tdrec940.t$fire$l,
       
          baandb.ttdrec941301  tdrec941,  
          baandb.ttdrec947301  tdrec947,
          baandb.ttccom130301  tccom130, 
          baandb.ttcemm122301  tcemm122,
          
        ( SELECT d.t$cnst DESC_DOMAIN_STAT, 
                 l.t$desc DESC_STAT 
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
                                         and l1.t$cpac = l.t$cpac ) ) DESC_DOMAIN_STAT
   
WHERE tdrec940.t$fire$l = tdrec941.t$fire$l
  AND tdrec941.t$fire$l = tdrec947.t$fire$l
  AND tdrec941.t$line$l = tdrec947.t$line$l
  AND tdrec940.t$stat$l = DESC_DOMAIN_STAT.DESC_DOMAIN_STAT
  AND tccom130.t$cadr = tdrec940.t$ifad$l
  AND tcemm122.t$bupa = tdrec940.t$sfra$l

  AND Trunc(tdrec940.t$date$l) BETWEEN :DtAprovacaoDe AND :DtAprovacaoAte
  AND tcemm122.T$grid IN (:Filial)
  AND tdrec940.t$stat$l IN (:StatusRefFiscal)
  AND tdrec940.t$opfc$l IN (:COD_CFOP)
  AND tdrec940.t$fdtc$l IN (:TipoDocFiscal)