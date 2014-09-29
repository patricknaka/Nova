SELECT 
  DISTINCT
    301                                     CODE_CIA,
    ( select a.t$fovn$l                     
        from baandb.ttccom130301 a          
       where a.t$cadr=cisli940.t$sfra$l)    NUME_FILIAL,
    cisli940.t$docn$l                       NUME_NF,
    cisli940.t$seri$l                       SERI_NF,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                            DATA_EMISSA,
    cisli940.t$ccfo$l                       COD_CFOP,
    cisli245.t$slso                         ORDEM,
    tdsls400.t$sotp                         TIPO_ORD_VENDA_DEV,
    tccom130.t$fovn$l                       CPF_CNPJ,
    cisli940.t$itbn$l                       NOME_PARCEI,
    tccom130.t$cste                         UF_PARCEI,
    cisli940.t$amnt$l                       VALO_NFD,
    znnfe002.t$logn$c                       USUARIO,
    cisli940.t$cnfe$l                       CHAVE_NFD,
    cisli940.t$stat$l                       STATUS, iTABLE.DESC_STAT,
    cisli940.t$fire$l                       REF_FISCAL,
    cisli940d.t$docn$l                      NOTA_NF_VENDA,  
    cisli940d.t$seri$l                      SERI_NF_VENDA,
    cisli940d.t$cnfe$l                      CHAVE_NF_VENDA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940d.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                            DATA_NF_VENDA,
    cisli940d.t$amnt$l                      VALO_NF_VENDA,
    cisli245d.t$slso                        NUME_OV,
    cisli940.t$fdty$l                       COD_TIPO_DOC_FISCAL,
    iTIPODOCFIS.DESCR                       DESC_TIPO_DOC_FISCAL,
    tdrec940.t$stat$l                       CODE_STAT_NF_ORIG,					-- Status ref fiscal
    iSTATRECFIS.DESCR                       DESCR_STAT_NF_ORIG, 				-- Descric Staus Rf fiscal
    tdrec940.t$fire$l                       REFFIS_REC,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                            DATA_REC, 
    tdrec940.t$logn$l                       USER_REC,
    cisli940d.t$stat$l                      STATUS_NFD,
    ( SELECT l.t$desc DS_SITUACAO_NF
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'ci'
         AND d.t$cdom = 'sli.stat'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'ci'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = cisli940d.t$stat$l
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
                                     and l1.t$cpac = l.t$cpac ) ) 
                                            DESCR_STATUS_NFD
  
FROM      baandb.tcisli940301  cisli940 
 
LEFT JOIN baandb.tznnfe002301 znnfe002 ON znnfe002.t$fire$c = cisli940.t$fire$l,
 
          baandb.tcisli940301  cisli940d,  
          baandb.tcisli245301  cisli245,
          baandb.tcisli245301  cisli245d,  
          baandb.ttdsls400301  tdsls400,
          baandb.ttdsls401301  tdsls401,
          baandb.ttdrec947301  tdrec947,
          baandb.ttdrec940301  tdrec940,
          baandb.ttcemm030301  tcemm030,  
          baandb.ttccom130301  tccom130,
          baandb.ttcemm124301  tcemm124,
    
          ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_STAT
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
                                           and l1.t$cpac = l.t$cpac ) ) iTABLE,
										   
          ( SELECT d.t$cnst COD, l.t$desc DESCR 
              FROM baandb.tttadv401000 d, 
                   baandb.tttadv140000 l
             WHERE d.t$cpac = 'ci'
               AND d.t$cdom = 'sli.tdff.l'
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
                                           and l1.t$cpac  =  l.t$cpac ) ) iTIPODOCFIS,

          ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
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
                                           and l1.t$cpac = l.t$cpac ) ) iSTATRECFIS
 
WHERE cisli940.t$fdty$l = 14
  AND cisli940.t$fire$l = cisli245.t$fire$l
  AND tdsls401.t$orno   = cisli245.t$slso
  AND tdsls401.t$pono   = cisli245.t$pono
  AND cisli245d.t$fire$l = tdsls401.t$fire$l
  AND cisli245d.t$line$l = tdsls401.t$line$l   
  AND cisli940d.t$fire$l = cisli245d.t$fire$l
  AND tccom130.t$cadr = cisli940.t$itoa$l 
  AND tcemm124.t$cwoc = cisli940.t$cofc$l
  AND tcemm124.t$dtyp = 1 
  AND tcemm030.t$eunt = tcemm124.t$grid  
  AND cisli940.t$stat$l = iTABLE.CODE_STAT
  AND iTIPODOCFIS.COD = cisli940.t$fdty$l
  AND tdsls400.t$orno = tdsls401.t$orno
  AND tdrec947.t$oorg$l = 1 --Venda
  AND tdrec947.t$orno$l = tdsls401.t$orno
  AND tdrec947.t$pono$l = tdsls401.t$pono
  AND tdrec940.t$fire$l = tdrec947.t$fire$l
  AND iSTATRECFIS.CODE = tdrec940.t$stat$l

  AND tcemm030.T$EUNT IN (:Filial)
  AND tdrec940.t$stat$l IN(:StatusRefFiscal)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) BETWEEN :EmissaoDE AND :EmissaoATE
  AND tdrec940.t$opfc$l IN (:COD_CFOP) 