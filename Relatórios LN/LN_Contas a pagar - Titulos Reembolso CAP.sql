SELECT
  DISTINCT
    Concat(tfacp200.t$ttyp, tfacp200.t$ninv)    TRANSCAO,
    tfacp200.t$ninv                             NUME_TITULO,
    tfacp200.t$ttyp                             CODE_TRANS,
    tdrec940.t$fire$l                           CODE_REFER,
    tfacp200.t$docn$l                           NUME_NF,
    tfacp200.t$seri$l                           SERI_NF,
    regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')
                                                CNPJ_FORN,
    tccom100.t$nama                             NOME_FORN,
    tfacp200.t$docd                             DATA_EMISSAO,
    tfacp200.t$dued                             DATA_VENCTO,
    tfacp200.t$amnt                             VALO_TITULO,  
    tfacp200.t$balc                             SALD_TITULO,
    '201'                                       CODE_CIA,             

    CASE  WHEN (tfacp200.t$balc - tfacp200.t$bala) = 0 THEN 1 
          ELSE 2 
     END                                        DESC_SITUA1,

    CASE  WHEN tfacp201.t$pyst$l ! =  3 THEN 2 
          ELSE 1 
     END                                        CODE_SITUA2,

    CASE  WHEN tfacp201.t$pyst$l ! =  3 THEN 'Não' 
          ELSE 'Sim' 
     END                                        DESC_SITUA2,

    --PAGTO_PLANEJADO.                            DATA_PLAN_PAGTO,  --Preencher se status = Selecionado (3)
    tflcb230.t$payd$d                           DATA_PLAN_PAGTO,
         
    tfacp200.t$bloc                             STATUS_BLOQUEIO,
    
    NVL(BLOQUEIO.DSC_STATUS_BLOQUEIO, 'Sem bloqueio') 
                                                DESC_STATUS_BLOQUEIO,
    CASE WHEN tfacp201.t$pyst$l = 5 
           THEN tfacp201.t$amnt
         ELSE   tfacp201.t$balc 
     END                                        VALOR_APAGAR,
    tfacp201.t$brel                             NUM_REL_BANCARIA, 
    tfcmg001.t$desc                             DESC_REL_BANCARIA,

    case when (    (tfacp201.t$brel = null or trim(tfacp201.t$brel) = '') 
               and (tfcmg001.t$desc = null or trim(tfcmg001.t$desc) = '') ) then ''
         else Concat(Concat(tfacp201.t$brel, ' - '), tfcmg001.t$desc) 
     end                                        REL_BANCARIA,

    NVL(TRIM(tfacp201.t$paym), 'N/A')           METODO_PAGTO,
    tfacp201.t$bank                             BANCO_PARCEIRO,
    tfcmg011.t$agcd$l                           NUME_AGENCIA,
    tfcmg011.t$agdg$l                           DIGI_AGENCIA,
    tfcmg011.t$desc                             DESC_AGENCIA,
    tccom125.t$bano                             NUME_CONTA,
    tccom125.t$dacc$d                           DIGI_CONTA,  
    Trim(tfcmg011.t$desc  || ' ' ||
          'AG ' || tfcmg011.t$agcd$l || '-' || 
                   tfcmg011.t$agdg$l || '   ' || 'CC ' || 
                   tccom125.t$bano || '-' || 
                   tccom125.t$dacc$d )          CONTA_PN,
                   
    --LOTE_PAGTO.                                 LOTE_PAGTO,
    tflcb230.t$btno$d                           LOTE_PAGTO,
    
    tdrec940.t$fire$l                           NUM_RFISCAL,
    tdrec940.t$rfdt$l                           NUM_CFISCAL, 
    DTRFD.DESC_CODIGO_FISCAL                    DESC_CODIGO_FISCAL,        
    tdrec940.t$fdtc$l                           TIPO_ORDEM,
    tcmcs966.t$dsca$l                           DESC_TIPO_ORDEM,       
    tdrec947.t$orno$l                           NUM_ORDEM,
    tfacp201.t$mopa$d                           CODE_MODAL_PGTO,
    
    DESC_MODAL_PGTO.                            DESC_MODAL_PGTO,
    OCORRENCIA.                                 OCORRENCIA1,
    OCORRENCIA.                                 OCORRENCIA2,
    OCORRENCIA.                                 OCORRENCIA3,
    OCORRENCIA.                                 OCORRENCIA4,
              
    tfacp200.t$ifbp                             CODE_PN,
    tccom100.t$nama                             DESC_PN,

    Concat(Concat(tfacp200.t$ifbp, ' - '), 
           tccom100.t$nama)                     COD_DESC_PEN,
    nvl(tfacp201.t$pyst$l, 1)                   STAT_PRG,
    iSTAT.DESCR                                 DESCR_STAT_PRG,
 
    znsls412.t$uneg$c                           UNID_NEG,
    NVL(znint002.t$desc$c, 'Reembolso Manual')  NM_UNID_NEG,
    znsls401.t$orno$c                           ORDEM_VENDA,
    znsls412.t$pecl$c                           PEDIDO,
    znsls402.t$idmp$c                           MEIO_PGTO,
    MEIO_PAGTO.                                 DESCR_MEIO_PGTO,
    znsls400.t$idca$c                           CANAL_VENDAS,
    CANAL_VENDA.                                DESCR_CANAL_VENDA,
    znsls402.t$bopg$c                           BOLETO_PARA_PGTO,           
    znsls402.t$idad$c                           ID_ADQUIRENTE,
    znsls402.t$cccd$c                           COD_CARTAO_CREDITO_DEBITO,

    CASE WHEN tflcb230.t$send$d = 0 
           THEN tflcb230.t$stat$d
         ELSE   tflcb230.t$send$d
     END                                        CODE_STAT_ARQ,
    
    CASE WHEN tflcb230.t$send$d = 0
           THEN NVL(iStatArq.DESCR, 'Arquivo não vinculado')
         ELSE   NVL(iSendArq.DESCR, 'Arquivo não vinculado')
     END                                        DESCR_STAT_ARQ,
          
    tflcb230.t$lach$d                           DATA_STAT_ARQ

FROM       baandb.ttfacp200301  tfacp200  

INNER JOIN baandb.ttfacp201301  tfacp201
        ON tfacp201.t$ttyp = tfacp200.t$ttyp
       AND tfacp201.t$ninv = tfacp200.t$ninv

INNER JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tfacp200.t$ifbp
    
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
    
-- LEFT JOIN ( select max(a.t$btno) LOTE_PAGTO, 
--                    a.t$ttyp, 
--                    a.t$ninv
--               from baandb.ttfcmg101301 a
--           group by a.t$ttyp, a.t$ninv ) LOTE_PAGTO
--        ON LOTE_PAGTO.t$ttyp = tfacp200.t$ttyp
--       AND LOTE_PAGTO.t$ninv = tfacp200.t$ninv
       
 LEFT JOIN ( select m.t$bloc COD_STATUS_BLOQUEIO,
                    m.t$desc DSC_STATUS_BLOQUEIO
               from baandb.ttfacp002301 m ) BLOQUEIO
        ON BLOQUEIO.COD_STATUS_BLOQUEIO = tfacp200.t$bloc

-- LEFT JOIN ( select MIN(a.t$plan) DATA_PLAN_PAGTO,
--                    a.t$ttyp,
--                    a.t$ninv,
--                    a.t$schn
--               from baandb.ttfcmg101301 a 
--           group by a.t$ttyp,
--                    a.t$ninv,
--                    a.t$schn) PAGTO_PLANEJADO
--        ON PAGTO_PLANEJADO.t$ttyp = tfacp200.t$ttyp
--       AND PAGTO_PLANEJADO.t$ninv = tfacp200.t$ninv 
--       AND PAGTO_PLANEJADO.t$schn = tfacp201.t$schn
      

 LEFT JOIN ( SELECT a.t$ttyp$d, 
                    a.t$ninv$d,
                    a.t$lach$d,
                    max(a.t$stat$d) t$stat$d,
                    max(a.t$send$d) t$send$d,
                    max(a.t$btno$d) t$btno$d,
                    max(a.t$payd$d) t$payd$d
               FROM baandb.ttflcb230301 a
              WHERE a.t$sern$d = ( select max(b.t$sern$d)
                                     from baandb.ttflcb230301 b
                                    where b.t$ttyp$d = a.t$ttyp$d
                                      and b.t$ninv$d = a.t$ninv$d )
           GROUP BY a.t$ttyp$d, 
                    a.t$ninv$d, 
                    a.t$lach$d ) tflcb230
        ON  tflcb230.t$ttyp$d = tfacp200.t$ttyp
       AND  tflcb230.t$ninv$d = tfacp200.t$ninv
   
 LEFT JOIN ( SELECT d.t$cnst CODE,
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
        ON iStatArq.CODE = tflcb230.t$stat$d  
    
 LEFT JOIN ( SELECT d.t$cnst CODE,
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
                                            and l1.t$cpac = l.t$cpac ) ) iSendArq 
        ON iSendArq.CODE = tflcb230.t$send$d  
        
 LEFT JOIN baandb.ttdrec940301  tdrec940
        ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
       AND tdrec940.t$invn$l = tfacp200.t$ninv
        
 LEFT JOIN ( SELECT iDOMAIN.t$cnst iCODE, iLABEL.t$desc DESC_CODIGO_FISCAL 
               FROM baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              WHERE iDOMAIN.t$cpac = 'td'
                AND iDOMAIN.t$cdom = 'rec.trfiDOMAIN.l'
                AND iLABEL.t$clan = 'p'
                AND iLABEL.t$cpac = 'td'
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
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) DTRFD
        ON tdrec940.t$rfdt$l = DTRFD.iCODE 
  
 LEFT JOIN baandb.ttdrec947301  tdrec947
        ON tdrec947.t$fire$l = tdrec940.t$fire$l
       
 LEFT JOIN baandb.ttcmcs966301  tcmcs966
        ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l
   
 LEFT JOIN ( select distinct zncmg011.t$typd$c
               from baandb.tzncmg011301 zncmg011
              where zncmg011.t$typd$c! = ' ' ) tipoDEV
        ON tipoDEV.t$typd$c = tfacp200.t$ttyp
 
 LEFT JOIN baandb.tznsls412301 znsls412
        ON znsls412.t$ttyp$c = tipoDEV.t$typd$c
       AND znsls412.t$ninv$c = tfacp200.t$ninv
       AND znsls412.t$type$c = 3

 LEFT JOIN baandb.tznint002301 znint002
        ON znint002.t$uneg$c = znsls412.t$uneg$c
    
 LEFT JOIN baandb.tznsls402301 znsls402
        ON znsls402.t$ncia$c = znsls412.t$ncia$c
       AND znsls402.t$uneg$c = znsls412.t$uneg$c
       AND znsls402.t$pecl$c = znsls412.t$pecl$c
       AND znsls402.t$sqpd$c = znsls412.t$sqpd$c
       AND znsls402.t$sequ$c = znsls412.t$sequ$c

 LEFT JOIN ( select a.t$desc$c DESCR_MEIO_PGTO,
                    a.T$MPGS$C
               from baandb.tzncmg007301 a ) MEIO_PAGTO
        ON MEIO_PAGTO.T$MPGS$C = znsls402.t$idmp$c
 
 LEFT JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls412.t$ncia$c
       AND znsls400.t$uneg$c = znsls412.t$uneg$c
       AND znsls400.t$pecl$c = znsls412.t$pecl$c
       AND znsls400.t$sqpd$c = znsls412.t$sqpd$c
     
 LEFT JOIN ( select tcmcs066.t$dsca  DESCR_CANAL_VENDA,
                    tcmcs066.t$chan
               from baandb.ttcmcs066301 tcmcs066 ) CANAL_VENDA
        ON CANAL_VENDA.t$chan = znsls400.t$idca$c
   
 LEFT JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$ncia$c = znsls412.t$ncia$c
       AND znsls401.t$uneg$c = znsls412.t$uneg$c
       AND znsls401.t$pecl$c = znsls412.t$pecl$c
       AND znsls401.t$sqpd$c = znsls412.t$sqpd$c
       AND znsls401.t$qtve$c < 0
                 
 LEFT JOIN baandb.ttfcmg001301  tfcmg001
        ON tfcmg001.t$bank = tfacp201.t$brel

 LEFT JOIN baandb.ttccom125301  tccom125
        ON tccom125.t$ptbp = tfacp201.t$ifbp
       AND tccom125.t$cban = tfacp201.t$bank

 LEFT JOIN baandb.ttfcmg011301  tfcmg011
        ON tfcmg011.t$bank = tccom125.t$brch

 LEFT JOIN ( SELECT tflcb231a.t$ocr1$d OCORRENCIA1,
                    tflcb231a.t$ocr2$d OCORRENCIA2,
                    tflcb231a.t$ocr3$d OCORRENCIA3,
                    tflcb231a.t$ocr4$d OCORRENCIA4,
                    tflcb231a.t$ttyp$d,
                    tflcb231a.t$ninv$d
               FROM baandb.ttflcb231301  tflcb231a
              WHERE tflcb231a.t$dare$d = ( SELECT MAX(tflcb231b.t$dare$d)
                                             FROM baandb.ttflcb231301  tflcb231b
                                            WHERE tflcb231b.t$ttyp$d = tflcb231a.t$ttyp$d
                                              AND tflcb231b.t$ninv$d = tflcb231a.t$ninv$d ) ) OCORRENCIA
        ON OCORRENCIA.t$ttyp$d = tfacp200.t$ttyp
       AND OCORRENCIA.t$ninv$d = tfacp200.t$ninv

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
                                            and l1.t$cpac = l.t$cpac ) ) iSTAT
        ON iSTAT.CODE = NVL(tfacp201.t$pyst$l, 1)
        
 LEFT JOIN ( SELECT l.t$desc DESC_MODAL_PGTO,
                    d.t$cnst COD_MODAL_PGTO
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.mopa.d'
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
                                            and l1.t$cpac = l.t$cpac ) )  DESC_MODAL_PGTO
        ON DESC_MODAL_PGTO.COD_MODAL_PGTO = tfacp201.t$mopa$d 
    
WHERE tfacp200.t$docn = 0 
AND   tfacp200.t$ttyp in ('PKB','PKC','PKD','PKE','PKF','PRB','PRW','PKG')

  AND tfacp200.t$docd BETWEEN :EmissaoDe AND :EmissaoAte
  AND NVL(znsls412.t$uneg$c, 0) IN (:UniNegocio)
  AND NVL(tfacp201.t$pyst$l, 1) IN (:Situacao)
  AND NVL( CASE WHEN tflcb230.t$send$d = 0 
                  THEN tflcb230.t$stat$d
                ELSE   tflcb230.t$send$d
            END, 0 ) IN (:StatusArquivo)  
  AND ( (regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') = Trim(:CNPJ)) OR (Trim(:CNPJ) is null) )
  AND ( (znsls412.t$pecl$c IN (Trim(:Pedido))) OR (:Todos = 1) )
