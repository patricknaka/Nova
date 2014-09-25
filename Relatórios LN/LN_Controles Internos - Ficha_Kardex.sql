SELECT
  301                        NUME_CIA,
  tcemm030.t$euca            NUME_FILIAL,
  tcemm030.T$EUNT            CHAVE_FILIAL,
  whinr110.t$cwar            CODE_CWAR,
  whinr110.t$item            CODE_ITEM,
  whinr110.t$seqn            SEQN_TRANS,
  whinr110.t$trdt            DATA_MOV,
  abs(whinr110.t$qstk)       QUAN_MOV,
  
  CASE WHEN Sum(whina113.t$amnt$1) is null 
         THEN Sum(whina115.t$amnt$1) 
       ELSE Sum(whina113.t$amnt$1) 
   END                       VALO_MOV,
   
  whinr110.t$kost            TIPO_TRANS, KOST.DESC_TRANS,
  whinr110.t$koor            TIPO_ORDEM, KOOR.DESC_ORDEM,
  
  CASE WHEN whina112.t$qstk <> 0.00 
         THEN 'E' 
       WHEN whina114.t$qstk <> 0.00 
         THEN 'S' 
   END                       CODE_ES,
   
  CASE WHEN whinr110.t$kost = 5 
         THEN cisli940.t$docn$l 
       ELSE tdrec940.t$docn$l 
   END                       DOC_FISCAL
  
FROM      baandb.twhinr110301 whinr110 

LEFT JOIN baandb.ttcemm112301 tcemm112 
       ON tcemm112.t$waid = whinr110.t$cwar
	   
LEFT JOIN baandb.ttcemm030301 tcemm030 
       ON tcemm030.t$eunt = tcemm112.t$grid
	   
LEFT JOIN baandb.twhina112301 whina112 
       ON whina112.t$ocmp = whinr110.t$ocmp
      AND whina112.t$koor = whinr110.t$koor
      AND whina112.t$orno = whinr110.t$orno
      AND whina112.t$pono = whinr110.t$pono
      AND whina112.t$srnb = whinr110.t$srnb
      AND whina112.t$cwar = whinr110.t$cwar
      AND whina112.t$item = whinr110.t$item
      AND whina112.t$trdt = whinr110.t$trdt
	  
LEFT JOIN baandb.twhina113301 whina113 
       ON whina113.t$item = whina112.t$item
      AND whina113.t$cwar = whina112.t$cwar
      AND whina113.t$trdt = whina112.t$trdt
      AND whina113.t$seqn = whina112.t$seqn
	  
LEFT JOIN baandb.twhina114301 whina114 
       ON whina114.t$ocmp = whinr110.t$ocmp
      AND whina114.t$koor = whinr110.t$koor
      AND whina114.t$orno = whinr110.t$orno
      AND whina114.t$pono = whinr110.t$pono
      AND whina114.t$srnb = whinr110.t$srnb
      AND whina114.t$item = whinr110.t$item
      AND whina114.t$cwar = whinr110.t$cwar
      AND whina114.t$ctdt = whinr110.t$trdt
	  
LEFT JOIN baandb.twhina115301 whina115 
       ON whina115.t$item = whina114.t$item
      AND whina115.t$cwar = whina114.t$cwar
      AND whina115.t$trdt = whina114.t$trdt
      AND whina115.t$sern = whina114.t$sern
	  
LEFT JOIN baandb.twhinh501301 whinh501 
       ON whinh501.t$orno = whinr110.t$orno
      AND whinh501.t$pono = whinr110.t$pono
	  
LEFT JOIN baandb.twhinh520301 whinh520 
       ON whinh520.t$orno = whinr110.t$orno
	   
LEFT JOIN baandb.tcisli245301 cisli245 
       ON cisli245.t$slso = whinr110.t$orno
      AND cisli245.t$pono = whinr110.t$pono
      AND cisli245.t$sqnb = whinr110.t$srnb    
	  
LEFT JOIN baandb.tcisli941301 cisli941 
       ON cisli941.t$fire$l = cisli245.t$fire$l
      AND cisli941.t$line$l = cisli245.t$line$l
	  
LEFT JOIN baandb.tcisli940301 cisli940 
       ON cisli940.t$fire$l = cisli941.t$fire$l
	   
LEFT JOIN baandb.ttdrec947301 tdrec947 
       ON tdrec947.t$orno$l = whinr110.t$orno
      AND tdrec947.t$pono$l = whinr110.t$pono
      AND tdrec947.t$seqn$l = whinr110.t$srnb    
	  
LEFT JOIN baandb.ttdrec941301 tdrec941
       ON tdrec941.t$fire$l = tdrec947.t$fire$l
      AND tdrec941.t$line$l =  tdrec947.t$line$l
	  
LEFT JOIN baandb.ttdrec940301 tdrec940 
       ON tdrec940.t$fire$l =  tdrec941.t$fire$l,
         
        ( SELECT d.t$cnst CODE_TRANS, 
                 l.t$desc DESC_TRANS
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac = 'tc' 
             AND d.t$cdom = 'kost'
             AND l.t$clan = 'p'
             AND l.t$cpac = 'tc'
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
                                         and l1.t$cpac = l.t$cpac ) ) KOST,
           
        ( SELECT d.t$cnst CODE_ORDEM, 
                 l.t$desc DESC_ORDEM
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac = 'tc' 
             AND d.t$cdom = 'koor'
             AND l.t$clan = 'p'
             AND l.t$cpac = 'tc'
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
                                         and l1.t$cpac = l.t$cpac ) ) KOOR

WHERE whinr110.t$kost > 0
  AND whinr110.t$kost = KOST.CODE_TRANS
  AND whinr110.t$koor = KOOR.CODE_ORDEM
  AND (   ( whinh501.t$cadj IS NULL AND whinh520.t$adrn IS NULL )
       OR ( whinh501.t$cadj <> 'CARGAI' )
       OR ( whinh520.t$adrn <> 'CARGA' )
       OR ( whinh501.t$cadj = 'CARGAI' AND whina112.t$qskt <> 0 )
       OR ( whinh520.t$adrn = 'CARGA'  AND whina112.t$qskt <> 0 )  )
    
  AND whinr110.t$trdt BETWEEN :DataMovDe AND :DataMovAte
  AND tcemm030.T$EUNT IN (:Filial)
  AND Trim(whinr110.t$item) = NVL(:CodItem, Trim(whinr110.t$item))

GROUP BY tcemm030.t$euca, 
         tcemm030.T$EUNT, 
         whinr110.t$cwar, 
         whinr110.t$item, 
         whinr110.t$seqn, 
         whinr110.t$trdt, 
         whinr110.t$qstk,
         whinr110.t$kost, 
         KOST.DESC_TRANS, 
         whinr110.t$koor, 
         KOOR.DESC_ORDEM,
         CASE WHEN whina112.t$qstk <> 0.00 
                THEN 'E' 
              WHEN whina114.t$qstk <> 0.00 
                THEN 'S' 
          END,
        CASE WHEN whinr110.t$kost = 5 
               THEN cisli940.t$docn$l 
             ELSE tdrec940.t$docn$l 
         END