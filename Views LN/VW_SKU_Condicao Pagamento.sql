SELECT  tdipu010.t$citg CD_DEPARTAMENTO,
        znpur008.t$cpay$c CD_CONDICAO_PAGAMENTO,
        tdipu010.t$sbim COD_COND_PGTO_AUT,
        CASE WHEN tcmcs003.t$tpar$l=1 THEN 1
        ELSE  2
        END CONSIGNACAO,
        201 CD_CIA,
        tdipu010.t$vlmf$c VL_MINIMO_PEDIDO,
		CAST((FROM_TZ(CAST(TO_CHAR(znpur008.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
        tdipu010.t$otbp CD_PARCEIRO
FROM    ttdipu010201 tdipu010
		LEFT JOIN ttdipu002201 tdipu002 ON tdipu002.t$citg=tdipu010.t$citg AND tdipu002.t$kitm=1
		LEFT JOIN ttcmcs003201 tcmcs003 ON tcmcs003.t$cwar=tdipu002.t$cwar,
		ttccom100201 tccom100,
		ttccom130201 tccom130,
		tznpur008201 znpur008
WHERE 	tdipu010.t$citg!=' '
AND   	tccom100.t$bpid=tdipu010.t$otbp
AND		tccom130.t$cadr=tccom100.t$cadr
AND		znpur008.t$citg$c=tdipu010.t$citg
AND		znpur008.t$ftyp$c=tccom130.t$ftyp$l
AND		znpur008.t$fovn$c=tccom130.t$fovn$l

