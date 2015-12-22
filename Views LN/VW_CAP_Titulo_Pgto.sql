SELECT DISTINCT
	1                                                     CD_CIA,																						
	tfacp200.t$ninv                                       NR_TITULO,
	tfcmg011.t$baoc$l                                     CD_BANCO,
	tfcmg011.t$agcd$l                                     NR_AGENCIA,
	tfcmg001.t$bano                                       NR_CONTA_CORRENTE,
	tfacp201.t$mopa$d                                     CD_MODALIDADE_PAGAMENTO,														
	tfacp200.t$docn                                       SQ_DOCUMENTO,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacp600.t$sdat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)          DT_PAGAMENTO,
 	ABS(tfacp200.t$amti + tfacp200.t$ramn$l)              VL_PAGAMENTO,
	tfacP200.t$lino                                       NR_MOVIMENTO,
	CASE WHEN tflcb230.t$revs$d=1 
    then TO_CHAR(tflcb230.t$lach$d)
    ELSE ' ' END                                        DT_ESTORNO,
	tflcb230.t$send$d                                     CD_SITUACAO_PAGTO_ELETRONICO,
	nvl(tfcmg109.t$stpp,0)                                CD_SITUACAO_PAGAMENTO,
  CASE WHEN tfacp200.t$rcd_utc > tfacp201.t$rcd_utc then
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacp200.t$rcd_utc, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE)
	ELSE
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacp201.t$rcd_utc, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE) END		DT_ULT_ATUALIZACAO,				
	CASE WHEN tfacp200.t$balc=0 
    then (select max(d.t$docd) 
            from baandb.ttfacp200201 d
            where d.t$ttyp=tfacp200.t$ttyp
            and d.t$ninv=tfacp200.t$ninv) 
    ELSE to_date('1970-01-01', 'YYYY-MM-DD') END        DT_LIQUIDACAO_TITULO,
  tfacp600.t$payt                                       CD_TRANSACAO_TITULO,
	tfacp200.t$ttyp || tfacp200.t$ninv                    CD_CHAVE_PRIMARIA,
  tfcmg011f.t$baoc$l                                    CD_BANCO_DESTINO,
  tfcmg011f.t$agcd$l                                    NR_AGENCIA_DESTINO,
  tccom125.t$bano                                       NR_CONTA_CORRENTE_DESTINO,
  tfacp200.t$paym                                       CD_METODO_PAGAMENTO,
  tfacp600.t$ptbp                                       CD_PARCEIRO                        
  
FROM baandb.ttfacp600201 tfacp600

LEFT JOIN baandb.ttfcmg109201 tfcmg109
  ON tfcmg109.t$btno=tfacp600.t$pbtn

LEFT JOIN baandb.ttfcmg001201 tfcmg001
  ON tfcmg001.t$bank=tfacp600.t$bank  

LEFT JOIN baandb.ttccom125201 tccom125                      
  ON tccom125.t$cban=tfacp600.t$basu                    
  AND tccom125.t$ptbp=tfacp600.t$ptbp                    

LEFT JOIN baandb.ttfcmg011201 tfcmg011
  ON tfcmg011.t$bank=tfcmg001.t$brch

LEFT JOIN baandb.ttfcmg011201 tfcmg011f
  ON tfcmg011f.t$bank=tccom125.t$brch,                  

  baandb.ttfacp200201 tfacp200

LEFT JOIN baandb.ttflcb230201 tflcb230 
  ON tflcb230.t$docn$d=tfacp200.t$docn
  AND tflcb230.t$ttyp$d=tfacp200.t$tdoc
  AND tflcb230.t$ninv$d=tfacp200.t$ninv,

baandb.ttfacp201201 tfacp201

WHERE tfacp200.t$tdoc=tfacp600.t$payt
  AND tfacp200.t$docn=tfacp600.t$payd
  AND tfacp200.t$lino=tfacp600.t$payl
  AND tfacp200.T$PTBP=tfacp600.T$PTBP
  AND tfacp200.T$TDOC NOT IN 
    (select a.t$tlif$c from BAANDB.tznacr013201 a 
      where a.t$lndt$c<TO_DATE('1990-01-01', 'YYYY-MM-DD'))
  AND tfacp200.t$tpay!=5
  AND tfacp600.t$seqn=(select min(a.t$seqn) from baandb.ttfacp600201 a
						where a.t$pcom=tfacp600.t$pcom
						and a.t$payt=tfacp600.t$payt
						and a.t$payd=tfacp600.t$payd
						and a.t$payl=tfacp600.t$payl)
  AND tfacp201.t$ttyp=tfacp200.t$ttyp
  AND tfacp201.t$ninv=tfacp200.t$ninv
  AND tfacp201.t$schn=tfacp200.t$schn			
