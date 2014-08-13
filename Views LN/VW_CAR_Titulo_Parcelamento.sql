select 
			'201' 													CD_CIA,
			CASE WHEN nvl((	select c.t$styp from baandb.tcisli205201 c
							where c.t$styp='BL ATC'
							AND c.T$ITYP=tfacr201.t$ttyp
							AND c.t$idoc=tfacr201.t$ninv
							AND rownum=1),0)=0 
			THEN 2
			ELSE 3
			END 													CD_FILIAL,
			CONCAT(tfacr201.t$ttyp, TO_CHAR(tfacr201.t$ninv)) 		CD_CHAVE_PRIMARIA,

			tfacr201.t$schn											NR_PARCELA,
			tfacr201.t$amnt											VL_PARCELA,
			tfacr201.t$paym											CD_METODO_RECEBIMENTO,
			tfacr201.t$rpst$l										CD_SITUACAO_PAGAMENTO,
			tfacr201.t$recd											DT_VENCIMENTO,
			tfacr201.t$rcd_utc										DT_ATUALIZACAO
from	
			baandb.ttfacr201201 tfacr201