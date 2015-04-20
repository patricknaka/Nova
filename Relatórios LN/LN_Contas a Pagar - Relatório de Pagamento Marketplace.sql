SELECT
  TCCOM130_ACR.T$FOVN$L                     CNPJ,
  TFACR200T.T$ITBP                          COD_PN,
  TCCOM100_ACR.T$NAMA                       PN_LOGISTA,
  TFACR200T.T$DOCD                          DT_EMISSAO_CAR,
  TFACR200T.T$DUED                          DT_VENCIMENTO_CAR,
  TFACR200T.T$TTYP ||                       
  TFACR200T.T$NINV                          TRANSACAO_CAR,
  TFACR200T.T$AMNT                          VALOR_CAR,
  TFACR200T.T$DOCN$L                        NF_COMISSAO,
  TFACR200T.T$SERI$L                        SERIE_COMISSAO,
  TFACP200T.T$DOCD                          DT_EMISSAO_CAP,
  TFACP200T.T$DUED                          DT_VENCIMENTO_CAP,
  TFACP200T.T$TTYP                          
  || TFACP200T.T$NINV                       TRANSACAO_CAP,
  TFACP200T.T$AMNT                          VALOR_CAP,
  TFACP200T.T$BALC                          SALDO_CAP,
  TFCMG101.T$PLAN                           DT_PLAN_PAGTO,
  TFCMG101.T$BTNO                           LOTE_PGTO,
  ST_PAGMT.DSCA                             STATUS_PGTO_TRANS_CAP,
  
  CASE WHEN tflcb230.t$send$d = 0 
         THEN NVL(iStatArq.DESCR,  'Arquivo não vinculado') 
       ELSE   NVL(iStatArq2.DESCR, 'Arquivo não vinculado') 
   END                                      STATUS_ENVIO_ARQ,
                                            
  NVL(TCCOM125.T$CBAN, 'NÃO APLCAVEL')      CODE_CONTA_PN_LOJISTA,
  NVL(TFCMG011.T$BANK || ' - ' ||               
  TFCMG011.T$DESC,'NÃO APLICAVEL')          FILIAL_BANCARIA,
  NVL(TCCOM125.T$BANO, 'NÃO APLICAVEL')     CONTA_BANCARIA,
  NVL(TCCOM125.T$DACC$D, 'NÃO APLICAVEL')   DIGITO_CONTA,
  TFCMG001.T$BANK                           RELACAO_BANCARIA_PAGADORA,
  TFACP200T.T$PTYP                          TIPO_COMPRA,
  NVL(TFGLD106.T$LEAC, TFGLD102.T$LEAC)     CONTA_CONTABIL_CAP,
  NVL(TFGLD008F.T$DESC, TFGLD008N.T$DESC)   DESCR_CONTA_CONTABIL,
  TFCMG101.T$PTYP || ' - ' ||               
  TFCMG101.T$PDOC                           DOC_PAGAMENTO,
  TFACP200T.T$REFR                          REFERENCIA,
  TFACR200M.T$TDOC || ' ' || 
  TFACR200M.T$DOCN							TRANSCAO_ENC,
  NVL(TFGLD106R.T$LEAC, TFGLD102R.T$LEAC) 	CONTA_CONTABIL_CAR,
  NVL(TFGLD008FR.T$DESC, TFGLD008NR.T$DESC)	DESCR_CONTA_CONTABIL_CAR,
  TFACP200T.t$balc-TFACP200T.t$bala             VALOR_APAGAR
  
  
FROM       BAANDB.TTFACR200201 TFACR200T

INNER JOIN BAANDB.TTCCOM100201 TCCOM100_ACR 
        ON TCCOM100_ACR.T$BPID = TFACR200T.T$ITBP

INNER JOIN BAANDB.TTCCOM130201 TCCOM130_ACR 
        ON TCCOM130_ACR.T$CADR = TCCOM100_ACR.T$CADR

INNER JOIN BAANDB.TTFACR200201 TFACR200M  
        ON TFACR200M.T$TTYP = TFACR200T.T$TTYP
       AND TFACR200M.T$NINV = TFACR200T.T$NINV
       AND TFACR200M.T$TDOC = 'ENC'
			
INNER JOIN BAANDB.TTFACP200201 TFACP200M  
        ON TFACP200M.T$TDOC = TFACR200M.T$TDOC
       AND TFACP200M.T$DOCN = TFACR200M.T$DOCN
			
INNER JOIN BAANDB.TTFACP200201 TFACP200T  
        ON TFACP200T.T$TTYP = TFACP200M.T$TTYP
       AND TFACP200T.T$NINV = TFACP200M.T$NINV

INNER JOIN (SELECT A.T$TTYP,
                   A.T$NINV,
				   A.T$BANK,
                   MAX(A.T$PYST$L) T$PYST$L
              FROM BAANDB.TTFACP201201 A
          GROUP BY A.T$TTYP,
                   A.T$BANK,
                   A.T$NINV ) TFACP201  
        ON TFACP201.T$TTYP = TFACP200T.T$TTYP
       AND TFACP201.T$NINV = TFACP200T.T$NINV            
            
 LEFT JOIN ( select A.T$PTYP$D,
                    A.T$DOCN$D,
                    A.T$TTYP$D, 
                    A.T$NINV$D,
                    A.T$LACH$D,
                    MAX(A.T$STAT$D) T$STAT$D,
                    MAX(A.T$SEND$D) T$SEND$D
               from BAANDB.TTFLCB230201 A
              where A.T$SERN$D = ( SELECT MAX(B.T$SERN$D)
                                     FROM BAANDB.TTFLCB230201 B
                                    WHERE B.T$TTYP$D = A.T$TTYP$D
                                      AND B.T$NINV$D = A.T$NINV$D )
           group by A.T$PTYP$D,
                    A.T$DOCN$D,
                    A.T$TTYP$D, 
                    A.T$NINV$D, 
                    A.T$LACH$D ) TFLCB230
        ON TFLCB230.T$TTYP$D = TFACP200T.T$TTYP
       AND TFLCB230.T$NINV$D = TFACP200T.T$NINV

 INNER JOIN BAANDB.TTFCMG101201 TFCMG101
        ON TFCMG101.T$TTYP = TFACP200T.T$TTYP
       AND TFCMG101.T$NINV = TFACP200T.T$NINV
 
 LEFT JOIN BAANDB.TTCCOM125201 TCCOM125
		ON	TCCOM125.T$PTBP	=	TFACP200T.T$IFBP
		AND	TCCOM125.T$CBAN	=	TFACP201.T$BANK
		
 
 LEFT JOIN BAANDB.TTFCMG001201 TFCMG001  
        ON TFCMG001.T$BANK = TFCMG101.T$BANK

 LEFT JOIN BAANDB.TTFCMG011201 TFCMG011 
        ON TFCMG011.T$BANK = TCCOM125.T$BRCH

 LEFT JOIN ( SELECT A.T$OTYP,
                    A.T$ODOC,
                    A.T$LEAC
               FROM BAANDB.TTFGLD106201 A
              WHERE A.T$DBCR = 1
                AND A.T$OLIN = ( SELECT MIN(B.T$OLIN)
                                   FROM BAANDB.TTFGLD106201 B
                                  WHERE B.T$OTYP = A.T$OTYP
                                    AND B.T$ODOC = A.T$ODOC
                                    AND B.T$DBCR = 1 ) ) TFGLD106
        ON TFGLD106.T$OTYP = TFACP200T.T$TTYP
       AND TFGLD106.T$ODOC = TFACP200T.T$NINV

 LEFT JOIN ( SELECT A.T$TTYP,
                    A.T$DOCN,
                    A.T$LEAC
               FROM BAANDB.TTFGLD102201 A
              WHERE A.T$DBCR = 1
                AND A.T$LINO = ( SELECT MIN(B.T$LINO)
                                   FROM BAANDB.TTFGLD102201 B
                                  WHERE B.T$TTYP = A.T$TTYP
                                    AND B.T$DOCN = A.T$DOCN
                                    AND B.T$DBCR = 1 ) ) TFGLD102
        ON TFGLD102.T$TTYP  = TFACP200T.T$TTYP
       AND TFGLD102.T$DOCN  = TFACP200T.T$NINV

 LEFT JOIN ( SELECT A.T$OTYP,
                    A.T$ODOC,
                    A.T$LEAC
               FROM BAANDB.TTFGLD106201 A
              WHERE A.T$DBCR = 2
                AND A.T$OLIN = ( SELECT MIN(B.T$OLIN)
                                   FROM BAANDB.TTFGLD106201 B
                                  WHERE B.T$OTYP = A.T$OTYP
                                    AND B.T$ODOC = A.T$ODOC
                                    AND B.T$DBCR = 2 ) ) TFGLD106R
        ON TFGLD106R.T$OTYP = TFACR200T.T$TTYP
       AND TFGLD106R.T$ODOC = TFACR200T.T$NINV

 LEFT JOIN ( SELECT A.T$TTYP,
                    A.T$DOCN,
                    A.T$LEAC
               FROM BAANDB.TTFGLD102201 A
              WHERE A.T$DBCR = 2
                AND A.T$LINO = ( SELECT MIN(B.T$LINO)
                                   FROM BAANDB.TTFGLD102201 B
                                  WHERE B.T$TTYP = A.T$TTYP
                                    AND B.T$DOCN = A.T$DOCN
                                    AND B.T$DBCR = 2 ) ) TFGLD102R
        ON TFGLD102R.T$TTYP  = TFACR200T.T$TTYP
       AND TFGLD102R.T$DOCN  = TFACR200T.T$NINV
	   
 LEFT JOIN BAANDB.TTFGLD008201 TFGLD008F  
        ON TFGLD008F.T$LEAC = TFGLD106.T$LEAC

 LEFT JOIN BAANDB.TTFGLD008201 TFGLD008FR
        ON TFGLD008FR.T$LEAC = TFGLD106R.T$LEAC
		
 LEFT JOIN BAANDB.TTFGLD008201 TFGLD008N  
        ON TFGLD008N.T$LEAC = TFGLD102.T$LEAC

 LEFT JOIN BAANDB.TTFGLD008201 TFGLD008NR
        ON TFGLD008NR.T$LEAC = TFGLD102R.T$LEAC
		
 LEFT JOIN ( select d.t$cnst CODE,
                    l.t$desc DSCA
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
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )  ST_PAGMT
        ON ST_PAGMT.CODE  = TFACP201.T$PYST$L            
            
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatArq2
        ON iStatArq2.CODE = tflcb230.t$send$d
		
WHERE TFACR200T.T$DOCN = 0
  AND TFACP200T.T$DOCN = 0
  AND TFACP200T.T$TTYP IN ('PKK', 'RKL')
    
  AND TFCMG101.T$PLAN Between :DataPagtoDe And :DataPagtoAte
  AND ((:TransacaoTodos = 1) OR (TFACR200T.T$TTYP || TFACR200T.T$NINV IN (:Transacao) AND :TransacaoTodos = 0))  
  
