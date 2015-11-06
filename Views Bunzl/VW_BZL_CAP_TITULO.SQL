SELECT DISTINCT
--**********************************************************************************************************************************************************
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
	'CAP' CD_MODULO,
	tfacp200.t$ninv NR_TITULO,
  CAST(15 AS INT) as CD_CIA,
	CASE WHEN tfacp200.t$ttyp IN ('AGA', 'GA1') THEN 3 ELSE 2 END CD_FILIAL,
	tfacp200.t$ttyp CD_TRANSACAO_TITULO,
	tfacp200.t$tpay CD_TIPO_DOCUMENTO,
	tfacp200.t$ifbp CD_PARCEIRO,
	tfacp200.t$docn$l NR_NF_RECEBIDA,
	tfacp200.t$seri$l NR_SERIE_NF_RECEBIDA,
	tfacp200.t$line$l SQ_NF_RECEBIDA,
	tfacp200.t$docd DT_EMISSAO_TITULO,															--#FAF.001.n
	tfacp200.t$dued DT_VENCIMENTO,															--#FAF.001.n
	tfacp201.t$odue$l DT_VENCIMENTO_ORIGINAL,														--#FAF.001.n
	CASE WHEN tfacp200.t$balh$1=0 THEN																									--#FAF.175.n
		(select  																														--#FAF.003.sn
			max(p.t$docd) from baandb.ttfacp200602 p where p.t$ttyp=tfacp200.t$ttyp
			and p.t$ninv=tfacp200.t$ninv) 
	ELSE NULL
	END													DT_LIQUIDACAO_TITULO,															--#FAF.175.n
	tfacp200.t$amnt VL_TITULO,
	nvl(tdrec940.t$tfda$l, tfacp200.t$amnt)  VL_ORIGINAL,									--#FAF.007.o	
	CASE WHEN tfacp200.t$afpy=2 THEN '1' ELSE '2' END IN_BLOQUEIO_TITULO,
	tfacp201.t$pyst$l CD_PREPARADO_PAGAMENTO,
	tfacp200.t$stap CD_SITUACAO_TITULO,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) DT_SITUACAO_TITULO,
	tfacp200.t$doty$l CD_TIPO_NF,
	tfacp200.t$balh$1 VL_SALDO,
	tfcmg011f.t$baoc$l CD_BANCO_DESTINO,
	tfcmg011f.t$agcd$l NR_AGENCIA_DESTINO,
	tfcmg011f.t$agdg$l NR_DIGITO_AGENCIA_DESTINO,
	tfcmg001f.t$bano NR_CONTA_CORRENTE_DESTINO,
	tfcmg001f.t$ofdg$l NR_DIG_CONTA_CORRENTE_DESTINO,
	tfacp200.t$lapa VL_TAXA_MORA,																		--#FAF.001.n
	nvl((select p.t$inra$l from baandb.ttfacp201602 p														--#FAF.003.sn 
		where p.t$ttyp=tfacp200.t$ttyp and p.t$ninv=tfacp200.t$ninv
		and ROWNUM=1),0) VL_TAXA_MULTA,																		--#FAF.003.en
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
	(Select u.t$eunt From baandb.ttcemm030602 u where u.t$euca!=' '
		AND TO_NUMBER(u.t$euca)=CASE WHEN tfacp200.t$dim2=' ' then 999
		WHEN tfacp200.t$dim2>to_char(0) then 999 
		else TO_NUMBER(tfacp200.t$dim2) END
		and rownum = 1 ) CD_UNIDADE_EMPRESARIAL,
	tdrec940.t$fire$l NR_REFERENCIA_FISCAL,
	tfacp200.t$ttyp || tfacp200.t$ninv CD_CHAVE_PRIMARIA,
	tfacp200.t$leac CD_CONTA_ORIGEM,																		--#FAF.288.sn
	
	(Select distinct tdrec952.t$leac$l from baandb.ttdrec952602 tdrec952
	 WHERE 	tdrec952.t$ttyp$l=tfacp200.t$ttyp
	 AND 	tdrec952.t$invn$l=tfacp200.t$ninv
	 AND    tdrec952.t$fire$l=tdrec940.t$fire$l
	 AND 	tdrec952.t$dbcr$l=1
	 AND	tdrec952.t$trtp$l=2
	 AND 	tdrec952.t$brty$l=0
	 and rownum=1)	CD_CONTA_DESTINO																		--#FAF.288.en
FROM
  baandb.ttfacp200602 tfacp200
  LEFT JOIN baandb.ttdrec940602 tdrec940
  ON tdrec940.t$docn$l=tfacp200.t$docn$l
  AND tdrec940.t$seri$l=tfacp200.t$seri$l
  AND tdrec940.t$ttyp$l=tfacp200.t$ttyp
  AND tdrec940.t$invn$l=tfacp200.t$ninv
  LEFT JOIN baandb.ttdrec947602 tdrec947
  ON tdrec947.t$fire$l=tdrec940.t$fire$l
  LEFT JOIN baandb.ttccom125602 tccom125
  ON  tccom125.t$ptbp=tfacp200.t$otbp
  AND tccom125.t$cban=tfacp200.t$bank
  LEFT JOIN baandb.ttfcmg011602 tfcmg011
  ON  tfcmg011.t$bank=tccom125.t$brch,
  (SELECT a.t$ttyp,
      a.t$ninv,
      MIN(a.t$odue$l) t$odue$l,
      MIN(a.t$liqd)   t$liqd,
      SUM(a.t$amnt)   t$amnt,
      MIN(a.t$pyst$l) t$pyst$l,
      MAX(a.t$inta$l) t$inta$l,
	  MAX(a.t$bank) t$bank
  FROM baandb.ttfacp201602 a
  GROUP BY a.t$ttyp,
       a.t$ninv) tfacp201
  LEFT JOIN baandb.ttfcmg001602 tfcmg001f
	ON tfcmg001f.t$bank=tfacp201.t$bank
  LEFT JOIN baandb.ttfcmg011602 tfcmg011f
	ON tfcmg011f.t$bank=tfcmg001f.t$brch
WHERE
  tfacp201.t$ttyp=tfacp200.t$ttyp
AND  tfacp201.t$ninv=tfacp200.t$ninv
AND tfacp200.t$docn=0