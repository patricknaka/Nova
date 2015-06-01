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
    301                                         CODE_CIA,             

    CASE WHEN (tfacp200.t$balc - tfacp200.t$bala) = 0 
           THEN 1 
         ELSE   2 
     END                                        DESC_SITUA1,

    CASE WHEN tfacp201.t$pyst$l !=  3 
           THEN 2 
         ELSE   1 
     END                                        CODE_SITUA2,

    CASE WHEN tfacp201.t$pyst$l != 3 
           THEN 'Não' 
         ELSE   'Sim' 
     END                                        DESC_SITUA2,

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

    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfacp201.t$bank
         ELSE   tfcmg101.t$basu 
     END                                        BANCO_PARCEIRO,
		 
    CASE WHEN tfcmg011_ac.t$agcd$l IS NULL 
           THEN tfcmg011_ag.t$agcd$l                           
         ELSE   tfcmg011_ac.t$agcd$l 
     END                                        NUME_AGENCIA,
		 
    CASE WHEN tfcmg011_ac.t$agdg$l IS NULL 
           THEN tfcmg011_ag.t$agdg$l
         ELSE   tfcmg011_ac.t$agdg$l 
     END                                        DIGI_AGENCIA,
		 
    CASE WHEN tfcmg011_ac.t$desc IS NULL 
           THEN tfcmg011_ag.t$desc 
         ELSE   tfcmg011_ac.t$desc 
     END                                        DESC_AGENCIA,
	
    CASE WHEN tccom125_ac.t$bano IS NULL 
           THEN tccom125_ag.t$bano
         ELSE   tccom125_ac.t$bano 
     END                 		 		 		NUME_CONTA,
	
    CASE WHEN tccom125_ac.t$dacc$d IS NULL 
           THEN tccom125_ag.t$dacc$d
         ELSE   tccom125_ac.t$dacc$d 
     END                                        DIGI_CONTA,
	 
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN Trim(tfcmg011_ag.t$desc  || ' ' ||
                     'AG ' || tfcmg011_ag.t$agcd$l || '-' || 
                     tfcmg011_ag.t$agdg$l || '   ' || 'CC ' || 
                     tccom125_ag.t$bano || '-' || 
                     tccom125_ag.t$dacc$d )          
         ELSE   Trim(tfcmg011_ac.t$desc  || ' ' ||
                     'AG ' || tfcmg011_ac.t$agcd$l || '-' || 
                     tfcmg011_ac.t$agdg$l || '   ' || 'CC ' || 
                     tccom125_ac.t$bano || '-' || 
                     tccom125_ac.t$dacc$d )    
     END                                        CONTA_PN,
	 
    tdrec940.t$fire$l                           NUM_RFISCAL,
    tdrec940.t$rfdt$l                           NUM_CFISCAL, 
    DTRFD.DESC_CODIGO_FISCAL                    DESC_CODIGO_FISCAL,        
    tdrec940.t$fdtc$l                           TIPO_ORDEM,
    tcmcs966.t$dsca$l                           DESC_TIPO_ORDEM,       
    tdrec947.t$orno$l                           NUM_ORDEM,
    CMG103.t$mopa$d                             CODE_MODAL_PAGTO,
    MODAL_PGTO_HIST.DESC_MODAL                  DESC_MODAL_PAGTO,
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

    tfcmg101.t$btno                             TENTATIVA_LOTE_PAGTO,
    tfcmg101.t$mopa$d                           TENTATIVA_MOD_PAGTO,
    DESC_MODAL_PGTO_2                           DESC_MOD_PAGTO,
    CASE WHEN tfacp201.t$pyst$l = 3 
           THEN 'Sim' 
         ELSE   'N/A' 
     END                                        TENTATIVA_PREP_PAGTO,
    tfcmg101.t$plan                             DATA_TENTATIVA_PAGTO,
    NVL(tflcb230_HIST.t$send$d, -1)             TENTATIVA_STATUS_ENVIO,
    iStatsend.DESCR                             DSC_TENTATIVA_STATUS_ENVIO,
    tflcb230_HIST.t$erro$d                      DSC_ERRO,
    tfcmg101.t$bank                             NUME_BANCO,
    CASE WHEN tfcmg101.t$basu IS NULL THEN
        tfcmg011_ag.t$agcd$l                           
    ELSE tfcmg011_ac.t$agcd$l END               CODE_AGENCIA,
    tfcmg001.t$bano                             CODE_CONTA,
    tfcmg011_HIST.t$desc                        BANCO_PN,
    CMG103.t$basu                               COD_CONTA,
    TENT.RN                                     TENTATIVA_PAGTO

FROM       baandb.ttfacp200301  tfacp200  

INNER JOIN baandb.ttfacp201301  tfacp201
        ON tfacp201.t$ttyp = tfacp200.t$ttyp
       AND tfacp201.t$ninv = tfacp200.t$ninv

INNER JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tfacp200.t$ifbp
    
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
    
 LEFT JOIN ( select m.t$bloc COD_STATUS_BLOQUEIO,
                    m.t$desc DSC_STATUS_BLOQUEIO
               from baandb.ttfacp002301 m ) BLOQUEIO
        ON BLOQUEIO.COD_STATUS_BLOQUEIO = tfacp200.t$bloc
        
 LEFT JOIN baandb.ttdrec940301  tdrec940
        ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
       AND tdrec940.t$invn$l = tfacp200.t$ninv
        
 LEFT JOIN ( select iDOMAIN.t$cnst iCODE, iLABEL.t$desc DESC_CODIGO_FISCAL 
               from baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              where iDOMAIN.t$cpac = 'td'
                and iDOMAIN.t$cdom = 'rec.trfiDOMAIN.l'
                and iLABEL.t$clan = 'p'
                and iLABEL.t$cpac = 'td'
                and iLABEL.t$clab = iDOMAIN.t$za_clab
                and rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4)) 
                                                 from baandb.tttadv401000 l1 
                                                where l1.t$cpac = iDOMAIN.t$cpac 
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                and rpad(iLABEL.t$vers,4) ||
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
              where zncmg011.t$typd$c != ' ' ) tipoDEV
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

 LEFT JOIN baandb.ttccom125301  tccom125_ag           --Banco PN da Agenda Pagto
        ON tccom125_ag.t$ptbp = tfacp201.t$ifbp
       AND tccom125_ag.t$cban = tfacp201.t$bank

 LEFT JOIN baandb.ttfcmg011301  tfcmg011_ag
        ON tfcmg011_ag.t$bank = tccom125_ag.t$brch
        
 LEFT JOIN ( select tflcb231a.t$ocr1$d OCORRENCIA1,
                    tflcb231a.t$ocr2$d OCORRENCIA2,
                    tflcb231a.t$ocr3$d OCORRENCIA3,
                    tflcb231a.t$ocr4$d OCORRENCIA4,
                    tflcb231a.t$ttyp$d,
                    tflcb231a.t$ninv$d
               from baandb.ttflcb231301  tflcb231a
              where tflcb231a.t$dare$d = ( SELECT MAX(tflcb231b.t$dare$d)
                                             FROM baandb.ttflcb231301  tflcb231b
                                            WHERE tflcb231b.t$ttyp$d = tflcb231a.t$ttyp$d
                                              AND tflcb231b.t$ninv$d = tflcb231a.t$ninv$d ) ) OCORRENCIA
        ON OCORRENCIA.t$ttyp$d = tfacp200.t$ttyp
       AND OCORRENCIA.t$ninv$d = tfacp200.t$ninv

 LEFT JOIN ( select d.t$cnst CODE,
                    l.t$desc DESCR
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'acp.pyst.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) iSTAT
        ON iSTAT.CODE = NVL(tfacp201.t$pyst$l, 1)
        
 LEFT JOIN ( select l.t$desc DESC_MODAL_PGTO,
                    d.t$cnst COD_MODAL_PGTO
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.mopa.d'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )  DESC_MODAL_PGTO
        ON DESC_MODAL_PGTO.COD_MODAL_PGTO = tfacp201.t$mopa$d 

 LEFT JOIN baandb.ttfcmg101301 tfcmg101
        ON tfcmg101.t$comp = 301 
       AND tfcmg101.t$ifbp = tfacp200.t$ifbp
       AND tfcmg101.t$tadv = 1                 --Fatura de Compra
       AND tfcmg101.t$ttyp = tfacp200.t$ttyp
       AND tfcmg101.t$ninv = tfacp200.t$ninv

 LEFT JOIN baandb.ttccom125301  tccom125_ac    --Banco PN do Acons. Pagto
        ON tccom125_ac.t$ptbp = tfcmg101.t$ifbp
       AND tccom125_ac.t$cban = tfcmg101.t$basu

 LEFT JOIN baandb.ttfcmg011301  tfcmg011_ac
        ON tfcmg011_ac.t$bank = tccom125_ac.t$brch
        
 LEFT JOIN ( select l.t$desc DESC_MODAL_PGTO_2,
                    d.t$cnst COD_MODAL_PGTO_2
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.mopa.d'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )  DESC_MODAL_PGTO_2
        ON DESC_MODAL_PGTO_2.COD_MODAL_PGTO_2 = tfacp201.t$mopa$d 

 LEFT JOIN baandb.ttflcb230301 tflcb230p
        ON tflcb230p.t$ptyp$d = tfcmg101.t$ptyp
       AND tflcb230p.t$docn$d = tfcmg101.t$pdoc
       AND tflcb230p.t$ttyp$d = tfcmg101.t$ttyp
       AND tflcb230p.t$ninv$d = tfcmg101.t$ninv
       AND tflcb230p.t$sern$d = TO_CHAR(tfcmg101.t$schn)
       AND tflcb230p.t$comp$d = tfcmg101.t$comp
  
 LEFT JOIN ( select a.t$mopa$d,
                    a.t$btno,
                    a.t$basu,
                    a.t$ptbp,
                    a.t$ttyp,
                    a.t$docn
               from baandb.ttfcmg103301 a ) CMG103
        ON CMG103.t$btno = tfcmg101.t$btno
       AND CMG103.t$basu = tfcmg101.t$basu
       AND CMG103.t$ptbp = tfcmg101.t$ifbp
       AND CMG103.t$ttyp = tfcmg101.t$ptyp
       AND CMG103.t$docn = tfcmg101.t$pdoc
        
 LEFT JOIN ( select l.t$desc DESC_MODAL,
                    d.t$cnst COD_MODAL
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.mopa.d'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )  MODAL_PGTO_HIST
        ON MODAL_PGTO_HIST.COD_MODAL = CMG103.t$mopa$d

 LEFT JOIN baandb.ttccom125301  tccom125_HIST
        ON tccom125_HIST.t$ptbp = CMG103.t$ptbp
       AND tccom125_HIST.t$cban = CMG103.t$basu
       
 LEFT JOIN baandb.ttfcmg011301  tfcmg011_HIST
        ON tfcmg011_HIST.t$bank = tccom125_HIST.t$brch
      
 LEFT JOIN baandb.ttflcb230301 tflcb230_HIST
        ON tflcb230_HIST.t$ptyp$d = CMG103.t$ttyp
       AND tflcb230_HIST.t$docn$d = CMG103.t$docn
       AND tflcb230_HIST.t$ttyp$d = tfacp200.t$ttyp
       AND tflcb230_HIST.t$ninv$d = tfacp200.t$ninv

 LEFT JOIN ( select 0                         CODE,
                    'Não disponível'          DESCR
               from Dual
           
              union

             select d.t$cnst                  CODE,
                    l.t$desc                  DESCR
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.stat.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) iStatSend
        ON iStatSend.CODE = NVL(CASE WHEN tflcb230_HIST.T$send$D = 0 AND tflcb230_HIST.T$STAT$D = 5
                                       THEN 5 
                                     ELSE tflcb230_HIST.T$send$D
                                 END, 0)
 LEFT JOIN ( select D.T$TTYP$D,
                    D.T$NINV$D,
                    D.T$PTYP$D,
                    D.T$DOCN$D,
                    ROW_NUMBER() OVER 
                    ( PARTITION BY D.T$TTYP$D,
                                   D.T$NINV$D
                          ORDER BY D.T$PAYD$D )  RN
               from BAANDB.TTFLCB230301 D )  TENT
        ON TENT.T$TTYP$D = TFACP200.T$TTYP
       AND TENT.T$NINV$D = TFACP200.T$NINV
       AND TENT.T$PTYP$D = CMG103.T$TTYP
       AND TENT.T$DOCN$D = CMG103.T$DOCN
       
WHERE tfacp200.t$docn = 0 
  AND tfacp200.t$ttyp in ('PKB','PKC','PKD','PKE','PKF','PRB','PRW','PKG')
  
  AND tfacp200.t$docd BETWEEN :EmissaoDe AND :EmissaoAte
  AND NVL(znsls412.t$uneg$c, 0) IN (:UniNegocio)
  AND NVL(tfacp201.t$pyst$l, 1) IN (:Situacao)
  AND NVL(Trim(tflcb230p.t$send$d), -1) IN (:StatusEnvio)  
  AND ( (regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') = Trim(:CNPJ)) OR (Trim(:CNPJ) is null) )
  AND ( (znsls412.t$pecl$c IN (:Pedido) and :Todos = 0) OR (:Todos = 1) )
  AND ( (Concat(tfacp200.t$ttyp, tfacp200.t$ninv) IN (:Transacao) and :TransacaoTodos = 0) OR (:TransacaoTodos = 1) )
