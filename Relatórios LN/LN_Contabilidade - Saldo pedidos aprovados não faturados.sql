SELECT 
  ZNINT002.T$WSTP$C                               TIPO,
  ZNFMD001.T$FILI$C                               FILIAL,
  ZNSLS400.T$IDCO$C                               ID_CONTRATO_B2B,
  ZNSLS400.T$IDCP$C                               ID_CAMPANHA_B2B,
  ' '                                             NOME_CAMPANHA,   -- NÃO TEMOS ESTA INFORMAÇÃO NO LN
  TCCOM130F.T$FOVN$L                              CNPJ_FATURA,
  TCCOM130F.T$NAMA                                RAZAO_SOCIAL_FAT,
  ZNSLS004.T$PECL$C                               PEDIDO,
  ZNSLS004.T$ENTR$C                               ENTREGA,
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_PEDIDO,
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTAP$C, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_APROV,  
  
  NULL                                            DT_FAT,     -- NÃO TEMOS A DATA DE FATURAMENTO POIS ESTE RELATÓRIO MOSTRA PEDIDOS NÃO FATURADOS
  (SELECT MIN(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.T$DTOC$C, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE))
     FROM BAANDB.TZNSLS410301 A
    WHERE A.T$NCIA$C = ZNSLS004.T$NCIA$C
      AND A.T$UNEG$C = ZNSLS004.T$UNEG$C
      AND A.T$PECL$C = ZNSLS004.T$PECL$C
      AND A.T$SQPD$C = ZNSLS004.T$SQPD$C
      AND A.T$ENTR$C = ZNSLS004.T$ENTR$C
      AND A.T$POCO$C = 'ETR')                     DT_EXPED,
   
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_ENTR_PROMET,   
  NULL                                            NF_VENDA,   -- NÃO TEMOS A NF POIS ESTE RELATÓRIO MOSTRA PEDIDOS NÃO FATURADOS 
  ZNSLS401.VL_PRODUTO                             VL_PRODUTO,
  ZNSLS401.VL_DISC                                VL_DESCONTO,
  ZNSLS401.VL_FRET                                VL_FRETE,
  ZNSLS401.VL_PRODUTO + 
  ZNSLS401.VL_DISC    + 
  ZNSLS401.VL_FRET                                VL_TOTAL,
  TCMCS013.T$DSCA                                 FORMA_PGTO,
  ULT_PONTO.PT_CONTR                              ID_STATUS,
  ZNMCS002.T$DESC$C                               DESCR_STATUS
  
FROM       BAANDB.TTDSLS400301     TDSLS400
   
INNER JOIN ( SELECT DISTINCT 
                    A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C,
                    A.T$SQPD$C, 
                    A.T$ENTR$C, 
                    A.T$ORNO$C
               FROM BAANDB.TZNSLS004301 A )    ZNSLS004
        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO

INNER JOIN ( SELECT A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C, 
                    A.T$SQPD$C,
                    A.T$ENTR$C, 
                    MIN(A.T$DTAP$C) T$DTAP$C, 
                    MIN(A.T$DTEP$C) T$DTEP$C,
                    SUM(A.T$VLUN$C * A.T$QTVE$C) VL_PRODUTO, 
                    SUM(A.T$VLDI$C) VL_DISC, 
                    SUM(A.T$VLFR$C) VL_FRET
               FROM BAANDB.TZNSLS401301 A
           GROUP BY A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C, 
                    A.T$SQPD$C, 
                    A.T$ENTR$C )    ZNSLS401
        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C
    
 LEFT JOIN ( SELECT A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C, 
                    A.T$SQPD$C, 
                    A.T$ENTR$C, 
                    MAX(A.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY A.T$DTOC$C,  A.T$SEQN$C) PT_CONTR
               FROM BAANDB.TZNSLS410301 A
           GROUP BY A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C, 
                    A.T$SQPD$C, 
                    A.T$ENTR$C )    ULT_PONTO
        ON ULT_PONTO.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ULT_PONTO.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ULT_PONTO.T$PECL$C = ZNSLS004.T$PECL$C
       AND ULT_PONTO.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ULT_PONTO.T$ENTR$C = ZNSLS004.T$ENTR$C 

INNER JOIN BAANDB.TTCMCS013301     TCMCS013
        ON TCMCS013.T$CPAY  = TDSLS400.T$CPAY
		
 LEFT JOIN BAANDB.TZNMCS002301     ZNMCS002
        ON ZNMCS002.T$POCO$C = ULT_PONTO.PT_CONTR

INNER JOIN BAANDB.TZNSLS400301     ZNSLS400
        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C

INNER JOIN BAANDB.TTCCOM130301     TCCOM130F
        ON TCCOM130F.T$CADR = TDSLS400.T$OFAD

INNER JOIN BAANDB.TZNINT002301     ZNINT002
        ON ZNINT002.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS004.T$UNEG$C
	   
INNER JOIN BAANDB.TTCMCS065301     TCMCS065
        ON TCMCS065.T$CWOC  = TDSLS400.T$COFC

INNER JOIN BAANDB.TTCCOM130301     TCCOM130
        ON TCCOM130.T$CADR  = TCMCS065.T$CADR

INNER JOIN BAANDB.TZNFMD001301     ZNFMD001
        ON ZNFMD001.T$FOVN$C = TCCOM130.T$FOVN$L

WHERE TDSLS400.T$HDST IN (10,20,25,30,45)
  AND ZNINT002.T$WSTP$C IN ('B2B','ATACADO')
  AND ( select NVL(MAX(B.T$REFR$L), ' ')
          from BAANDB.TCISLI245301 A
    inner join BAANDB.TCISLI941301 B
            on B.T$FIRE$L = A.T$FIRE$L
           and B.T$LINE$L = A.T$LINE$L
         where A.T$SLCP = 301 
           and A.T$ORTP = 1
           and A.T$KOOR = 3
           and A.T$SLSO = TDSLS400.T$ORNO ) = ' '
AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE))
    BETWEEN :DataPedidoDe AND :DataPedidoAte