SELECT 
 DISTINCT 
       301                      NUM_CIA,
       cisli940.t$cofc$l || ' - ' ||  cisli940.t$sfra$l       CNPJ_FILIAL,
       tdrec940.t$cofc$l        DEPTO_FILIAL,
       tcmcs065.t$dsca          DESR_FILIAL,
       tdrec941.t$fire$l        REF_FIS_ENTR,    

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 
                                DT_APRV,   
       tdrec940.t$docn$l        NR_NF,
       tdrec940.t$seri$l        SERIE_NF,
       tdrec940.t$fovn$l        CNPJ_FORNEC,
       tdrec940.t$sfbn$l        NOME_PARC,
       Trim(cisli941.t$item$l)  ITEM,
       cisli941.t$desc$l        DS_Item,
       tdrec941.t$gamt$l        VL_ITEM,
       tdrec941.t$qnty$l        QT_ITEM,
       cisli941.t$dqua$l        QT_DEV,
       cisli940.t$docn$l        NR_NFD,
       cisli940.t$seri$l        SERIE_NFD,
       whinh300.t$recd$c        RECDOC,
       tdrec940.t$lipl$l        PLACA,
       cisli940.t$cnfe$l        CHAVE,
       cisli940.t$amnt$l        Valor_Total_NF,
       NVL( ( select Trim(tttxt010.t$text)
             from baandb.ttttxt010301 tttxt010 
            where tttxt010.t$ctxt = cisli940.t$obse$l),' ') 
                                MOTIVO_DEVOLUCAO,
       znnfe011.t$logn$c || ' - '
       || login.t$name          USUARIO,
       znrec013.T$RFFA$c        REF_DEVOLUCAO

FROM       baandb.ttcmcs065301 tcmcs065

INNER JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.t$cofc$l = tcmcs065.t$cwoc

INNER JOIN baandb.ttdrec941301 tdrec941
        ON tdrec941.t$fire$l = tdrec940.t$fire$l
              
INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$fire$l = tdrec941.t$rfdv$c
       AND cisli941.t$line$l = tdrec941.t$lfdv$c

INNER JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli941.t$fire$l

LEFT JOIN  baandb.tznrec013301 znrec013
on znrec013.T$RFRE$C = cisli940.t$fire$l  

INNER JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid   = tdrec940.t$bpid$l

 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
     
 LEFT JOIN baandb.twhinh300301 whinh300
        ON whinh300.t$fire$c = tdrec940.t$fire$l
    
      Left Join  baandb.tznnfe011301 znnfe011
      on   znnfe011.t$fire$c = cisli940.t$fire$l   
      AND znnfe011.t$nfes$c = 2
      
    
LEFT JOIN (select a.t$user,
                    a.t$name   
               from baandb.tttaad200000 a) login
        ON login.t$user = znnfe011.t$logn$C   

WHERE cisli940.t$fdty$l = 5
  AND tdrec940.t$cofc$l IN (:Filial)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 'DD-MON-YYYY HH24:MI:SS'), 
      'DD-MON-YYYY HH24:MI:SS'),'GMT') AT time zone 'America/Sao_Paulo') AS DATE) ) 
	  BETWEEN :DataAprovacaoDe 
	      AND :DataAprovacaoAte
  AND ( (Trim(tdrec940.t$fovn$l) Like '%' || :CNPJ_FORN || '%') OR (:CNPJ_FORN IS NULL) )
