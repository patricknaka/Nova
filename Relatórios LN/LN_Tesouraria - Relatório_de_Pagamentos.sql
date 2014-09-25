SELECT
	tfcmg011.t$baoc$l CODE_BANCO,
	tfcmg011.t$agcd$l CODE_AGENCIA,
	tfcmg001.t$bano   CODE_CONTA,
  CAST((FROM_TZ(CAST(TO_CHAR(tfcmg103.t$docd, 	'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE) DATA_PAGTO,
	tfcmg103.t$paym CODE_METODO_PGTO, 
  iMOPA.t$desc,  
  tfcmg103.t$docn   NUME_TITULO,    
  tfacp200a.t$tpay   TIPO_DOCTO,  
  CAST((FROM_TZ(CAST(TO_CHAR(tfacp200a.t$docd, 	'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE) DATA_EMISSAO,  
  CAST((FROM_TZ(CAST(TO_CHAR(tfcmg103.t$dued$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE) DATA_VENCTO,
  tfacp200a.t$amnt 	VLR_TITULO,
  tfcmg103.t$amnt 	VLR_PAGTO,
  tfcmg103.t$ptbp  	CODE_FORNECEDOR, 
  tccom100.t$nama   DESC_FORNECEDOR,
  tfcmg109.t$stpp   SITUACAO_PAGTO, iSTPP.DESC_PAGTO,  
  tfacp200a.t$leac  CTA_CONTABIL,
  tfcmg103.t$btno   NUME_LOTE  
  
FROM
	ttfacp600201 tfacp600 
                        LEFT  JOIN  ttfcmg109201  tfcmg109  ON  tfcmg109.t$btno  = tfacp600.t$pbtn
                        LEFT  JOIN  ttfcmg103201  tfcmg103  ON  tfcmg103.T$BTNO  = tfcmg109.T$BTNO
                        LEFT  JOIN  ttfcmg001201  tfcmg001  ON  tfcmg001.t$bank  = tfacp600.t$bank
                        LEFT  JOIN  ttfcmg001201  tfcmg001f ON  tfcmg001f.t$bank = tfacp600.t$basu
                        LEFT  JOIN  ttfcmg011201  tfcmg011  ON  tfcmg011.t$bank  = tfcmg001.t$brch
                        LEFT  JOIN  ttfcmg011201  tfcmg011f ON  tfcmg011f.t$bank = tfcmg001f.t$brch,
  
  ttfacp200201 tfacp200 LEFT  JOIN  ttfacp200201  tfacp200a ON  tfacp200a.t$ttyp = tfacp200.t$ttyp 
                                                            AND tfacp200a.t$ninv = tfacp200.t$ninv 
                                                            AND tfacp200a.t$lino = 0,
  ttccom100201  tccom100,
                      (select a.t$paym, a.t$desc from BAANDB.ttfcmg003201 a) iMOPA,
                        (SELECT 	iDOMAIN.t$cnst CODE_PAGTO, iLABEL.t$desc DESC_PAGTO
                        FROM  	tttadv401000 iDOMAIN, tttadv140000 iLABEL 
                        WHERE 	iDOMAIN.t$cpac = 'tf' 
                        AND   	iDOMAIN.t$cdom = 'cmg.stpp'
                        AND   	iDOMAIN.t$vers = 'B61'
                        AND   	iLABEL.t$clab = iDOMAIN.t$za_clab
                        AND   	iLABEL.t$clan = 'p'
                        AND   	iLABEL.t$cpac = 'tf'
                        AND   	iLABEL.t$vers = (SELECT  max(l1.t$vers) 
                              FROM    tttadv140000 l1 
                              WHERE   l1.t$clab=iLABEL.t$clab 
                              AND     l1.t$clan=iLABEL.t$clan 
                              AND     l1.t$cpac=iLABEL.t$cpac   )) iSTPP  
WHERE 
  tfacp200.t$tdoc=tfacp600.t$payt
AND	
  tfacp200.t$docn=tfacp600.t$payd
AND 
  tfacp200.t$lino=tfacp600.t$payl
AND
  tfcmg103.t$ttyp = tfacp200.t$tdoc 
AND 
  tfcmg103.t$docn = tfacp200.t$docn
AND
  tccom100.t$bpid = tfcmg103.t$ptbp
AND
	tfcmg103.t$paym = iMOPA.t$paym
AND
  tfcmg109.t$stpp = iSTPP.CODE_PAGTO  