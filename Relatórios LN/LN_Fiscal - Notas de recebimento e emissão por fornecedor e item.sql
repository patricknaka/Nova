SELECT 
  DISTINCT 
    301                       NUME_CIA,
    Trim(tdrec941.t$item$l)   ITEM,
    tcemm030.t$euca           NUME_FILIAL,
    tdrec940.t$fire$l         NUME_RFISCAL, 
    tdrec940.t$stat$l         STAT_RFISCAL, 
                              DESC_STAT_RFISCAL, 
    tccom130.t$fovn$l         CPF_CNPJ_PARCEIRO, 
    tccom130.t$nama           DESC_PARCEIRO,
    tdrec940.t$docn$l         NUME_NOTA,
    tdrec940.t$seri$l         SERIE_NOTA, 
    tdrec940.t$tfda$l         VALOR_TOTAL, 
    tdrec940.t$opfc$l         NUME_CCFO,
    tdrec940.t$logn$l         ID_USUARIO,
    ttaad200.t$name           DESC_USUARIO,
    tdrec940.t$cnfe$l         CHAVE_ACESSO, 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                              DATA_RFISCAL,
    tdrec940.t$ptyp$l         TIPO_ORDEM,
    tdrec940.t$rfdt$l         CODE_TIPO_OPER,
  
    ( SELECT l.t$desc DS_TIPO_OPERACAO            
        FROM BAANDB.tttadv401000 d,
             BAANDB.tttadv140000 l      
       WHERE d.t$cpac = 'td'               
         AND d.t$cdom = 'rec.trfd.l'          
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
                                     and l1.t$cpac = l.t$cpac )
         AND d.t$cnst = tdrec940.t$rfdt$l )
                              DESCR_TIPO_OPERACAO
    
FROM      BAANDB.ttdrec940301 tdrec940 

LEFT JOIN BAANDB.tttaad200000 ttaad200
       ON ttaad200.t$user = tdrec940.t$logn$l,
 
          BAANDB.ttdrec941301 tdrec941,
          BAANDB.ttcemm030301 tcemm030,
          BAANDB.ttcemm124301 tcemm124,
          BAANDB.ttccom100301 tccom100

LEFT JOIN BAANDB.ttccom130301 tccom130
       ON tccom130.t$cadr = tccom100.t$cadr,
   
        ( SELECT d.t$cnst CODE_STAT, 
                 l.t$desc DESC_STAT_RFISCAL
            FROM BAANDB.tttadv401000 d, 
                 BAANDB.tttadv140000 l 
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
                                         and l1.t$cpac = l.t$cpac ) ) iTABLE
         
WHERE tccom100.t$bpid = tdrec940.t$bpid$l
  AND tdrec941.t$fire$l = tdrec940.t$fire$l
  AND tdrec940.t$stat$l = iTABLE.CODE_STAT
  AND tcemm124.t$cwoc = tdrec940.t$cofc$l 
  AND tcemm124.t$dtyp = 2 
  AND tcemm030.t$eunt = tcemm124.t$grid 
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) BETWEEN :RefFiscal_De AND :RefFiscal_Ate
  AND ( (Trim(tccom130.t$fovn$l) Like '%' || :CNPJ || '%') OR (:CNPJ IS NULL) )
  AND ( (Trim(tdrec941.t$item$l) Like '%' || :Item || '%') OR (:Item IS NULL) )