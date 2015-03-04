SELECT 
  DISTINCT
    tccom130.t$ftyp$l  TIPO_ENTIDADE,
    tccom130.t$fovn$l  ENTIDADE_FISCAL,
    tccom130.t$nama    RAZAO_SOCIAL,
    tccom966.t$stin$d  INSC_ESTADUAL,
    tccom966.t$ctin$d  INSC_MUNICIPAL,
    tccom130.t$enfe$l  EMAIL_NFE,
    tccom130.t$telp    TELEFONE,
    tccom130.t$ccty    PAIS,
    tccom130.t$cste    ESTADO,
    tccom130.t$ccit    CIDADE,
    tccom130.t$pstc    CEP,
    tccom130.t$user    CRIADO_POR,
        
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                       CRIADO_EM,
        
    tccom130.t$lmus    ALTERADO_POR,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                       ALTERADO_EM
  
FROM       baandb.ttccom100301 tccom100
      
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr

 LEFT JOIN baandb.ttccom966301 tccom966
        ON tccom966.t$comp$d = tccom130.t$fovn$l
  
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'),  
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
      BETWEEN NVL(:DtCadDe,  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 
                              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))   
          AND NVL(:DtCadAte, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 
                              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))  
      BETWEEN NVL(:DtAltDe,  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
                              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
          AND NVL(:DtAltAte, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
                              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))