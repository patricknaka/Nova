SELECT ZNCOM005.T$UNEG$C                               UNEG,
       ZNINT002.T$DESC$C                               DESC_UNEG,
       ZNSLS400.T$IDCA$C                               ID_CANAL,
       TCMCS045.T$DSCA                                 DESCR_CANAL,
       znsls401.t$pcga$c                               NR_PEDIDO_PRODUTO,
       ZNCOM005.T$PECL$C                               NR_PEDIDO_GARANTIA,       --Pedido Garantia
       zncom005.t$tpga$c                               TIPO_PLANO_GARANTIA,
    
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_EMISSAO.t$dtoc$c,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      
           AT time zone 'America/Sao_Paulo') AS DATE)  DT_SOLICITACAO,           --Ponto DNF Venda/Cancelamento

       ZNSLS401_P.T$ENTR$C                             ENTREGA_PEDIDO,
       ZNCOM005.T$ENTR$C                               ENTREGA_GARANTIA,
    
       ZNCOM005.T$ENGA$C                               COD_PLANO_GAR,          

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C,                     --Data da Emissão do Pedido
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      
           AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_PED_GARANTIA,
		   
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_G.t$dtoc$c,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_GARANTIA, 

       ZNSLS400.T$CVEN$C                               VENDEDOR,
       ZNCOM005.T$CAST$C                               CERTIFICADO,

       CASE WHEN ZNCOM005.T$QUAN$C < 0.0
              THEN 'CANCELAMENTO'
            ELSE   'VENDA' 
       END                                             TIPO,
       TCIBD001_G.T$NRPE$C                             PZ_GARATIA_EST,
       TDIPU001.T$NRPE$C                               PZ_GARANTIA_FABR,
       
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.T$DATE$L, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  INICIO_GAR_FABR,
       
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(cisli940.T$DATE$L, TDIPU001.T$NRPE$C), 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  FIN_GAR_FABR,
       
       
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(cisli940.T$DATE$L, TDIPU001.T$NRPE$C) + 1, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  INICIO_GAR_EST,
               
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(cisli940.T$DATE$L, TDIPU001.T$NRPE$C + TCIBD001_G.T$NRPE$C) + 1, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  FIN_GAR_EST,
           
       ZNCOM005.T$IGAR$C                               ITEM_GARANTIDO,
       TCIBD001_I.T$DSCA                               DESCRICAO,
       TCIBD001_I.T$MDFB$C                             COD_MOD_FABRICANTE,
       TCMCS023.T$CITG                                 ID_DEPARTAMENTO,
       TCMCS023.T$DSCA                                 DESCR_DEPARTAMENTO,
       TCIBD001_I.T$FAMI$C                             ID_FAMILIA,
       ZNMCS031.T$DSCA$C                               DESCR_FAMILIA,
       NVL(ZNSLS401_P.T$VLUN$C, ZNCOM005.T$IGVA$C)     VL_PRODUTO,
       ZNSLS401_P.T$VLUN$C - 
       (ZNSLS401_P.T$VLDI$C / ZNSLS401_P.T$QTVE$C)     VL_PRODUTO_PAGO,
       ZNSLS401_P.T$VLDI$C                             VL_DESCONTO_INCONDICIONAL,
       ZNCOM005.T$PRIS$C                               VL_GARANTIA,
       ZNCOM005.T$VRSG$C                               CUSTO,
       ZNCOM005.T$PELI$C                               PREMIO_LIQ,
       ZNCOM005.T$PIOF$C                               IOF,
       ZNCOM005.T$PPIS$C                               PIS,
       ZNCOM005.T$PCOF$C                               COFINS,
       ZNCOM005.T$IRRF$C                               IRRF,
       ZNCOM005.T$CANG$C                               VL_COMISSAO,
       ZNCOM005.T$CANG$C -
       ZNCOM005.T$IRRF$C                               MARGEM_CONTR,
       cisli940.T$DOCN$L                             NUM_NOTA,
       cisli940.T$SERI$L                             SERIE,
    
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.T$DATE$L, --ZNSLS410_P.T$DTEM$C, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_NF,
     
       ZNSLS400.T$OFBP$C                               ID_CLIENTE_FAT,   
       ZNSLS400.T$NOMF$C                               NOME_CLIENTE_FAT,
       TCCOM100.T$CADR                                 ID_CLIENTE_ENT,
       ZNSLS400.T$FTYP$C                               TIPO_CLIENTE,
       ZNSLS400.T$NOMF$C                               NOME_CLIENTE,
       ZNSLS400.T$ICLF$C                               CPF_CLIENTE,
       ZNSLS400.T$EMAF$C                               EMAIL_CLIENTE, 
       ZNSLS400.T$TELF$C                               CONTATO_1,
       ZNSLS400.T$TE1F$C                               CONTATO_2,
       ZNSLS400.T$TE2F$C                               CONTATO_3,
       ZNSLS400.T$LOGF$C                               ENDERECO,
       ZNSLS400.T$NUMF$C                               NUMERO,
       ZNSLS400.T$COMF$C                               COMPLEMENTO,
       ZNSLS400.T$CEPF$C                               CEP,
       ZNSLS400.T$CIDF$C                               MUNICIPIO,
       ZNSLS400.T$UFFA$C                               UF
 
FROM ( SELECT A.T$NCIA$C,
              A.T$UNEG$C,
              A.T$PECL$C,
              A.T$SQPD$C,
              A.T$ENTR$C,
              A.T$SEQU$C,
              A.T$CDVE$C,
              A.T$DATE$C,
              A.T$IGAR$C,
              A.T$ENGA$C,
              A.T$ORNO$C,
              A.T$PONO$C,
              A.T$SQNB$C,
              A.T$FIRE$C,
              A.T$LINE$C,
              A.T$CANC$C,
              A.T$CAST$C,
              A.T$TPGA$C,
              SUM(A.T$PRIS$C) T$PRIS$C,
              SUM(A.T$PELI$C) T$PELI$C,
              SUM(A.T$PIOF$C) T$PIOF$C,
              SUM(A.T$PPIS$C) T$PPIS$C,
              SUM(A.T$PCOF$C) T$PCOF$C,
              SUM(A.T$IRRF$C) T$IRRF$C,
              SUM(A.T$CCOR$C) T$CCOR$C,
              SUM(A.T$QUAN$C) T$QUAN$C,
              SUM(A.T$CANG$C) T$CANG$C,
              SUM(A.T$VRSG$C) T$VRSG$C,
              SUM(A.T$IGVA$C) T$IGVA$C
         FROM BAANDB.TZNCOM005301 A
     GROUP BY A.T$NCIA$C,
              A.T$UNEG$C,
              A.T$PECL$C,
              A.T$SQPD$C,
              A.T$ENTR$C,
              A.T$SEQU$C,
              A.T$CDVE$C,
              A.T$DATE$C,
              A.T$IGAR$C,
              A.T$ENGA$C,
              A.T$ORNO$C,
              A.T$PONO$C,
              A.T$SQNB$C,
              A.T$FIRE$C,
              A.T$LINE$C,
              A.T$CANC$C,
              A.T$CAST$C,
              A.T$TPGA$C ) ZNCOM005

LEFT  JOIN BAANDB.TZNINT002301 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNCOM005.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNCOM005.T$UNEG$C
  
LEFT JOIN BAANDB.TZNSLS400301 ZNSLS400
       ON ZNSLS400.T$NCIA$C = ZNCOM005.T$NCIA$C
      AND ZNSLS400.T$UNEG$C = ZNCOM005.T$UNEG$C
      AND ZNSLS400.T$PECL$C = ZNCOM005.T$PECL$C
      AND ZNSLS400.T$SQPD$C = ZNCOM005.T$SQPD$C

LEFT JOIN BAANDB.TTCMCS045301 TCMCS045
       ON TCMCS045.T$CREG  = ZNSLS400.T$IDCA$C
  
LEFT JOIN BAANDB.TTCIBD001301 TCIBD001_I                --Item Produto
       ON TRIM(TCIBD001_I.T$ITEM) = TO_CHAR(ZNCOM005.T$IGAR$C)

LEFT JOIN BAANDB.TTDIPU001301 TDIPU001
       ON TDIPU001.T$ITEM = TCIBD001_I.T$ITEM
       
LEFT JOIN BAANDB.TZNSLS401301 ZNSLS401                  --Entrega Garantia
       ON ZNSLS401.T$NCIA$C = ZNCOM005.T$NCIA$C
      AND ZNSLS401.T$UNEG$C = ZNCOM005.T$UNEG$C
      AND ZNSLS401.T$PECL$C = ZNCOM005.T$PECL$C
      AND ZNSLS401.T$SQPD$C = ZNCOM005.T$SQPD$C
      AND ZNSLS401.T$ENTR$C = ZNCOM005.T$ENTR$C
      AND ZNSLS401.T$SEQU$C = ZNCOM005.T$SEQU$C

LEFT JOIN BAANDB.TZNSLS401301 ZNSLS401_P                --Entrega Produto
       ON ZNSLS401_P.T$NCIA$C = ZNSLS401.T$NCIA$C
      AND ZNSLS401_P.T$UNEG$C = ZNSLS401.T$UNEG$C
      AND ZNSLS401_P.T$PECL$C = ZNSLS401.T$PCGA$C
      AND ZNSLS401_P.T$SQPD$C = ZNSLS401.T$SPIG$C
      AND ZNSLS401_P.T$ENTR$C = ZNSLS401.T$NEIG$C
      AND ZNSLS401_P.T$SEQU$C = ZNSLS401.T$SGAR$C

LEFT JOIN BAANDB.TTCIBD001301 TCIBD001_G                 --Item Garantia       
       ON TCIBD001_G.T$ITEM = ZNSLS401.T$ITML$C
  
LEFT JOIN BAANDB.TTCMCS023301 TCMCS023
       ON TCMCS023.T$CITG  = TCIBD001_I.T$CITG

LEFT JOIN BAANDB.TZNMCS031301 ZNMCS031
       ON ZNMCS031.T$CITG$C = TCIBD001_I.T$CITG
      AND ZNMCS031.T$SETO$C = TCIBD001_I.T$SETO$C
      AND ZNMCS031.T$FAMI$C = TCIBD001_I.T$FAMI$C
  
LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   min(a.t$dtoc$c) t$dtoc$c,
                   min(a.t$seqn$c) t$seqn$c
              from baandb.tznsls410301 a
        inner join baandb.tznsls401301 z    
                on a.t$ncia$c = z.t$ncia$c
               and a.t$uneg$c = z.t$uneg$c
               and a.t$pecl$c = z.t$pcga$c
               and a.t$sqpd$c = z.t$spig$c
               and a.t$entr$c = z.t$neig$c
             where a.t$poco$c = 'DNF'
               and z.t$idor$c = 'LJ'
          group by a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c ) znsls410_G         --Emissão Venda Produto
       ON ZNSLS410_G.T$NCIA$C = ZNCOM005.T$NCIA$C
      AND ZNSLS410_G.T$UNEG$C = ZNCOM005.T$UNEG$C
      AND ZNSLS410_G.T$PECL$C = ZNCOM005.T$PECL$C

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   min(a.t$dtoc$c) t$dtoc$c,
                   min(a.t$seqn$c) t$seqn$c
              from baandb.tznsls410301 a
             where a.t$poco$c = 'DNF'
          group by a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c ) znsls410_EMISSAO      --Data de Emissao
       ON znsls410_EMISSAO.T$NCIA$C = ZNCOM005.T$NCIA$C
      AND znsls410_EMISSAO.T$UNEG$C = ZNCOM005.T$UNEG$C
      AND znsls410_EMISSAO.T$PECL$C = ZNCOM005.T$PECL$C
      AND znsls410_EMISSAO.T$SQPD$C = ZNCOM005.T$SQPD$C
      AND znsls410_EMISSAO.T$ENTR$C = ZNCOM005.T$ENTR$C

LEFT JOIN baandb.tcisli245301 cisli245
       ON cisli245.t$slso = ZNSLS401_P.t$orno$c
      AND cisli245.t$pono = ZNSLS401_P.t$pono$c

LEFT JOIN ( select cisli940.t$date$l,
                   cisli940.t$docn$l,
                   cisli940.t$seri$l,
                   cisli940.t$fire$l,
                   cisli940.t$stat$l
              from baandb.tcisli940301  cisli940
             where cisli940.t$stat$l in (5, 6) ) cisli940
       ON cisli940.t$fire$l = cisli245.t$fire$l

LEFT JOIN baandb.ttccom100301 tccom100
       ON tccom100.t$bpid = znsls400.t$ofbp$c
       
WHERE EXISTS ( select *     --ITENS TIPO GARANTIA ESTENDIDA
                 from baandb.tznisa002301 a,
                      baandb.tznisa001301 b
                where a.t$npcl$c = TCIBD001_G.T$NPCL$C     
                  and b.t$nptp$c = a.t$nptp$c
                  and b.t$emnf$c = 2    --Emissao de Nota Fiscal = Nao
                  and b.t$bpti$c = 2    --Tipo de Interface de Aviso = Arquivo Texto
                  and b.t$nfed$c = 2  ) --Gera Nota Fiscal de Entrada = Nao

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_EMISSAO.t$dtoc$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                AT time zone 'America/Sao_Paulo') AS DATE))  
      BETWEEN :DataPedidoDe AND :DataPedidoAte
  AND ZNSLS400.T$IDCA$C IN (:CanalVendas)
  AND ZNCOM005.T$CANC$C IN (:Status) --1 = Cancelamento, 2 = Venda
  AND ( (:UNegocioTodos = 1) OR (TRIM(ZNCOM005.T$UNEG$C) IN (:UNegocio) AND (:UNegocioTodos = 0)) )
  AND ( (:PedGarantiaTodos = 1) OR (TRIM(ZNCOM005.T$PECL$C) IN (:PedGarantia) AND (:PedGarantiaTodos = 0)) )
  