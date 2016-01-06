CREATE OR REPLACE VIEW VW_NK_LOJA_VENDA_TROCA AS
SELECT
--***************************************************************************************************************************
--        TROCA
--***************************************************************************************************************************
    TDREC940.T$DOCN$L || TDREC940.T$SERI$L          TICKET,
    'NIKE.COM'                                      FILIAL,
    tdrec941.t$line$l                                ITEM,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)       DATA_VENDA,
    ''                                              CODIGO_BARRA,
    ltrim(rtrim(NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM)))      PRODUTO,
    '01'                                            COR_PRODUTO,
    ZNIBD005.T$DESC$C                                TAMANHO,
    TDREC941.T$QNTY$L                                QTDE,
    TDREC941.T$PRIC$L  + ROUND((TDREC941.T$ADDC$L + TDREC941.T$GEXP$L + TDREC941.T$CCHR$L)/TDREC941.T$QNTY$L,4)            PRECO_LIQUIDO,
    (TDREC941.T$ADDC$L + TDREC941.T$GEXP$L + TDREC941.T$CCHR$L)*(-1)                        DESCONTO_ITEM,
    0                                                QTDE_CANCELADA,
    0.0                                             CUSTO,
    NVL(Q_IPI.T$AMNT$L,0)                            IPI,
    ''                                              ID_VENDEDOR,
    0                                                ITEM_EXCLUIDO,
    0                                                NÃO_MOVIMENTA_ESTOQUE,
    ''                                              INDICA_ENTREGA_FUTURA,
        tdrec941.t$fire$l                           REF_FISCAL,
            tdrec941.t$line$l                       LIN_REF_FICAL,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)       DT_ULT_ALTERACAO,
    tcibd001.t$mdfb$c                               MOD_FABR_ITEM,
    tdrec941.t$opfc$l                               CFOP,
    tdrec940.t$fdtc$l                               COD_TIPO_DOC_FISCAL

FROM
      BAANDB.TTDREC947601  TDREC947

INNER JOIN  BAANDB.TTDREC941601 TDREC941  ON  TDREC941.T$FIRE$L  =  TDREC947.T$FIRE$L
                      AND  TDREC941.T$LINE$L  =  TDREC947.T$LINE$L

INNER JOIN  BAANDB.TTDREC940601 TDREC940  ON  TDREC940.T$FIRE$L  =  TDREC941.T$FIRE$L

INNER JOIN  BAANDB.TZNSLS004601  ZNSLS004  ON  ZNSLS004.T$ORNO$C  =  TDREC947.T$ORNO$L
                      AND  ZNSLS004.T$PONO$C  =  TDREC947.T$PONO$L

INNER JOIN  BAANDB.TZNSLS400601  ZNSLS400  ON  ZNSLS400.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                      AND ZNSLS400.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =  ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =  ZNSLS004.T$SQPD$C

INNER JOIN  BAANDB.TZNSLS401601 ZNSLS401  ON  ZNSLS401.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                            AND ZNSLS401.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                            AND ZNSLS401.T$PECL$C   =  ZNSLS004.T$PECL$C
                                            AND ZNSLS401.T$SQPD$C   =  ZNSLS004.T$SQPD$C
                      AND ZNSLS401.T$ENTR$C   =  ZNSLS004.T$ENTR$C
                      AND ZNSLS401.T$SEQU$C   =  ZNSLS004.T$SEQU$C

INNER JOIN  BAANDB.TTCIBD001601  TCIBD001  ON  TCIBD001.T$ITEM    =  TDREC941.T$ITEM$L

LEFT JOIN (  SELECT  A.T$ORNO,
          A.T$PONO,
          A.T$SQNB,
          SUM(A.T$COGS$1) CTOT
      FROM  BAANDB.TTDSLS415601 A
      WHERE   A.T$CSTO = 2
      GROUP BY A.T$ORNO,
               A.T$PONO,
               A.T$SQNB)  TDSLS415  ON  TDSLS415.T$ORNO    =  TDREC947.T$ORNO$L
                      AND  TDSLS415.T$PONO    =  TDREC947.T$PONO$L
                                      AND  TDSLS415.T$SQNB    =  TDREC947.T$SEQN$L

LEFT JOIN  BAANDB.TTCIBD004601  TCIBD004  ON  TCIBD004.T$CITT    =  '000'
                      AND  TCIBD004.T$BPID    =  ' '
                      AND  TCIBD004.T$ITEM    =  TCIBD001.T$ITEM

 LEFT JOIN (   select     whwmd217.t$item item,
              case when sum(nvl(whwmd217.t$mauc$1,0)) = 0
               then round(sum(whwmd217.t$ftpa$1*a.t$qhnd)/sum(a.t$qhnd), 4)
               else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)
               end mauc
        from baandb.twhwmd217601 whwmd217
        left join baandb.twhinr140601 a
                on a.t$cwar = whwmd217.t$cwar
                and a.t$item = whwmd217.t$item
        group by   whwmd217.t$item) custo                       -- Custo médio do item em todos os armazens
                      ON  custo.item       =   TCIBD001.T$ITEM

LEFT JOIN (  SELECT   A.T$FIRE$L,
          A.T$LINE$L,
          A.T$AMNT$L,
          A.T$RATE$L
      FROM BAANDB.TTDREC942601 A
      WHERE  A.T$BRTY$L=3) Q_IPI    ON  Q_IPI.T$FIRE$L    =  TDREC941.T$FIRE$L
                      AND  Q_IPI.T$LINE$L    =  TDREC941.T$LINE$L

LEFT JOIN   baandb.tznibd005601 znibd005
       ON   znibd005.t$size$c = tcibd001.t$size$c

WHERE
      TDREC947.T$NCMP$L=601
    AND  TDREC947.T$OORG$L=1
    AND tdrec940.t$stat$l IN (4,5,6)      --4-aprovado, 5-aprovado com problemas, 6-estornado
    AND  tdrec940.t$cnfe$l != ' '
    AND  TDREC940.T$RFDT$L = 10            --10 - retorno de mercadoria
    AND tdrec940.t$rfdt$l NOT IN (19,20,21,22,23) --Conhecimento de Frete Aéreo-19, Ferroviário-20, Aquaviário-21, Rodoviário--22, Multimodal-23
    AND tdrec947.t$seri$l = 1;
