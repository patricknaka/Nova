SELECT 
  DISTINCT
    601                                           CODE_CIA,
    tccom130b.t$fovn$l                            NUME_FILIAL,
    cisli940.t$docn$l                             NUME_NF,
    cisli940.t$seri$l                             SERI_NF,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                                  DATA_EMISSA,
    cisli940.t$ccfo$l                             COD_CFOP,
    cisli245.t$slso                               ORDEM,
    tdsls400.t$sotp                               TIPO_ORD_VENDA_DEV,
    tccom130.t$fovn$l                             CPF_CNPJ,
    cisli940.t$itbn$l                             NOME_PARCEI,
    tccom130.t$cste                               UF_PARCEI,
    cisli940.t$amnt$l                             VALO_NFD,
    NVL(Usuario.t$logn$c, Log_Nfd.t$logn$c)       USUARIO,
    NVL(NOME_USUARIO.t$name, Nfd_user.t$name)     NOME_USUARIO,
    cisli940.t$cnfe$l                             CHAVE_NFD,
    cisli940.t$stat$l                             STATUS, iTABLE.DESC_STAT,
    cisli940.t$fire$l                             REF_FISCAL,
    NVL(cisli940d.t$docn$l, znmcs092.t$docn$c)    NOTA_NF_VENDA,  
    NVL(cisli940d.t$seri$l, znmcs092.t$seri$c)    SERI_NF_VENDA,
    NVL(cisli940d.t$cnfe$l, znmcs092.t$cnfe$c)    CHAVE_NF_VENDA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(NVL(cisli940d.t$date$l, znmcs092.t$trdt$c), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)    DATA_NF_VENDA,
  
    NVL(cisli940d.t$amnt$l, znmcs092.t$amnt$c)    VALO_NF_VENDA,
    cisli245d.t$slso                              NUME_OV,
    cisli940.t$fdty$l                             COD_TIPO_DOC_FISCAL,
    iTIPODOCFIS.DESCR                             DESC_TIPO_DOC_FISCAL,
    tdrec940.t$stat$l                             CODE_STAT_NF_ORIG,      -- Status ref fiscal
    iSTATRECFIS.DESCR                             DESCR_STAT_NF_ORIG,     -- Descric Staus Rf fiscal
    tdrec940.t$fire$l                             REFFIS_REC,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)    DATA_REC,
                                             
    tdrec940.t$logn$l                             USER_REC,
    cisli940d.t$stat$l                            STATUS_NFD,
    DESCR_STATUS_NFD.DS_SITUACAO_NF               DESCR_STATUS_NFD,
    Log_Nfe_P_WMS.t$logn$c                        PRONTO_PARA_ENVIAR_WMS,
    Nfe_User_P_WMS.t$name                         NOME_PRONTO_ENVIAR_WMS,
    Log_Nfe_A_WMS.t$logn$c                        AGUARDANDO_WMS,
    Nfe_User_A_WMS.t$name                         NOME_AGUARDANDO_WMS,
    Log_Nfe_AP.t$logn$c                           APROVADO    --Já grava o login da rede
--    Nfe_User_AP.t$name                            NOME_APROVADO
    
FROM       baandb.tcisli245601  cisli245       
 
INNER JOIN baandb.tcisli940601  cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l

INNER JOIN baandb.ttdsls401601     tdsls401
        ON tdsls401.t$orno   = cisli245.t$slso
       AND tdsls401.t$pono   = cisli245.t$pono
 
 LEFT JOIN baandb.tcisli245601  cisli245d
        ON cisli245d.t$fire$l = tdsls401.t$fire$l
       AND cisli245d.t$line$l = tdsls401.t$line$l
       AND cisli245d.t$fire$l !=  ' '

 LEFT JOIN baandb.tcisli940601  cisli940d
        ON cisli940d.t$fire$l = cisli245d.t$fire$l
     
INNER JOIN baandb.ttdsls400601  tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno
    
LEFT JOIN baandb.ttdrec947601  tdrec947
        ON tdrec947.t$ncmp$l = 601
       AND tdrec947.t$oorg$l = 1
       AND tdrec947.t$orno$l = tdsls401.t$orno
       AND tdrec947.t$pono$l = tdsls401.t$pono
       AND tdrec947.t$seqn$l = tdsls401.t$sqnb
       
LEFT JOIN baandb.ttdrec940601  tdrec940
        ON tdrec940.t$fire$l = tdrec947.t$fire$l
    
INNER JOIN baandb.ttcemm124601  tcemm124
        ON tcemm124.t$cwoc = cisli940.t$cofc$l

INNER JOIN baandb.ttcemm030601  tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid

INNER JOIN baandb.ttccom130601  tccom130
        ON tccom130.t$cadr = cisli940.t$itoa$l 
    
 LEFT JOIN ( SELECT znnfe002. t$fire$c, 
                    znnfe002.t$logn$c
               FROM baandb.tznnfe002601 znnfe002 
              WHERE znnfe002.t$datg$c = ( SELECT MAX(znnfe002A.t$datg$c)
                                            FROM baandb.tznnfe002601 znnfe002A
                                           WHERE znnfe002A.T$fire$c = znnfe002.T$fire$c ) ) Usuario
        ON Usuario.t$fire$c = cisli940.t$fire$l

 LEFT JOIN ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_STAT
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.stat'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
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
                                            and l1.t$cpac = l.t$cpac ) ) iTABLE
        ON iTABLE.CODE_STAT = cisli940.t$stat$l
             
 LEFT JOIN ( SELECT d.t$cnst COD, l.t$desc DESCR 
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'ci'
                AND d.t$cdom = 'sli.tdff.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
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
                                            and l1.t$cpac  =  l.t$cpac ) ) iTIPODOCFIS
        ON iTIPODOCFIS.COD = cisli940.t$fdty$l

 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
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
                                            and l1.t$cpac = l.t$cpac ) ) iSTATRECFIS
        ON iSTATRECFIS.CODE = tdrec940.t$stat$l
  
 LEFT JOIN ( SELECT l.t$desc  DS_SITUACAO_NF,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'ci'
                AND d.t$cdom = 'sli.stat'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
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
                                            and l1.t$cpac = l.t$cpac ) ) DESCR_STATUS_NFD
        ON DESCR_STATUS_NFD.t$cnst = cisli940d.t$stat$l
        
INNER JOIN baandb.ttccom130601 tccom130B
        ON tccom130B.t$cadr = cisli940.t$sfra$l

 LEFT JOIN baandb.tznmcs096601   znmcs096
        ON znmcs096.t$orno$c = cisli245.t$slso
       AND znmcs096.t$pono$c = cisli245.t$pono
       AND znmcs096.t$ncmp$c = 2
       AND ROWNUM = 1
       
 LEFT JOIN baandb.tznmcs092601   znmcs092
        ON znmcs092.t$ncmp$c = znmcs096.t$ncmp$c
       AND znmcs092.t$cref$c = znmcs096.t$cref$c
       AND znmcs092.t$cfoc$c = znmcs096.t$cfoc$c
       AND znmcs092.t$docn$c = znmcs096.t$docn$c
       AND znmcs092.t$seri$c = znmcs096.t$seri$c
       AND znmcs092.t$doty$c = znmcs096.t$doty$c
       AND znmcs092.t$trdt$c = znmcs096.t$trdt$c
       AND znmcs092.t$creg$c = znmcs096.t$creg$c
       AND znmcs092.t$cfov$c = znmcs096.t$cfov$c
       
 LEFT JOIN ( select ttaad200.t$user,
                    ttaad200.t$name
               from baandb.tttaad200000 ttaad200 ) NOME_USUARIO
        ON NOME_USUARIO.t$user = Usuario.t$logn$c
    
 LEFT JOIN ( SELECT a.t$fire$c,
                    a.t$stfa$c,
                    a.t$nfes$c,
                    a.t$logn$c
               FROM baandb.tznnfe011601 a ) Log_Nfd
        ON Log_Nfd.t$fire$c = cisli940.t$fire$l
       AND Log_Nfd.t$stfa$c = 5   --Impressa
       AND Log_Nfd.t$nfes$c = 2   --Transmitida
       
 LEFT JOIN ( select ttaad200.t$user,
                    ttaad200.t$name
               from baandb.tttaad200000 ttaad200 ) Nfd_User
        ON Nfd_User.t$user = Log_Nfd.t$logn$c
        
 LEFT JOIN ( SELECT a.t$fire$c,
                    a.t$stre$c,
                    a.t$logn$c,
                    max(a.t$data$c)
               FROM baandb.tznnfe011601 a
               GROUP BY a.t$fire$c,
                        a.t$stre$c,
                        a.t$logn$c ) Log_Nfe_P_WMS
        ON Log_Nfe_P_WMS.t$fire$c = tdrec940.t$fire$l
       AND Log_Nfe_P_WMS.t$stre$c = 201   --Pronto para enviar para WMS
       
 LEFT JOIN ( select ttaad200.t$user,
                    ttaad200.t$name
               from baandb.tttaad200000 ttaad200 ) Nfe_User_P_WMS
        ON Nfe_User_P_WMS.t$user = Log_Nfe_P_WMS.t$logn$c
        
LEFT JOIN ( SELECT a.t$fire$c,
                    a.t$stre$c,
                    a.t$logn$c,
                    max(a.t$data$c)
               FROM baandb.tznnfe011601 a
               GROUP BY a.t$fire$c,
                        a.t$stre$c,
                        a.t$logn$c ) Log_Nfe_A_WMS
        ON Log_Nfe_A_WMS.t$fire$c = tdrec940.t$fire$l
       AND Log_Nfe_A_WMS.t$stre$c = 200   --Aguardando WMS
       
 LEFT JOIN ( select ttaad200.t$user,
                    ttaad200.t$name
               from baandb.tttaad200000 ttaad200 ) Nfe_User_A_WMS
        ON Nfe_User_A_WMS.t$user = Log_Nfe_A_WMS.t$logn$c
        
LEFT JOIN ( SELECT a.t$fire$c,
                    a.t$stre$c,
                    a.t$logn$c,
                    max(a.t$data$c)
               FROM baandb.tznnfe011601 a
               GROUP BY a.t$fire$c,
                        a.t$stre$c,
                        a.t$logn$c ) Log_Nfe_AP
        ON Log_Nfe_AP.t$fire$c = tdrec940.t$fire$l
       AND Log_Nfe_AP.t$stre$c = 4   --Aprovado

-- LEFT JOIN ( select ttaad200.t$user,
--                    ttaad200.t$name
--               from baandb.tttaad200000 ttaad200 ) Nfe_User_AP
--        ON Nfe_User_AP.t$user = Log_Nfe_AP.t$logn$c

WHERE cisli940.t$fdty$l = 14
  AND tcemm124.t$dtyp = 1

  AND tcemm030.T$EUNT IN (:Filial)
  AND NVL(tdrec940.t$stat$l,0) IN(:StatusRefFiscal)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE)) 
      Between :EmissaoDE 
          And :EmissaoATE
  AND NVL(cisli940.t$ccfo$l, 'N/I') IN (:COD_CFOP)
