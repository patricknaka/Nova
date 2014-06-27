-- #FAF.115 - 	07-jun-2014, Fabio Ferreira, 	Inclusão do campo CIA
-- #FAF.119 - 	09-jun-2014, Fabio Ferreira, 	Correção registro duplicado
-- #FAF.163 - 	23-jun-2014, Fabio Ferreira, 	Correção registros duplicados e filtro para não mostrar encontro de contas
-- #FAF.163.1 - 	27-jun-2014, Fabio Ferreira, 	Filtro para não mostrar correções de multas e juros
--*************************************************************************************************************************************************************
SELECT DISTINCT
	201 CD_CIA,																						--#FAF.113.n
	tfacp200.t$ninv NR_TITULO,
	tfcmg011.t$baoc$l CD_BANCO,
	tfcmg011.t$agcd$l NR_AGENCIA,
	tfcmg001.t$bano NR_CONTA_CORRENTE,
	tfcmg103.T$MOPA$D CD_MODALIDADE_PAGAMENTO, -- tfcmg103.mopa.d
	tfacp200.t$docn SQ_DOCUMENTO,
  CAST((FROM_TZ(CAST(TO_CHAR(tfacp600.t$sdat, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) DT_PAGAMENTO,
	ABS(tfacp200.t$amti + tfacp200.t$ramn$l) VL_PAGAMENTO,
	tfacP200.t$lino NR_MOVIMENTO,
	CASE WHEN tflcb230.t$revs$d=1 then TO_CHAR(tflcb230.t$lach$d)
	ELSE ' '
	END DT_ESTORNO,
	tflcb230.t$send$d CD_SITUACAO_PAGTO_ELETRONICO,
	nvl(tfcmg109.t$stpp,0) CD_SITUACAO_PAGAMENTO,
	tfacp600.t$ddat DT_ATUALIZACAO,
	CASE WHEN tfacp200.t$balc=0 then
	(select max(d.t$docd) from ttfacp200201 d
	where d.t$ttyp=tfacp200.t$ttyp
	and d.t$ninv=tfacp200.t$ninv) 
  ELSE to_date('1970-01-01', 'YYYY-MM-DD')
  END DT_LIQUIDACAO_TITULO,
  tfacp600.t$payt CD_TRANSACAO_TITULO,
	tfacp200.t$ttyp || tfacp200.t$ninv CD_CHAVE_PRIMARIA,
  tfcmg011f.t$baoc$l CD_BANCO_DESTINO,
  tfcmg011f.t$agcd$l NR_AGENCIA_DESTINO,
  tccom125.t$bano NR_CONTA_CORRENTE_DESTINO,
  tfacp200.t$paym CD_METODO_PAGAMENTO,
  tfacp600.t$ptbp CD_PARCEIRO                        
 
          --#FAF.003.n  
FROM
  ttfacp600201 tfacp600
  LEFT JOIN ttfcmg109201 tfcmg109
  ON tfcmg109.t$btno=tfacp600.t$pbtn
  LEFT JOIN ttfcmg103201 tfcmg103
  ON tfcmg103.T$BTNO=tfcmg109.T$BTNO
  AND tfcmg103.t$ttyp=tfacp600.t$payt										--#FAF.119.n
  AND tfcmg103.t$docn=tfacp600.t$payd
  LEFT JOIN ttfcmg001201 tfcmg001
  ON tfcmg001.t$bank=tfacp600.t$bank
--  LEFT JOIN ttfcmg001201 tfcmg001f                    

--#FAF.002.o
--  ON tfcmg001f.t$bank=tfacp600.t$basu                    

--#FAF.002.o
  LEFT JOIN ttccom125201 tccom125                      

--#FAF.002.sn                    
  ON tccom125.t$cban=tfacp600.t$basu                    
  AND tccom125.t$ptbp=tfacp600.t$ptbp                    

--#FAF.002.en
  LEFT JOIN ttfcmg011201 tfcmg011
  ON tfcmg011.t$bank=tfcmg001.t$brch
  LEFT JOIN ttfcmg011201 tfcmg011f
  ON tfcmg011f.t$bank=tccom125.t$brch,                  

  ttfacp200201 tfacp200
  LEFT JOIN ttflcb230201 tflcb230 
  ON tflcb230.t$docn$d=tfacp200.t$docn
  AND tflcb230.t$ttyp$d=tfacp200.t$tdoc
  AND tflcb230.t$ninv$d=tfacp200.t$ninv
WHERE
      tfacp200.t$tdoc=tfacp600.t$payt
  AND  tfacp200.t$docn=tfacp600.t$payd
  AND tfacp200.t$lino=tfacp600.t$payl
  AND tfacp200.T$PTBP=tfacp600.T$PTBP																								--#FAF.163.n
  AND tfacp200.T$TDOC NOT IN (select a.t$tlif$c from BAANDB.tznacr013201 a where a.t$lndt$c<TO_DATE('1990-01-01', 'YYYY-MM-DD'))	--#FAF.163.n
--AND tfacp200.t$ttyp || tfacp200.t$ninv='PFS124'
  AND tfacp200.t$tpay!=5																											--#FAF.163.1.n