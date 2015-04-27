SELECT DISTINCT
    tfcmg101.t$btno         NUME_LOTE,
    tfcmg101.t$ninv         NUME_TITULO,
    tfcmg101.t$ttyp         CODE_TRANSAC,
    tfcmg101.t$dued$l       DATA_VENC,
    tccom130.t$fovn$l       CNPJ_FORN,
    Trim(tccom100.t$nama)   NOME_FORN,
    tfcmg101.t$amnt-
    tfcmg101.t$ramn$l -
    NVL(ACP200.JUROS,0)     VALO_PAGA,
    tfcmg101.t$amnt$l -
    NVL(ACP200.JUROS,0)     VALO_BRUTO,
    tfcmg101.t$post         CODE_LIQUID, 
    tfcmg101.t$paym         CODE_METPGTO,
 
    CASE WHEN tfcmg003.t$typp = 2 
           THEN 1 
         ELSE   2 
     END                    CODE_TIPOPGTO,
 
    tfcmg101.t$bank         NUME_BANCO,
    tfcmg011.t$agcd$l       CODE_AGENCIA,
    tfcmg001.t$bano         CODE_CONTA,
    tfcmg101.t$mopa$d       CODE_MODAL, 
    iTABLE.                 DESC_MODAL,
    tfcmg101.t$plan         DATA_PAGAM,
    tfcmg109.t$stpp         CODE_STATUS,
    iSTATUS.DESCR           DESCR_STATUS,
    tfcmg101.t$tadv         CODE_TIPO_ACONSELHAMENTO,

    ACONSELHAMENTO.         DESCR_TIPO_ACONSELHAMENTO,
    
    CASE WHEN tfcmg101.t$tadv=5 THEN     --Pagamento Adiantado
        CASE WHEN tfcmg103.t$paid=1 THEN
              5         --Pago
        ELSE  99  END   --Criado
    ELSE
      NVL(tfacp201.t$pyst$l, tfcmg104.t$stst) 
    END                        CODE_STAT_PRG,
    
    CASE WHEN tfcmg101.t$tadv=5 THEN     --Pagamento Adiantado
        CASE WHEN tfcmg103.t$paid=1 THEN
              'Pago'
        ELSE  'Criado'  END
    ELSE
        iPrgStat.DESCR 
    END                       DESCR_STAT_PRG,
 
    CASE WHEN tflcb230.t$send$d = 0 
           THEN tflcb230.t$stat$d
         ELSE tflcb230.t$send$d 
     END                    CODE_STAT_ARQ, 
    
    CASE WHEN tflcb230.t$send$d = 0 
           THEN iStatArq.DESCR
         ELSE iStatArq2.DESCR 
     END                    DESCR_STAT_ARQ
 
FROM       baandb.ttccom100301  tccom100

INNER JOIN baandb.ttccom130301  tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr

INNER JOIN baandb.ttfcmg101301  tfcmg101  
        ON tccom100.T$BPID   = tfcmg101.t$ifbp

INNER JOIN ( SELECT SUM(t.t$amnt) VALO_LOTE,
                    t.t$ninv,
                    t.t$ttyp,
                    t.t$btno
               FROM baandb.ttfcmg101301 t
           GROUP BY t.t$ninv,
                    t.t$ttyp,
                    t.t$btno ) LOTE
        ON LOTE.t$ninv = tfcmg101.t$ninv
       AND LOTE.t$ttyp = tfcmg101.t$ttyp
       AND LOTE.t$btno = tfcmg101.t$btno
  
INNER JOIN baandb.ttfcmg109301  tfcmg109
        ON tfcmg109.t$btno   = tfcmg101.t$btno

INNER JOIN baandb.ttfcmg003301  tfcmg003
        ON tfcmg003.t$paym   = tfcmg101.t$paym
    
 LEFT JOIN baandb.ttfcmg001301 tfcmg001 
        ON tfcmg001.t$bank = tfcmg101.t$bank
     
 LEFT JOIN baandb.ttfcmg011301 tfcmg011 
        ON tfcmg011.t$bank = tfcmg001.t$brch
     
 LEFT JOIN baandb.ttfacp201301 tfacp201
        ON tfacp201.t$ttyp = tfcmg101.t$ttyp
       AND tfacp201.t$ninv = tfcmg101.t$ninv
       AND tfacp201.t$schn = tfcmg101.t$schn
     
 LEFT JOIN baandb.ttfcmg104301 tfcmg104 
        ON tfcmg104.t$orno = tfcmg101.t$ninv
       AND tfcmg104.t$ifbp = tfcmg101.t$ifbp
    
 LEFT JOIN ( select   sum(a.t$amti) JUROS,
                      a.t$ttyp, 
                      a.t$ninv
             from     baandb.ttfacp200301  a
             where    a.t$tpay = 5    --correção 
             group by a.t$ttyp, a.t$ninv )  ACP200
       ON ACP200.t$ttyp = tfcmg101.t$ttyp
      AND ACP200.t$ninv = tfcmg101.t$ninv
        
 
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
               FROM baandb.ttflcb230301 a
              WHERE a.t$sern$d = ( select max(b.t$sern$d)
                                     from baandb.ttflcb230301 b
                                    where b.t$ttyp$d = a.t$ttyp$d
                                      and b.t$ninv$d = a.t$ninv$d
                                      and b.t$ptyp$d = a.t$ptyp$d
                                      and b.t$docn$d = a.t$docn$d )
           GROUP BY a.t$ttyp$d, 
                    a.t$ninv$d, 
                    a.t$ptyp$d, 
                    a.t$docn$d ) tflcb230
        ON tflcb230.t$ttyp$d = tfcmg101.t$ttyp
       AND tflcb230.t$ninv$d = tfcmg101.t$ninv
       AND tflcb230.t$ptyp$d = tfcmg101.t$ptyp
       AND tflcb230.t$docn$d = tfcmg101.t$pdoc
    
 LEFT JOIN ( SELECT 0                 CODE,
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
        ON iStatArq.CODE = NVL(CASE WHEN tflcb230.t$send$d = 0 
                                      THEN tflcb230.t$stat$d
                                    ELSE   tflcb230.t$send$d 
                                END, 0)
        
 LEFT JOIN ( SELECT 0                 CODE,
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
        ON iStatArq2.CODE = NVL(CASE WHEN tflcb230.t$send$d = 0 
                                       THEN tflcb230.t$stat$d
                                     ELSE   tflcb230.t$send$d 
                                   END, 0)

LEFT JOIN ( SELECT iDOMAIN.t$cnst CODE_MODAL, 
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
                                                and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE
        ON tfcmg101.t$mopa$d = iTABLE.CODE_MODAL
     
 LEFT JOIN ( SELECT d.t$cnst CODE,
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
        ON tfcmg109.t$stpp   = iSTATUS.CODE

 LEFT JOIN ( SELECT l.t$desc DESCR_TIPO_ACONSELHAMENTO,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.tadv'
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
                                            and l1.t$cpac = l.t$cpac ) ) ACONSELHAMENTO
        ON ACONSELHAMENTO.t$cnst = tfcmg101.t$tadv

  LEFT JOIN baandb.ttfcmg103301 tfcmg103
         ON tfcmg103.t$btno=tfcmg101.t$btno
        AND tfcmg103.t$ptbp=tfcmg101.t$ifbp
        AND ROWNUM=1
        
WHERE tfcmg101.t$plan BETWEEN :DataPagamentoDe AND :DataPagamentoAte
  AND tfcmg101.t$bank = NVL(:Banco,tfcmg101.t$bank)
  AND ((tfcmg011.t$agcd$l = :Agencia) or (:Agencia = '000'))
  AND ((tfcmg001.t$bano = :Conta) or (:Conta = '000'))  
  AND tfcmg101.t$mopa$d = (CASE WHEN :CodModal = 0 THEN tfcmg101.t$mopa$d ELSE :CodModal END)
  AND tfcmg101.t$paym = (CASE WHEN :TipoPagto = 'Todos' THEN tfcmg101.t$paym ELSE :TipoPagto END)
  AND tfcmg101.t$tadv IN (:TipoAconselhamento)
  AND tfcmg109.t$stpp IN (:Situacao)
  AND NVL(iPrgStat.DESCR, 'Título não vinculado') IN (:StatusPagto)
  AND NVL(CASE WHEN tflcb230.t$send$d = 0 
                 THEN tflcb230.t$stat$d
             ELSE     tflcb230.t$send$d 
           END, 0) IN (:StatusArquivo)
