SELECT
--***************************************************************************************************************************
--				SAIDA
--***************************************************************************************************************************

        TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sysdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE), 'YY') ||
        substr(to_char(
                        ceil(current_date - date '1900-01-01') + 
                        substr(to_char(cisli940.t$docn$l,'00000000'),-6,6)
                ,'0000000'),-6,6)                         ROMANEIO_PRODUTO,

    
		'NIKE.COM'												                    FILIAL,	
		21														                        CODIGO_TAB_PRECO,
		CISLI940.T$CCFO$L										                  TIPO_ENTRADA_SAIDA,
		REGEXP_REPLACE(TCCOM130_ORG.T$FOVN$L, '[^0-9]', '')		FILIAL_ORIGEM_DESTINO,
		''														                        RESPONSAVEL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE)            EMISSAO,
 		(	SELECT SUM(A.T$DQUA$L)
			FROM BAANDB.TCISLI941601 a,
           baandb.tznsls000601 b
			WHERE A.T$FIRE$L = CISLI940.T$FIRE$L	        
      AND b.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
      AND a.t$item$l != b.t$itmf$c      --ITEM FRETE
      AND a.t$item$l != b.t$itmd$c      --ITEM DESPESAS
      AND a.t$item$l != b.t$itjl$c      --ITEM JUROS			
      )                                                   QTDE_TOTAL,
		CISLI940.T$AMNT$L										                  VALOR_TOTAL,
		REGEXP_REPLACE(TCCOM130_TRN.T$FOVN$L, '[^0-9]', '')		CGC,
		''														                        OBS,
		''														                        ENTRADA_SAIDA_ENCERRADA,
		''														                        ENTRADA_SAIDA_CANCELADA,
		CISLI940.T$SERI$L										                  SERIE_NF,
		TO_CHAR(CISLI940.T$DOCN$L, '000000000')					      NF_NUMERO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATS$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE)            DATA_SAIDA,
		''														                        ENTRADA_CONFERIDA,
		''														                        ENTRADA_SEM_PRODUTOS,
		0														                          ENTRADA_POR,
		CASE WHEN CISLI940.T$FDTY$L=9
			THEN 1
			ELSE 0 END											                    INDICA_DEVOLUCAO,
		''														                        ROMANEIO_AJUSTE,
		''														                        FORNECEDOR,
		2														                          TIPO_TRANSACAO,
    cisli940.t$fire$l                                     REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE)            DT_ULT_ALTERACAO,
    cisli940.t$ccfo$l                                     CFOP,
    tcmcs940.t$dsca$l                                     DESC_CFOP,
    cisli940.t$fdtc$l                                     COD_TIPO_DOC_FISCAL,
    tcmcs966.t$dsca$l                                     DESC_COD_TIPO_DOC_FIS
    
FROM  BAANDB.TCISLI940601	CISLI940
INNER JOIN	BAANDB.TTCCOM130601	TCCOM130_ORG	ON	TCCOM130_ORG.T$CADR	=	CISLI940.T$SFRA$L
INNER JOIN	BAANDB.TTCCOM130601 TCCOM130_TRN	ON	TCCOM130_TRN.T$CADR	=	CISLI940.T$ITOA$L

LEFT JOIN baandb.ttcmcs940601 tcmcs940
       ON tcmcs940.t$ofso$l = cisli940.t$ccfo$l
       
LEFT JOIN baandb.ttcmcs966601 tcmcs966
       ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l
       
WHERE
--			CISLI940.T$FDTY$L IN (4,5,9,17,18,19,22,23,26,32,33)
   	  CISLI940.T$STAT$L IN (2, 5, 6, 101)			-- 2-CANCELADA, 5-IMPRESSO, 6-LANÇADO, 101-ESTORNADA
AND   cisli940.t$cnfe$l != ' '
AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1   --faturamento       
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5   --nota impressa
                  and   znnfe011.t$nfes$c = 5)  --nfe processada
AND      cisli940.t$fdty$l != 2   --venda sem pedido
			
--***************************************************************************************************************************
--				ENTRADA
--***************************************************************************************************************************
UNION
SELECT 

      REVERSE(TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sysdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE), 'YY')) ||
        substr(to_char(
                        ceil(current_date - date '1900-01-01') + 
                        substr(to_char(tdrec940.t$docn$l,'00000000'),-6,6)
                ,'0000000'),-6,6)                         ROMANEIO_PRODUTO,

                
		'NIKE.COM'												                    FILIAL,	
		21														                        CODIGO_TAB_PRECO,
		TDREC940.T$OPFC$L										                  TIPO_ENTRADA_SAIDA,
		REGEXP_REPLACE(TCCOM130_ORG.T$FOVN$L, '[^0-9]', '')		FILIAL_ORIGEM_DESTINO,
		''														                        RESPONSAVEL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE)            EMISSAO,
    whinh301.t$rqua                                       QTDE_TOTAL,
		TDREC940.T$TFDA$L										                  VALOR_TOTAL,
		REGEXP_REPLACE(TDREC940.T$FOVN$L, '[^0-9]', '')			  CGC,
		''														                        OBS,
		''														                        ENTRADA_SAIDA_ENCERRADA,
		''														                        ENTRADA_SAIDA_CANCELADA,
		TDREC940.T$SERI$L										                  SERIE_NF,
		TO_CHAR(TDREC940.T$DOCN$L, '000000000')					      NF_NUMERO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$ODAT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE)            DATA_SAIDA,
		''														                        ENTRADA_CONFERIDA,
		''														                        ENTRADA_SEM_PRODUTOS,
		CASE WHEN TCEMM122.T$BUPA IS NULL
			THEN 1
			ELSE 2 END											                    ENTRADA_POR,
		0														                          INDICA_DEVOLUCAO,
		''														                        ROMANEIO_AJUSTE,
		''														                        FORNECEDOR,
		1														                          TIPO_TRANSACAO,
    tdrec940.t$fire$l                                     REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE)            DT_ULT_ALTERACAO,
    tdrec940.t$opfc$l                                     CFOP,
    tcmcs940.t$dsca$l                                     DESC_CFOP,
    tdrec940.t$fdtc$l                                     COD_TIPO_DOC_FISCAL,
    tcmcs966.t$dsca$l                                     DESC_COD_TIPO_DOC_FIS
    
FROM  BAANDB.TTDREC940601	TDREC940

INNER JOIN	BAANDB.TTCCOM130601	TCCOM130_ORG	ON	TCCOM130_ORG.T$CADR	=	TDREC940.T$SFRA$L

LEFT JOIN	BAANDB.TTCEMM122601	TCEMM122		
       ON	TCEMM122.T$LOCO		=	601
      AND	TCEMM122.T$BUPA		=	TDREC940.T$BPID$L

LEFT JOIN baandb.ttcmcs940601 tcmcs940
       ON tcmcs940.t$ofso$l = tdrec940.t$opfc$l
       
LEFT JOIN baandb.ttcmcs966601 tcmcs966
       ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l

LEFT JOIN ( select  a.t$fire$c,
                    a.t$sfbp,
                    a.t$shid 
            from    baandb.twhinh300601 a
            group by a.t$fire$c,
                     a.t$sfbp,
                     a.t$shid ) whinh300
      ON  whinh300.t$fire$c = tdrec940.t$fire$l
      
LEFT JOIN ( select  a.t$sfbp,
                    a.t$shid,
                sum(a.t$rqua) t$rqua
            from    baandb.twhinh301601 a
            group by a.t$sfbp,
                     a.t$shid ) whinh301
      ON  whinh301.t$sfbp = whinh300.t$sfbp
     AND  whinh301.t$shid = whinh300.t$shid
     
WHERE
    TDREC940.T$STAT$L IN (4,5,6)  --4-Aprovado, 5-Aprovado com Problemas, 6-estornada
    AND	tdrec940.t$cnfe$l != ' '
    AND tdrec940.t$doty$l != 8    --8-conhecimento de frete

ORDER BY TIPO_TRANSACAO, REF_FISCAL
