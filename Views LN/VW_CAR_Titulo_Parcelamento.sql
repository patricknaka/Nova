select 
			'201' 													    CD_CIA,
			CASE WHEN nvl((	select c.t$styp from baandb.tcisli205201 c
							where c.t$styp='BL ATC'
							AND c.T$ITYP=tfacr201.t$ttyp
							AND c.t$idoc=tfacr201.t$ninv
							AND rownum=1),0)=0 
			THEN 2	ELSE 3	END 								CD_FILIAL,
			CONCAT(tfacr201.t$ttyp, TO_CHAR(tfacr201.t$ninv)) 		CD_CHAVE_PRIMARIA,

			tfacr201.t$schn											NR_PARCELA,
			tfacr201.t$amnt											VL_PARCELA,
      tfcmg011.t$baoc$l                   CD_BANCO,
      tfcmg011.t$agcd$l                   NR_AGENCIA,
      tfcmg001.t$bano                     NR_CONTA_CORRENTE,
			tfacr201.t$paym											CD_METODO_RECEBIMENTO,
			tfacr201.t$rpst$l										CD_SITUACAO_PAGAMENTO,
			tfacr201.t$recd											DT_VENCIMENTO,
			tfacr201.t$rcd_utc									DT_ATUALIZACAO
from	
			baandb.ttfacr201201 tfacr201, baandb.ttfacr200201 tfacr200
      LEFT JOIN baandb.ttfcmg001201 tfcmg001 ON tfcmg001.t$bank = tfacr200.t$bank
      LEFT JOIN baandb.ttfcmg011201 tfcmg011 ON tfcmg011.t$bank = tfcmg001.t$brch
where
    tfacr201.t$ttyp = tfacr200.t$ttyp AND
    tfacr201.t$ninv = tfacr200.t$ninv 
    
