SELECT DISTINCT

      (SELECT tcemm030.t$euca FROM BAANDB.ttcemm124301 tcemm124, BAANDB.ttcemm030301 tcemm030
      WHERE tcemm124.t$cwoc=tdsls400dev.t$cofc
      AND tcemm030.t$eunt=tcemm124.t$grid
      AND tcemm124.t$loco=301
      AND rownum=1) id_filial,
-- 'nao tem no ln' as id_processo,
  CASE  WHEN tdsls400dev.t$hdst<=10  THEN 'Incluida'
    WHEN tdsls400dev.t$hdst<=25 THEN 'Pendente'
    WHEN tdsls400dev.t$hdst<=30  THEN 'Encerrada'
    WHEN tdsls400dev.t$hdst=35   THEN 'Cancelada'
    ELSE 'Aguardando Pedido' END tpEstado,
  znsls401dev.t$cmot$c id_motivo,
  znsls401dev.t$lmot$c moti_nome,
  CASE WHEN znsls401dev.t$copo$c = 0 THEN 'Retorno'
       WHEN znsls401dev.t$copo$c = 1 THEN 'Coleta'
       WHEN znsls401dev.t$copo$c = 2 THEN 'Postagem'					
       ELSE ' ' 
  END AS tp_instancia,
	znsls401dev.t$orno$c 	id_instancia, 
--	znsls401dev.t$idtr$c 	id_transp,			-- campo retirdo a pedido de Eduardo Barbosa
	znsls401orig.t$idtr$c 	CNPJ_TRANSPORTADOR_ENTREGA,    -- alias alterdo a pedido de Eduardo Barbosa                           
	tdsls400dev.t$odat		dt_ocorr,  
--	znsls401dev.t$mgrt$c	situacao,	--preciso da situacao  -- só temo o código da mega rota ou estado no LN  
	tdsls400dev.t$rcd_utc 	dt_situacao, 
	znsls401dev.t$pecl$c 	ped_cliente,
	znsls401orig.t$entr$c 	entrega,
	cisli940orig.t$docn$l 	id_nf_orig,
	cisli940orig.t$seri$l 	serie_orig, 
	(	SELECT 	tcemm030.t$euca 
		FROM 	BAANDB.ttcemm124301 tcemm124, 
				BAANDB.ttcemm030301 tcemm030
		WHERE 	tcemm124.t$cwoc=cisli940orig.t$cofc$l
		AND 	tcemm030.t$eunt=tcemm124.t$grid
		AND 	tcemm124.t$loco=301
		AND 	rownum=1) 										fili_nfe,				--  znsls401.t$orno$c ORDEM,
	cisli940dev.t$docn$l 										nfe,
	cisli940dev.t$seri$l 										serie_nfe,
	cisli940dev.t$bpid$l 										cli_nfe,
  
	CASE WHEN cisli940dev.t$stat$l IN (1,3,4) THEN 'Aberta'
	   WHEN cisli940dev.t$stat$l IN (2,101) THEN 'Cancelada'
     WHEN cisli940dev.t$stat$l IS NULL THEN 'Não Emitida'
	   ELSE 'Impressa/Lançada'
	END  														sit_nfe,
	tdrec947.t$fire$l 											nr,
	CASE WHEN cisli940orig.t$stat$l IN (1,3,4) THEN 'Aberta'
	   WHEN cisli940orig.t$stat$l IN (2,101) THEN 'Cancelada'
	   ELSE 'Impressa/Lançada'
	END    														sit_nr,  
	znsls409.t$lbrd$c											in_forcado,-- 1 = forçado / 2 = não forçado
	znsls401dev.t$cepe$c 										cep,
	znsls401dev.t$cide$c 										muni_nome,
	znsls401dev.t$ufen$c 										muni_estado,
	tdsls401dev.t$item 											id_item,
	tcibd001.t$dsca 											item_nome,
	ABS(tdsls401dev.t$qoor)										qtd_item,
	ABS(tdsls401dev.t$oamt) 									vlr_tot_item,
	znsls401orig.t$vlfr$c 										vlr_frete_ite,
	znsls401orig.t$idik$c 										kit_wms,
  -- ,'nao tem ln'-- PROCESSO (CLASSIFICACAO_CHAMADO)
  -- ,'nao tem ln'-- MOTIVO_FORCADO (MOTIVO_PELA LIBERACAO FORCADA)
  -- ,'nao tem ln' as id_motivo_forcado-- NUM_RASTREAMENTO (SOMENTE NO CASO_CORREIOS)
  -- ,'nao tem ln' as moti_fim
  -- ,'nao tem ln'-- NUM_RASTREAMENTO (SOMENTE NO CASO_CORREIOS)
	(select znsls410.t$poco$c
	 FROM BAANDB.tznsls410301 znsls410
	 WHERE znsls410.t$ncia$c=znsls401dev.t$ncia$c
	 AND znsls410.t$uneg$c=znsls401dev.t$uneg$c
	 AND znsls410.t$pecl$c=znsls401dev.t$pecl$c
   AND znsls410.t$entr$c=znsls401dev.t$entr$c
	 AND znsls410.t$dtoc$c= (SELECT MAX(c.t$dtoc$c)
						  FROM BAANDB.tznsls410301 c
						  WHERE c.t$ncia$c=znsls410.t$ncia$c
						  AND c.t$uneg$c=znsls410.t$uneg$c
						  AND c.t$pecl$c=znsls410.t$pecl$c
						  AND c.t$sqpd$c=znsls410.t$sqpd$c
						  AND c.t$entr$c=znsls410.t$entr$c)                          
	 AND rownum=1) 												id_ult_ponto_entrega,
  -- TIPO ESTADO (CAPITAL/INTERIOR)                            											*** DESCONSIDERAR NÃO EXISTE NO LN / SERÁ EXTRAIDO DO SITE ***
	cisli940orig.t$date$l 										DT_EMISSAO_NF_VENDA,
	cisli940dev.t$date$l 										DT_NF_COLETA, 							--(NF_ENTRADA)
	cisli940orig.t$cfrw$l										COD_TRANSP_ENTREGA,
	tcmcs080orig.t$dsca											NOME_TRANSP_ENTREGA,
	regexp_replace(tccom130orig.t$fovn$l, '[^0-9]', '')			CNPJ_TRANSP_ENTREGA,
	tdsls400dev.t$cfrw											COD_TRANSP_REVERSA,
	tcmcs080dev.t$dsca											NOME_TRANSP_REVERSA,
	regexp_replace(tccom130DEV.t$fovn$l, '[^0-9]', '')			CNPJ_TRANSP_REVERSA	
	
	
	
FROM
                BAANDB.ttdsls400301 tdsls400dev				-- Ordem de venda devolução
                                                                                                                                                                                
INNER JOIN      BAANDB.tznsls004301    znsls004dev	ON	znsls004dev.t$orno$c	=	tdsls400dev.t$orno                                         
																					
INNER JOIN      BAANDB.tznsls401301 znsls401dev		ON	znsls401dev.t$ncia$c  	=	znsls004dev.t$ncia$c     -- Pedido integrado devolução
                                                    AND	znsls401dev.t$uneg$c	=	znsls004dev.t$uneg$c
                                                    AND	znsls401dev.t$pecl$c  	=	znsls004dev.t$pecl$c
                                                    AND	znsls401dev.t$sqpd$c	=	znsls004dev.t$sqpd$c
                                                    AND	znsls401dev.t$entr$c 	=	znsls004dev.t$entr$c
													AND	znsls401dev.t$sequ$c    =	znsls004dev.t$sequ$c
													
INNER JOIN	(	SELECT 	F.t$ncia$c,
                        F.t$uneg$c,
                        F.t$pecl$c,
                        F.t$sqpd$c,
                        F.t$entr$c,
                        MAX(F.T$LBRD$C) T$LBRD$C,
						MAX(F.T$DVED$C) T$DVED$C
				FROM BAANDB.TZNSLS409301 F
				GROUP BY
						F.t$ncia$c,
						F.t$uneg$c,
						F.t$pecl$c,
						F.t$sqpd$c,
						F.t$entr$c)	ZNSLS409		ON	ZNSLS409.t$ncia$c		=	znsls401dev.t$ncia$c
													AND ZNSLS409.t$uneg$c       =	znsls401dev.t$uneg$c
                                                    AND ZNSLS409.t$pecl$c       =	znsls401dev.t$pecl$c
                                                    AND ZNSLS409.t$sqpd$c       =	znsls401dev.t$sqpd$c
                                                    AND ZNSLS409.t$entr$c       =	znsls401dev.t$entr$c

                                                                                                                                                                                                                
INNER JOIN      BAANDB.ttdsls401301 tdsls401dev 	ON	tdsls401dev.t$orno		=	znsls004dev.t$orno$c
													AND tdsls401dev.t$pono		=	znsls004dev.t$pono$c		-- Linhas Ordem de venda devolução

LEFT JOIN		BAANDB.ttcmcs080301 tcmcs080dev		ON	tcmcs080dev.t$cfrw		=	tdsls400dev.t$cfrw

LEFT JOIN		BAANDB.ttccom130301 tccom130DEV		ON	tccom130DEV.t$cadr		=	tcmcs080dev.t$cadr$l

LEFT JOIN		BAANDB.tcisli245301 cisli245dev 	ON	cisli245dev.t$slcp		=	301
                                                    AND cisli245dev.t$ortp		=	1
                                                    AND cisli245dev.t$koor		=	3
                                                    AND cisli245dev.t$slso		=	tdsls401dev.t$orno
													AND	cisli245dev.t$sqnb		=	tdsls401dev.t$sqnb
	                                                AND	cisli245dev.t$pono		=	tdsls401dev.t$pono	
													
LEFT JOIN		BAANDB.ttdrec947301 tdrec947 		ON	tdrec947.t$ncmp$l		=	301
                                                    AND tdrec947.t$oorg$l		=	1
                                                    AND tdrec947.t$orno$l		=	tdsls401dev.t$orno
													AND	tdrec947.t$pono$l		=	tdsls401dev.t$pono
	                                                AND	tdrec947.t$seqn$l		=	tdsls401dev.t$sqnb													
                                                                                                      
LEFT JOIN		BAANDB.tcisli941301 cisli941dev		ON	cisli941dev.t$fire$l	=	cisli245dev.t$fire$l
													AND cisli941dev.t$line$l	=	cisli245dev.t$line$l
													
LEFT JOIN       BAANDB.tcisli940301 cisli940dev		ON  cisli940dev.t$fire$l  	=	cisli941dev.t$fire$l

INNER JOIN		BAANDB.ttcibd001301 tcibd001		ON	tcibd001.t$item			=	tdsls401dev.t$item 

INNER JOIN		BAANDB.tznsls401301 znsls401orig	ON	znsls401orig.t$ncia$c	=	znsls401dev.t$ncia$c	-- Pedido integrado origem
                                                    AND znsls401orig.t$uneg$c   =	znsls401dev.t$uneg$c
                                                    AND znsls401orig.t$pecl$c   =	znsls401dev.t$pvdt$c
                                                    AND znsls401orig.t$sqpd$c   =	znsls401dev.t$sedt$c
                                                    AND znsls401orig.t$entr$c   =	znsls401dev.t$endt$c
                                                    AND znsls401orig.t$sequ$c   = 	znsls401dev.t$sidt$c
                           
LEFT JOIN  		BAANDB.tcisli940301 cisli940orig	ON	cisli940orig.t$fire$l		=	tdsls401dev.t$fire$l

LEFT JOIN		BAANDB.ttcmcs080301 tcmcs080orig	ON	tcmcs080orig.t$cfrw		=	cisli940orig.t$cfrw$l

LEFT JOIN		BAANDB.ttccom130301 tccom130orig	ON	tccom130orig.t$cadr		=	tcmcs080orig.t$cadr$l

where
			znsls401dev.t$idor$c='TD'
	AND     znsls401dev.t$qtve$c<0
	AND		ZNSLS409.T$DVED$C=2
	AND   	ZNSLS409.T$LBRD$C=1

