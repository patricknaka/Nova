SELECT
  tfgld106.t$dcdt                      DATA_TRANS,
  tfgld106.t$oyer                      ANO_FISCAL,
  tfgld106.T$FPRD                      PERI_FISCAL,
  Filial.COD_FILIAL                    NUME_FILIAL,
  CASE WHEN Filial.COD_FILIAL is NULL THEN
    ' '
  ELSE  tfgld010_2.t$desc END          NOME_FILIAL,
  tfgld106.t$dbcr                      NATU_LANÇTO,
  tfgld106.t$obat                      LOTE,
  tfgld106.t$osrn                      SEQ_LOTE,  
  
  CASE WHEN ( select count(*) 
                from baandb.ttfgld106301 a1
               where a1.t$otyp = tfgld106.t$otyp
                 and a1.t$odoc = tfgld106.t$odoc) = 2 
                THEN ( SELECT a2.t$leac 
                         FROM baandb.ttfgld106301 a2
                        WHERE a2.t$otyp = tfgld106.t$otyp
                          AND a2.t$odoc = tfgld106.t$odoc
                          AND a2.t$dbcr != tfgld106.t$dbcr )
       ELSE NULL 
  END                                  ID_CONTA_CONTRAPARTIDA,
  
  tfgld106.t$leac                      ID_CONTA_PRINCIPAL,
  tfgld008.t$desc                      NOME_DA_CONTA,
  tfgld106.t$dim1                      ID_CCUSTO,
  
  CASE WHEN tfgld106.t$dim1 = ' ' THEN ' '
       ELSE tfgld010.t$desc 
  END                                  NOME_CCUSTO,
  
  tfgld106.t$refr                      HIST_COMPLETO,
  
  CASE WHEN tfgld106.t$dbcr = 1 THEN tfgld106.t$amnt 
       ELSE 0 
  END                                  VLR_DEBITO,
   
  CASE WHEN tfgld106.t$dbcr = 2 THEN tfgld106.t$amnt 
       ELSE 0 
  END                                  VLR_CREDITO
  
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
     
 LEFT JOIN baandb.ttfgld008301 tfgld008
        ON tfgld008.t$leac = tfgld106.t$leac
    
 LEFT JOIN baandb.ttfgld010301 tfgld010
        ON tfgld106.t$typ1 = tfgld010.t$dtyp
       AND tfgld106.t$dim1 = tfgld010.t$dimx

  LEFT JOIN baandb.ttfgld010301 tfgld010_2
         ON tfgld010_2.t$dimx=Filial.COD_FILIAL
        AND tfgld010_2.t$dtyp=2
       
WHERE TRUNC(tfgld106.t$dcdt) BETWEEN (:DataDe) AND (:DataAte)

  AND NVL(Trim(Filial.COD_FILIAL), '000') IN (:Filial)
            
  AND tfgld106.t$leac BETWEEN  CASE WHEN Trim(:IdContaDe) IS NULL THEN ' ' 
                                     ELSE :IdContaDe
                               END
                                      AND :IdContaAte
  
  AND tfgld106.t$dim1 BETWEEN CASE WHEN Trim(:IdCCustoDe) IS NULL THEN ' ' 
                                   ELSE :IdCCustoDe 
                               END  
                                    AND :IdCCustoAte
