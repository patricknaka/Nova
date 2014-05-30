-- FAF.008 - Fabio Ferreira, 21-mai-2014, Fabio Ferreira, 	Incluido campos OBSERVACAO, FLAG_UTILIZ_ATAC, PPB
-- FAF.009 - Fabio Ferreira, 21-mai-2014, Fabio Ferreira, 	Incluido campo Armazem
-- #FAF.084 - Fabio Ferreira, 26-mai-2014, Fabio Ferreira, 	Inclusão do campo MODELO_FABRICANTE
--*********************************************************************************************************************************************************
SELECT  ltrim(rtrim(tcibd001.t$item)) CD_ITEM,
        201 CD_CIA,
		tccom100.t$bpid CD_FORNECEDOR,
        tccom130.t$fovn$l CNPJ_FORNCEDOR,
        tcibd004.t$aitc CD_ITEM_FORNECEDOR,
		tcibd001.t$mdfb$c DS_MODELO_FABRICANTE,											--#FAF.084.n
        tcibd001.t$dsca DS_ITEM,
        tcibd936.t$frat$l NR_NBM,
        tcibd001.t$ceat$l CD_EAN,
        whwmd400.t$abcc CD_STATUS_ABC,
        tcibd001.t$citg CD_DEPARTAMENTO,
        tcibd001.t$seto$c CD_SETOR,
        tcibd001.t$fami$c CD_FAMILIA,
        tcibd001.t$csig CD_SITUACAO_ITEM,
        tcmcs060.t$otbp CD_FABRICANTE,
        tccom100f.T$NAMA NM_NOME_FABRICANTE,
        tcibd001.t$kitm CD_GENERO,
        tcibd001.t$nrpe$c QT_GARANTIA_FABRICANTE,
        tcibd200.t$mioq QT_MINIMA_FORNECEDOR,
        tcibd936.t$sour$l CD_PROCEDENCIA,
		tcibd001.t$okfi$c IN_OK_FISCAL,
        tcibd001.t$subf$c CD_SUBFAMILIA,
          CASE WHEN tcmcs023.t$tpit$c=2 THEN 10
               WHEN tcmcs023.t$tpit$c=3 THEN 20
          ELSE tcibd001.t$espe$c
          END CD_ITEM_CONTROLE,
        whwmd400.t$hght VL_ALTURA,
        whwmd400.t$wdth VL_LARGURA,
        whwmd400.t$dpth NR_COMPRIMENTO,
        tcibd001.t$nwgt$l VL_PESO_UNITARIO,
        tcibd001.t$wght VL_PESO_BRUTO,
        tcibd001.t$tptr$c CD_TIPO_TRANSPORTE,
        CAST((FROM_TZ(CAST(TO_CHAR(tcibd001.t$lmdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
            AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
        tcibd001.t$mont$c IN_MONTAGEM,
          CASE WHEN tcibd001.t$csig='SUS' THEN 1
          ELSE 2
          END  IN_ITEM_SUSPENSO,
        CASE WHEN tdisa001.t$dtla$c>TO_DATE('10-JAN-1990','DD-MON-YYYY') THEN tdisa001.t$dtla$c
        ELSE NULL END DT_LANCAMENTO_PREVENDA,
        whwmd400.t$slmp CD_ROTATIVIDADE,
        tcibd001.t$cuni CD_UNIDADE_MEDIDA,
        CAST((FROM_TZ(CAST(TO_CHAR(tcibd001.t$dtcr$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
            AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
          CASE WHEN tcibd001.t$espe$c = 2 THEN 1
          ELSE 2
          END IN_KIT,
        tcibd001.t$clor$c DS_COR,
        tcibd001.t$size$c NR_TAMANHO,
        tcibd001.T$NPCL$C CD_CLASSE_NPRODUTO,
        tdipu001.t$prip VL_COMPRA,
        tdipu001.T$IXDN$C CD_CATEGORIA,
		tcibd001.t$obse$c DS_OBSERVACAO,														--#FAF.008.sn
		tcibd001.t$uatc$c IN_UTILIZACAO_ATACADO,
		tcibd001.t$ppbe$c PPB,																--#FAF.008.en
		tdisa001.t$cwar CD_ARMAZEM																--#FAF.009.n
FROM  ttcibd001201 tcibd001
LEFT JOIN ttdipu001201 tdipu001 ON tdipu001.t$item=tcibd001.t$item
LEFT JOIN ttccom100201 tccom100 ON tccom100.t$bpid=tdipu001.t$otbp
LEFT JOIN ttccom130201 tccom130 ON tccom130.t$cadr=tccom100.t$cadr
LEFT JOIN ttcibd004201 tcibd004 ON tcibd004.t$item=tcibd001.t$item AND tcibd004.t$citt='000' --AND tcibd004.t$bpid=tccom100.t$bpid 
LEFT JOIN ttcibd936201 tcibd936 ON tcibd936.t$ifgc$l=tcibd001.t$ifgc$l
LEFT JOIN twhwmd400201 whwmd400 ON whwmd400.t$item=tcibd001.t$item
LEFT JOIN ttcibd200201 tcibd200 ON tcibd200.t$item=tcibd001.t$item
LEFT JOIN ttdisa001201 tdisa001 ON tdisa001.t$item=tcibd001.t$item
LEFT JOIN ttcmcs060201 tcmcs060 ON tcmcs060.t$cmnf=tcibd001.t$cmnf
LEFT JOIN ttccom100201 tccom100f ON tccom100f.T$BPID=tcmcs060.T$OTBP,
ttcmcs023201 tcmcs023
WHERE
tcmcs023.t$citg=tcibd001.t$citg