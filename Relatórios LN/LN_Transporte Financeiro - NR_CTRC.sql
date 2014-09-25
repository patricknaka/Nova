SELECT 
  DISTINCT 
    tcemm030.t$euca                                  NUME_FILIAL,
    tccom130.t$fovn$l                                CNPJ_FILIAL, 
    tdrec940.t$fire$l                                NUME_RFISCAL,
  
    CASE WHEN tdrec940.t$date$l < '01/01/1980'
           THEN NULL
         ELSE tdrec940.t$adat$l
     END                                             DATA_NR,

    CASE WHEN tdrec947.t$oorg$l=1 
           THEN ( select distinct 
                         a.t$fdty$l 
                    from baandb.tcisli940201 a, 
                         baandb.tcisli245201 b
                   where b.t$slso=tdrec947.t$orno$l
                     and b.t$pono=tdrec947.t$pono$l
                     and b.t$fire$l=a.t$fire$l )
         ELSE ( select distinct 
                       c.t$rfdt$l 
                  from baandb.ttdrec940201 c, 
                       baandb.ttdrec947201 d
                 where d.t$orno$l=tdrec947.t$orno$l
                   and d.t$pono$l=tdrec947.t$pono$l
                   and d.t$fire$l=c.t$fire$l )    
     END                                             TP_DOCTO_FISCAL,

    CASE WHEN  tdrec947.t$oorg$l=1 
           THEN ( select l.t$desc DS_TIPO_OPERACAO
                    from baandb.tcisli940201 a, 
                         baandb.tcisli245201 b,
                         baandb.tttadv401000 d,
                         baandb.tttadv140000 l
                   where b.t$slso=tdrec947.t$orno$l
                     and b.t$pono=tdrec947.t$pono$l
                     and b.t$fire$l=a.t$fire$l
                     and d.t$cpac='ci'
                     and d.t$cdom='sli.tdff.l'
                     and d.t$vers='B61U'
                     and d.t$rele='a7'
                     and d.t$cust='glo1'
                     and l.t$clab=d.t$za_clab
                     and l.t$clan='p'
                     and l.t$cpac='ci'
                     and l.t$vers='B61U'
                     and l.t$rele='a7'
                     and l.t$cust='glo1'
                     and d.t$cnst=a.t$fdty$l )

         ELSE ( select l.t$desc DS_TIPO_OPERACAO   
                  from baandb.ttdrec940201 c, 
                       baandb.ttdrec947201 d,
                       baandb.tttadv401000 d,
                       baandb.tttadv140000 l
                 where d.t$orno$l=tdrec947.t$orno$l
                   and d.t$pono$l=tdrec947.t$pono$l
                   and d.t$fire$l=c.t$fire$l
                   and d.t$cpac='td'   
                   and d.t$cdom='rec.trfd.l'    
                   and d.t$vers='B61U'
                   and d.t$rele='a7'
                   and d.t$cust='glo1'
                   and l.t$clab=d.t$za_clab
                   and l.t$clan='p'
                   and l.t$cpac='td'    
                   and l.t$vers='B61U'
                   and l.t$rele='a7'
                   and l.t$cust='glo1'
                   and d.t$cnst=c.t$rfdt$l )   
     END                                             DESCR_TP_DOCTO_FISCAL,

    tdrec940.t$stat$l                                STAT_RFISCAL, 
    DESC_STAT_RFISCAL, 
    tccom130.t$ftyp$l                                TP_FORNECEDOR,
    tdrec940.t$fovn$l                                CNPJ_FORNECEDOR,  
    tdrec940.t$bpid$l                                DESC_FORNECEDOR,    
    tdrec940.t$opfc$l                                NUME_CCFO,  
    TO_CHAR(tdrec940.t$idat$l, 'MM')                 MES_EMISSAO,  
    tdrec940.t$docn$l                                NUME_NOTA,
    tdrec940.t$seri$l                                SERIE_NOTA,  
    ( SELECT tdrec949.t$amnt$l 
        FROM baandb.ttdrec949201 tdrec949
       WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
         AND tdrec949.t$brty$l=1)                    VALOR_ICMS, 
    tdrec940.t$tfda$l                                VALOR_TOTAL,  
    tdrec940.t$lipl$l                                PLACA_CAMINHAO,  
    tdrec940.t$idat$l                                DATA_EMISSAO,
    tdrec940.t$odat$l                                DATA_REGISTRO

FROM      baandb.ttdrec940201  tdrec940  

LEFT JOIN baandb.tttaad200000  ttaad200
       ON ttaad200.t$user=tdrec940.t$logn$l,
  
          baandb.ttdrec947201  tdrec947,  
          baandb.ttcemm030201  tcemm030,
          baandb.ttcemm124201  tcemm124,
          baandb.ttccom100201  tccom100
          
LEFT JOIN ttccom130201         tccom130
       ON tccom130.t$cadr = tccom100.t$cadr,
    
        ( SELECT d.t$cnst CODE_STAT, 
                 l.t$desc DESC_STAT_RFISCAL
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac='td' 
             AND d.t$cdom='rec.stat.l'
             AND d.t$vers='B61U'
             AND d.t$rele='a7'
             AND l.t$clab=d.t$za_clab
             AND l.t$clan='p'
             AND l.t$cpac='td'
             AND l.t$vers=( select max(l1.t$vers) 
                              from baandb.tttadv140000 l1 
                             where l1.t$clab=l.t$clab 
                               and l1.t$clan=l.t$clan 
                               and l1.t$cpac=l.t$cpac)) iTABLE,
          
        ( SELECT d.t$cnst CNST, 
                 l.t$desc DESC_TIPO_ORDEM
            FROM baandb.tttadv401000 d,
                 baandb.tttadv140000 l 
           WHERE d.t$cpac='ci' 
             AND d.t$cdom='sli.tdff.l'
             AND d.t$vers='B61U'
             AND d.t$rele='a7'
             AND l.t$clab=d.t$za_clab
             AND l.t$clan='p'
             AND l.t$cpac='ci'
             AND l.t$vers=( select max(l1.t$vers) 
                              from baandb.tttadv140000 l1 
                             where l1.t$clab=l.t$clab 
                               and l1.t$clan=l.t$clan 
                               and l1.t$cpac=l.t$cpac ) ) FGET

WHERE tccom100.t$bpid = tdrec940.t$bpid$l
  AND tdrec940.t$stat$l = iTABLE.CODE_STAT
  AND tcemm124.t$cwoc = tdrec940.t$cofc$l 
  AND tcemm124.t$dtyp = 1 
  AND tcemm030.t$eunt = tcemm124.t$grid  
  AND tdrec940.t$rfdt$l = 22 -- Conhec. Transp. Rodoviário
  AND tdrec940.t$fire$l = tdrec947.t$fire$l

  AND Trunc(tdrec940.t$date$l) Between :DataEmissaoDe And :DataEmissaoAte  