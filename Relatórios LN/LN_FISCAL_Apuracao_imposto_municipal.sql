SELECT 
  DISTINCT
    tcemm030.t$euca                                 FILIAL,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
                                                    DT_NR,
             
    tdrec940.t$fire$l                               NR,
    tccom100.t$fovn                                 CNPJ_FORN,
    tccom100.t$nama                                 NOME_FORN,
    tdrec940.t$docn$l                               NOTA_FISCAL,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
                                                    DATA_EMISSAO,
              
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
     tfacp301.payd                                  DT_VENC,
     
     CASE WHEN tfacp200.t$balc = 0 THEN 'LIQUIDADO' 
          ELSE 'ABERTO' 
      END                                           SIT_TITULO
   
FROM       baandb.ttccom100201 tccom100
          
INNER JOIN baandb.ttdrec940201 tdrec940
        ON tccom100.t$bpid = tdrec940.t$bpid$l
      
 LEFT JOIN baandb.ttfacp200201 tfacp200
        ON tfacp200.t$ttyp = tdrec940.t$ttyp$l
       AND tfacp200.t$ninv = tdrec940.t$invn$l
       AND tfacp200.t$lino = 0
 	  
 LEFT JOIN ( select a.t$ttyp, 
                    a.t$ninv,
                    min(a.t$payd) payd
               from baandb.ttfacp201201 a
           group by a.t$ttyp, a.t$ninv ) tfacp301
       ON tfacp301.t$ttyp=tdrec940.t$ttyp$l
      AND tfacp301.t$ninv=tdrec940.t$invn$l
	   
INNER JOIN baandb.ttcemm124201 tcemm124
        ON tcemm124.t$cwoc = tdrec940.t$cofc$l
		
 LEFT JOIN baandb.ttcemm030201 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid
  
WHERE TRIM(tdrec940.t$opfc$l) IN ('1933', '2933', '1300')
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataEmissaoDe AND :DataEmissaoAte