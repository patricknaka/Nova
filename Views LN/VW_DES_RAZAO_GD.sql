SELECT
  tfgld106.t$dcdt                      DT_TRANSACAO,
  tfgld106.t$oyer                      NR_ANO_FISCAL,
  tfgld106.T$FPRD                      NR_MES_FISCAL,
  -- Filial.COD_FILIAL                    NR_FILIAL,
  tfgld106.t$dim2					   NR_FILIAL,
  tfgld106.t$dbcr                      NR_NATUREZA_LANCAMENTO,
  tfgld106.t$obat                      NR_LOTE,
  tfgld106.t$otyp                      CD_TIPO_TRANSACAO,
  tfgld106.t$odoc					   NR_DOCUMENTO,				
  tfgld106.t$olin					   NR_LINHA_DOCUMENTO,
  CASE WHEN ( select count(*) 
                from baandb.ttfgld106301 a1
               where a1.t$otyp = tfgld106.t$otyp
                 and a1.t$odoc = tfgld106.t$odoc ) = 2 
         THEN ( select a2.t$leac 
                  from baandb.ttfgld106301 a2
                 where a2.t$otyp = tfgld106.t$otyp
                   and a2.t$odoc = tfgld106.t$odoc
                   and a2.t$dbcr != tfgld106.t$dbcr )
       ELSE NULL 
   END                                 NR_CONTA_CONTRAPARTIDA,
  
  tfgld106.t$leac                      NR_CONTA_PRINCIPAL,
   tfgld106.t$dim1                      NR_CENTRO_CUSTO,
   
   CASE WHEN tfgld106.t$dim3 = ' ' 
         THEN ' '
       ELSE ( SELECT tfgld010_3.t$desc
                FROM baandb.ttfgld010301 tfgld010_3
               WHERE tfgld010_3.t$dimx = tfgld106.t$dim3
                 AND tfgld010_3.t$dtyp = 3 )      
   END                                 NM_UNIDADE_NEGOCIO,
   
   CASE WHEN tfgld106.t$dim5 = ' ' 
         THEN ' '
       ELSE ( SELECT tfgld010_5.t$desc
                FROM baandb.ttfgld010301 tfgld010_5
               WHERE tfgld010_5.t$dimx = tfgld106.t$dim5
                 AND tfgld010_5.t$dtyp = 5 )      
   END                                 NM_BANDEIRA,
   
  tfgld106.t$dim6                      NM_PROJETO,
  
  tfgld106.t$desc$l                    DS_HISTORICO,
  tfgld106.t$refr                      DS_REFERENCIA,
  
  CASE WHEN tfgld106.t$dbcr = 1 
         THEN tfgld106.t$amnt 
       ELSE 0 
   END                                 VL_DEBITO,
   
  CASE WHEN tfgld106.t$dbcr = 2 
         THEN tfgld106.t$amnt 
       ELSE 0 
   END                                 VL_CREDITO
FROM       baandb.ttfgld106301  tfgld106

 -- LEFT JOIN ( select distinct 
                    -- a.t$dim2 COD_FILIAL,
                    -- a.t$otyp,
                    -- a.t$odoc
               -- from baandb.ttfgld106301 a
              -- where a.t$dim2 !=  ' ' ) Filial
        -- ON Filial.t$otyp = tfgld106.t$otyp
       -- AND Filial.t$odoc = tfgld106.t$odoc
       
INNER JOIN baandb.ttfgld100301 tfgld100
        ON tfgld100.t$year = tfgld106.t$oyer 
       AND tfgld100.t$btno = tfgld106.t$obat
     
 LEFT JOIN baandb.ttfgld008301 tfgld008
        ON tfgld008.t$leac = tfgld106.t$leac

WHERE  tfgld106.t$leac BETWEEN  '300000000' AND '399999999'
