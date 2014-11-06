-- FAF.008 - Fabio Ferreira, 21-mai-2014, Fabio Ferreira, 	Incluido campos OBSERVACAO, FLAG_UTILIZ_ATAC, PPB
-- FAF.009 - Fabio Ferreira, 21-mai-2014, Fabio Ferreira, 	Incluido campo Armazem
-- #FAF.084 - Fabio Ferreira, 26-mai-2014, Fabio Ferreira, 	Inclusão do campo MODELO_FABRICANTE
-- #FAF.120 - Fabio Ferreira, 09-jun-2014, Fabio Ferreira, 	Fitro de data de atualização
--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--	#FAF.181 - 27-jun-2014,	Fabio Ferreira,	Adicionado o campo DS_APELIDO
--  #FAF.296 - 21-aug-2014,	Fabio Ferreira,	Adicionado o campo NR_CNPJ_FABRICANTE
--*********************************************************************************************************************************************************
SELECT  ltrim(rtrim(tcibd001.t$item)) CD_ITEM,
        1 CD_CIA,
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END NR_CNPJ_FORNECEDOR,				--#FAF.151.n		
        tccom100.t$bpid CD_FORNECEDOR,
		tccom100.t$seak DS_APELIDO,																	--#FAF.181.n
        tcmcs060.t$otbp CD_FABRICANTE,
        tccom100f.T$NAMA NM_NOME_FABRICANTE,
        tcibd004.t$aitc CD_ITEM_FORNECEDOR,
        tcibd001.t$dsca DS_ITEM,
        tcibd936.t$frat$l NR_NBM,
        tcibd001.t$ceat$l CD_EAN,
        whwmd400.t$abcc CD_STATUS_ABC,
        tdipu001.T$IXDN$C CD_CATEGORIA,
        tcibd001.t$citg CD_DEPARTAMENTO,
        tcibd001.t$seto$c CD_SETOR,
        tcibd001.t$fami$c CD_FAMILIA,
        tcibd001.t$csig CD_SITUACAO_ITEM,
        CASE WHEN regexp_replace(tccom130f.t$fovn$l, '[^0-9]', '') IS NULL							--#FAF.296.sn
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tccom130f.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tccom130f.t$fovn$l, '[^0-9]', '') END NR_CNPJ_FABRICANTE,				--#FAF.296.en
        tcibd001.t$kitm CD_GENERO,
        tcibd001.t$nrpe$c QT_GARANTIA_FABRICANTE,
        tcibd200.t$mioq QT_MINIMA_FORNECEDOR,
        tcibd936.t$sour$l CD_PROCEDENCIA,
		tcibd001.t$okfi$c IN_OK_FISCAL,
        tcibd001.t$subf$c CD_SUB_FAMILIA,
          CASE WHEN tcmcs023.t$tpit$c=2 THEN 10
               WHEN tcmcs023.t$tpit$c=3 THEN 20
          ELSE tcibd001.t$espe$c
          END CD_ITEM_CONTROLE,
        whwmd400.t$hght VL_ALTURA,
        whwmd400.t$wdth VL_LARGURA,
        whwmd400.t$dpth VL_COMPRIMENTO,
        tcibd001.t$nwgt$l VL_PESO_UNITARIO,
        tcibd001.t$wght VL_PESO_BRUTO,
        tcibd001.t$tptr$c CD_TIPO_TRANSPORTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$lmdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO,
        tcibd001.t$mont$c IN_MONTAGEM,
          CASE WHEN tcibd001.t$csig='SUS' THEN 1
          ELSE 2
          END  IN_ITEM_SUSPENSO,
        CASE WHEN tdisa001.t$dtla$c>TO_DATE('10-JAN-1990','DD-MON-YYYY') THEN tdisa001.t$dtla$c
        ELSE NULL END DT_LANCAMENTO_PREVENDA,
        whwmd400.t$slmp CD_ROTATIVIDADE,
        tcibd001.t$cuni CD_UNIDADE_MEDIDA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$dtcr$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
          CASE WHEN tcibd001.t$espe$c = 2 THEN 1
          ELSE 2
          END IN_KIT,
        tcibd001.t$clor$c DS_COR,
        tcibd001.t$size$c NR_TAMANHO,
        tcibd001.T$NPCL$C CD_CLASSE_NPRODUTO,
        tdipu001.t$prip VL_COMPRA,
		tcibd001.t$obse$c DS_OBSERVACAO,														--#FAF.008.sn
		tcibd001.t$uatc$c IN_UTILIZACAO_ATACADO,
		tcibd001.t$ppbe$c PPB,																--#FAF.008.en
		tdisa001.t$cwar CD_ARMAZEM,					--#FAF.009.n
		tcibd001.t$mdfb$c DS_MODELO_FABRICANTE											--#FAF.084.n
FROM  baandb.ttcibd001201 tcibd001
LEFT JOIN baandb.ttdipu001201 tdipu001 ON tdipu001.t$item=tcibd001.t$item
LEFT JOIN baandb.ttccom100201 tccom100 ON tccom100.t$bpid=tdipu001.t$otbp
LEFT JOIN baandb.ttccom130201 tccom130 ON tccom130.t$cadr=tccom100.t$cadr
LEFT JOIN baandb.ttcibd004201 tcibd004 ON tcibd004.t$item=tcibd001.t$item AND tcibd004.t$citt='000' --AND tcibd004.t$bpid=tccom100.t$bpid 
LEFT JOIN baandb.ttcibd936201 tcibd936 ON tcibd936.t$ifgc$l=tcibd001.t$ifgc$l
LEFT JOIN baandb.twhwmd400201 whwmd400 ON whwmd400.t$item=tcibd001.t$item
LEFT JOIN baandb.ttcibd200201 tcibd200 ON tcibd200.t$item=tcibd001.t$item
LEFT JOIN baandb.ttdisa001201 tdisa001 ON tdisa001.t$item=tcibd001.t$item
LEFT JOIN baandb.ttcmcs060201 tcmcs060 ON tcmcs060.t$cmnf=tcibd001.t$cmnf
LEFT JOIN baandb.ttccom100201 tccom100f ON tccom100f.T$BPID=tcmcs060.T$OTBP
LEFT JOIN baandb.ttccom130201 tccom130f ON tccom130f.t$cadr=tcmcs060.t$cadr,						--#FAF.296.n
baandb.ttcmcs023201 tcmcs023
WHERE
tcmcs023.t$citg=tcibd001.t$citg
--AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$lmdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--    AT time zone sessiontimezone) AS DATE)>=TRUNC(sysdate, 'DAY')                          		--#FAF.120.n