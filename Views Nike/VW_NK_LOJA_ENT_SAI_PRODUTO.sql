SELECT
--***************************************************************************************************************************
--				SAIDA
--***************************************************************************************************************************
		'NIKE.COM'												            FILIAL,	
        TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sysdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE), 'YY') ||
        substr(to_char(
                        ceil(current_date - date '1900-01-01') + 
                        substr(to_char(cisli940.t$docn$l,'00000000'),-6,6)
                ,'0000000'),-6,6)                  ROMANEIO_PRODUTO,
		TCIBD001.T$ITEM                     					PRODUTO,
		'01'													                COR_PRODUTO,
		znibd005.t$desc$c										          TAMANHO,
		''														                CODIGO_BARRA,
		CISLI941.T$AMNT$L										          VALOR ,
		CISLI941.T$PRIC$L										          PRECO1,
		CISLI941.T$DQUA$L										          QTDE_ITEM,
    2														                  TIPO_TRANSACAO,     --Saídas
    cisli941.t$fire$l                             REF_FISCAL,             
    cisli941.t$line$l                              LIN_REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)    DT_ULT_ALTERACAO,
    tcibd001.t$mdfb$c                             MOD_FABR_ITEM,
    cisli940.t$ccfo$l                             CFO,
    cisli940.t$fdtc$l                             COD_DOC_FISCAL
    
FROM  BAANDB.TCISLI940601	CISLI940
INNER JOIN	BAANDB.TCISLI941601 CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L

INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	ON	TCIBD001.T$ITEM		=	CISLI941.T$ITEM$L

LEFT JOIN	BAANDB.TTCIBD004601	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	CISLI941.T$ITEM$L
                      
LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')

LEFT JOIN baandb.tznibd005601 znibd005
       ON znibd005.t$size$c = TCIBD001.T$SIZE$C
       
WHERE CISLI940.T$STAT$L IN (2, 5, 6, 101)			-- 2-CANCELADA, 5-IMPRESSO, 6-LANÇADO, 101-ESTORNADA
AND   cisli940.t$cnfe$l != ' '
AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1   --faturamento  
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5   --nota impressa
                  and   znnfe011.t$nfes$c = 5)  --nfe processada
AND      cisli940.t$fdty$l != 2     --venda sem pedido			
AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS			
			
			

--***************************************************************************************************************************
--				ENTRADA
--***************************************************************************************************************************

UNION
SELECT
		'NIKE.COM'												            FILIAL,	
      REVERSE(TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sysdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE), 'YY')) ||
        substr(to_char(
                        ceil(current_date - date '1900-01-01') + 
                        substr(to_char(tdrec940.t$docn$l,'00000000'),-6,6)
                ,'0000000'),-6,6)                 ROMANEIO_PRODUTO,

    WHINH301.t$item                               PRODUTO,
		'01'													                COR_PRODUTO,
    

    ZNIBD005.t$desc$c                             TAMANHO,
		''														                CODIGO_BARRA,

    CAST((WHINH301.T$RQUA * TDREC941.T$PRIC$L) AS NUMERIC(38,4))           VALOR,
		CAST(TDREC941.T$PRIC$L AS NUMERIC(38,4)  )     PRECO1,

    WHINH301.t$rqua                               QTDE_ITEM,
    1														                  TIPO_TRANSACAO,   --Entradas
    tdrec941.t$fire$l                             REF_FISCAL,
    TDREC941.T$LINE$L                             LIN_REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$ADAT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)    DT_ULT_ALTERACAO,

    TCIBD001.t$mdfb$c                             MOD_FABR_ITEM,
    tdrec940.t$opfc$l                             CFO,
    tdrec940.t$fdtc$l                             COD_DOC_FISCAL
    
FROM  BAANDB.TTDREC940601	TDREC940

INNER JOIN	BAANDB.TTDREC941601 TDREC941	ON	TDREC941.T$FIRE$L	=	TDREC940.T$FIRE$L
                      
LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
       
LEFT JOIN baandb.twhinh300601 whinh300
       ON whinh300.t$fire$c = tdrec940.t$fire$l
       
LEFT JOIN ( select a.t$sfbp,
                   a.t$shid,
                   a.t$item,
                   a.t$rqua,
                   b.t$mitm ITEM_NOTA
            from  baandb.twhinh301601 a 
            inner join   baandb.ttibom010601  b
                    on   b.t$sitm = a.t$item 
 
            UNION
            
            select a.t$sfbp,
                   a.t$shid,
                   a.t$item ITEM_NOTA,
                   a.t$rqua,
                   b.t$item
            from  baandb.twhinh301601 a 
            inner join baandb.ttcibd001601 b
                    on b.t$item = a.t$item) WHINH301
       ON WHINH301.t$sfbp = whinh300.t$sfbp
      AND WHINH301.t$shid = whinh300.t$shid
      AND WHINH301.ITEM_NOTA = tdrec941.t$item$l   --item agrupador, ou não
      
INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	
       ON	TCIBD001.T$ITEM		=	WHINH301.T$ITEM
       
INNER JOIN baandb.tznibd005601 znibd005
       ON znibd005.t$size$c = TCIBD001.T$SIZE$C
       
WHERE TDREC940.T$STAT$L IN (4,5,6)  --4-Aprovado, 5-Aprovado com Problemas, 6-estornada
  AND	tdrec940.t$cnfe$l != ' '
  AND tdrec941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
  AND tdrec941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
  AND tdrec941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS			
  AND WHINH301.T$RQUA != 0
  AND tdrec940.t$doty$l != 8    --8-conhecimento de frete
  AND tdrec940.t$rfdt$l != 14	  --Nota de Débito-14
  
  ORDER BY TIPO_TRANSACAO, REF_FISCAL, LIN_REF_FISCAL
