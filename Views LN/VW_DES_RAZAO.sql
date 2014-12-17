SELECT
  tfgld106.t$leac                           CONTA,
  tfgld008.t$desc                           DESCRICAO,
  tfgld106.t$dcdt                           DATA,
  tfgld106.t$oyer                           ANO_FISCAL,
  tfgld106.T$FPRD                           PERI_FISCAL,
  tfgld106.t$obat                           LOTE,
  CONCAT(tfgld106.t$otyp,tfgld106.t$odoc)   DOCUMENTO,
  tfgld106.T$OCMP                           CIA,
  tfgld106.t$refr                           HISTORICO,
  CASE WHEN tfgld106.t$dbcr = 1 
         THEN tfgld106.t$amnt 
       ELSE 0 
   END                                      DEBITO,
   
  CASE WHEN tfgld106.t$dbcr = 2 
         THEN tfgld106.t$amnt 
       ELSE 0 
   END                                      CREDITO,
   tccom130.t$fovn$l                        CNPJ_CPF,
   tccom100.t$nama                          NOME
  
  FROM       baandb.ttfgld106301  tfgld106
        
  LEFT JOIN baandb.ttfgld008301  tfgld008
        ON tfgld008.t$leac = tfgld106.t$leac
        
  LEFT JOIN baandb.ttccom100301   tccom100
         ON tccom100.t$bpid=tfgld106.t$bpid
         
  LEFT JOIN baandb.ttccom130301 tccom130
         ON tccom130.t$cadr=tccom100.t$cadr
         
