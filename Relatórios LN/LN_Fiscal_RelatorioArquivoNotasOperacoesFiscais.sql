SELECT 
  DISTINCT 
  301                CODE_CIA, 
  tcemm122.T$grid    UNID_EMPRESARIAL, 
  tccom130.t$fovn$L  NUME_FILIAL,
                       
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l,  
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)  
                       DATA_APROV, 
                       
    tdrec940.t$fire$l  REFE_FISCAL,                  
    tdrec940.t$stat$l  STAT_REFFISC,   
    DESC_DOMAIN_STAT.  DESC_STAT, 
    tdrec940.t$fovn$l  CNPJ_FORN, 
    tdrec940.t$fids$l  NOME_PARCE, 
    tdrec940.t$opfc$l  NUME_CFOP, 
    tdrec940.t$docn$l  NUME_NF, 
    tdrec940.t$seri$l  SERI_NF, 
    tdrec940.t$tfda$l  VALO_TOTAL, 
    whinh300.t$recd$c  RECDOC_WMS, 
    tdrec940.t$lipl$l  PLAC_VEIC, 
    tdrec940.t$logn$l  CODE_USUA, 
    tdrec940.t$logn$l                             USER_REC,
    Log_Nfe_P_WMS.t$logn$c                        PRONTO_PARA_ENVIAR_WMS,
    Log_Nfe_A_WMS.t$logn$c                        AGUARDANDO_WMS,
    Log_Nfe_AP.t$logn$c                           APROVADO,
    tdrec940.t$cnfe$l  CHAV_ACESS, 
    tdrec940.t$fdtc$l  COD_TIPO_DOCFIS, 
    tcmcs966.t$dsca$l  DESC_TIPO_DOCFIS 
       
FROM       baandb.ttdrec940301   tdrec940   
 
INNER JOIN baandb.ttdrec941301  tdrec941
        ON tdrec941.T$FIRE$L = tdrec940.T$FIRE$L

 LEFT JOIN baandb.twhinh300301  whinh300 
        ON whinh300.t$fire$c = tdrec940.t$fire$l
        
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tdrec940.t$sfra$l
	
-- MMF.sn
INNER JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$cadr = tccom130.t$cadr
-- MMF.en

INNER JOIN baandb.ttcemm122301  tcemm122
        ON tcemm122.t$bupa = tccom100.t$bpid
--        ON tcemm122.t$bupa = tdrec940.t$sfra$l
            
 LEFT JOIN ( SELECT d.t$cnst DESC_DOMAIN_STAT,  
                    l.t$desc DESC_STAT  
               FROM baandb.tttadv401000 d,  
                    baandb.tttadv140000 l  
              WHERE d.t$cpac = 'td'  
                AND d.t$cdom = 'rec.stat.l' 
                AND l.t$clan = 'p' 
                AND l.t$cpac = 'td' 
                AND l.t$clab = d.t$za_clab 
                AND rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4))  
                                           from baandb.tttadv401000 l1  
                                          where l1.t$cpac = d.t$cpac  
                                            and l1.t$cdom = d.t$cdom ) 
                AND rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) ||  
                                                    rpad(l1.t$cust,4))  
                                           from baandb.tttadv140000 l1  
                                          where l1.t$clab = l.t$clab  
                                            and l1.t$clan = l.t$clan  
                                            and l1.t$cpac = l.t$cpac ) ) DESC_DOMAIN_STAT
        ON tdrec940.t$stat$l = DESC_DOMAIN_STAT.DESC_DOMAIN_STAT
	   
 LEFT JOIN baandb.ttcmcs966301 tcmcs966
        ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l
        

     
    
 LEFT JOIN ( select a.t$fire$c,
                    a.t$stfa$c,
                    a.t$nfes$c,
                    a.t$logn$c
               from baandb.tznnfe011301 a ) Log_Nfd
        ON Log_Nfd.t$fire$c = tdrec940.t$fire$l
       AND Log_Nfd.t$stfa$c = 5   --Impressa
       AND Log_Nfd.t$nfes$c = 2   --Transmitida
       
 LEFT JOIN ( select ttaad200.t$user,
                    ttaad200.t$name
               from baandb.tttaad200000 ttaad200 ) Nfd_User
        ON Nfd_User.t$user = Log_Nfd.t$logn$c
        
 LEFT JOIN ( select a.t$fire$c,
                    a.t$stre$c,
                    a.t$logn$c,
                    max(a.t$data$c)
               from baandb.tznnfe011301 a
           group by a.t$fire$c,
                    a.t$stre$c,
                    a.t$logn$c ) Log_Nfe_P_WMS
        ON Log_Nfe_P_WMS.t$fire$c = tdrec940.t$fire$l
       AND Log_Nfe_P_WMS.t$stre$c = 201   --Pronto para enviar para WMS
       
 LEFT JOIN ( select ttaad200.t$user,
                    ttaad200.t$name
               from baandb.tttaad200000 ttaad200 ) Nfe_User_P_WMS
        ON Nfe_User_P_WMS.t$user = Log_Nfe_P_WMS.t$logn$c
        
LEFT JOIN ( select a.t$fire$c,
                   a.t$stre$c,
                   a.t$logn$c,
                   max(a.t$data$c)
              from baandb.tznnfe011301 a
          group by a.t$fire$c,
                   a.t$stre$c,
                   a.t$logn$c ) Log_Nfe_A_WMS
        ON Log_Nfe_A_WMS.t$fire$c = tdrec940.t$fire$l
       AND Log_Nfe_A_WMS.t$stre$c = 200   --Aguardando WMS
       
 LEFT JOIN ( select ttaad200.t$user,
                    ttaad200.t$name
               from baandb.tttaad200000 ttaad200 ) Nfe_User_A_WMS
        ON Nfe_User_A_WMS.t$user = Log_Nfe_A_WMS.t$logn$c
        

 LEFT JOIN ( select a.t$fire$c,
                   a.t$stre$c,
                   a.t$logn$c,
                   max(a.t$data$c)
              from baandb.tznnfe011301 a
          group by a.t$fire$c,
                   a.t$stre$c,
                   a.t$logn$c ) Log_Nfe_AP
        ON Log_Nfe_AP.t$fire$c = tdrec940.t$fire$l
       AND Log_Nfe_AP.t$stre$c = 4   --Aprovado    
				
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l,  
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
         AT time zone 'America/Sao_Paulo') AS DATE)) 
      between :DtAprovacaoDe 
          and :DtAprovacaoAte 
  AND tcemm122.T$grid IN (:Filial) 
  AND tdrec940.t$stat$l IN (:StatusRefFiscal) 
  AND tdrec940.t$opfc$l IN (:COD_CFOP) 
  AND NVL(Trim(tdrec940.t$fdtc$l), '000') IN (:TipoDocFiscal) 

ORDER BY Trunc(DATA_APROV), 
         REFE_FISCAL
