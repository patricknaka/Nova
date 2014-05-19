SELECT DISTINCT
    znsls401.t$pecl$c NUM_PEDIDO,
    znsls401.t$entr$c NUM_ENTREGA,
	CONCAT(TRIM(znsls401.t$pecl$c), TRIM(to_char(znsls401.t$entr$c))) PEDIDO_ENTREGA, 
	tdsls400.t$orno ORDEM,
    znsls400.t$uffa$c UF_PEDIDO,
    znsls004.t$orig$c ORIGEM_PEDIDO,
	CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_EMISSAO_PEDIDO,		
	CAST((FROM_TZ(CAST(TO_CHAR(tdsls400.t$ddat, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_LIMITE_ENTREGA,		
	CAST((FROM_TZ(CAST(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ENTREGA_PROMETIDA_CLIENTE,
    znsls401.t$tpes$c TIPO_ESTOQUE,
    dtpg.midt DT_PAGAMENTO,
    ltrim(rtrim(tdsls401.t$item)) CÓDIGO_ITEM,
    tcibd001.t$dsca NOME_ITEM,
    tcmcs023.t$dsca DESCR_DEPARTAMENTO_ITEM,
    tdsls401.t$qoor QTD_COMPRADA_CLIENTE,
    (tcibd100.t$blck+tcibd100.t$allo)-tcibd100.t$stoc QUANTIDADE_FALTA,
    (SELECT SUM(whinp100.t$qana)
    FROM  twhinp100201 whinp100
    WHERE whinp100.T$koor=2
    AND   whinp100.t$kotr=1
    AND   whinp100.t$item=tdsls401.t$item) QUANTIDADE_COMPRAS_ABERTO_ITEM,
    tccom130.t$fovn$l CNPJ_FORNECEDOR,
    tccom100.t$nama NOME_FORNECEDOR,
    znsls401.t$vlun$c PRECO_VENDA_UNITARIO,
	(select case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
			else round(sum(a.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
			end mauc
     from  twhwmd217201 a,
          ttcemm112201 tcemm112,
          twhwmd215201 whwmd215
     where tcemm112.t$waid=a.t$cwar
     AND tcemm112.t$loco=201
     AND whwmd215.t$cwar=a.t$cwar
     AND whwmd215.t$item=a.t$item
	 AND a.t$item=tdsls401.t$item
	 AND tcemm112.t$grid=tcemm124.t$grid
     group by  a.t$item,
     tcemm112.t$grid) VALOR_CMV_UNITARIO,					
    znsls400.t$idli$c ID_LISTA_CASAMENTO,
    ' ' CATEGORIA_COMPRA,						-- *** PEDENTE DE DUVIDA ***
    znsls400.t$uneg$c UNIDADE_NEGÓCIO,
    tcemm030.t$euca COD_FILIAL,
	tcemm124.t$grid UNID_EMPRESARIAL
FROM    ttdsls401201 tdsls401,
        ttcibd001201 tcibd001
		LEFT JOIN ttdipu001201 tdipu001
		ON tdipu001.t$item=tcibd001.t$item
		LEFT JOIN ttccom100201 tccom100
		ON tccom100.t$bpid=tdipu001.t$otbp
		LEFT JOIN ttccom130201 tccom130
		ON tccom130.t$cadr=tccom100.t$cadr,
		ttcibd100201 tcibd100,
        ttcmcs023201 tcmcs023,
        tznsls401201 znsls401
        LEFT JOIN tznsls004201 znsls004 
        ON  znsls004.t$ncia$c=znsls401.t$ncia$c
        AND znsls004.t$uneg$c=znsls401.t$uneg$c
        AND znsls004.t$pecl$c=znsls401.t$pecl$c
        AND znsls004.t$sqpd$c=znsls401.t$sqpd$c
        AND znsls004.t$entr$c=znsls401.t$entr$c
        AND znsls004.t$orno$c=znsls401.t$orno$c,
        ttcemm124201 tcemm124,
		ttcemm030201 tcemm030,		
        ttdsls400201 tdsls400,
        tznsls400201 znsls400,
        (SELECT min(a.t$dtra$c) midt,
                a.t$ncia$c,
                a.t$uneg$c,
                a.t$pecl$c,
                a.t$sqpd$c
        FROM tznsls402201 a
        GROUP BY a.t$ncia$c,
                 a.t$uneg$c,
                 a.t$pecl$c,
                 a.t$sqpd$c) dtpg
WHERE   znsls401.t$orno$c=tdsls401.t$orno
AND     znsls401.t$pono$c=tdsls401.t$pono
AND     tdsls400.t$orno=tdsls401.t$orno
AND     tcemm124.t$cwoc=tdsls400.t$cofc
AND 	tcemm030.t$eunt=tcemm124.t$grid
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
AND     dtpg.t$ncia$c=znsls401.t$ncia$c
AND     dtpg.t$uneg$c=znsls401.t$uneg$c
AND     dtpg.t$pecl$c=znsls401.t$pecl$c
AND     dtpg.t$sqpd$c=znsls401.t$sqpd$c
AND     tcibd001.t$item=tdsls401.t$item
AND     tcmcs023.t$citg=tcibd001.t$citg
AND		  tcibd100.t$item=tcibd001.t$item
AND     tcibd100.t$stoc-(tcibd100.t$blck+tcibd100.t$allo)<0