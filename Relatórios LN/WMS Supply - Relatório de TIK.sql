SELECT
			BOM.SKU									ID_PAI,
			SKP.DESCR								DESCR_PAI,
			BOM.COMPONENTSKU						ID_COMPONENTE,
			SKC.DESCR								DESCR_COMPONENTE,
			SKC.STDCUBE								CUBO,
			SKC.STDGROSSWGT							PESO_BRUTO,
			SKC.STDNETWGT							PESO_LIQ,
			--										TARA				**** DESCONIDERAR
			TIPO_ITEM.DSC_TIPO						KIT_TIK,
			BOM.SEQUENCE							SEQUENCIA,
			BOM.QTY									QUANT,
			CASE WHEN BOM.BOMONLY = 'Y'		
				THEN 'SIM'		
				ELSE 'NÃO' END						APENAS_BOM,
			CASE WHEN BOM.PRIMARYCOMPONENT=1
				THEN 'SIM'
				ELSE 'NÃO' END						COMPENENTE_MESTRE
			--										PROPRIETARIO		*** DESCONIDERAR

FROM
				ENTERPRISE.BILLOFMATERIAL 	BOM
	INNER JOIN	ENTERPRISE.SKU				SKP		ON	SKP.SKU		=	BOM.SKU
	INNER JOIN	ENTERPRISE.SKU				SKC		ON	SKC.SKU		=	BOM.COMPONENTSKU
			
	LEFT JOIN ( select clkp.code          COD_TIPO, 
					NVL(trans.description, 
					clkp.description)  DSC_TIPO
				from WMWHSE5.codelkup clkp
				left join WMWHSE5.translationlist trans 
				 on trans.code = clkp.code
				and trans.joinkey1 = clkp.listname
				and trans.locale = 'pt'
				and trans.tblname = 'CODELKUP' 
			  where clkp.listname = 'EANTYPE'
				and Trim(clkp.code) is not null  ) TIPO_ITEM
												ON	TIPO_ITEM.COD_TIPO = SKC.BOMITEMTYPE
ORDER BY 1