SELECT
  DISTINCT
    tfcmg101.t$btno         NR_LOTE,
    tfcmg101.t$ttyp         TRANS,
    tfcmg101.t$ninv         TITULO,
	tfcmg102.t$lino			LINHA,
    tfcmg101.t$plan         DATA_PAGTO,
    tccom130.t$fovn$l       CNPJ_PN,
    Trim(tccom100.t$nama)   R_SOCIAL_PN,
    tfcmg102.t$leac         CONTA_CONTABIL,
    tfgld008.t$desc         DESCRICAO_CONTA,
    tfcmg101.t$amnt$l       VALO_BRUTO,
	tfcmg102.t$amnt			VALO_A_PAGAR,
    iPrgStat.DESCR          SITUACAO,
    iSTATUS.DESCR           STATUS_PAGTO,
    iStatArq.DESCR          STATUS_ARQUIVO,
    tfcmg101.t$paym         METODO_PAGTO,
    tfcmg104.t$ptyp || ' '
    || tfcmg104.t$pdoc      DOCUMENTO_PAGAMENTO,
    ACONSELHAMENTO.         DESCR_TIPO_ACONSELHAMENTO,
    tfcmg104.t$docn$l       ID_WORKFLOW,
    tfcmg104.t$seri$l       IMPOSTO,
    tfcmg109.t$user         LOGIN,
    ttaad200.t$name         USUARIO,
    Trim(tfcmg104.t$refr)   REFERENCIA,
    tfcmg104.t$bkre$l       BANCO_PAGTO,
    tfcmg001.t$desc         DESC_BANCO

FROM       baandb.ttfcmg101301 tfcmg101

INNER JOIN baandb.ttccom100301 tccom100  
        ON tccom100.T$BPID = tfcmg101.t$ifbp
        
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
  
INNER JOIN baandb.ttfcmg109301 tfcmg109
        ON tfcmg109.t$btno = tfcmg101.t$btno

 LEFT JOIN baandb.ttfacp201301 tfacp201
        ON tfacp201.t$ttyp = tfcmg101.t$ttyp
       AND tfacp201.t$ninv = tfcmg101.t$ninv
       AND tfacp201.t$schn = tfcmg101.t$schn
     
 LEFT JOIN baandb.ttfcmg104301 tfcmg104 
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
     
             SELECT d.t$cnst * 10 CODE,
                    l.t$desc      DESCR
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
        ON iPrgStat.CODE = nvl(tfacp201.t$pyst$l, tfcmg104.t$stst * 10)
     
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

 LEFT JOIN ( select a.t$user,
                    a.t$name
               from baandb.tttaad200000 a ) ttaad200
        ON ttaad200.t$user = tfcmg109.t$user
        
  LEFT JOIN baandb.ttfcmg001301 tfcmg001
         ON tfcmg001.t$bank = tfcmg104.t$bkre$l
         
  LEFT JOIN baandb.ttfcmg102301 tfcmg102
         ON tfcmg102.t$tpay = 1
        AND tfcmg102.t$ifbp = tfcmg101.t$ifbp
        AND tfcmg102.t$orno = tfcmg101.t$ninv
        AND tfcmg102.t$srno = tfcmg101.t$srno
        
  LEFT JOIN baandb.ttfgld008301 tfgld008
         ON tfgld008.t$leac = tfcmg102.t$leac
         
WHERE tfcmg101.t$tadv = 7
  AND tfcmg101.t$plan
      BETWEEN :DataPgtoDe
          AND :DataPgtoAte
  AND tfcmg101.t$paym = (CASE WHEN :TipoPagto = 'Todos' THEN tfcmg101.t$paym ELSE :TipoPagto END)
  AND ( (:PN = '000') OR (tccom100.t$bpid = :PN) )
  AND NVL(TRIM(iPrgStat.DESCR), 'Não cadastrado') IN (:Situacao)
  AND NVL(CASE WHEN tflcb230.t$send$d = 0 
                 THEN tflcb230.t$stat$d
               ELSE   tflcb230.t$send$d 
           END, 0) IN (:StatusArquivo)
  AND ( (:WorkFlowTodos = 0) OR (tfcmg104.t$docn$l in (:WorkFlow) AND (:WorkFlowTodos = 1)) )

ORDER BY  DATA_PAGTO, NR_LOTE, TITULO



=

" SELECT  " &
"   DISTINCT  " &
"     tfcmg101.t$btno         NR_LOTE,  " &
"     tfcmg101.t$ttyp         TRANS,  " &
"     tfcmg101.t$ninv         TITULO,  " &
" 	  tfcmg102.t$lino			LINHA,  " &
"     tfcmg101.t$plan         DATA_PAGTO,  " &
"     tccom130.t$fovn$l       CNPJ_PN,  " &
"     Trim(tccom100.t$nama)   R_SOCIAL_PN,  " &
"     tfcmg102.t$leac         CONTA_CONTABIL,  " &
"     tfgld008.t$desc         DESCRICAO_CONTA,  " &
"     tfcmg101.t$amnt$l       VALO_BRUTO,  " &
" 	  tfcmg102.t$amnt			VALO_A_PAGAR,  " &
"     iPrgStat.DESCR          SITUACAO,  " &
"     iSTATUS.DESCR           STATUS_PAGTO,  " &
"     iStatArq.DESCR          STATUS_ARQUIVO,  " &
"     tfcmg101.t$paym         METODO_PAGTO,  " &
"     tfcmg104.t$ptyp || ' '  " &
"     || tfcmg104.t$pdoc      DOCUMENTO_PAGAMENTO,  " &
"     ACONSELHAMENTO.         DESCR_TIPO_ACONSELHAMENTO,  " &
"     tfcmg104.t$docn$l       ID_WORKFLOW,  " &
"     tfcmg104.t$seri$l       IMPOSTO,  " &
"     tfcmg109.t$user         LOGIN,  " &
"     ttaad200.t$name         USUARIO,  " &
"     Trim(tfcmg104.t$refr)   REFERENCIA,  " &
"     tfcmg104.t$bkre$l       BANCO_PAGTO,  " &
"     tfcmg001.t$desc         DESC_BANCO  " &
"  " &
" FROM       baandb.ttfcmg101" + Parameters!Compania.Value +  " tfcmg101  " &
"  " &
" INNER JOIN baandb.ttccom100" + Parameters!Compania.Value +  " tccom100  " &
"         ON tccom100.T$BPID = tfcmg101.t$ifbp  " &
"  " &
" INNER JOIN baandb.ttccom130" + Parameters!Compania.Value +  " tccom130  " &
"         ON tccom130.t$cadr = tccom100.t$cadr  " &
"  " &
" INNER JOIN baandb.ttfcmg109" + Parameters!Compania.Value +  " tfcmg109  " &
"         ON tfcmg109.t$btno = tfcmg101.t$btno  " &
"  " &
"  LEFT JOIN baandb.ttfacp201" + Parameters!Compania.Value +  " tfacp201  " &
"         ON tfacp201.t$ttyp = tfcmg101.t$ttyp  " &
"        AND tfacp201.t$ninv = tfcmg101.t$ninv  " &
"        AND tfacp201.t$schn = tfcmg101.t$schn  " &
"  " &
"  LEFT JOIN baandb.ttfcmg104" + Parameters!Compania.Value +  " tfcmg104  " &
"         ON tfcmg104.t$orno = tfcmg101.t$ninv  " &
"        AND tfcmg104.t$ifbp = tfcmg101.t$ifbp  " &
"  " &
"  LEFT JOIN ( SELECT d.t$cnst CODE,  " &
"                     l.t$desc DESCR  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'acp.pyst.l'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac )  " &
"  " &
"               UNION  " &
"  " &
"              SELECT d.t$cnst * 10 CODE,  " &
"                     l.t$desc      DESCR  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.stst'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) iPrgStat  " &
"         ON iPrgStat.CODE = nvl(tfacp201.t$pyst$l, tfcmg104.t$stst * 10)  " &
"  " &
"  LEFT JOIN ( SELECT a.t$ttyp$d,  " &
"                     a.t$ninv$d,  " &
"                     a.t$ptyp$d,  " &
"                     a.t$docn$d,  " &
"                     max(a.t$stat$d) t$stat$d,  " &
"                     max(a.t$send$d) t$send$d  " &
"                FROM baandb.ttflcb230" + Parameters!Compania.Value +  " a  " &
"               WHERE a.t$sern$d = ( select max(b.t$sern$d)  " &
"                                      from baandb.ttflcb230" + Parameters!Compania.Value +  " b  " &
"                                     where b.t$ttyp$d = a.t$ttyp$d  " &
"                                       and b.t$ninv$d = a.t$ninv$d  " &
"                                       and b.t$ptyp$d = a.t$ptyp$d  " &
"                                       and b.t$docn$d = a.t$docn$d )  " &
"            GROUP BY a.t$ttyp$d,  " &
"                     a.t$ninv$d,  " &
"                     a.t$ptyp$d,  " &
"                     a.t$docn$d ) tflcb230  " &
"         ON tflcb230.t$ttyp$d = tfcmg101.t$ttyp  " &
"        AND tflcb230.t$ninv$d = tfcmg101.t$ninv  " &
"        AND tflcb230.t$ptyp$d = tfcmg101.t$ptyp  " &
"        AND tflcb230.t$docn$d = tfcmg101.t$pdoc  " &
"  " &
"  LEFT JOIN ( SELECT 0                 CODE,  " &
"                     'Não vinculado'   DESCR  " &
"                FROM Dual  " &
"  " &
"               UNION  " &
"  " &
"              SELECT d.t$cnst CODE,  " &
"                     l.t$desc DESCR  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.stat.l'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                    rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) iStatArq  " &
"         ON iStatArq.CODE = NVL(CASE WHEN tflcb230.t$send$d = 0  " &
"                                       THEN tflcb230.t$stat$d  " &
"                                     ELSE   tflcb230.t$send$d  " &
"                                 END, 0)  " &
"  " &
"  LEFT JOIN ( SELECT d.t$cnst CODE,  " &
"                     l.t$desc DESCR,  " &
"                     'CAP' CD_MODULO  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.stpp'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) iSTATUS  " &
"         ON tfcmg109.t$stpp   = iSTATUS.CODE  " &
"  " &
"  LEFT JOIN ( SELECT l.t$desc DESCR_TIPO_ACONSELHAMENTO,  " &
"                     d.t$cnst  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.tadv'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) ACONSELHAMENTO " &
"         ON ACONSELHAMENTO.t$cnst = tfcmg101.t$tadv  " &
"  " &
"  LEFT JOIN ( select a.t$user,  " &
"                     a.t$name  " &
"                from baandb.tttaad200000 a ) ttaad200  " &
"         ON ttaad200.t$user = tfcmg109.t$user  " &
"  " &
"   LEFT JOIN baandb.ttfcmg001301  tfcmg001  " &
"          ON tfcmg001.t$bank = tfcmg104.t$bkre$l  " &
"  " &
"   LEFT JOIN baandb.ttfcmg102301  tfcmg102  " &
"          ON tfcmg102.t$tpay = 1  " &
"         AND tfcmg102.t$ifbp = tfcmg101.t$ifbp  " &
"         AND tfcmg102.t$orno = tfcmg101.t$ninv  " &
"         AND tfcmg102.t$srno = tfcmg101.t$srno  " &
"  " &
"   LEFT JOIN baandb.ttfgld008301  tfgld008  " &
"          ON tfgld008.t$leac = tfcmg102.t$leac  " &
"  " &
" WHERE tfcmg101.t$tadv = 7  " &
"	  AND tfcmg101.t$plan  "&
"		  BETWEEN :DataPgtoDe  "&
"			  AND :DataPgtoAte  "&
"	  AND tfcmg101.t$paym = (CASE WHEN :TipoPagto = 'Todos' THEN tfcmg101.t$paym ELSE :TipoPagto END)  "&
"	  AND ( (:PN = '000') OR (tccom100.t$bpid = :PN) )  "&
"  AND NVL(TRIM(iPrgStat.DESCR), 'Não cadastrado') IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ") "&
"	  AND NVL(CASE WHEN tflcb230.t$send$d = 0  "&
"					 THEN tflcb230.t$stat$d  "&
"				   ELSE   tflcb230.t$send$d  "&
"			   END, 0) IN (" + Replace(("'" + JOIN(Parameters!StatusArquivo.Value, "',") + "'"),",",",'") + ") "&
"   AND ( (tfcmg104.t$docn$l IN  "&
"         ( " + IIF(Trim(Parameters!WorkFlow.Value) = "", "''", "'" + Replace(Replace(Parameters!WorkFlow.Value, " ", ""), ",", "','") + "'")  + " )  "&
"           AND (" + IIF(Parameters!WorkFlow.Value Is Nothing, "1", "0") + " = 0))  " &
"            OR (" + IIF(Parameters!WorkFlow.Value Is Nothing, "1", "0") + " = 1) ) " &
"	ORDER BY  DATA_PAGTO, NR_LOTE, TITULO  "