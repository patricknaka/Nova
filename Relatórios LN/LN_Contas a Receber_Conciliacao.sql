SELECT Q1.*
  FROM ( SELECT
             201                                                									CIA,
									
             CASE WHEN NVL( (FILIAL.T$STYP), '0' ) = '0' 									
                    THEN 2 									
                  ELSE 3 									
             END                                                									FILIAL, 
												
             PRG_MOV.T$NINV                                     									TITULO,
             PRG_MOV.T$RPST$L                                   									SITUACAO_TITULO, 
             SIT_TIT.                                           									DESCR_SIT_TIT,
             PRG_MOV.T$TTYP                                     									DOC,
             TCCOM130.T$FOVN$L                                  									CNPJ,
             TCCOM100.T$NAMA                                    									NOME,
             PRG_MOV.T$DOCD                                     									DT_EMISSAO,
             PRG_MOV.T$AMNT                                     									VL_TITULO,
             PRG_MOV.T$BALC                                     									VL_SALDO_TITULO,
             PRG_MOV.T$PAYM                                     									CARTEIRA,
             TFCMG011.T$BAOC$L                                  									CD_BANCO,
             TFCMG011.T$AGCD$L                                  									NR_AGENCIA,
             TFCMG001.T$BANO                                    									NR_CONTA_CORRENTE,
             PRG_MOV.T$SCHN                                     									NR_DOCUMENTO,
             TITULO.T$LEAC                                      									CENTRO_CUSTO,
             PRG_MOV.T$RECD                                     									DT_VENCIMENTO,
             PRG_MOV.T$DUED$L                                   									DT_VENCIMENTO_ORIGINAL,
				
             CASE WHEN TITULO.T$BALC = 0 	
                    THEN ( SELECT MAX(P.T$DOCD) 	
                             FROM BAANDB.TTFACR200201 P	
                            WHERE P.T$TTYP = TITULO.T$TTYP 	
                           AND P.T$NINV = TITULO.T$NINV ) 	
                  ELSE NULL 	
              END                                               									DT_LIQUIDACAO_TITULO,
											
             TFCMG401.T$BTNO                                    									REMESSA,
             TFCMG409.T$DATE                                    									DT_REMESSA,
             CISLI940.T$DOCN$L                                  									NOTA,
             CISLI940.T$SERI$L                                  									SERIE,
             CISLI940.T$FIRE$L                                  									REF_FISCAL,
             PRG_MOV.T$BREL                                     									NR_BANCARIO,
             PEDIDO.T$UNEG$C                                  										UNID_NEGOCIO,
             ZNINT002.T$DESC$C                                  									DESC_UNID_NEGOCIO,
--             NVL( (T.T$TEXT),' ' )                              									OBSERVACAO,
             ZNREC007.T$LOGN$C                                  									USUARIO,
             CASE WHEN C_IDCP=1 THEN PEDIDO.T$IDCP$C ELSE NULL END									CAMPANHA,
             ZNREC007.T$CVPC$C                                  									CONTRATO_VPC,
             PRG_MOV.T$TDOC                                     									ID_TRANSACAO,
             GLD011.T$DESC                                      									TRANSACAO, 
             PRG_MOV.T$DOCD                                     									DATA_TRANSACAO,
				
             CASE WHEN PRG_MOV.T$DOCN ! =  0 	
                    THEN NVL(AGRUP.T$TTYP$C, TREF.T$TTYP) 	
                  ELSE NULL 	
              END                                               									TITULO_REFERENCIA,
												
             CASE WHEN PRG_MOV.T$DOCN ! =  0 									
                    THEN NVL(AGRUP.T$NINV$C, TREF.T$NINV) 									
                  ELSE NULL 									
              END                                               									DOCUMENTO_REFERENCIA,
												
             CASE WHEN PRG_MOV.T$DOCN ! =  0 									
                    THEN NVL(AGRUP.DT_VENC, TREF.DT_VENC) 									
                  ELSE NULL 									
              END                                               									DATA_VENCTO_TIT_REFM,
													
             CASE WHEN PRG_MOV.T$DOCN ! =  0 									
                    THEN NVL(AGRUP.DT_LIQ, TREF.DT_LIQ) 									
                  ELSE NULL 									
              END                                               									DATA_LIQUID_TIT_REF,
											
             CASE WHEN PRG_MOV.T$DOCN ! =  0 								
                    THEN NVL(AGRUP.T$DOCD, TREF.T$DOCD) 								
                  ELSE NULL 								
              END                                               									DATA_TRANSACAO_TIT_REF,
											
             CASE WHEN PRG_MOV.T$DOCN ! =  0 								
                    THEN NVL(AGRUP.T$AMNT, TREF.T$AMNT) 								
                  ELSE NULL 								
              END                                               									VALOR_TRANSACAO_TIT_REF,
             
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$LOGF$C ELSE NULL END                                  ENDERECO,
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$NUMF$C ELSE NULL END                                  NUMERO,
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$BAIF$C ELSE NULL END                                  BAIRRO,
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$CIDF$C ELSE NULL END                                  CIDADE,
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$UFFA$C ELSE NULL END                                  UF,
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$CEPF$C ELSE NULL END                                  CEP,
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$TELF$C ELSE NULL END                                  TELEFONE,
             CASE WHEN C_ENTR=1 THEN PEDIDO.T$ENTR$C ELSE NULL END                                  ENTREGA,
             CASE WHEN C_PEEX=1 THEN PEDIDO.T$PEEX$C ELSE NULL END                                  PEDIDO_EXTERNO,
			 
             TFCMG409.T$STDD                                    									SITUACAO_REMESSA,
             SIT_REM.                                           									DESCR_SIT_REM,
             CASE WHEN C_IDMP=1 THEN PEDIDO.T$IDMP$C ELSE NULL END                                  MEIO_PAGAMENTO,
             ZNCMG007.T$DESC$C                                  									DESCR_MEIO_PGTO, 
             CASE WHEN C_PEEX=1 THEN ZNSLS410.T$POCO$C ELSE NULL END								ULTIMO_PONTO,
             CASE WHEN C_PEEX=1 THEN ZNMCS002.T$DESC$C ELSE NULL END								DESCR_ULT_PONTO, 
			 
             CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 
              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)
																									DATA_EMISSAO_NF,
			 
             CISLI940.T$STAT$L                                  									SITUACAO_NF,
             SITUACAO_NF.                                       									DESCR_SITUACAO_NF,

             CASE WHEN ( PRG_MOV.T$RPST$L ! =  4 AND PRG_MOV.T$RECD < TRUNC(SYSDATE) )
                    THEN TRUNC(SYSDATE) - PRG_MOV.T$RECD
                  ELSE NULL 
              END                                               									TEMPO_ATRASO,
										
             TITULO.T$ITBP                                      									COD_PARCEIRO,
             PRG_MOV.T$AMNT                                     									VALOR_TRANSACAO,
             TCCOM130.T$INFO                                    									EMAIL

         
        FROM    ( SELECT NVL(TFACR201.T$TTYP, TFACR200.T$TTYP) T$TTYP,
                         NVL(TFACR201.T$NINV, TFACR200.T$NINV) T$NINV,
                         NVL(TFACR201.T$SCHN, TFACR200.T$SCHN) T$SCHN,
                         TFACR201.T$RPST$L,
                         NVL(TFACR201.T$DOCD, TFACR200.T$DOCD) T$DOCD,
                         TFACR201.T$AMNT,
                         TFACR201.T$BALC,
                         TFACR201.T$PAYM,
                         TFACR201.T$BREL,
                         TFACR200.T$TDOC,
                         TFACR200.T$DOCN,
                         TFACR201.T$RECD,
                         TFACR201.T$DUED$L,
                         NVL(TFACR200.T$ITBP, TFACR200.T$ITBP) T$ITBP
                    FROM BAANDB.TTFACR201201 TFACR201
         
        FULL OUTER JOIN ( SELECT SQ.* 
                            FROM BAANDB.TTFACR200201 SQ 
                           WHERE SQ.T$DOCN ! =  0 ) TFACR200 
                     ON TFACR200.T$TTYP = TFACR201.T$TTYP 
                    AND TFACR200.T$NINV = TFACR201.T$NINV
                    AND TFACR200.T$SCHN = TFACR201.T$SCHN ) PRG_MOV
            
        INNER JOIN BAANDB.TTFACR200201 TITULO 
                ON TITULO.T$TTYP = PRG_MOV.T$TTYP 
               AND TITULO.T$NINV = PRG_MOV.T$NINV 
               AND TITULO.T$DOCN = 0
            
        INNER JOIN BAANDB.TTCCOM100201 TCCOM100 
                ON TCCOM100.T$BPID = TITULO.T$ITBP 
          
        INNER JOIN BAANDB.TTCCOM130201 TCCOM130 
                ON TCCOM130.T$CADR = TCCOM100.T$CADR
          
         LEFT JOIN BAANDB.TTFCMG001201 TFCMG001 
                ON TFCMG001.T$BANK = PRG_MOV.T$BREL
          
         LEFT JOIN BAANDB.TTFCMG011201 TFCMG011 
                ON TFCMG011.T$BANK = TFCMG001.T$BRCH
          
         LEFT JOIN BAANDB.TTFCMG401201 TFCMG401  
                ON TFCMG401.T$TTYP = PRG_MOV.T$TTYP 
               AND TFCMG401.T$NINV = PRG_MOV.T$NINV
               AND TFCMG401.T$SCHN = PRG_MOV.T$SCHN
            
         LEFT JOIN BAANDB.TTFCMG409201 TFCMG409 
                ON TFCMG409.T$BTNO = TFCMG401.T$BTNO
          
         LEFT JOIN BAANDB.TCISLI940201 CISLI940 
                ON CISLI940.T$ITYP$L = TITULO.T$TTYP
               AND CISLI940.T$IDOC$L = TITULO.T$NINV
               AND CISLI940.T$DOCN$L = TITULO.T$DOCN$L
            
         LEFT JOIN BAANDB.TZNREC007201 ZNREC007  
                ON ZNREC007.T$TTYP$C = TITULO.T$TTYP
               AND ZNREC007.T$DOCN$C = TITULO.T$NINV
            
		LEFT JOIN	(SELECT
							LRF.T$REFR$L,
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
							MIN(ZNSLS402.T$IDMP$C) T$IDMP$C,
							COUNT(DISTINCT ZNSLS402.T$IDMP$C) C_IDMP,
							MIN(ZNSLS400.T$IDCP$C) T$IDCP$C,
							COUNT(DISTINCT ZNSLS400.T$IDCP$C) C_IDCP
					FROM 
								BAANDB.TCISLI941201 LRF
							
					INNER JOIN	BAANDB.TCISLI245201	RRF 
						ON	RRF.T$FIRE$L = LRF.T$FIRE$L
						AND	RRF.T$LINE$L = LRF.T$LINE$L
						
					INNER JOIN	BAANDB.TZNSLS004201 ZNSLS004
						ON	ZNSLS004.T$ORNO$C = RRF.T$SLSO
						AND	ZNSLS004.T$PONO$C = RRF.T$PONO

					LEFT JOIN BAANDB.TZNSLS400201 ZNSLS400 
						ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C
					   AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C
					   AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C
					   AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C

					LEFT JOIN BAANDB.TZNSLS402201 ZNSLS402  
						ON ZNSLS402.T$NCIA$C = ZNSLS004.T$NCIA$C
					   AND ZNSLS402.T$UNEG$C = ZNSLS004.T$UNEG$C
					   AND ZNSLS402.T$PECL$C = ZNSLS004.T$PECL$C
					   AND ZNSLS402.T$SQPD$C = ZNSLS004.T$SQPD$C
					 
					GROUP BY LRF.T$REFR$L) PEDIDO
						ON PEDIDO.T$REFR$L = CISLI940.T$FIRE$L
			
			
			
			
            
         LEFT JOIN (SELECT	A.T$NCIA$C,
		                    A.T$UNEG$C,
		                    A.T$PECL$C,
		                    A.T$SQPD$C,
		                    A.T$ENTR$C,
		                    MAX(A.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY A.T$DTOC$C, A.T$SEQN$C) T$POCO$C
					FROM BAANDB.TZNSLS410201 A
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
                  
         LEFT JOIN ( SELECT ZNACR005.T$TTY1$C,
                            ZNACR005.T$NIN1$C,
                            ZNACR005.T$TTY2$C,
                            ZNACR005.T$NIN2$C,
                            ZNACR005.T$TTYP$C, -- TITULO REF
                            ZNACR005.T$NINV$C, -- NUM REF
                            T.T$DOCD,          -- DATA TITULO
                            T.T$AMNT,          -- VALOR TITO
                            ( SELECT MIN(A.T$RECD) 
                                FROM BAANDB.TTFACR201201 A
                               WHERE A.T$TTYP = ZNACR005.T$TTYP$C
                                 AND A.T$NINV = ZNACR005.T$NINV$C ) DT_VENC,
                            CASE WHEN MAX(T.T$BALC) = 0 
                                   THEN MAX(M.T$DOCD) 
                                 ELSE NULL 
                             END DT_LIQ        -- DATA LIQUIDAÇÃO
            
                       FROM BAANDB.TZNACR005201 ZNACR005, 
                            BAANDB.TTFACR200201 T,
                            BAANDB.TTFACR200201 M
                      WHERE T.T$TTYP = ZNACR005.T$TTYP$C
                        AND T.T$NINV = ZNACR005.T$NINV$C
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
                                FROM BAANDB.TTFACR201201 A
                               WHERE A.T$TTYP = RS.T$TTYP
                                 AND A.T$NINV = RS.T$NINV ) DT_VENC,
                            CASE WHEN MAX(T.T$BALC) = 0 
                                   THEN MAX(M.T$DOCD) 
                                 ELSE NULL 
                             END DT_LIQ    -- DATA LIQUIDAÇÃO
                       FROM BAANDB.TTFACR200201 RS, 
                            BAANDB.TTFACR200201 T, 
                            BAANDB.TTFACR200201 M    
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
                       FROM BAANDB.TCISLI205201 C
                      WHERE C.T$STYP = 'BL ATC') FILIAL
                ON FILIAL.T$ITYP = TITULO.T$TTYP
               AND FILIAL.T$IDOC = TITULO.T$NINV
            
         LEFT JOIN ( SELECT L.T$DESC DESCR_SIT_TIT,
                            D.T$CNST
                       FROM BAANDB.TTTADV401000 D,
                            BAANDB.TTTADV140000 L
                      WHERE D.T$CPAC = 'TF'
                        AND D.T$CDOM = 'ACR.STRP.L'
                        AND L.T$CLAN = 'P'
                        AND L.T$CPAC = 'TF'
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
         
         LEFT JOIN BAANDB.TZNINT002201 ZNINT002
                ON ZNINT002.T$UNEG$C = PEDIDO.T$UNEG$C
         
--         LEFT JOIN BAANDB.TTTTXT010201 T 
--                ON T.T$CTXT = TITULO.T$TEXT  
--               AND T.T$CLAN = 'P' 
            
         LEFT JOIN BAANDB.TTFGLD011201 GLD011
                ON GLD011.T$TTYP = TITULO.T$TDOC
          
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
         
         LEFT JOIN BAANDB.TZNCMG007201 ZNCMG007
                ON ZNCMG007.T$MPGT$C = PEDIDO.T$IDMP$C
          
         LEFT JOIN BAANDB.TZNMCS002201 ZNMCS002
                ON ZNMCS002.T$POCO$C = ZNSLS410.T$POCO$C
         
         LEFT JOIN ( SELECT L.T$DESC DESCR_SITUACAO_NF,
                            D.T$CNST
                       FROM BAANDB.TTTADV401000 D,
                            BAANDB.TTTADV140000 L
                      WHERE D.T$CPAC = 'CI'
                        AND D.T$CDOM = 'SLI.STAT'
                        AND L.T$CLAN = 'P'
                        AND L.T$CPAC = 'CI'
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
                ON SITUACAO_NF.T$CNST = CISLI940.T$STAT$L) Q1
           
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