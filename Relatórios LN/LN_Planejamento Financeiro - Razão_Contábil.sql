SELECT
  tfgld106.t$dcdt                      DATA_TRANS,
  Filial.COD_FILIAL                    NUME_FILIAL,
  tfgld106.t$dbcr                      NATU_LANÇTO,
  tfgld106.t$obat                      LOTE,
  tfgld106.t$osrn                      SEQ_LOTE,  
  CASE WHEN ( select count(*) 
                from baandb.ttfgld106301 a1
               where a1.t$otyp = tfgld106.t$otyp
                 and a1.t$odoc = tfgld106.t$odoc) = 2 
         THEN ( select a2.t$leac 
                  from baandb.ttfgld106301 a2
                 where a2.t$otyp = tfgld106.t$otyp
                   and a2.t$odoc = tfgld106.t$odoc
                   and a2.t$dbcr !=  tfgld106.t$dbcr)
       ELSE NULL 
   END                                 ID_CONTA_CONTRAPARTIDA,
  tfgld106.t$leac                      ID_CONTA_PRINCIPAL,
  tfgld008.t$desc                      NOME_DA_CONTA,
  tfgld106.t$dim1                      ID_CCUSTO,
  CASE WHEN tfgld106.t$dim1 = ' ' THEN
        ' '
  ELSE  tfgld010.t$desc END            NOME_CCUSTO,
  tfgld106.t$refr                      HIST_COMPLETO,
  
  CASE WHEN tfgld106.t$dbcr = 1 
         THEN tfgld106.t$amnt 
       ELSE 0 
   END                                 VLR_DEBITO,
   
  CASE WHEN tfgld106.t$dbcr = 2 
         THEN tfgld106.t$amnt 
       ELSE 0 
   END                                 VLR_CREDITO
  
FROM       baandb.ttfgld106301  tfgld106

 LEFT JOIN ( select distinct a.t$dim2 COD_FILIAL,
                    a.t$otyp,
                    a.t$odoc
               from baandb.ttfgld106301 a
              where a.t$dim2 !=  ' '
                ) Filial
        ON Filial.t$otyp = tfgld106.t$otyp
       AND Filial.t$odoc = tfgld106.t$odoc
       
INNER JOIN baandb.ttfgld100301 tfgld100
        ON tfgld100.t$year = tfgld106.t$oyer 
       AND tfgld100.t$btno = tfgld106.t$obat
     
 LEFT JOIN baandb.ttfgld008301  tfgld008
        ON tfgld008.t$leac = tfgld106.t$leac
    
 LEFT JOIN baandb.ttfgld010301  tfgld010
        ON tfgld106.t$typ1 = tfgld010.t$dtyp
       AND tfgld106.t$dim1 = tfgld010.t$dimx

WHERE tfgld106.t$dcdt BETWEEN (:DataDe) AND (:DataAte)

  AND Filial.COD_FILIAL BETWEEN CASE WHEN Trim(:CodFilialDe) IS NULL THEN ' ' 
                                     ELSE :CodFilialDe 
                                END
                                      AND :CodFilialAte
            
  AND tfgld106.t$leac BETWEEN  CASE WHEN Trim(:IdContaDe) IS NULL THEN ' ' 
                                     ELSE :IdContaDe
                               END
                                      AND :IdContaAte
  
  AND tfgld106.t$dim1 BETWEEN CASE WHEN Trim(:IdCCustoDe) IS NULL THEN ' ' 
                                   ELSE :IdCCustoDe 
                               END  
                                    AND :IDCCUSTOATE
