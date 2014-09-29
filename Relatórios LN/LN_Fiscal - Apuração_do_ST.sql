SELECT
  DISTINCT 
    301                                                   NUME_CIA,
    ( select a.t$fovn$l 
        from baandb.ttccom130301 a 
       where a.t$cadr=tdrec940.t$sfra$l)                  NUME_FILIAL, 

    tdrec940.t$docn$l                                     NUME_NF,
    tdrec940.t$seri$l                                     CODE_SERIE, 
    tdrec940.t$stat$l                                     STAT_REFF, iTABLE.iDESC, 
    tdrec940.t$fovn$l                                     CNPJ_PARC, 
    tdrec940.t$fids$l                                     NOME_PARC,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)                                         
                                                          DATA_APROV,
    tdrec940.t$opfc$l                                     CODE_CFOP,
    tdrec947.t$orno$l                                     CODE_ORDEM,
    tdrec941.t$item$l                                     CODE_ITEM,
    tdrec941.t$dsca$l                                     DESC_ITEM, 
    tcibd936.t$frat$l                                     COD_NBM, 
    tdrec941.t$pric$l                                     PREC_ITEM, 
    tdrec941.t$qnty$l                                     QUAN_REC, 
    tdrec941.t$tamt$l                                     VALO_ITEM,
	
    ( SELECT tdrec942.t$sbas$l 
        FROM baandb.ttdrec942301 tdrec942 
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
         AND tdrec942.t$line$l=tdrec941.t$line$l 
         AND tdrec942.t$brty$l=1)                         BASE_ICMS, 
	
    ( SELECT tdrec942.t$rate$l 
        FROM baandb.ttdrec942301 tdrec942 
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
         AND tdrec942.t$line$l=tdrec941.t$line$l 
         AND tdrec942.t$brty$l=1)                         PERC_ICMS,
	
    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942301 tdrec942 
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
         AND tdrec942.t$line$l=tdrec941.t$line$l 
         AND tdrec942.t$brty$l=1)                         VALO_ICMS, 
	
    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942301 tdrec942 
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
         AND tdrec942.t$line$l=tdrec941.t$line$l 
         AND tdrec942.t$brty$l=2)                         VALO_ICMSST,

    ( SELECT tdrec949.t$isco$c 
        FROM baandb.ttdrec942301 tdrec942, 
             baandb.ttdrec949301 tdrec949
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
         AND tdrec949.t$fire$l=tdrec941.t$fire$l
         AND tdrec949.t$brty$l=2
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=2)                         FLAG_CONV,

    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942301 tdrec942 
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
         AND tdrec942.t$line$l=tdrec941.t$line$l 
         AND tdrec942.t$brty$l=3)                         VALO_IPI,
	
    tdrec940.t$fire$l                                     REFE_FISCAL,
    tccom130.t$cste                                       UF,
    tdrec940.t$rfdt$l                                     COD_TIPO_DOCFIS,
    tcmcs966.t$dsca$l                                     DESC_TIPO_DOCFIS,
    tdrec940.t$cnfe$l                                     CHAVE_ACESSO,
	
    nvl( (select sum(tdrec942.t$nmrg$l) 
            from baandb.ttdrec942301 tdrec942 
           WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
             AND tdrec942.t$line$l=tdrec941.t$line$l),0 ) MARGEM_LUCRO
			
FROM      baandb.ttdrec940301 tdrec940,

        ( SELECT iDOMAIN.t$cnst iCODE, iLABEL.t$desc iDESC 
            FROM baandb.tttadv401000 iDOMAIN, 
                 baandb.tttadv140000 iLABEL 
           WHERE iDOMAIN.t$cpac = 'td' 
             AND iDOMAIN.t$cdom = 'rec.stat.l'
             AND iLABEL.t$clan = 'p'
             AND iLABEL.t$cpac = 'td'
             AND iLABEL.t$clab = iDOMAIN.t$za_clab
             AND rpad(iDOMAIN.t$vers,4) ||
                 rpad(iDOMAIN.t$rele,2) ||
                 rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                       rpad(l1.t$rele,2) ||
                                                       rpad(l1.t$cust,4)) 
                                              from baandb.tttadv401000 l1 
                                             where l1.t$cpac = iDOMAIN.t$cpac 
                                               and l1.t$cdom = iDOMAIN.t$cdom )
             AND rpad(iLABEL.t$vers,4) ||
                 rpad(iLABEL.t$rele,2) ||
                 rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                      rpad(l1.t$rele,2) || 
                                                      rpad(l1.t$cust,4)) 
                                             from baandb.tttadv140000 l1 
                                            where l1.t$clab = iLABEL.t$clab 
                                              and l1.t$clan = iLABEL.t$clan 
                                              and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE,

          baandb.ttdrec941301 tdrec941,
          baandb.ttcibd001301 tcibd001 
		  
LEFT JOIN baandb.ttcibd936301 tcibd936
       ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l,

          baandb.ttdrec947301 tdrec947,
          baandb.ttccom100301 tccom100, 
          baandb.ttccom130301 tccom130,
          baandb.ttcemm030301 tcemm030, 
          baandb.ttcemm124301 tcemm124,
          baandb.ttcmcs966301 tcmcs966
		  
WHERE tdrec940.t$fire$l = tdrec941.t$fire$l
  AND tdrec941.t$fire$l = tdrec947.t$fire$l
  AND tdrec941.t$line$l = tdrec947.t$line$l
  AND tcibd001.t$item = tdrec941.t$item$l 
  AND tccom100.t$bpid = tdrec940.t$bpid$l 
  AND tccom130.t$cadr = tdrec940.t$ifad$l
  AND tcemm124.t$cwoc = tdrec940.t$cofc$l 
  AND tcemm124.t$dtyp = 2 
  AND tcemm030.t$eunt = tcemm124.t$grid
  AND tdrec940.t$stat$l = iTABLE.iCODE
  AND tcmcs966.t$fdtc$l=tdrec940.t$fdtc$l

  AND tcemm030.T$EUNT IN (:Filial)
  AND tdrec940.t$stat$l IN (:Status)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) BETWEEN :AprovacaoDe AND :AprovacaoAte
  AND tdrec940.t$opfc$l IN (:CFOP)
  
  AND (   (( SELECT  tdrec949.t$isco$c
               FROM  baandb.ttdrec942301 tdrec942, 
                     baandb.ttdrec949301 tdrec949
              WHERE  tdrec942.t$fire$l=tdrec941.t$fire$l 
                AND  tdrec949.t$fire$l=tdrec941.t$fire$l
                AND  tdrec949.t$brty$l=2
                AND  tdrec942.t$line$l=tdrec941.t$line$l
                AND  tdrec942.t$brty$l=2 )  = :Convenio ) 
        OR (:Convenio = 0)   )  