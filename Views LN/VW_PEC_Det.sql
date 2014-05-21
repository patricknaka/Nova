-- #FAF.006 - 15-mai-2014, Fabio Ferreira, 	Alteração do campo situação 
--********************************************************************************************************************************************************
SELECT
    201 COMPANHIA,
    tdpur401.t$orno NUM_PEDIDO_COMPRA,
    tdpur401.t$pono NUM_ITEM,
    ltrim(rtrim(tdpur401.t$item)) COD_ITEM,
    tdpur401.t$cuqp COD_UNIDADE_MEDIDA,
    tdpur401.t$qoor QTD_PEDIDA,
    tdipu001.t$prip PRECO_UNIT_ORIGINAL_ITEM,
    tdpur401.t$pric PRECO_UNIT_ATUAL_ITEM,
    tdpur401.t$qidl QTD_ENTREGUE,
    tdpur401.t$ddtb DT_ENTREGA,
    CASE WHEN ABS(tdpur401.t$qidl)>ABS(tdpur401.t$qoor)
	THEN tdpur401.t$qidl-tdpur401.t$qoor 
	ELSE 0
	END QTD_ENTREGUE_EXCESSO,
    tdpur401.t$qiap QUANTIDADE_LIQUIDADA,
    tdpur401.t$qirj QUANTIDADE_CANCELADA,
    CASE WHEN tdpur401.t$clyn=1 then 5															--#FAF.006.sn
	WHEN tdpur401.t$fire=1 THEN 2
	ELSE 1 END cod_status_item,																	--#FAF.006.en
	--tdpur401.t$clyn=1 SITUACAO_ITEM,															--#FAF.006.o
    --tdpru451.t$trdt DATA SITUAÇÃO DO ITEM,
    tcibd001.t$obse$c OBS_ITEM,
    tdpur401.t$rcd_utc DTHR_ATUALIZAÇÃO,
    tdpur401.t$disc$1 PERCENTUAL_DESCONTO,
    (select z.t$vlft$c from tznfmd630201 z
	where z.t$orno$c=tdpur401.t$orno) VALOR_FRETE,          
    (select sum(brmcs941.t$tamt$l) 
    from tbrmcs941201 brmcs941
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l) VALOR_FINANCEIRO,
    (select z.t$vlsg$c from tznfmd630201 z
	where z.t$orno$c=tdpur401.t$orno) VALOR_SEGURO,
    ltrim(rtrim(tdpur401.t$ikit$c))  COD_KIT,   
    (select t$opfc$l 
    from tbrmcs941201 brmcs941
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l
    and rownum=1) COD_NATUREZA_OPER,
    ' ' SEQ_NATUREZA_OPER                               -- *** NÃO TEMOS ESTA INFORMAÇÃO NA ORDEM DE COMPRA ***
FROM
    ttdpur401201 tdpur401,
    ttcibd001201 tcibd001,
    ttdipu001201 tdipu001
WHERE
        tcibd001.t$item=tdpur401.t$item
    AND tdipu001.t$item=tdpur401.t$item 
    AND tdpur401.t$oltp!=2

