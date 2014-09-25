SELECT DISTINCT
  ( SELECT tcemm030.t$euca 
      FROM baandb.ttcemm124201 tcemm124, 
           baandb.ttcemm030201 tcemm030
     WHERE tcemm124.t$cwoc = tdrec940.t$cofc$l 
       AND tcemm030.t$eunt = tcemm124.t$grid
       AND tcemm124.t$loco = 201 AND rownum = 1 ) FILIAL,
  
  tdrec940.t$date$l                               DT_NR,
  tdrec940.t$fire$l                               NR,
  tccom100.t$fovn                                 CNPJ_FORN,
  tccom100.t$nama                                 NOME_FORN,
  tdrec940.t$docn$l                               NOTA_FISCAL,
  tdrec940.t$idat$l                               DATA_EMISSAO,
  tdrec940.t$opfc$l                               CFOP,
  
  ( SELECT tdrec949.t$base$l
      FROM baandb.ttdrec949201 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 5 )                VALOR_PIS,
   
  ( SELECT tdrec949.t$base$l 
      FROM baandb.ttdrec949201 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 6 )                VALOR_COFINS,
   
  (SELECT tdrec949.t$base$l 
     FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
      AND tdrec949.t$brty$l = 13 )                VALOR_CSLL,
   
  ( SELECT tdrec949.t$base$l 
      FROM baandb.ttdrec949201 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 7 )                VALOR_ISS,
    
  ( SELECT tdrec949.t$base$l 
      FROM baandb.ttdrec949201 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 8 )                VALOR_INSS,
   
  ( SELECT tdrec949.t$base$l 
      FROM baandb.ttdrec949201 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l IN (9,10) )          VALOR_IRRF,
   
   tdrec940.t$tfda$l                              VALOR_TOTAL_NF,
   
   nvl( ( SELECT t.t$text 
            FROM baandb.ttttxt010201 t 
           WHERE t$clan = 'p' 
             AND t.t$ctxt = tdrec940.t$obse$l
             AND rownum = 1 ),' ' )               OBSERVACAO,
   tdrec940.t$logn$l                              USUSARIO,
   tfacp201.payd                                  DT_VENC,
   
   CASE WHEN tfacp200.t$balc = 0 THEN 'LIQUIDADO' 
        ELSE 'ABERTO' 
    END                                           SIT_TITULO

FROM      baandb.ttccom100201 tccom100,
          baandb.ttdrec940201 tdrec940
		  
LEFT JOIN baandb.ttfacp200201 tfacp200
       ON tfacp200.t$ttyp=tdrec940.t$ttyp$l
      AND tfacp200.t$ninv=tdrec940.t$invn$l
      AND tfacp200.t$lino=0
	  
LEFT JOIN ( select a.t$ttyp, 
                   a.t$ninv,
                   min(a.t$payd) payd
              from baandb.ttfacp201201 a
          group by a.t$ttyp, a.t$ninv ) tfacp201
      ON tfacp201.t$ttyp=tdrec940.t$ttyp$l
     AND tfacp201.t$ninv=tdrec940.t$invn$l
  
WHERE TRIM(tdrec940.t$opfc$l) IN ('1933', '2933', '1300')
  AND tccom100.t$bpid   = tdrec940.t$bpid$l

  AND Trunc(tdrec940.t$idat$l) Between :DataEmissaoDe 
  AND :DataEmissaoAte