-- #FAF.006 - 15-mai-2014, Fabio Ferreira, 	Alteração do campo situação 
--********************************************************************************************************************************************************
SELECT
    201 CD_CIA,
    tdpur401.t$orno NR_PEDIDO_COMPRA,
    tdpur401.t$pono NR_ITEM_NFR_REFERENCIA,
    ltrim(rtrim(tdpur401.t$item)) CD_ITEM,
    tdpur401.t$cuqp CD_UNIDADE_MEDIDA,
    tdpur401.t$qoor QT_PEDIDO,
    tdipu001.t$prip VL_UNITARIO_ORIGINAL_ITEM,
    tdpur401.t$pric VL_UNITARIO_ATUAL_ITEM,
    tdpur401.t$qidl QT_ENTREGUE,
    tdpur401.t$ddtb DT_ENTREGA,
    CASE WHEN ABS(tdpur401.t$qidl)>ABS(tdpur401.t$qoor)
	THEN tdpur401.t$qidl-tdpur401.t$qoor 
	ELSE 0
	END QT_ENTREGUE_EXCESSO,
    tdpur401.t$qiap QT_LIQUIDADA,
    tdpur401.t$qirj QT_CANCELADA,
    CASE WHEN tdpur401.t$clyn=1 then 5															--#FAF.006.sn
	WHEN tdpur401.t$fire=1 THEN 2
	ELSE 1 END CD_STATUS_ITEM,																	--#FAF.006.en
	--tdpur401.t$clyn=1 SITUACAO_ITEM,															--#FAF.006.o
    --tdpru451.t$trdt DATA SITUAÇÃO DO ITEM,
    tcibd001.t$obse$c DS_OBSERVACAO_ITEM,
    tdpur401.t$rcd_utc DT_ATUALIZACAO,
    tdpur401.t$disc$1 VL_PERCENTUAL_DESCONTO,
    (select z.t$vlft$c from tznfmd630201 z
	where z.t$orno$c=tdpur401.t$orno) VL_FRETE,          
    (select sum(brmcs941.t$tamt$l) 
    from tbrmcs941201 brmcs941
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l) VL_FINANCEIRO,
    (select z.t$vlsg$c from tznfmd630201 z
	where z.t$orno$c=tdpur401.t$orno) VL_SEGURO,
    ltrim(rtrim(tdpur401.t$ikit$c)) CD_KIT,   
    (select t$opfc$l 
    from tbrmcs941201 brmcs941
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l
    and rownum=1) CD_NATUREZA_OPERACAO,
    ' ' SQ_NATUREZA_OPERACAO                               -- *** NÃO TEMOS ESTA INFORMAÇÃO NA ORDEM DE COMPRA ***
FROM
    ttdpur401201 tdpur401,
    ttcibd001201 tcibd001,
    ttdipu001201 tdipu001
WHERE
        tcibd001.t$item=tdpur401.t$item
    AND tdipu001.t$item=tdpur401.t$item 
    AND tdpur401.t$oltp!=2

