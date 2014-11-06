-- #FAF.006 - 15-mai-2014, Fabio Ferreira, 	Alteração do campo situação 
-- #FAF.131 - 11-jun-2014, Fabio Ferreira, 	Filtro detalhe
-- #FAF.228, 15-jul-2014, Fabio Ferreira, 	Alteração origem frete e seguro
-- SQ_NATUREZA_OPERACAO		retirado com autorização Patrick em 20/08/2014
--********************************************************************************************************************************************************
SELECT
    1 CD_CIA,
    tdpur401.t$orno NR_PEDIDO_COMPRA,
    tdpur401.t$pono NR_ITEM_NFR_REFERENCIA,
    ltrim(rtrim(tdpur401.t$item)) CD_ITEM,
    tdpur401.t$cuqp CD_UNIDADE_MEDIDA,
    tdpur401.t$qoor QT_PEDIDO,
    tdipu001.t$prip VL_UNITARIO_ORIGINAL_ITEM,
    tdpur401.t$pric VL_UNITARIO_ATUAL_ITEM,
    tdpur401.t$qidl QT_ENTREGUE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$ddtb, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ENTREGA,
    CASE WHEN ABS(tdpur401.t$qidl)>ABS(tdpur401.t$qoor)
	THEN tdpur401.t$qidl-tdpur401.t$qoor 
	ELSE 0
	END QT_ENTREGUE_EXCESSO,
    tdpur401.t$qiap QT_LIQUIDADA,
    tdpur401.t$qirj QT_CANCELADA,
    CASE WHEN tdpur401.t$clyn=1 then 'C'															--#FAF.006.sn
	WHEN tdpur401.t$fire=1 THEN 'L'
	ELSE 'A' END CD_STATUS_ITEM,																	--#FAF.006.en
    tcibd001.t$obse$c DS_OBSERVACAO_ITEM,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO,
    tdpur401.t$disc$1 VL_PERCENTUAL_DESCONTO,
	FreteSeg.fght VL_FRETE,																			--#FAF.228.n
    (select sum(brmcs941.t$tamt$l) 
    from baandb.tbrmcs941201 brmcs941
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l) VL_FINANCEIRO,
	FreteSeg.insr VL_SEGURO, 																		--#FAF.228.n
    ltrim(rtrim(tdpur401.t$ikit$c)) CD_ITEM_KIT,   
    (select t$opfc$l 
    from baandb.tbrmcs941201 brmcs941
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l
    and rownum=1) CD_NATUREZA_OPERACAO
FROM
    baandb.ttdpur401201 tdpur401
	LEFT JOIN (	select 	a.t$orno, a.t$pono, sum(br.t$fght$l) fght, sum(br.t$insr$l) insr			--#FAF.228.sn
				from 	baandb.ttdpur401201 a,
              baandb.tbrmcs941201 br
				where 	a.t$txre$l!=' '
				and	 	a.t$oltp!=2
				and		br.t$txre$l=a.t$txre$l
				and 	br.t$line$l=a.t$txli$l
				group by a.t$orno, a.t$pono) FreteSeg ON FreteSeg.t$orno=tdpur401.t$orno
													 AND FreteSeg.t$pono=tdpur401.t$pono, 			--#FAF.228.en
    baandb.ttcibd001201 tcibd001,
    baandb.ttdipu001201 tdipu001
WHERE
        tcibd001.t$item=tdpur401.t$item
    AND tdipu001.t$item=tdpur401.t$item 
    AND tdpur401.t$oltp IN (1,4)															--#FAF.131.n