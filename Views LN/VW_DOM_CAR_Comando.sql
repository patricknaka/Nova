--	FAF.295 - 20-ago-2014, Fabio Ferreira, 	Inclusão do TP_COMANDO
--****************************************************************************************************************************************************************
SELECT DISTINCT
	tfcmg938.t$ocod$l CD_COMANDO,
	tfcmg938.t$odes$l DS_COMANDO,
	case when tfcmg938.t$octp$l=1 then 'ENVIAR' else 'RETORNAR' end TP_COMANDO
FROM
	baandb.ttfcmg938201 tfcmg938
