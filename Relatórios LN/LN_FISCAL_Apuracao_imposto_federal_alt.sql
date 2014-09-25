SELECT
  tdrec940.t$idat$l                       DATA_EMISSAO,
  
  CASE WHEN tfacp200.t$balc = 0 
         THEN ( select max(p.t$docd) 
                  from baandb.ttfacp200301 p
                 where p.t$ttyp = tfacp200.t$ttyp 
                   and p.t$ninv = tfacp200.t$ninv )
       ELSE NULL 
   END                                    DATA_LIQUIDACAO,
  tccom130.t$fovn$l                       CNPJ_FORN,
  tccom100.t$nama                         NOME_FORN,
  tdrec940.t$fire$l                       NR,
  tdrec940.t$docn$l                       NF,
  tdrec940.t$seri$l                       SERIE,
  tdrec940.t$ttyp$l || 
  tdrec940.t$invn$l                       TITULO,
  tdrec940.t$tfda$l                       VALOR_TOTAL,
 
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 7 )        VALOR_ISS,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l IN (9,10) )  VALOR_IRRF,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 8 )        VALOR_INSS,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 5 )        VALOR_PIS,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 6 )        VALOR_COFINS,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 13 )       VALOR_CSLL_RETIDO,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 11 )       VALOR_PIS_RETIDO,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 12 )       VALOR_COFINS_RETIDO,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 14 )       VALOR_ISS_RETIDO,
    
  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 15 )       VALOR_INSS_RETIDO_PJ,

  ( SELECT tdrec949.t$amnt$l 
      FROM baandb.ttdrec949301 tdrec949
     WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
       AND tdrec949.t$brty$l = 17 )       VALOR_INSS_RETIDO_PF

FROM      baandb.ttdrec940301 tdrec940
LEFT JOIN baandb.ttccom100301 tccom100 
       ON tccom100.t$bpid   = tdrec940.t$bpid$l
LEFT JOIN BAANDB.ttccom130301 tccom130 
       ON tccom130.t$cadr=tccom100.t$cadr
LEFT JOIN baandb.ttfacp200301 tfacp200 
       ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
      AND tdrec940.t$invn$l = tfacp200.t$ninv
    
WHERE Trim(tdrec940.t$opfc$l) in ('1933', '2933', '1300')  
  AND Trunc(tdrec940.t$idat$l) Between :DataEmissaoDe AND :DataEmissaoAte