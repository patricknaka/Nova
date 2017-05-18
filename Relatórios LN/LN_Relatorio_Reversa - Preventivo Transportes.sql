SELECT /*+ use_concat parallel(32) no_cpu_costing */
    znsls401.t$pecl$c                         PEDIDO,
		znsls401.t$endt$c                         ENTREGA_VENDA,
		znsls401.t$entr$c                         ENTREGA_DEVOLUCAO,
		znsls401troca.t$entr$c                    ENTREGA_TROCA,
		znsls401.t$orno$c                         ORDEM_DEVOLUCAO,
		
		 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_PEDIDO,

		
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_ORDEM_DEVOLUCAO,

		   CASE WHEN PAP_TD.t$dtoc$c IS NULL 
			   THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 
					  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
			 ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(PAP_TD.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 
					'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 
		END                                       DATA_APROVACAO_PEDIDO,	

		CASE WHEN znsls401.t$itpe$c = 15   --REVERSA
			   THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 
					  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
			 WHEN znsls401.t$itpe$c = 9    --POSTAGEM
			   THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(POSTAGEM.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 
					  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
			 WHEN znsls401.t$itpe$c = 17   --INSUCESSO
			   THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(INSUCESSO.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 
					  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
			 ELSE NULL 
		END                                       DATA_SOL_COLETA_POSTAGEM,

		
		CASE WHEN znsls401.t$itpe$c = 8
			   THEN NULL
			 ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(COLETA_PROMETIDA.t$dpco$c, 'DD-MON-YYYY HH24:MI:SS'),
					'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
		END                                       DATA_COLETA_PROMETIDA,								  
		
		CASE WHEN trunc(znfmd630.t$dtco$c) = to_date('01-01-1970','DD-MM-YYYY')  THEN
			NULL
		ELSE
			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) END
                                              DATA_CORRIGIDA,  
												  
		 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(COLETA_PROMETIDA.t$dtpr$c, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
												  DATA_RETORNO_PROMETIDA,
																					  
												  
		znfmd001.t$fili$c                         ESTABELECIMENTO,
		tccom130cnova.t$fovn$l                    CNPJ_NOVA,
		znint002.t$desc$c                         UNIDADE_NEGOCIO,
		

		cast(replace(replace(own_mis.filtro_mis(znsls002.t$dsca$c ),';',''),'"','')   as varchar(100))        
                                              TIPO_ENTREGA,
		zncms040.t$dsca$c                         TIPO_COLETA,
		

		tdsls094.t$dsca                           DESCRICAO_ORDEM_COLETA,  
		
		CASE WHEN znsls400.t$sige$c = 1 THEN
			'SIGE'
		ELSE  
			'LN'
		END                                       SIGE,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$lcat$c)),';',''),'"','')    as varchar(100))  
                                              CATEGORIA,
		  cast(replace(replace(own_mis.filtro_mis(znsls401.t$lass$c),';',''),'"','')   as varchar(100))       
                                              ASSUNTO,
	  
		cast(replace(replace(own_mis.filtro_mis(znsls401.t$lmot$c),';',''),'"','')   as varchar(100))         
                                              MOTIVO_DA_COLETA,

		 CASE WHEN znsls409.t$lbrd$c = 1
			   THEN 'Sim' -- Liberado
			 ELSE   'Não' -- Não Liberado
		 END                                      IN_FORCADO,
		 
		   CASE WHEN Trunc(znsls409.t$fdat$c) = To_date('01-01-1970','DD-MM-YYYY') 
			   THEN NULL
			 ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls409.t$fdat$c, 'DD-MON-YYYY HH24:MI:SS'),
					  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)    
		END                                        DATA_FORCADO,
		
		 CASE WHEN znsls409.t$dved$c = 1 OR
				  znsls409.t$lbrd$c = 1 OR
				  Trim(znsls409.t$pecl$c) is null
			   THEN 'Sim'
			 ELSE   'Não'
		END                                         LIBERADO,


		CASE WHEN znsls409.t$lbrd$c = 1 OR
				  znsls409.t$dved$c = 1 OR
				  znsls410.PT_CONTR IN ('VAL', 'RDV', 'RIE')
			   THEN 'ENCERRADO'
			 ELSE   'PENDENTE'
		END                                       SITUACAO_ATENDIMENTO,
												  
		 CASE WHEN COLETA.t$dtoc$c IS NOT NULL
			   THEN 'COL'
			 ELSE  ' '  
     END                                         STATUS_COLETA,                                         

	   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(COLETA.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
												  DATA_STATUS_COLETA,
	   
		CASE WHEN REC_COLETA.t$dtoc$c IS NOT NULL 
			   THEN 'RDV'
			 ELSE  ' '  
		END                                       STATUS_DEVOLUCAO,
		
		
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(REC_COLETA.t$dtoc$c,'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
												  DATA_STATUS_DEVOLUCAO,
	 
	 
		 CASE WHEN REC_CTR.t$dtoc$c IS NOT NULL 
			   THEN 'CTR'
			 ELSE  ' '  
		END                                       CTR,    
		
		CASE WHEN REC_CTR.t$dtoc$c  > '01/01/1975' then
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(REC_CTR.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'),
								'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)    
			ELSE NULL
		END                                        DATA_CTR,         
--		
		 RIE.t$poco$c                               RIE,

    CASE WHEN EXTRAVIO.t$poco$c IS NOT NULL THEN
        'EXT'
    WHEN EXT_FALTA_INF.t$poco$c IS NOT NULL THEN
        'EXF'
    WHEN ROUBO.t$poco$c IS NOT NULL THEN
        'ROU'
    WHEN AVARIA.t$poco$c IS NOT NULL THEN
        'AVA' 
    END
                                                EXT,
--		 ENT.t$poco$c                               ENT,
      'ENT'                                     ENT,
		
		 CASE WHEN  TCMCS080_ENTREGA.t$dsca IS NULL THEN
			VENDA_TRANSP.t$dsca
			  WHEN  EXPEDICAO.t$ntra$c = '' then  
			VENDA_TRANSP.t$dsca
		 ELSE
			NVL(tcmcs080_ENTREGA.t$dsca,EXPEDICAO.t$ntra$c)
		 END                                                                 
                                                NOME_TRANSP_ENTREGA,

		
		CASE WHEN cisli940.t$stat$l in (5, 6) OR
				  cisli940.t$cfrw$l in ('A44','A45','A46','T68','T69','T70','T71','T72','T73') 					
			   THEN CASE WHEN tcmcs080.t$dsca IS NULL 
						   THEN NVL(  cast(replace(replace(own_mis.filtro_mis(cisli940.t$cfrn$l),';',''),'"','')   as varchar(100)), 
														  ( select Trim(A.T$NTRA$C)
															from BAANDB.TZNSLS410301 A
														   where A.T$NCIA$C = ZNSLS401.T$NCIA$C
															 and A.T$UNEG$C = ZNSLS401.T$UNEG$C
															 and A.T$PECL$C = ZNSLS401.T$PECL$C
															 and A.T$SQPD$C = ZNSLS401.T$SQPD$C
															 and A.T$ENTR$C = ZNSLS401.T$ENTR$C
															 and A.T$NTRA$C != ' '
															 and ROWNUM = 1 ) )                   
						 ELSE  cast(replace(replace(own_mis.filtro_mis(tcmcs080.t$dsca),';',''),'"','')   as varchar(100))    
					END                                       
			 ELSE  cast(replace(replace(own_mis.filtro_mis(tcmcs080OV.t$dsca),';',''),'"','')   as varchar(100))    
		END                                       NOME_TRANSPORTADORA_COLETA,

		CASE WHEN cisli940.t$stat$l in (5, 6) OR 
				  cisli940.t$cfrw$l in ('A44','A45','A46','T68','T69','T70','T71','T72','T73') 	
			   THEN Trim(tcmcs080.t$seak)                     
			 ELSE Trim(tcmcs080OV.t$seak)   
		END                                       APELIDO_TRANSP_COLETA,

		CASE WHEN cisli940.t$stat$l in (5, 6) OR 
				  cisli940.t$cfrw$l in ('A44','A45','A46','T68','T69','T70','T71','T72','T73') 	
			   THEN NVL( tccom130transp.t$fovn$l, 
						 ( select Trim(A.T$FOVT$C)
							 from BAANDB.TZNSLS410301 A
							where A.T$NCIA$C = ZNSLS401.T$NCIA$C
							  and A.T$UNEG$C = ZNSLS401.T$UNEG$C
							  and A.T$PECL$C = ZNSLS401.T$PECL$C
							  and A.T$SQPD$C = ZNSLS401.T$SQPD$C
							  and A.T$ENTR$C = ZNSLS401.T$ENTR$C
							  and A.T$NTRA$C != ' '
							  and ROWNUM = 1 ) )              
			 ELSE tccom130OV.t$fovn$l 
		END                                       CNPJ_TRANSP_COLETA,
		
		znsls401.t$cepe$c                                                                                       CEP,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$cide$c )),';',''),'"','') as varchar(100))      CIDADE,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$ufen$c )),';',''),'"','') as varchar(100))      UF,
		cast(replace(replace(own_mis.filtro_mis(Trim(tdsls401.t$item)),';',''),'"','')    as varchar(100))      Item,
		cast(replace(replace(own_mis.filtro_mis(Trim(tcibd001.t$dsca)),';',''),'"','')    as varchar(100))      DESCRICAO_DO_ITEM, 

		(select cast(replace(replace(own_mis.filtro_mis(Trim(tcmcs023.t$dsca)),';',''),'"','')    as varchar(100))      
    from baandb.ttcmcs023301 tcmcs023
    where tcmcs023.t$citg = tcibd001.t$citg)
                                                                                                            DEPARTAMENTO,
		( select cast(replace(replace(own_mis.filtro_mis(Trim(znmcs030.t$dsca$c)),';',''),'"','')  as varchar(100))
      from baandb.tznmcs030301 znmcs030
      where znmcs030.t$citg$c = tcibd001.t$citg
        and znmcs030.t$seto$c = tcibd001.t$seto$c)
                                                                                                            SETOR, 
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$nome$c)),';',''),'"','')   as varchar(100))     NOME_CLIENTE_COLETA,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$tele$c)),';',''),'"','')   as varchar(100))     TEL,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$te1e$c)),';',''),'"','')   as varchar(100))     TEL_1,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$te2e$c)),';',''),'"','')   as varchar(100))     TEL_2,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$emae$c)),';',''),'"','')  as varchar(100))      Email, 
		znsls401.t$fovn$c                                                                                       CPF_CLIENTE,
		
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$loge$c)),';',''),'"','')   as varchar(100))     ENDERECO,
		znsls401.t$nume$c                                                                                       NUMERO,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$come$c)),';',''),'"','')   as varchar(100))     COMPLEMENTO,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$baie$c)),';',''),'"','')   as varchar(100))     BAIRRO,
		cast(replace(replace(own_mis.filtro_mis(Trim(znsls401.t$refe$c)),';',''),'"','')   as varchar(100))     REFERENCIA, 
		
		NVL(cisli941.t$dqua$l, 
			ABS(znsls401.t$qtve$c) )                  QTDE_ITEM,
		NVL(cisli941.t$dqua$l, ABS(znsls401.t$qtve$c))*
			tcibd001.t$wght                           PESO_KG,
--		CUBAGEM.TOT * NVL(znmcs080.t$cuba$c,0)      CUBAGEM,
      (whwmd400.t$hght*whwmd400.t$wdth*whwmd400.t$dpth * cisli941.t$dqua$l * znmcs080.t$cuba$c) 
                                                  CUBAGEM,
		cisli940.t$fire$l                           REF_FISCAL,
		  CASE WHEN znsls002.t$stat$c = 4 --Insucesso na Entrega  
			   THEN CASE WHEN znsls400.t$sige$c = 1 and znmcs096.t$trdt$c > to_date('01-01-1980','DD-MM-YYYY') 
						   THEN znmcs096.t$trdt$c
						 WHEN VENDA_REF.T$DOCN$L != 0 
						   THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(VENDA_REF.t$dtem$l, 
								  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
									AT time zone 'America/Sao_Paulo') AS DATE)

						 WHEN (znsls400.t$sige$c = 1 and znmcs096.t$docn$c = 0) OR
							  (znsls400.t$sige$c = 2 and VENDA_REF.t$docn$l = 0) 
						   THEN NULL
					END                                           
			 ELSE CASE WHEN cisli940.t$docn$l = 0 
						 THEN NULL
					   ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
							  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
								AT time zone 'America/Sao_Paulo') AS DATE)
				  END
		END                                       DATA_EMISSAO_NF,
		
		CASE WHEN znsls400.t$sige$c = 1 THEN znmcs096.t$docn$c
		ELSE VENDA_REF.T$DOCN$L END               NOTA_SAIDA,

		CASE WHEN znsls400.t$sige$c = 1 THEN znmcs096.t$seri$c
		ELSE VENDA_REF.T$SERI$L  END              SERIE_SAIDA,

		cisli940.t$docn$l                         NOTA_ENTRADA,

		cisli940.t$seri$l                         SERIE_ENTRADA,

		cisli941.t$pric$l                         VALOR_PRODUTO,


		 znsls401.t$vlfr$c                         VL_FRETE_SITE,
		CASE when cisli940.t$stat$l in (5,6) -- Status da nota: Impresso e Lançado
		  OR cisli940.t$stat$l is null then
		NVL(CISLI940.T$GAMT$L,0)                   
		  ELSE 0 
		END   
                                              VL_TOTAL_ITEM,
												  
		 CASE when cisli940.t$stat$l in (5,6) -- Status da nota: Impresso e Lançado   --ANALISAR
		  OR cisli940.t$stat$l is null then
		NVL(cisli940.t$amnt$l,0)                   
		  ELSE 0 
		END                                       
                                                VL_TOTAL_NF,

	   
		znfmd060.t$refe$c                         DESCRICAO_CONTRATO,
		CASE WHEN POSTAGEM.T$PECL$C IS NULL 
			   THEN NULL
			 ELSE znfmd630.t$etiq$c
		END                                       NUMERO_ETIQUETA,
		 cast(replace(replace(own_mis.filtro_mis(Trim(znmcs002.t$desc$c)),';',''),'"','')    as varchar(100))        OCORRENCIA,
		
		
	 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 
				 'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_DA_OCORRENCIA, 
			
		cisli940.t$cnfe$l                          CHAVE_DANFE,
                      
    znsls401.t$obet$c                          ETIQUETA_TRANSPORTADORA
		
 
FROM baandb.tznsls400301 znsls400

  INNER JOIN baandb.tznsls401301 znsls401
         ON znsls401.t$ncia$c = znsls400.t$ncia$c
        AND znsls401.t$uneg$c = znsls400.t$uneg$c
        AND znsls401.t$pecl$c = znsls400.t$pecl$c
        AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
     
  INNER JOIN baandb.ttcibd001301 tcibd001         --nao alterar o ponto de chamada, pois vai aumentar de forma drastica a custo de execucao
          ON tcibd001.t$item = znsls401.t$itml$c
          
  LEFT JOIN baandb.tznsls002301 znsls002
         ON znsls002.t$tpen$c = znsls401.t$itpe$c
	
  LEFT JOIN baandb.twhwmd400301 whwmd400
         ON whwmd400.t$item = znsls401.t$itml$c
         
	LEFT JOIN BAANDB.tznmcs040301 zncms040
         ON zncms040.t$ccol$c = znsls401.t$copo$c 

  LEFT JOIN baandb.tznint002301 znint002
         ON znint002.t$ncia$c = znsls401.t$ncia$c
        AND znint002.t$uneg$c = znsls401.t$uneg$c
        
  INNER JOIN baandb.tznsls409301 znsls409 
          ON znsls409.t$ncia$c = znsls401.t$ncia$c
         AND znsls409.t$uneg$c = znsls401.t$uneg$c
         AND znsls409.t$pecl$c = znsls401.t$pecl$c
         AND znsls409.t$sqpd$c = znsls401.t$sqpd$c
         AND znsls409.t$entr$c = znsls401.t$entr$c

  LEFT JOIN ( select  znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$sqpd$c,
                      znsls410.t$entr$c,
                      MAX(znsls410.t$date$c) t$date$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c,
                      MAX(znsls410.t$dpco$c) t$dpco$c,
                      MAX(znsls410.t$dtpr$c) t$dtpr$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'APD'
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$entr$c,
                        znsls410.t$date$c,
                        znsls410.t$sqpd$c,
                        znsls410.t$pecl$c ) COLETA_PROMETIDA
        ON COLETA_PROMETIDA.t$ncia$c = znsls401.t$ncia$c
		   AND COLETA_PROMETIDA.t$uneg$c = znsls401.t$uneg$c
		   AND COLETA_PROMETIDA.t$pecl$c = znsls401.t$pecl$c
		   AND COLETA_PROMETIDA.t$sqpd$c = znsls401.t$sqpd$c
       AND COLETA_PROMETIDA.t$entr$c = znsls401.t$entr$c

  LEFT JOIN ( select  znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$entr$c,
                      znsls410.t$pecl$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$date$c) t$date$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c,
                      MAX(znsls410.t$dpco$c) t$dpco$c,
                      MAX(znsls410.t$dtpr$c) t$dtpr$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'COS'
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$entr$c,
                        znsls410.t$date$c,
                        znsls410.t$sqpd$c,
                        znsls410.t$pecl$c ) SOLIC_COLETA
        ON SOLIC_COLETA.t$ncia$c = znsls401.t$ncia$c
       AND SOLIC_COLETA.t$uneg$c = znsls401.t$uneg$c
		   AND SOLIC_COLETA.t$pecl$c = znsls401.t$pecl$c
		   AND SOLIC_COLETA.t$entr$c = znsls401.t$entr$c
		   AND SOLIC_COLETA.t$sqpd$c = znsls401.t$sqpd$c 

   LEFT JOIN ( select znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$entr$c,
                      znsls410.t$pecl$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$date$c) t$date$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c
                from baandb.tznsls410301 znsls410
                where znsls410.t$poco$c = 'POS'       --POSTAGEM
                group by  znsls410.t$ncia$c,
                          znsls410.t$uneg$c,
                          znsls410.t$pecl$c,
                          znsls410.t$sqpd$c,
                          znsls410.t$entr$c ) POSTAGEM
          ON POSTAGEM.t$ncia$c = znsls401.t$ncia$c
         AND POSTAGEM.t$uneg$c = znsls401.t$uneg$c
         AND POSTAGEM.t$pecl$c = znsls401.t$pecl$c
         AND POSTAGEM.t$entr$c = znsls401.t$entr$c
         AND POSTAGEM.t$sqpd$c = znsls401.t$sqpd$c 
		   
	 LEFT JOIN ( select znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$entr$c,
                      znsls410.t$pecl$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$date$c) t$date$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c
                from baandb.tznsls410301 znsls410
                where znsls410.t$poco$c = 'INS'       --INSUCESSO
                group by  znsls410.t$ncia$c,
                          znsls410.t$uneg$c,
                          znsls410.t$pecl$c,
                          znsls410.t$sqpd$c,
                          znsls410.t$entr$c) INSUCESSO
        ON INSUCESSO.t$ncia$c = znsls401.t$ncia$c
		   AND INSUCESSO.t$uneg$c = znsls401.t$uneg$c
		   AND INSUCESSO.t$pecl$c = znsls401.t$pecl$c
		   AND INSUCESSO.t$entr$c = znsls401.t$entr$c
		   AND INSUCESSO.t$sqpd$c = znsls401.t$sqpd$c
		   
    LEFT JOIN ( select  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c,
                        MAX(znsls410.t$dtoc$c) t$dtoc$c
                from baandb.tznsls410301 znsls410
                where znsls410.t$poco$c = 'RDV'       --Retorno da Mercadoria ao CD
                group by  znsls410.t$ncia$c,
                          znsls410.t$uneg$c,
                          znsls410.t$pecl$c,
                          znsls410.t$entr$c,   
                          znsls410.t$sqpd$c ) REC_COLETA
        ON REC_COLETA.t$ncia$c = znsls401.t$ncia$c
		   AND REC_COLETA.t$uneg$c = znsls401.t$uneg$c
		   AND REC_COLETA.t$pecl$c = znsls401.t$pecl$c
		   AND REC_COLETA.t$entr$c = znsls401.t$entr$c
		   AND REC_COLETA.t$sqpd$c = znsls401.t$sqpd$c
		   
		  LEFT JOIN ( select  znsls410.t$ncia$c,
                          znsls410.t$uneg$c,
                          znsls410.t$pecl$c,
                          znsls410.t$entr$c,
                          znsls410.t$sqpd$c,
                          MAX(znsls410.t$dtoc$c) t$dtoc$c
                  from baandb.tznsls410301 znsls410
                  where znsls410.t$poco$c = 'CTR'       --Coleta Enviada Para Transportador
                  group by  znsls410.t$ncia$c,
                            znsls410.t$uneg$c,
                            znsls410.t$pecl$c,
                            znsls410.t$entr$c,
                            znsls410.t$sqpd$c ) REC_CTR
        ON REC_CTR.t$ncia$c = znsls401.t$ncia$c
		   AND REC_CTR.t$uneg$c = znsls401.t$uneg$c
		   AND REC_CTR.t$pecl$c = znsls401.t$pecl$c
		   AND REC_CTR.t$entr$c = znsls401.t$entr$c
		   AND REC_CTR.t$sqpd$c = znsls401.t$sqpd$c
		 
	 LEFT JOIN ( select znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$sqpd$c,
                      znsls410.t$entr$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'COL'       --COLETADO
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c ) COLETA
        ON COLETA.t$ncia$c = znsls401.t$ncia$c
		   AND COLETA.t$uneg$c = znsls401.t$uneg$c
		   AND COLETA.t$pecl$c = znsls401.t$pecl$c
		   AND COLETA.t$sqpd$c = znsls401.t$sqpd$c
		   AND COLETA.t$entr$c = znsls401.t$entr$c

	 LEFT JOIN ( select /*+ PUSH_PRED INDEX(A TZNSLS410301$IDX3) */
                      a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      MIN(a.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 a
              where a.t$poco$c = 'PAP'      --APROVAÇÃO PAGTO DEVOLUÇÃO
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c ) PAP_TD      
          ON PAP_TD.t$ncia$c = znsls401.t$ncia$c
         AND PAP_TD.t$uneg$c = znsls401.t$uneg$c
         AND PAP_TD.t$pecl$c = znsls401.t$pecl$c
         AND PAP_TD.t$sqpd$c = znsls401.t$sqpd$c
         AND PAP_TD.t$entr$c = znsls401.t$entr$c

	 LEFT JOIN ( select znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c,
                      znsls410.t$entr$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'POS'       --POSTAGEM
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$sqpd$c,
                        znsls410.t$pecl$c,
                        znsls410.t$entr$c ) POSTAGEM
        ON POSTAGEM.t$ncia$c = znsls401.t$ncia$c
		   AND POSTAGEM.t$uneg$c = znsls401.t$uneg$c
		   AND POSTAGEM.t$pecl$c = znsls401.t$pecl$c
		   AND POSTAGEM.t$entr$c = znsls401.t$entr$c
		   
	 LEFT JOIN ( select znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$entr$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'CPC'       --Cancelamento da Coleta
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c ) CANC_COLETA
        ON CANC_COLETA.t$ncia$c = znsls401.t$ncia$c
		   AND CANC_COLETA.t$uneg$c = znsls401.t$uneg$c
		   AND CANC_COLETA.t$pecl$c = znsls401.t$pecl$c
		   AND CANC_COLETA.t$sqpd$c = znsls401.t$sqpd$c
		   AND CANC_COLETA.t$entr$c = znsls401.t$entr$c

	LEFT JOIN ( select  znsls410. t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$poco$c,
                      znsls410.t$entr$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'RIE'       --Cancelamento da Coleta
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$poco$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c ) RIE
        ON RIE.t$ncia$c = znsls401.t$ncia$c
		   AND RIE.t$uneg$c = znsls401.t$uneg$c
		   AND RIE.t$pecl$c = znsls401.t$pvdt$c
		   AND RIE.t$entr$c = znsls401.t$endt$c
		   AND RIE.t$sqpd$c = znsls401.t$sedt$c

	LEFT JOIN ( select
                    znsls410. t$ncia$c, 
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$poco$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'EXT'
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$poco$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c ) EXTRAVIO
         ON EXTRAVIO.t$ncia$c = znsls401.t$ncia$c
		    AND EXTRAVIO.t$uneg$c = znsls401.t$uneg$c
		    AND EXTRAVIO.t$pecl$c = znsls401.t$pvdt$c
		    AND EXTRAVIO.t$entr$c = znsls401.t$endt$c
		    AND EXTRAVIO.t$sqpd$c = znsls401.t$sedt$c

	LEFT JOIN ( select
                    znsls410. t$ncia$c, 
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$poco$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'EXF'
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$poco$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c ) EXT_FALTA_INF
         ON EXT_FALTA_INF.t$ncia$c = znsls401.t$ncia$c
		    AND EXT_FALTA_INF.t$uneg$c = znsls401.t$uneg$c
		    AND EXT_FALTA_INF.t$pecl$c = znsls401.t$pvdt$c
		    AND EXT_FALTA_INF.t$entr$c = znsls401.t$endt$c
		    AND EXT_FALTA_INF.t$sqpd$c = znsls401.t$sedt$c

	LEFT JOIN ( select
                    znsls410. t$ncia$c, 
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$poco$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'ROU'
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$poco$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c ) ROUBO
         ON ROUBO.t$ncia$c = znsls401.t$ncia$c
		    AND ROUBO.t$uneg$c = znsls401.t$uneg$c
		    AND ROUBO.t$pecl$c = znsls401.t$pvdt$c
		    AND ROUBO.t$entr$c = znsls401.t$endt$c
		    AND ROUBO.t$sqpd$c = znsls401.t$sedt$c

	LEFT JOIN ( select
                    znsls410. t$ncia$c, 
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$poco$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'AVA'
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$poco$c,
                        znsls410.t$entr$c,
                        znsls410.t$sqpd$c ) AVARIA
         ON AVARIA.t$ncia$c = znsls401.t$ncia$c
		    AND AVARIA.t$uneg$c = znsls401.t$uneg$c
		    AND AVARIA.t$pecl$c = znsls401.t$pvdt$c
		    AND AVARIA.t$entr$c = znsls401.t$endt$c
		    AND AVARIA.t$sqpd$c = znsls401.t$sedt$c

	LEFT JOIN ( select
                    znsls410. t$ncia$c, 
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$poco$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c,
                    MAX(znsls410.t$dtoc$c) t$dtoc$c
              from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'RTD'
              group by  znsls410.t$ncia$c,
                        znsls410.t$uneg$c,
                        znsls410.t$pecl$c,
                        znsls410.t$poco$c,
                        znsls410.t$sqpd$c,
                        znsls410.t$entr$c
                         ) ROTA_DEV
         ON ROTA_DEV.t$ncia$c = znsls401.t$ncia$c
		    AND ROTA_DEV.t$uneg$c = znsls401.t$uneg$c
		    AND ROTA_DEV.t$pecl$c = znsls401.t$pvdt$c
		    AND ROTA_DEV.t$sqpd$c = znsls401.t$sedt$c
        AND ROTA_DEV.t$entr$c = znsls401.t$endt$c
      

    LEFT JOIN ( select  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c,
                        a.t$sequ$c,
                        max(a.t$orno$c) t$orno$c,
                        min(a.t$pono$c) t$pono$c
                from baandb.tznsls004301 a 
                group by  a.t$ncia$c,
                          a.t$uneg$c,
                          a.t$pecl$c,
                          a.t$sqpd$c,
                          a.t$entr$c,
                          a.t$sequ$c ) znsls004_ENTREGA
       ON znsls004_ENTREGA.t$ncia$c = znsls401.t$ncia$c
      AND znsls004_ENTREGA.t$uneg$c = znsls401.t$uneg$c
      AND znsls004_ENTREGA.t$pecl$c = znsls401.t$pvdt$c
      AND znsls004_ENTREGA.t$sqpd$c = znsls401.t$sedt$c
      AND znsls004_ENTREGA.t$entr$c = znsls401.t$endt$c
      AND znsls004_ENTREGA.t$sequ$c = znsls401.t$sidt$c

    LEFT JOIN baandb.tznsls401301 znsls401_ENTREGA
           ON znsls401_ENTREGA.t$ncia$c = znsls004_ENTREGA.t$ncia$c
          AND znsls401_ENTREGA.t$uneg$c = znsls004_ENTREGA.t$uneg$c
          AND znsls401_ENTREGA.t$pecl$c = znsls004_ENTREGA.t$pecl$c
          AND znsls401_ENTREGA.t$sqpd$c = znsls004_ENTREGA.t$sqpd$c
          AND znsls401_ENTREGA.t$entr$c = znsls004_ENTREGA.t$entr$c
          AND znsls401_ENTREGA.t$sequ$c = znsls004_ENTREGA.t$sequ$c  
		   
	 LEFT JOIN ( select /*+ PUSH_PRED */
                      znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$entr$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$orno$c)  t$orno$c,
                      MAX(znsls410.t$dtoc$c)  t$dtoc$c,
                      MAX(znsls410.t$ntra$c)  t$ntra$c
                from baandb.tznsls410301 znsls410
                where znsls410.t$poco$c = 'ETR'  --ENTREGUE À TRANSPORTADORA
                group by  znsls410.t$ncia$c,
                          znsls410.t$uneg$c,
                          znsls410.t$pecl$c,
                          znsls410.t$entr$c,
                          znsls410.t$sqpd$c ) EXPEDICAO
        ON EXPEDICAO.t$ncia$c = znsls004_ENTREGA.t$ncia$c
		   AND EXPEDICAO.t$uneg$c = znsls004_ENTREGA.t$uneg$c
		   AND EXPEDICAO.t$pecl$c = znsls004_ENTREGA.t$pecl$c
		   AND EXPEDICAO.t$entr$c = znsls004_ENTREGA.t$entr$c
		   AND EXPEDICAO.t$sqpd$c = znsls004_ENTREGA.t$sqpd$c
       
    LEFT JOIN baandb.tcisli245301 SLI245
           ON SLI245.t$slcp = 301
          AND SLI245.t$ortp = 1
          AND SLI245.t$koor = 3
          AND SLI245.t$slso = znsls004_ENTREGA.t$orno$c
          AND SLI245.t$oset = 0
          AND SLI245.t$pono = znsls004_ENTREGA.t$pono$c
          AND SLI245.t$sqnb = 0

	 LEFT JOIN baandb.tcisli940301 VENDA_REF
          ON VENDA_REF.t$fire$l = SLI245.t$fire$l
			
	 LEFT JOIN baandb.ttcmcs080301  VENDA_TRANSP
          ON VENDA_TRANSP.t$cfrw = VENDA_REF.t$cfrw$l
	 
    LEFT JOIN baandb.ttcmcs080301 tcmcs080_ENTREGA
           ON tcmcs080_ENTREGA.t$cfrw = VENDA_REF.t$cfrw$l

	 LEFT JOIN ( select znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$entr$c,
                      znsls410.t$sqpd$c,
                      MAX(znsls410.t$dtoc$c) DATA_OCORR
                from baandb.tznsls410301 znsls410
                where znsls410.t$poco$c = 'CAN'      --PEDIDO CANCELADO
                group by znsls410.t$ncia$c,
                         znsls410.t$uneg$c,
                         znsls410.t$pecl$c,
                         znsls410.t$entr$c,
                         znsls410.t$sqpd$c ) CANC_PED
        ON CANC_PED.t$ncia$c = znsls004_ENTREGA.t$ncia$c
		   AND CANC_PED.t$uneg$c = znsls004_ENTREGA.t$uneg$c
		   AND CANC_PED.t$pecl$c = znsls004_ENTREGA.t$pecl$c
		   AND CANC_PED.t$entr$c = znsls004_ENTREGA.t$entr$c
		   AND CANC_PED.t$sqpd$c = znsls004_ENTREGA.t$sqpd$c

	 LEFT JOIN ( select a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      max(a.t$entr$c) t$entr$c 
               from BAANDB.tznsls401301 a
               where a.t$qtve$c > 0
               group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c ) znsls401troca         
        ON znsls401troca.t$ncia$c = znsls401.t$ncia$c
		   AND znsls401troca.t$uneg$c = znsls401.t$uneg$c
		   AND znsls401troca.t$pecl$c = znsls401.t$pecl$c
		   AND znsls401troca.t$sqpd$c = znsls401.t$sqpd$c
	 		
LEFT JOIN baandb.tcisli245301 cisli245 
       ON cisli245.t$slcp = 301
      AND cisli245.t$ortp = 1
      AND cisli245.t$koor = 3
      AND cisli245.t$slso = znsls409.t$dorn$c        -- OV de Devolução
      AND cisli245.t$oset = 0
      AND cisli245.t$pono = znsls401.t$pono$c

	 LEFT JOIN baandb.ttdsls401301  tdsls401
          ON tdsls401.t$orno = znsls409.t$dorn$c
         AND tdsls401.t$pono = znsls401.t$pono$c
         AND tdsls401.t$sqnb = 0

	 LEFT JOIN baandb.ttdrec947301 tdrec947
          ON tdrec947.t$ncmp$l = 301 
         AND tdrec947.t$oorg$l = 1 
         AND tdrec947.t$orno$l = znsls409.t$orno$c
         AND tdrec947.t$pono$l = znsls401.t$pono$c 
		   
	 LEFT JOIN baandb.tcisli940301 cisli940               --trava em razão da cisli245
          ON cisli940.t$fire$l = cisli245.t$fire$l      --Nota de Retorno de Mercadoria ao Cliente

  LEFT JOIN baandb.tcisli941301 cisli941               --trava em razao da cisli245
         ON cisli941.t$fire$l = cisli245.t$fire$l
        AND cisli941.t$line$l = cisli245.t$line$l
  
  LEFT JOIN baandb.ttdsls400301 tdsls400
         ON tdsls400.t$orno = tdsls401.t$orno

  LEFT JOIN baandb.ttcmcs080301 tcmcs080          --Transportadora da Coleta
          ON tcmcs080.t$cfrw = cisli940.t$cfrw$l
           
  LEFT JOIN baandb.ttcmcs080301 tcmcs080OV 
         ON tcmcs080OV.T$CFRW = tdsls400.t$cfrw     

  LEFT JOIN baandb.ttcmcs065301 tcmcs065 
         ON tcmcs065.t$cwoc = tdsls400.t$cofc
          
  LEFT JOIN baandb.ttccom130301 tccom130 
         ON tccom130.t$cadr = tcmcs065.t$cadr
      
  LEFT JOIN baandb.ttccom130301 tccom130OV 
         ON tcmcs080OV.T$CADR$L = tccom130OV.t$cadr    
         
  LEFT JOIN baandb.ttccom130301  tccom130cnova 
         ON tccom130cnova.t$cadr = cisli940.t$sfra$l
		
  LEFT JOIN baandb.ttccom130301 tccom130transp 
         ON tccom130transp.t$cadr = tcmcs080.t$cadr$l
	  
  LEFT JOIN baandb.tznfmd001301 znfmd001
         ON znfmd001.t$fovn$c = tccom130.t$fovn$l

  LEFT JOIN baandb.ttdsls094301 tdsls094
         ON tdsls094.t$sotp = tdsls400.t$sotp
          
	 LEFT JOIN ( select znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$entr$c,
                      znsls410.t$sqpd$c,
                      max(znsls410.t$dtoc$c) t$dtoc$c,
                      MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
                from baandb.tznsls410301 znsls410
                group by znsls410.t$ncia$c,
                         znsls410.t$uneg$c,
                         znsls410.t$pecl$c,
                         znsls410.t$entr$c,
                         znsls410.t$sqpd$c ) znsls410
            ON znsls410.t$ncia$c = znsls401.t$ncia$c
           AND znsls410.t$uneg$c = znsls401.t$uneg$c
           AND znsls410.t$pecl$c = znsls401.t$pecl$c
           AND znsls410.t$entr$c = znsls401.t$entr$c
           AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
		
	 LEFT JOIN baandb.tznmcs002301 znmcs002
          ON znmcs002.t$poco$c = znsls410.PT_CONTR
		
    LEFT JOIN ( select  a.t$ncmp$c,
                        a.t$cref$c,
                        a.t$cfoc$c,
                        a.t$docn$c,
                        a.t$seri$c,
                        a.t$doty$c,
                        a.t$trdt$c,
                        a.t$creg$c,
                        a.t$cfov$c,
                        a.t$orno$c,
                        a.t$pono$c
                from baandb.tznmcs096301 a 
               group by a.t$ncmp$c,
                        a.t$cref$c,
                        a.t$cfoc$c,
                        a.t$docn$c,
                        a.t$seri$c,
                        a.t$doty$c,
                        a.t$trdt$c,
                        a.t$creg$c,
                        a.t$cfov$c,
                        a.t$orno$c,
                        a.t$pono$c ) znmcs096       --Precisa criar indice
			ON znmcs096.t$orno$c = cisli245.t$slso
     AND znmcs096.t$pono$c = cisli245.t$pono
     AND znmcs096.t$ncmp$c = 2    --Faturamento       

	 LEFT JOIN  (Select /*+ PUSH_PRED */ 
                     a.t$orno$c,
                      a.t$pecl$c,
                      a.t$torg$c,
                      a.t$cfrw$c,
                      a.t$cono$c,
                      MIN(a.t$etiq$c) t$etiq$c,
                      a.t$stat$c,
                      a.t$dtco$c
                from  baandb.tznfmd630301 a
                group by
                      a.t$orno$c,
                      a.t$pecl$c,
                      a.t$torg$c,
                      a.t$cfrw$c,
                      a.t$cono$c,
                      a.t$stat$c,
                      a.t$dtco$c ) znfmd630
			  ON znfmd630.t$orno$c = tdsls400.t$orno

    LEFT JOIN baandb.tznmcs080301 znmcs080 
           ON znmcs080.t$cfrw$c = znfmd630.t$cfrw$c
           
    LEFT JOIN baandb.tznfmd060301 znfmd060         --Contrato Transportadora    --criar indice por cfrw/cono
           ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
          AND znfmd060.t$cono$c = znfmd630.t$cono$c

WHERE tdsls094.t$reto in (1, 3)           -- Ordem Devolução, Ordem Devolução Rejeitada
      AND tdsls094.t$insu$c = 2
      AND tcibd001.t$citg != '1000'
--      AND REC_COLETA.t$dtoc$c IS not NULL
      AND znsls401.t$iitm$c = 'P'
      AND znsls401.t$qtve$c < 0  
      AND znsls400.t$idpo$c = 'TD' 
      AND znsls400.t$dtem$c
--      Between TO_DATE('15/04/2017 03:00:00','DD/MM/YYYY HH24:MI:SS') and TO_DATE('15/05/2017 02:59:59','DD/MM/YYYY HH24:MI:SS')
     Between to_date('01/02/2016','dd/mm/yyyy') and trunc(LAST_DAY(SYSDATE - 1))
