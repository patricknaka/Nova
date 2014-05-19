SELECT
    201 COMPANHIA,
	(SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND tcemm124.t$loco=201
	AND rownum=1) FILIAL,	
	(SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
	AND tcemm124.t$loco=201
	AND rownum=1) UNID_EMPRESARIAL,
	(SELECT tdrec947.t$rcno$l FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec940.t$fire$l
	AND rownum=1) NUM_NOTA_RECEBIMENTO,
	CAST((FROM_TZ(CAST(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE) DT_EMISSAO_NOTA_RECEBIMENTO,
	tdrec940.t$rfdt$l COD_TIPO_OPERACAO,
	tdrec940.t$bpid$l COD_FORNECEDOR,
	tdrec940.t$docn$l NUM_NOTA_FISCAL_RECEBIDA,
	tdrec940.t$seri$l SER_NOTA_FISCAL_RECEBIDA,
	tdrec940.t$doty$l ESPECIE_NOTA_FISCAL_RECEBIDA,
	CAST((FROM_TZ(CAST(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE) DT_EMISSAO_NF_RECEB,
	CAST((FROM_TZ(CAST(TO_CHAR(tdrec940.t$odat$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE) DT_SAIDA_NF_RECEB,	 
	tdrec940.t$opor$l COD_NATUREZA_OPERACAO,
	tdrec940.t$opfc$l SEQ_NATUREZA_OPERACAO,
	CASE WHEN tdrec940.t$opor$l='1556' THEN 1
	ELSE 2
	END FLAG_MERC_USO_CONSUMO,
	(Select a.t$fire$l from ttdrec944201 a, ttdrec940201 b
	where b.t$fire$l=a.t$fire$l 
	AND b.T$RFDT$L=31
	AND a.T$REFR$L=tdrec940.t$fire$l
	AND rownum=1) NUM_NOTA_RECE_COMPLEMENTO,	
	tdrec940.t$cpay$l COD_CONDICAO_PGTO,
	tdrec940.t$gtam$l VALOR_MERCADORIA,
	(SELECT tdrec949.t$base$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=1) VALOR_BASE_ICMS,
	(SELECT tdrec949.t$amnt$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=1) VALOR_ICMS,
	(SELECT tdrec949.t$amnt$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=2) VALOR_ICMS_ST,
	0 VALOR_ICMS_DESTACADO,													-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	(SELECT tdrec949.t$base$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=3) VALOR_BASE_IPI,
	(SELECT tdrec949.t$amnt$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=3) VALOR_IPI,
	0 VALOR_IPI_DESTACADO,													-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_SERVICO,														-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	tdrec940.t$gexp$l VALOR_DESPESA,
	tdrec940.t$addc$l VALOR_DESCONTO,
	(SELECT tdrec949.t$amnt$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=7) VALOR_ISS,
	tdrec940.t$fght$l VALOR_FRETE,
	0 VALOR_DESPESA_ACESSORIA,												-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	tdrec940.t$tfda$l VALOR_TOTAL_NOTA,
	tdrec940.t$gwgt$l PESO_BRUTO,
	nvl((select t.t$text from ttttxt010201 t 
	where t$clan='p'
	AND t.t$ctxt=tdrec940.t$obse$l
	and rownum=1),' ') OBSERVACAO_NOTA_RECEBIMENTO,
	tdrec940.t$stat$l SITUACAO_NOTA_RECEBIMENTO,
	CAST((FROM_TZ(CAST(TO_CHAR(GREATEST(tdrec940.t$date$l, tdrec940.t$idat$l, tdrec940.t$odat$l, tdrec940.t$adat$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_SITUACAO,
	CAST((FROM_TZ(CAST(TO_CHAR(GREATEST(tdrec940.t$date$l, tdrec940.t$idat$l, tdrec940.t$odat$l, tdrec940.t$adat$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_HR_ATUALIZACAO,
	tdrec940.t$lipl$l COD_CAMINHAO,
	(SELECT tdrec947.t$rcno$l FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec940.t$fire$l
	AND rownum=1) NUM_LOTE,
	0 FLAG_SUFRAMA,															-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	(SELECT tdrec949.t$amnt$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=5) VALOR_PIS,
	(SELECT tdrec949.t$amnt$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=6) VALOR_COFINS,
	0 VALOR_CSLL,															-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_DESCONTO_CONDICIONAL,											-- *** DESCONSIDERAR ***
	tdrec940.t$addc$l VALOR_DESC_INCONDICIONAL,
	(SELECT tdrec949.t$base$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=16) BASE_IMPOSTO_IMPORT,
	(SELECT tdrec949.t$amnt$l FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=16) VALOR_IMPOSTO_IMPORT,
	tdrec940.t$cchr$l VL_DESPESA_ADUANEIRA,
	0 VALOR_ADICIONAL_IMPORTACAO,											-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_PIS_IMPORTACAO,													-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_COFINS_IMPORT,													-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_CIF,															-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	tdrec940.t$doty$l MODELO_FISCAL,
	0 COD_MOTIVO_DEVOLUCAO_ATO,												-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 DT_HR_MOTIVO_DEVOLUCAO_ATO,											-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	nvl((Select max(d.t$crpd$l) from ttdrec941201 d
	where d.t$fire$l=tdrec940.t$fire$l),2) TIPO_FRETE,																
	tdrec940.t$fire$l NUM_REFERENCIA_DOCUMENTAL,
	nvl((SELECT tdrec949.t$isco$c FROM ttdrec949201 tdrec949
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec949.t$brty$l=2),2) FLAG_ICMS_ST_SEM_CONV								
FROM
	ttdrec940201 tdrec940
WHERE tdrec940.t$rfdt$l not in (3,5,8,13,16,22,33)
AND tdrec940.t$stat$l>3
