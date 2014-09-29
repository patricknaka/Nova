SELECT DISTINCT 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) 
                                          DATA_EMISSAO,
 ( select max(p.t$docd) 
     from baandb.ttfacp200301 p
    where tdrec940.t$ttyp$l = p.t$ttyp
      and tdrec940.t$invn$l = p.t$ninv
      and p.t$balc = 0 )                  DATA_LIQUIDACAO,
	  
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
       
LEFT JOIN baandb.ttccom130301 tccom130 
       ON tccom130.t$cadr=tccom100.t$cadr
           
WHERE Trim(tdrec940.t$opfc$l) in ('1933', '2933', '1300')  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)) Between :DataEmissaoDe AND :DataEmissaoAte