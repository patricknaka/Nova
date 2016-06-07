SELECT Q1.*
	  FROM ( SELECT 301                                                               CIA,
--				 CASE WHEN NVL( (FILIAL.T$STYP), '0' ) = '0'                  
--						THEN 2 ELSE 3 END                                                 FILIAL,
         znfmd001_fili.t$fili$c                                               FILIAL,
				 PRG_MOV.T$NINV                                                       TITULO,
				 PRG_MOV.T$RPST$L                                                     SITUACAO_TITULO, 
				 SIT_TIT.                                                             DESCR_SIT_TIT,
				 PRG_MOV.T$TTYP                                                       DOC,
				 TCCOM130.T$FOVN$L                                                    CNPJ,
				 TCCOM100.T$NAMA                                                      NOME,
				 PRG_MOV.T$DOCD                                                       DT_EMISSAO,
				 PRG_MOV.T$AMNT                                                       VL_TITULO,
				 PRG_MOV.T$BALC                                                       VL_SALDO_TITULO,
				 PRG_MOV.T$PAYM                                                       CARTEIRA,
				 TFCMG011.T$BAOC$L                                                    CD_BANCO,
				 TFCMG011.T$AGCD$L                                                    NR_AGENCIA,
				 TFCMG001.T$BANO                                                      NR_CONTA_CORRENTE,
				 PRG_MOV.T$SCHN                                                       NR_DOCUMENTO,
				 TITULO.T$LEAC                                                        CENTRO_CUSTO,
				 PRG_MOV.T$RECD                                                       DT_VENCIMENTO,
				 PRG_MOV.T$DUED$L                                                     DT_VENCIMENTO_ORIGINAL,
         CASE WHEN PRG_MOV.T$RPST$L IN (3,4) THEN  --PARCIALMENTE PAGO 0U PAGO
             CASE WHEN TITULO.T$BALC = 0
                THEN ( SELECT MAX(P.T$DOCD)   
                     FROM BAANDB.TTFACR200301 P 
                    WHERE P.T$TTYP = TITULO.T$TTYP  
                     AND P.T$NINV = TITULO.T$NINV
                     AND P.T$LINE = TITULO.T$LINE
                     AND P.T$TDOC != ' '
                     AND P.T$DOCN != 0
                     AND P.T$LINO != 0)  
                ELSE    ( SELECT MAX(P.T$DOCD)   
                     FROM BAANDB.TTFACR200301 P 
                    WHERE P.T$TTYP = TITULO.T$TTYP  
                     AND P.T$NINV = TITULO.T$NINV
                     AND P.T$LINE = TITULO.T$LINE
                     AND P.T$TDOC != ' '
                     AND P.T$DOCN != 0
                     AND P.T$LINO != 0)  
                  END
         ELSE NULL END                                                                DT_LIQUIDACAO_TITULO,				 
         TFCMG401.T$BTNO                                                              REMESSA,
				 TFCMG409.T$DATE                                                      DT_REMESSA,
				 CISLI940.T$DOCN$L                                                    NOTA,
				 CISLI940.T$SERI$L                                                    SERIE,
				 CISLI940.T$FIRE$L                                                    REF_FISCAL,
				 PRG_MOV.T$BANU$L                                                     NR_BANCARIO,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL 
            THEN PEDIDO.T$UNEG$C 
            ELSE PEDIDO_REL.T$UNEG$C 
          END                                                                         UNID_NEGOCIO,
				 CASE WHEN (PEDIDO_REL.T$FIRE$L) IS NULL
            THEN ZNINT002.T$DESC$C
            ELSE ZNINT002_REL.T$DESC$C
         END                                                                          DESC_UNID_NEGOCIO,
				 ZNREC007.T$LOGN$C                                                    USUARIO,
         CASE WHEN (PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_IDCP=1 
              THEN PEDIDO.T$IDCP$C 
              ELSE NULL 
            END
         ELSE CASE WHEN PEDIDO_REL.C_IDCP=1 
              THEN PEDIDO_REL.T$IDCP$C 
              ELSE NULL 
              END
         END                                                                          CAMPANHA,
				 ZNREC007.T$CVPC$C                                                    CONTRATO_VPC,
				 PRG_MOV.T$TDOC                                                       ID_TRANSACAO,
				 GLD011.T$DESC                                                        TRANSACAO, 
				 PRG_MOV.T$DOCD                                                       DATA_TRANSACAO,
				 CASE WHEN PRG_MOV.T$DOCN ! =  0  
						THEN NVL(AGRUP.T$TTYP$C, TREF.T$TTYP)   
					  ELSE NULL   
				  END                                                                 TITULO_REFERENCIA,
				 CASE WHEN PRG_MOV.T$DOCN ! =  0                  
						THEN NVL(AGRUP.T$NINV$C, TREF.T$NINV)                   
					  ELSE NULL                   
				  END                                                                 DOCUMENTO_REFERENCIA,
				 CASE WHEN PRG_MOV.T$DOCN ! =  0                  
						THEN NVL(AGRUP.DT_VENC, TREF.DT_VENC)                   
					  ELSE NULL                   
				  END                                                                 DATA_VENCTO_TIT_REFM,
				 CASE WHEN PRG_MOV.T$DOCN ! =  0                  
						THEN NVL(AGRUP.DT_LIQ, TREF.DT_LIQ)                   
					  ELSE NULL                   
				  END                                                                 DATA_LIQUID_TIT_REF,
				 CASE WHEN PRG_MOV.T$DOCN ! =  0                
						THEN NVL(AGRUP.DT_LIQ, TREF.DT_LIQ)                 
					  ELSE NULL                 
				  END                                                                 DATA_TRANSACAO_TIT_REF,
				 CASE WHEN PRG_MOV.T$DOCN ! =  0                
						THEN NVL(AGRUP.T$AMNT, TREF.T$AMNT)                 
					  ELSE NULL                 
				  END                                                                 VALOR_TRANSACAO_TIT_REF,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_PEEX=1 
              THEN PEDIDO.T$PEEX$C 
              ELSE NULL 
            END
         ELSE
            CASE WHEN PEDIDO_REL.C_PEEX=1 
              THEN PEDIDO_REL.T$PEEX$C 
              ELSE NULL 
            END 
         END                                                                  PEDIDO_EXTERNO,
				 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 
				  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)
													  DATA_EMISSAO_NF,
				 CISLI940.T$STAT$L                                                    SITUACAO_NF,
				 SITUACAO_NF.                                                         DESCR_SITUACAO_NF,
				 TITULO.T$ITBP                                                        COD_PARCEIRO,
				 PRG_MOV.T$RECA                                                       VALOR_TRANSACAO,
         CASE WHEN (PEDIDO_REL.T$FIRE$L) IS NULL 
            THEN ZNCMG007.t$desc$c 
            ELSE ZNCMG007_REL.t$desc$c
         END                                                                  DESC_MEIO_PAGTO,
         CASE WHEN (PEDIDO_REL.T$FIRE$L) IS NULL 
            THEN ZNINT002.T$WSTP$C  
            ELSE ZNINT002_REL.T$WSTP$C 
         END                                                                  TIPO_VENDA,
         CASE WHEN (PEDIDO_REL.T$FIRE$L) IS NULL 
            THEN zncmg007.t$ctmp$c
            ELSE zncmg007_REL.t$ctmp$c
         END                                                                  CATEGORIA_MP,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$LOGF$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$LOGF$C 
              ELSE NULL END
         END                                                                  ENDERECO,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$NUMF$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$NUMF$C 
              ELSE NULL END
         END                                                                  NUMERO,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$BAIF$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$BAIF$C 
              ELSE NULL END
         END                                                                  BAIRRO,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$CIDF$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$CIDF$C 
              ELSE NULL END
         END                                                                  CIDADE,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$UFFA$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$UFFA$C 
              ELSE NULL END
         END                                                                  UF,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$CEPF$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$CEPF$C 
              ELSE NULL END
         END                                                                  CEP,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$TELF$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$TELF$C 
              ELSE NULL END
         END                                                                  TELEFONE,
				 CASE WHEN(PEDIDO_REL.T$FIRE$L) IS NULL THEN
            CASE WHEN PEDIDO.C_ENTR = 1 
              THEN PEDIDO.T$ENTR$C 
              ELSE NULL END
         ELSE
            CASE WHEN PEDIDO_REL.C_ENTR = 1 
              THEN PEDIDO_REL.T$ENTR$C 
              ELSE NULL END
         END                                                                  ENTREGA,
         TCCOM130.T$INFO                                                      EMAIL,
         NVL( (T.T$TEXT),' ' )                                                OBSERVACAO,
         PRG_MOV.T$TDOC                                                       TRANSACAO_RECEB,
         PRG_MOV.T$DOCN                                                       NR_DOCTO_RECEB,
         PRG_MOV.PAGO                                                         VL_DOCTO_RECEB,
         PRG_MOV.DT_REC                                                       DT_RECEB,
         cisli940.t$fdtc$l                                                    COD_TIPO_DOC_FISCAL
         
 FROM    ( SELECT NVL(TFACR201.T$TTYP, TFACR200.T$TTYP) T$TTYP,
							 NVL(TFACR201.T$NINV, TFACR200.T$NINV) T$NINV,
							 NVL(TFACR201.T$SCHN, TFACR200.T$SCHN) T$SCHN,
							 TFACR201.T$RPST$L,
							 NVL(TFACR201.T$DOCD, TFACR200.T$DOCD) T$DOCD,
							 TFACR201.T$AMNT,
							 TFACR201.T$BALC,
               TFACR200.T$AMNT PAGO,
							 TFACR200.T$DOCD DT_REC,
               TFACR201.T$PAYM,
							 TFACR201.T$BREL,
							 TFACR200.T$TDOC,
							 TFACR200.T$DOCN,
							 TFACR201.T$RECD,
							 TFACR201.T$DUED$L,
               TFACR201.T$RECA,
							 NVL(TFACR200.T$ITBP, TFACR200.T$ITBP) T$ITBP,
               EBF.T$BANU$L T$BANU$L
						FROM BAANDB.TTFACR201301 TFACR201
			 
			FULL OUTER JOIN ( SELECT SQ.*
								FROM BAANDB.TTFACR200301 SQ 
							   WHERE SQ.T$DOCN ! =  0 
							   --AND   SQ.T$STEP IN (7,10,16,20) --7-Duplicata Aceita/Enviada, 10-DOCUMENTO ENVIADO AO BANCO, 16-Paga, 20-Não Aplicável 
                 --and SQ.T$AMNT > 0
                 ) TFACR200     
						 ON TFACR200.T$TTYP = TFACR201.T$TTYP 
						AND TFACR200.T$NINV = TFACR201.T$NINV
						AND TFACR200.T$SCHN = TFACR201.T$SCHN
            
      left join baandb.ttfcmg948301 EBF
             on TFACR201.T$TTYP = EBF.T$TTYP$L
            and TFACR201.T$NINV = EBF.T$NINV$L
            and to_char(TFACR201.T$SCHN) = EBF.T$SERN$L) PRG_MOV
				
			INNER JOIN BAANDB.TTFACR200301 TITULO 
					ON TITULO.T$TTYP = PRG_MOV.T$TTYP 
				   AND TITULO.T$NINV = PRG_MOV.T$NINV 
				   AND TITULO.T$DOCN = 0

			LEFT JOIN BAANDB.TTFACR200301 TITPGO  -- TITULOS COM PAGAMENTO
					ON TITPGO.T$TTYP = PRG_MOV.T$TTYP 
				   AND TITPGO.T$NINV = PRG_MOV.T$NINV 
				   AND TITPGO.T$DOCN ! = 0
           AND TITPGO.T$DOCN = PRG_MOV.T$DOCN
				   AND TITPGO.T$TDOC = PRG_MOV.T$TDOC
				   AND TITPGO.T$AMNT > 0
            
 			INNER JOIN BAANDB.TTCCOM100301 TCCOM100 
					ON TCCOM100.T$BPID = TITULO.T$ITBP 
			  
			INNER JOIN BAANDB.TTCCOM130301 TCCOM130 
					ON TCCOM130.T$CADR = TCCOM100.T$CADR
			  
			 LEFT JOIN BAANDB.TTFCMG001301 TFCMG001 
					ON TFCMG001.T$BANK = PRG_MOV.T$BREL
			  
			 LEFT JOIN BAANDB.TTFCMG011301 TFCMG011 
					ON TFCMG011.T$BANK = TFCMG001.T$BRCH
			  
			 LEFT JOIN BAANDB.TTFCMG401301 TFCMG401  
					ON TFCMG401.T$TTYP = PRG_MOV.T$TTYP 
				   AND TFCMG401.T$NINV = PRG_MOV.T$NINV
				   AND TFCMG401.T$SCHN = PRG_MOV.T$SCHN
				
			 LEFT JOIN BAANDB.TTFCMG409301 TFCMG409 
					ON TFCMG409.T$BTNO = TFCMG401.T$BTNO
			  
			 LEFT JOIN BAANDB.TCISLI940301 CISLI940 
					ON CISLI940.T$ITYP$L = TITULO.T$TTYP
				   AND CISLI940.T$IDOC$L = TITULO.T$NINV
				   AND CISLI940.T$DOCN$L = TITULO.T$DOCN$L
				
			 LEFT JOIN BAANDB.TZNREC007301 ZNREC007  
					ON ZNREC007.T$TTYP$C = TITULO.T$TTYP
				   AND ZNREC007.T$DOCN$C = TITULO.T$NINV

--referencia fiscal
		LEFT JOIN (SELECT
				  LRF.T$FIRE$L,
          FAT.T$ityp$l,
          FAT.T$idoc$l,
				  MIN(ZNSLS004.T$NCIA$C) T$NCIA$C,
				  MIN(ZNSLS004.T$UNEG$C) T$UNEG$C,
				  MIN(ZNSLS004.T$PECL$C) T$PECL$C,
				  MIN(ZNSLS004.T$SQPD$C) T$SQPD$C,
				  MIN(ZNSLS004.T$ENTR$C) T$ENTR$C,
				  COUNT(DISTINCT ZNSLS004.T$ENTR$C) C_ENTR,
				  MIN(ZNSLS400.T$LOGF$C) T$LOGF$C,
				  MIN(ZNSLS400.T$NUMF$C) T$NUMF$C,
				  MIN(ZNSLS400.T$BAIF$C) T$BAIF$C,
				  MIN(ZNSLS400.T$CIDF$C) T$CIDF$C,
				  MIN(ZNSLS400.T$UFFA$C) T$UFFA$C,
				  MIN(ZNSLS400.T$CEPF$C) T$CEPF$C,
				  MIN(ZNSLS400.T$TELF$C) T$TELF$C,
				  MIN(ZNSLS400.T$PEEX$C) T$PEEX$C,
				  COUNT(DISTINCT ZNSLS400.T$PEEX$C) C_PEEX,
				  ZNSLS402.T$IDMP$C,
				  MIN(ZNSLS400.T$IDCP$C) T$IDCP$C,
				  COUNT(DISTINCT ZNSLS400.T$IDCP$C) C_IDCP
			  FROM 
					BAANDB.TCISLI941301 LRF
				  
        INNER JOIN BAANDB.TCISLI940301 FAT                
				ON  LRF.T$FIRE$L = FAT.T$FIRE$L
          
        --dados do faturamento ou pré faturamento
        INNER JOIN (select cisli245.t$SLSO, cisli245.t$PONO, cisli245.t$FIRE$L
                    from baandb.tcisli245301 cisli245
                    UNION
                    select znsli005.t$ORNO$C, znsli005.t$PONO$C, znsli005.t$FIRE$C
                    from baandb.tznsli005301 znsli005 ) RRF
        on 	RRF.t$FIRE$L = FAT.t$fire$l
				
			  INNER JOIN  BAANDB.TZNSLS004301 ZNSLS004
				ON  ZNSLS004.T$ORNO$C = RRF.T$SLSO
				AND ZNSLS004.T$PONO$C = RRF.T$PONO

			  LEFT JOIN BAANDB.TZNSLS400301 ZNSLS400 
				ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C
				 AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C
				 AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C
				 AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C

			  LEFT JOIN BAANDB.TZNSLS402301 ZNSLS402  
				ON ZNSLS402.T$NCIA$C = ZNSLS004.T$NCIA$C
				 AND ZNSLS402.T$UNEG$C = ZNSLS004.T$UNEG$C
				 AND ZNSLS402.T$PECL$C = ZNSLS004.T$PECL$C
        
        INNER JOIN BAANDB.TZNCMG007301 ZNCMG007
        ON ZNCMG007.T$MPGS$C = ZNSLS402.T$IDMP$C
        AND zncmg007.t$ctmp$c IN (5,6)
		   
			  GROUP BY LRF.T$FIRE$L, FAT.T$ityp$l, FAT.T$idoc$l, ZNSLS402.T$IDMP$C) PEDIDO

				ON PEDIDO.T$FIRE$L = CISLI940.T$FIRE$L
        and PEDIDO.T$ityp$l = CISLI940.T$ityp$l
        and PEDIDO.T$idoc$l = CISLI940.T$idoc$l

--referencia fiscal relativa
  LEFT join (SELECT
				  REL.T$FIRE$L,
				  REL.T$REFR$L,
          FAT.T$ityp$l,
          FAT.T$idoc$l,
          MIN(ZNSLS004_REL.T$NCIA$C) T$NCIA$C,
				  MIN(ZNSLS004_REL.T$UNEG$C) T$UNEG$C,
				  MIN(ZNSLS004_REL.T$PECL$C) T$PECL$C,
				  MIN(ZNSLS004_REL.T$SQPD$C) T$SQPD$C,
				  MIN(ZNSLS004_REL.T$ENTR$C) T$ENTR$C,
				  COUNT(DISTINCT ZNSLS004_REL.T$ENTR$C) C_ENTR,
				  MIN(ZNSLS400_REL.T$LOGF$C) T$LOGF$C,
				  MIN(ZNSLS400_REL.T$NUMF$C) T$NUMF$C,
				  MIN(ZNSLS400_REL.T$BAIF$C) T$BAIF$C,
				  MIN(ZNSLS400_REL.T$CIDF$C) T$CIDF$C,
				  MIN(ZNSLS400_REL.T$UFFA$C) T$UFFA$C,
				  MIN(ZNSLS400_REL.T$CEPF$C) T$CEPF$C,
				  MIN(ZNSLS400_REL.T$TELF$C) T$TELF$C,
				  MIN(ZNSLS400_REL.T$PEEX$C) T$PEEX$C,
				  COUNT(DISTINCT ZNSLS400_REL.T$PEEX$C) C_PEEX,
				  ZNSLS402_REL.T$IDMP$C,
				  MIN(ZNSLS400_REL.T$IDCP$C) T$IDCP$C,
				  COUNT(DISTINCT ZNSLS400_REL.T$IDCP$C) C_IDCP
			  FROM 
					BAANDB.TCISLI941301 REL
          
        INNER JOIN BAANDB.TCISLI940301 FAT                
				ON  REL.T$FIRE$L = FAT.T$FIRE$L
          
        --dados do faturamento ou pré faturamento
        INNER JOIN (select cisli245.t$SLSO, cisli245.t$PONO, cisli245.t$FIRE$L
                    from baandb.tcisli245301 cisli245
                    UNION
                    select znsli005.t$ORNO$C, znsli005.t$PONO$C, znsli005.t$FIRE$C
                    from baandb.tznsli005301 znsli005 ) RRF_REL
        on 	RRF_REL.t$FIRE$L = REL.t$refr$l		
        
			  INNER JOIN  BAANDB.TZNSLS004301 ZNSLS004_REL
				ON  ZNSLS004_REL.T$ORNO$C = RRF_REL.T$SLSO
				AND ZNSLS004_REL.T$PONO$C = RRF_REL.T$PONO

			  LEFT JOIN BAANDB.TZNSLS400301 ZNSLS400_REL 
				ON ZNSLS400_REL.T$NCIA$C = ZNSLS004_REL.T$NCIA$C
				 AND ZNSLS400_REL.T$UNEG$C = ZNSLS004_REL.T$UNEG$C
				 AND ZNSLS400_REL.T$PECL$C = ZNSLS004_REL.T$PECL$C
				 AND ZNSLS400_REL.T$SQPD$C = ZNSLS004_REL.T$SQPD$C

			  LEFT JOIN BAANDB.TZNSLS402301 ZNSLS402_REL  
				ON ZNSLS402_REL.T$NCIA$C = ZNSLS004_REL.T$NCIA$C
				 AND ZNSLS402_REL.T$UNEG$C = ZNSLS004_REL.T$UNEG$C
				 AND ZNSLS402_REL.T$PECL$C = ZNSLS004_REL.T$PECL$C
			  
        INNER JOIN BAANDB.TZNCMG007301 ZNCMG007REL
        ON ZNCMG007REL.T$MPGS$C = ZNSLS402_rel.T$IDMP$C
        AND zncmg007REL.t$ctmp$c IN (5,6)
		    
        where REL.T$REFR$L <> ' '
        GROUP BY REL.T$FIRE$L, REL.T$REFR$L, FAT.T$ityp$l, FAT.T$idoc$l,ZNSLS402_REL.T$IDMP$C) PEDIDO_REL

         ON PEDIDO_REL.T$ityp$l = CISLI940.T$ityp$l
        and PEDIDO_REL.T$idoc$l = CISLI940.T$idoc$l
        and PEDIDO_REL.T$fire$L = CISLI940.T$fire$L

--referencia fiscal 
			 LEFT JOIN (SELECT  A.T$NCIA$C,
							A.T$UNEG$C,
							A.T$PECL$C,
							A.T$SQPD$C,
							A.T$ENTR$C,
							MAX(A.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY A.T$DTOC$C, A.T$SEQN$C) T$POCO$C
			  FROM BAANDB.TZNSLS410301 A
			  GROUP BY A.T$NCIA$C,
					   A.T$UNEG$C,
					   A.T$PECL$C,
					   A.T$SQPD$C,
					   A.T$ENTR$C) ZNSLS410  
					ON ZNSLS410.T$NCIA$C = PEDIDO.T$NCIA$C
				   AND ZNSLS410.T$UNEG$C = PEDIDO.T$UNEG$C
				   AND ZNSLS410.T$PECL$C = PEDIDO.T$PECL$C
				   AND ZNSLS410.T$SQPD$C = PEDIDO.T$SQPD$C
				   AND ZNSLS410.T$ENTR$C = PEDIDO.T$ENTR$C            
					  
--referencia fiscal relativa
			 LEFT JOIN (SELECT  A.T$NCIA$C,
							A.T$UNEG$C,
							A.T$PECL$C,
							A.T$SQPD$C,
							A.T$ENTR$C,
							MAX(A.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY A.T$DTOC$C, A.T$SEQN$C) T$POCO$C
			  FROM BAANDB.TZNSLS410301 A
			  GROUP BY A.T$NCIA$C,
					   A.T$UNEG$C,
					   A.T$PECL$C,
					   A.T$SQPD$C,
					   A.T$ENTR$C) ZNSLS410_REL  
					ON ZNSLS410_REL.T$NCIA$C = PEDIDO_REL.T$NCIA$C
				   AND ZNSLS410_REL.T$UNEG$C = PEDIDO_REL.T$UNEG$C
				   AND ZNSLS410_REL.T$PECL$C = PEDIDO_REL.T$PECL$C
				   AND ZNSLS410_REL.T$SQPD$C = PEDIDO_REL.T$SQPD$C
				   AND ZNSLS410_REL.T$ENTR$C = PEDIDO_REL.T$ENTR$C    

			 LEFT JOIN ( SELECT 
                  ZNACR005.T$TTY1$C,
                  ZNACR005.T$NIN1$C,
                  ZNACR005.T$TTY2$C,
                  ZNACR005.T$NIN2$C,
                  ZNACR005.T$TTYP$C, -- TITULO REF
                  ZNACR005.T$NINV$C, -- NUM REF
                  T.T$DOCD,          -- DATA TITULO
                  T.T$AMNT,          -- VALOR TITO
                  ( SELECT MIN(A.T$RECD) 
                    FROM BAANDB.TTFACR201301 A
                     WHERE A.T$TTYP = ZNACR005.T$TTY1$C
                     AND A.T$NINV = ZNACR005.T$NIN1$C ) DT_VENC,
                  CASE WHEN MAX(T.T$BALC) = 0 
                       THEN MAX(M.T$DOCD) 
                     ELSE NULL 
                   END DT_LIQ        -- DATA LIQUIDAÇÃO
            
                 FROM BAANDB.TZNACR005301 ZNACR005, 
                  BAANDB.TTFACR200301 T,
                  BAANDB.TTFACR200301 M
                WHERE T.T$TTYP = ZNACR005.T$TTY1$C
                AND T.T$NINV = ZNACR005.T$NIN1$C
                AND M.T$TTYP = T.T$TTYP
                AND M.T$NINV = T.T$NINV
                AND ZNACR005.T$FLAG$C = 1              
                AND T.T$LINO = 0
                AND M.T$LINO ! =  0
               GROUP BY ZNACR005.T$TTY1$C,
                  ZNACR005.T$NIN1$C,
                  ZNACR005.T$TTY2$C,
                  ZNACR005.T$NIN2$C,
                  ZNACR005.T$TTYP$C, --TITULO REF
                  ZNACR005.T$NINV$C, --NUM REF
                  T.T$AMNT,
                  T.T$DOCD ) AGRUP
					ON  AGRUP.T$TTY1$C = PRG_MOV.T$TTYP
				   AND AGRUP.T$NIN1$C = PRG_MOV.T$NINV        
				   AND AGRUP.T$TTY2$C = PRG_MOV.T$TDOC        
				   AND AGRUP.T$NIN2$C = PRG_MOV.T$DOCN          
					   
			 LEFT JOIN ( SELECT RS.T$TTYP,
								RS.T$NINV,
								RS.T$TDOC,
								RS.T$DOCN,
								T.T$DOCD,      -- DATA TITULO
								T.T$AMNT,      -- VALOR TITO
								( SELECT MIN(A.T$RECD) 
									FROM BAANDB.TTFACR201301 A
								   WHERE A.T$TTYP = RS.T$TTYP
									 AND A.T$NINV = RS.T$NINV ) DT_VENC,
								CASE WHEN MAX(T.T$BALC) = 0 
									   THEN MAX(M.T$DOCD) 
									 ELSE NULL 
								 END DT_LIQ    -- DATA LIQUIDAÇÃO
						   FROM BAANDB.TTFACR200301 RS, 
								BAANDB.TTFACR200301 T, 
								BAANDB.TTFACR200301 M    
						  WHERE T.T$TTYP = RS.T$TTYP
							AND T.T$NINV = RS.T$NINV
							AND M.T$TTYP = T.T$TTYP
							AND M.T$NINV = T.T$NINV
							AND T.T$LINO = 0
							AND M.T$LINO ! =  0
					   GROUP BY RS.T$TTYP,
								RS.T$NINV,
								RS.T$TDOC,
								RS.T$DOCN,
								T.T$DOCD,
								T.T$AMNT ) TREF
					ON  TREF.T$TDOC = PRG_MOV.T$TDOC 
				   AND TREF.T$DOCN = PRG_MOV.T$DOCN 
				   AND TREF.T$TTYP || TREF.T$NINV ! =  PRG_MOV.T$TTYP || PRG_MOV.T$NINV
				   AND TREF.T$AMNT = PRG_MOV.T$AMNT*-1 
				
			 LEFT JOIN ( SELECT C.T$STYP,
								C.T$ITYP,
								C.T$IDOC
						   FROM BAANDB.TCISLI205301 C
						  WHERE C.T$STYP = 'BL ATC') FILIAL
					ON FILIAL.T$ITYP = TITULO.T$TTYP
				   AND FILIAL.T$IDOC = TITULO.T$NINV
				
			 LEFT JOIN ( SELECT L.T$DESC DESCR_SIT_TIT,
								D.T$CNST
						   FROM BAANDB.TTTADV401000 D,
								BAANDB.TTTADV140000 L
						  WHERE D.T$CPAC = 'tf'
							AND D.T$CDOM = 'acr.strp.l'
							AND L.T$CLAN = 'p'
							AND L.T$CPAC = 'tf'
							AND L.T$ZC_CONT = 3
							AND L.T$CLAB = D.T$ZA_CLAB
							AND RPAD(D.T$VERS,4) ||
								RPAD(D.T$RELE,2) ||
								RPAD(D.T$CUST,4) = ( SELECT MAX(RPAD(L1.T$VERS,4) ||
																RPAD(L1.T$RELE,2) ||
																RPAD(L1.T$CUST,4)) 
													   FROM BAANDB.TTTADV401000 L1 
													  WHERE L1.T$CPAC = D.T$CPAC 
														AND L1.T$CDOM = D.T$CDOM )
							AND RPAD(L.T$VERS,4) ||
								RPAD(L.T$RELE,2) ||
								RPAD(L.T$CUST,4) = ( SELECT MAX(RPAD(L1.T$VERS,4) ||
																RPAD(L1.T$RELE,2) ||
																RPAD(L1.T$CUST,4)) 
													   FROM BAANDB.TTTADV140000 L1 
													  WHERE L1.T$CLAB = L.T$CLAB 
														AND L1.T$CLAN = L.T$CLAN 
														AND L1.T$CPAC = L.T$CPAC ) ) SIT_TIT
					ON SIT_TIT.T$CNST = PRG_MOV.T$RPST$L
			 
--referencia fiscal 
			 LEFT JOIN BAANDB.TZNINT002301 ZNINT002
					ON ZNINT002.T$UNEG$C = PEDIDO.T$UNEG$C
			 
--referencia fiscal relativa
			 LEFT JOIN BAANDB.TZNINT002301 ZNINT002_REL
					ON ZNINT002_REL.T$UNEG$C = PEDIDO_REL.T$UNEG$C

       LEFT JOIN BAANDB.TTTTXT010301 T 
          ON T.T$CTXT = TITULO.T$TEXT  
         AND T.T$CLAN = 'P' 

			 LEFT JOIN BAANDB.TTFGLD011301 GLD011
					ON GLD011.T$TTYP = PRG_MOV.T$TDOC
			  
			 LEFT JOIN ( SELECT L.T$DESC DESCR_SIT_REM,
								D.T$CNST
						   FROM BAANDB.TTTADV401000 D,
								BAANDB.TTTADV140000 L
						  WHERE D.T$CPAC = 'TF'
							AND D.T$CDOM = 'CMG.STDD'
							AND L.T$CLAN = 'P'
							AND L.T$CPAC = 'TF'
							AND L.T$CLAB = D.T$ZA_CLAB
							AND RPAD(D.T$VERS,4) ||
								RPAD(D.T$RELE,2) ||
								RPAD(D.T$CUST,4) = ( SELECT MAX(RPAD(L1.T$VERS,4) ||
																RPAD(L1.T$RELE,2) ||
																RPAD(L1.T$CUST,4)) 
													   FROM BAANDB.TTTADV401000 L1 
													  WHERE L1.T$CPAC = D.T$CPAC 
														AND L1.T$CDOM = D.T$CDOM )
							AND RPAD(L.T$VERS,4) ||
								RPAD(L.T$RELE,2) ||
								RPAD(L.T$CUST,4) = ( SELECT MAX(RPAD(L1.T$VERS,4) ||
																RPAD(L1.T$RELE,2) ||
																RPAD(L1.T$CUST,4)) 
													   FROM BAANDB.TTTADV140000 L1 
													  WHERE L1.T$CLAB = L.T$CLAB 
														AND L1.T$CLAN = L.T$CLAN 
														AND L1.T$CPAC = L.T$CPAC ) ) SIT_REM
					ON SIT_REM.T$CNST = TFCMG409.T$STDD
			 
--referencia fiscal
			 LEFT JOIN BAANDB.TZNCMG007301 ZNCMG007
					ON ZNCMG007.T$MPGS$C = PEDIDO.T$IDMP$C
			  
--referencia fiscal relativa
			 LEFT JOIN BAANDB.TZNCMG007301 ZNCMG007_REL
					ON ZNCMG007_REL.T$MPGS$C = PEDIDO_REL.T$IDMP$C

			 LEFT JOIN BAANDB.TZNMCS002301 ZNMCS002
					ON ZNMCS002.T$POCO$C = ZNSLS410.T$POCO$C
			 
			 LEFT JOIN ( SELECT L.T$DESC DESCR_SITUACAO_NF,
								D.T$CNST
						   FROM BAANDB.TTTADV401000 D,
								BAANDB.TTTADV140000 L
						  WHERE D.T$CPAC = 'ci'
							AND D.T$CDOM = 'sli.stat'
							AND L.T$CLAN = 'p'
							AND L.T$CPAC = 'ci'
							AND L.T$CLAB = D.T$ZA_CLAB
							AND RPAD(D.T$VERS,4) || 
								RPAD(D.T$RELE,2) || 
								RPAD(D.T$CUST,4) =  ( SELECT MAX(RPAD(L1.T$VERS,4) || 
																 RPAD(L1.T$RELE,2) || 
																 RPAD(L1.T$CUST,4) ) 
														FROM BAANDB.TTTADV401000 L1 
													   WHERE L1.T$CPAC = D.T$CPAC 
														 AND L1.T$CDOM = D.T$CDOM )
							AND RPAD(L.T$VERS,4) || 
								RPAD(L.T$RELE,2) || 
								RPAD(L.T$CUST,4) =  ( SELECT MAX(RPAD(L1.T$VERS,4) || 
																 RPAD(L1.T$RELE,2) || 
																 RPAD(L1.T$CUST,4)) 
														FROM BAANDB.TTTADV140000 L1 
													   WHERE L1.T$CLAB = L.T$CLAB 
														 AND L1.T$CLAN = L.T$CLAN 
														 AND L1.T$CPAC = L.T$CPAC )) SITUACAO_NF
					ON SITUACAO_NF.T$CNST = CISLI940.T$STAT$L
          
      LEFT JOIN baandb.ttcmcs065301 tcmcs065_fili
             ON tcmcs065_fili.t$cwoc = cisli940.t$cofc$l
             
      LEFT JOIN baandb.ttccom130301 tccom130_fili
             ON tccom130_fili.t$cadr = tcmcs065_fili.t$cadr
             
      LEFT JOIN baandb.tznfmd001301 znfmd001_fili
             ON znfmd001_fili.t$fovn$c = tccom130_fili.t$fovn$l   ) Q1 


	WHERE TRUNC(DT_EMISSAO) BETWEEN :DATAEMISSAODE AND :DATAEMISSAOATE
	  AND TRUNC(DT_VENCIMENTO) BETWEEN NVL(:DATAVENCTODE, DT_VENCIMENTO) AND NVL(:DATAVENCTOATE, DT_VENCIMENTO)
	  AND TRUNC(DATA_TRANSACAO) BETWEEN NVL(:DATATRANSACAODE, DATA_TRANSACAO) AND NVL(:DATATRANSACAOATE, DATA_TRANSACAO)
	  AND FILIAL IN (:FILIAL)
	  AND DOC IN (:TIPOTRANSACAO)
	  AND NVL(UNID_NEGOCIO, 0) IN (:UNINEGOCIO)
	  AND NVL(SITUACAO_NF, 0) IN (:SITUACAONF)
	  AND SITUACAO_TITULO IN (:STATUSTITULO)
	  AND ( (ID_TRANSACAO = TRIM(:TRANSACAO)) OR (TRIM(:TRANSACAO) IS NULL) )
	  AND ( (REGEXP_REPLACE(CNPJ, '[^0-9]', '') = TRIM(:CNPJ)) OR (TRIM(:CNPJ) IS NULL) )
    and ( Q1.DOC in ('RB3','RE1','RE2','RE4','RWC','RG4','RGC',
                     'SB3','SE1','SE2','SE4','SWC','SG4','SGC' )
    or (q1.doc = 'FAT' and Q1.COD_TIPO_DOC_FISCAL IN ('S00001','S00005','S00008','S00200','S00201')) -- VDA P/REVENDA, VDA P/CONSUMO, MODELO C, PÓS CONSOLIDADO, PRÉ CONSOLIDADO
    AND Q1.CATEGORIA_MP IN (5,6))
