SELECT
  tfcmg011.t$baoc$l  CODE_BANCO,
  tfcmg011.t$agcd$l  CODE_AGENCIA,
  tfcmg001.t$bano    CODE_CONTA,
  tfcmg103.t$docd    DATA_PAGTO,
  tfcmg103.t$paym    CODE_METODO_PGTO, 
  tfcmg003.          t$desc,  
  tfcmg103.t$docn    NUME_TITULO,    
  tfacp200a.t$tpay   TIPO_DOCTO,  
  tfacp200a.t$docd   DATA_EMISSAO,  
  tfcmg103.t$dued$l  DATA_VENCTO,
  tfacp200a.t$amnt   VLR_TITULO,
  tfcmg103.t$amnt    VLR_PAGTO,
  tfcmg103.t$ptbp    CODE_FORNECEDOR, 
  tccom100.t$nama    DESC_FORNECEDOR,
  tfcmg109.t$stpp    SITUACAO_PAGTO, 
  iSTPP.             DESC_PAGTO,  
  tfacp200a.t$leac   CTA_CONTABIL,
  tfcmg103.t$btno    NUME_LOTE  
  
FROM       baandb.ttfacp200201 tfacp200

INNER JOIN baandb.ttfacp600201 tfacp600
        ON tfacp200.t$tdoc   = tfacp600.t$payt
       AND tfacp200.t$docn   = tfacp600.t$payd
       AND tfacp200.t$lino   = tfacp600.t$payl
 
 LEFT JOIN baandb.ttfcmg109201 tfcmg109  
        ON tfcmg109.t$btno   = tfacp600.t$pbtn
 
 LEFT JOIN baandb.ttfcmg103201 tfcmg103  
        ON tfcmg103.T$BTNO   = tfcmg109.T$BTNO
       AND tfcmg103.t$ttyp = tfacp200.t$tdoc 
       AND tfcmg103.t$docn = tfacp200.t$docn
 
 LEFT JOIN baandb.ttccom100201 tccom100
        ON tccom100.t$bpid   = tfcmg103.t$ptbp

 LEFT JOIN BAANDB.ttfcmg003201 tfcmg003
        ON tfcmg003.t$paym = tfcmg103.t$paym

 LEFT JOIN baandb.ttfcmg001201 tfcmg001  
        ON tfcmg001.t$bank   = tfacp600.t$bank
 
 LEFT JOIN baandb.ttfcmg001201 tfcmg001f 
        ON tfcmg001f.t$bank  = tfacp600.t$basu
 
 LEFT JOIN baandb.ttfcmg011201 tfcmg011  
        ON tfcmg011.t$bank   = tfcmg001.t$brch
 
 LEFT JOIN baandb.ttfcmg011201 tfcmg011f 
        ON tfcmg011f.t$bank  = tfcmg001f.t$brch
  
 LEFT JOIN baandb.ttfacp200201 tfacp200a 
        ON tfacp200a.t$ttyp  = tfacp200.t$ttyp 
       AND tfacp200a.t$ninv  = tfacp200.t$ninv

 LEFT JOIN (SELECT d.t$cnst CODE_PAGTO, 
                   l.t$desc DESC_PAGTO
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
                                           and l1.t$cpac = l.t$cpac )) iSTPP
        ON tfcmg109.t$stpp = iSTPP.CODE_PAGTO 
  
WHERE tfacp200a.t$lino = 0
  
AND tfcmg103.t$docd BETWEEN NVL(:DtPagtoDe, tfcmg103.t$docd) AND NVL(:DtPagtoAte, tfcmg103.t$docd)
AND tfcmg103.t$paym IN (:Modalidade)
AND tfcmg109.t$stpp IN (:Situacao)
AND tfcmg011.t$baoc$l = NVL(:Banco, tfcmg011.t$baoc$l)
AND tfcmg103.t$btno = NVL(:Lote, tfcmg103.t$btno)