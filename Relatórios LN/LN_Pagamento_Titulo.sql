SELECT
    tfcmg101.t$btno         NUME_LOTE,
 
    ( SELECT SUM(t.t$amnt) 
        FROM baandb.ttfcmg101201 t
       WHERE t.t$ninv = tfcmg101.t$ninv
         AND t.t$ttyp = tfcmg101.t$ttyp
         AND t.t$btno = tfcmg101.t$btno ) 
                            VALO_LOTE,
       
    tfcmg101.t$ninv         NUME_TITULO,
    tfcmg101.t$ttyp         CODE_TRANSAC,
    tfcmg101.t$dued$l       DATA_VENC,
    tccom130.t$fovn$l       CNPJ_FORN,
    tccom100.t$nama         NOME_FORN,
    tfcmg101.t$amnt-
    tfcmg101.t$ramn$l       VALO_PAGA,
    tfcmg101.t$post         CODE_LIQUID, 
    tfcmg101.t$paym         CODE_METPGTO,
 
    CASE WHEN tfcmg003.t$typp = 2 THEN  1 
      ELSE  2 
    END                     CODE_TIPOPGTO,
 
    tfcmg101.t$bank         NUME_BANCO,
    tfcmg011.t$agcd$l       CODE_AGENCIA,
    tfcmg001.t$bano         CODE_CONTA,
    tfcmg101.t$mopa$d       CODE_MODAL, iTABLE.DESC_MODAL,
    tfcmg101.t$plan         DATA_PAGAM,
    tfcmg109.t$stpp         CODE_STATUS,
    iSTATUS.DESCR           DESCR_STATUS,
    tfcmg101.t$tadv         CODE_TIPO_ACONSELHAMENTO,

    ( SELECT l.t$desc DS_MODALIDADE
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'tf'
         AND d.t$cdom = 'cmg.tadv'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'tf'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = tfcmg101.t$tadv 
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
                                     and l1.t$cpac = l.t$cpac ) )
                            DESCR_TIPO_ACONSELHAMENTO,
       
    nvl(tfacp201.t$pyst$l, tfcmg104.t$stst) 
                            CODE_STAT_PRG,
       
    iPrgStat.DESCR          DESCR_STAT_PRG,
    CASE WHEN tflcb230.t$send$d = 0 THEN
      tflcb230.t$stat$d
    ELSE tflcb230.t$send$d END  CODE_STAT_ARQ, 
    
    CASE WHEN tflcb230.t$send$d = 0 THEN
      iStatArq.DESCR
    ELSE iStatArq2.DESCR END    DESCR_STAT_ARQ
 
FROM      baandb.ttccom100201  tccom100

INNER JOIN baandb.ttccom130201  tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr

INNER JOIN baandb.ttfcmg101201  tfcmg101  
        ON tccom100.T$BPID   = tfcmg101.t$ifbp
    
INNER JOIN baandb.ttfcmg109201  tfcmg109
        ON tfcmg109.t$btno   = tfcmg101.t$btno

INNER JOIN baandb.ttfcmg003201  tfcmg003
        ON tfcmg003.t$paym   = tfcmg101.t$paym
    
 LEFT JOIN baandb.ttfcmg001201 tfcmg001 
        ON tfcmg001.t$bank = tfcmg101.t$bank
     
 LEFT JOIN baandb.ttfcmg011201 tfcmg011 
        ON tfcmg011.t$bank = tfcmg001.t$brch
     
 LEFT JOIN baandb.ttfacp201201 tfacp201 
        ON tfacp201.t$ttyp = tfcmg101.t$ttyp
       AND tfacp201.t$ninv = tfcmg101.t$ninv
       AND tfacp201.t$schn = tfcmg101.t$schn
     
 LEFT JOIN baandb.ttfcmg104201 tfcmg104 
        ON tfcmg104.t$orno = tfcmg101.t$ninv
       AND tfcmg104.t$ifbp = tfcmg101.t$ifbp
    
 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'acp.pyst.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
       
              UNION
     
             SELECT d.t$cnst*10 CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.stst'
                AND l.t$clab = d.t$za_clab
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iPrgStat
        ON iPrgStat.CODE = nvl(tfacp201.t$pyst$l, tfcmg104.t$stst*10)
     
 LEFT JOIN ( SELECT a.t$ttyp$d, 
                    a.t$ninv$d, 
                    a.t$ptyp$d, 
                    a.t$docn$d,
                    max(a.t$stat$d) t$stat$d,
                    max(a.t$send$d) t$send$d
               FROM baandb.ttflcb230201 a
              WHERE a.t$sern$d = ( select max(b.t$sern$d)
                                     from baandb.ttflcb230201 b
                                    where b.t$ttyp$d = a.t$ttyp$d
                                      and b.t$ninv$d = a.t$ninv$d
                                      and b.t$ptyp$d = a.t$ptyp$d
                                      and b.t$docn$d = a.t$docn$d )
           GROUP BY a.t$ttyp$d, a.t$ninv$d, a.t$ptyp$d, a.t$docn$d ) tflcb230
        ON tflcb230.t$ttyp$d = tfcmg101.t$ttyp
       AND tflcb230.t$ninv$d = tfcmg101.t$ninv
       AND tflcb230.t$ptyp$d = tfcmg101.t$ptyp
       AND tflcb230.t$docn$d = tfcmg101.t$pdoc
    
 LEFT JOIN ( SELECT 0                         CODE,
                    'Não vinculado'   DESCR
               FROM Dual
             
              UNION
			  
             SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.stat.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatArq 
        ON iStatArq.CODE = NVL(tflcb230.t$stat$d, 0)  
        
         LEFT JOIN ( SELECT 0                         CODE,
                    'Não vinculado'   DESCR
               FROM Dual
             
              UNION
			  
             SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.stat.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatArq2 
        ON iStatArq2.CODE = NVL(tflcb230.t$send$d, 0),     
        
        
           ( SELECT iDOMAIN.t$cnst CODE_MODAL, 
                    iLABEL.t$desc DESC_MODAL  
               FROM baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              WHERE iDOMAIN.t$cpac = 'tf' 
                AND iDOMAIN.t$cdom = 'cmg.mopa.d'
                AND iLABEL.t$clan = 'p'
                AND iLABEL.t$cpac = 'tf'
                AND iLABEL.t$clab = iDOMAIN.t$za_clab
                AND rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4)) 
                                                 from baandb.tttadv401000 l1 
                                                where l1.t$cpac = iDOMAIN.t$cpac 
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                AND rpad(iLABEL.t$vers,4) ||
                    rpad(iLABEL.t$rele,2) ||
                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4)) 
                                                from baandb.tttadv140000 l1 
                                               where l1.t$clab = iLABEL.t$clab 
                                                 and l1.t$clan = iLABEL.t$clan 
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE,
     
           ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR,
                    'CAP' CD_MODULO
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.stpp'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iSTATUS

WHERE tfcmg101.t$mopa$d = iTABLE.CODE_MODAL
  AND tfcmg109.t$stpp   = iSTATUS.CODE
  
  AND tfcmg101.t$plan BETWEEN :DataPagamentoDe AND :DataPagamentoAte
  AND tfcmg101.t$bank = NVL(:Banco,tfcmg101.t$bank)
  AND ((tfcmg011.t$agcd$l = :Agencia) or (:Agencia = '000'))
  AND ((tfcmg001.t$bano = :Conta) or (:Conta = '000'))  
  AND tfcmg101.t$mopa$d = (CASE WHEN :CodModal = 0 THEN tfcmg101.t$mopa$d ELSE :CodModal END)
  AND tfcmg101.t$paym = (CASE WHEN :TipoPagto = 'Todos' THEN tfcmg101.t$paym ELSE :TipoPagto END)
  AND tfcmg101.t$tadv IN (:TipoAconselhamento)
  AND tfcmg109.t$stpp IN (:Situacao)
  AND iPrgStat.DESCR IN (:StatusPagto)
  AND NVL(tflcb230.t$stat$d, 0) IN (:StatusArquivo)  
