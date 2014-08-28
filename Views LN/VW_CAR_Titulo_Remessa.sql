-- #FAF.204 - 04-jul-2014, Fabio Ferreira, 	Adicionado campo CD_MODULO
-- #FAF.204 - 04-jul-2014, Fabio Ferreira, 	Campo Nr. do banco tfcmg948
--***************************************************************************************************************************************************

SELECT distinct   201 CD_CIA,
	  tfcmg401.t$ttyp || tfcmg401.t$ninv CD_CHAVE_PRIMARIA,
          tfcmg401.t$btno NR_REMESSA,
          tfcmg409.t$date DT_REMESSA,
          tfcmg401.t$schn NR_PARCELA,
          tfacr201.t$liqd DT_PREVISTA_RECEBIMENTO,
          tfcmg401.t$paym CD_METODO_RECEBIMENTO,
          tfacr201.t$rpst$l CD_SITUACAO_TITULO,
		  'CAR' CD_MODULO,
		  tfcmg948.t$banu$l NR_BANCO												--#FAF.294.n.

FROM        baandb.ttfcmg401201 tfcmg401
INNER JOIN  baandb.ttfcmg409201 tfcmg409 ON  tfcmg409.t$btno=tfcmg401.t$btno
INNER JOIN  baandb.ttfacr201201 tfacr201 ON  tfacr201.t$ttyp=tfcmg401.t$ttyp 
                                         AND tfacr201.t$ninv=tfcmg401.t$ninv
                                         AND tfacr201.t$schn=tfcmg401.t$schn
LEFT JOIN	baandb.ttfcmg948201 tfcmg948 ON  tfcmg948.t$ttyp$l=tfcmg401.t$ttyp		--#FAF.294.sn
										 AND tfcmg948.t$ninv$l=tfcmg401.t$ninv
										 AND tfcmg948.t$btno$l=tfcmg401.t$btno		--#FAF.294.en
ORDER BY 2