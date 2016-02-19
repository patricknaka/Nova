SELECT ZNCOM005.T$UNEG$C                               UNEG,
       ZNINT002.T$DESC$C                               DESC_UNEG,
       ZNSLS400.T$IDCA$C                               ID_CANAL,
       TCMCS045.T$DSCA                                 DESCR_CANAL,
       znsls401.t$pcga$c                               NR_PEDIDO_PRODUTO,
       ZNCOM005.T$PECL$C                               NR_PEDIDO_GARANTIA,       --Pedido Garantia
       zncom005.t$tpga$c                               TIPO_PLANO_GARANTIA,
	   
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_G.t$dtoc$c,
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
         AT time zone 'America/Sao_Paulo') AS DATE)    DT_VENDA,                 --Data Venda Garantia - Ponto 'DNF'
	   

       ZNSLS401_P.T$ENTR$C                             ENTREGA_PEDIDO,
       ZNCOM005.T$ENTR$C                               ENTREGA_GARANTIA,
	   
       ZNCOM005.T$ENGA$C                               COD_PLANO_GAR,          

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C,                     --será necessario as duas Datas Original/Raiz (Pedido Produto e Pedido Garantia)
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      
           AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_PED_GARANTIA,  --Data da Emissão do Pedido

		   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_G.t$dtoc$c, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_GARANTIA, 
	   
       ZNSLS400.T$CVEN$C                               VENDEDOR,
       ' '                                             NOME_VENDEDOR,            -- NÃO TEMOS O NOME NO LN, SÓ TEMOS O CÓDIGO QUE VEM DA INTERFACE DE PEDIDOS (COM O VALOR 100)
       ZNCOM005.T$CAST$C                               CERTIFICADO,
        CASE WHEN ZNCOM005.T$QUAN$C < 0.0
              THEN 'CANCELAMENTO'
            ELSE   'VENDA' 
       END                                             TIPO,
       TCIBD001_G.T$NRPE$C                             PZ_GARATIA_EST,
       TDIPU001.T$NRPE$C                               PZ_GARANTIA_FABR,
	   
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410_P.T$DTOC$C, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  INICIO_GAR_FABR,
       
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(ZNSLS410_P.T$DTOC$C, TDIPU001.T$NRPE$C), 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  FIN_GAR_FABR,
       
       
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(ZNSLS410_P.T$DTOC$C, TDIPU001.T$NRPE$C) + 1, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  INICIO_GAR_EST,
               
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(ZNSLS410_P.T$DTOC$C, TDIPU001.T$NRPE$C + TCIBD001_G.T$NRPE$C) + 1, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)  FIN_GAR_EST,
	   
       ZNCOM005.T$IGAR$C                               ITEM_GARANTIDO,
       TCIBD001_I.T$DSCA                               DESCRICAO,
--       TCIBD001_I.T$CMNF                               COD_MOD_FABRICANTE,
       TCIBD001_I.T$MDFB$C                             COD_MOD_FABRICANTE,
       ' '                                             DSC_MOD_FABRICANTE,    --A definir
       TCMCS023.T$CITG                                 ID_DEPARTAMENTO,
       TCMCS023.T$DSCA                                 DESCR_DEPARTAMENTO,
       TCIBD001_I.T$FAMI$C                             ID_FAMILIA,
       ZNMCS031.T$DSCA$C                               DESCR_FAMILIA,
--       CASE WHEN ZNCOM005.T$QUAN$C > 0 THEN
--            cisli941.t$pric$l                               
--       ELSE TDREC941.T$PRIC$L END                      VL_PRODUTO,           --Sem desconto e unitário
       ZNCOM005.T$IGVA$C                                VL_PRODUTO,
--       CASE WHEN ZNCOM005.T$QUAN$C > 0 THEN
--            cisli941.t$pric$l - cisli941.t$disc$l      
--       ELSE TDREC941.T$PRIC$L - TDREC941.T$ADDC$L/TDREC941.T$QNTY$L END VL_PRODUTO_PAGO,      --Com desconto e unitario
       ZNCOM005.T$IGVA$C                               VL_PRODUTO_PAGO,
       ZNCOM005.T$PRIS$C                               VL_GARANTIA,
--       NVL(ABS(CUSTO.VALOR),0)                         CUSTO,
       ZNCOM005.T$VRSG$C                               CUSTO,
       ZNCOM005.T$PELI$C                               PREMIO_LIQ,
       ZNCOM005.T$PIOF$C                               IOF,
       ZNCOM005.T$PPIS$C                               PIS,
       ZNCOM005.T$PCOF$C                               COFINS,
       ZNCOM005.T$IRRF$C                               IRRF,
       ZNCOM005.T$CANG$C                               VL_COMISSAO,
       ZNCOM005.T$CANG$C -
       ZNCOM005.T$IRRF$C                               MARGEM_CONTR,
       ZNSLS410_P.T$DOCN$C                             NUM_NOTA,
       ZNSLS410_P.T$SERI$C                             SERIE,
	   
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410_P.T$DTEM$C, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    --Alterar para Data da Garantia Estendida (data de emissao do codigo ativacao serv. ou dt do cancelamento)
           AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_NF,    --Data da Emissão da Nota Fiscal
		   
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
         FROM BAANDB.TZNCOM005201 A
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
              A.T$TPGA$C) ZNCOM005
              
LEFT  JOIN BAANDB.TZNINT002201 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNCOM005.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNCOM005.T$UNEG$C
  
LEFT JOIN BAANDB.TZNSLS400201 ZNSLS400                  --Pedido Garantia
        ON ZNSLS400.T$NCIA$C = ZNCOM005.T$NCIA$C
       AND ZNSLS400.T$UNEG$C = ZNCOM005.T$UNEG$C
       AND ZNSLS400.T$PECL$C = ZNCOM005.T$PECL$C
       AND ZNSLS400.T$SQPD$C = ZNCOM005.T$SQPD$C

LEFT JOIN BAANDB.TTCMCS045201 TCMCS045
        ON TCMCS045.T$CREG  = ZNSLS400.T$IDCA$C
  
LEFT JOIN BAANDB.TTCIBD001201 TCIBD001_I                --Item Produto
        ON TRIM(TCIBD001_I.T$ITEM) = TO_CHAR(ZNCOM005.T$IGAR$C)

LEFT JOIN BAANDB.TTDIPU001201 TDIPU001
       ON TDIPU001.T$ITEM = TCIBD001_I.T$ITEM
       
LEFT JOIN BAANDB.TZNSLS401201 ZNSLS401                  --Entrega Garantia
       ON ZNSLS401.T$NCIA$C = ZNCOM005.T$NCIA$C
      AND ZNSLS401.T$UNEG$C = ZNCOM005.T$UNEG$C
      AND ZNSLS401.T$PECL$C = ZNCOM005.T$PECL$C
      AND ZNSLS401.T$SQPD$C = ZNCOM005.T$SQPD$C
      AND ZNSLS401.T$ENTR$C = ZNCOM005.T$ENTR$C
      AND ZNSLS401.T$SEQU$C = ZNCOM005.T$SEQU$C

 LEFT JOIN BAANDB.TZNSLS401201 ZNSLS401_P               --Entrega Produto
        ON ZNSLS401_P.T$NCIA$C = ZNSLS401.T$NCIA$C
       AND ZNSLS401_P.T$UNEG$C = ZNSLS401.T$UNEG$C
       AND ZNSLS401_P.T$PECL$C = ZNSLS401.T$PCGA$C
       AND ZNSLS401_P.T$SQPD$C = ZNSLS401.T$SPIG$C
       AND ZNSLS401_P.T$ENTR$C = ZNSLS401.T$NEIG$C
       AND ZNSLS401_P.T$SEQU$C = ZNSLS401.T$SGAR$C

 LEFT JOIN BAANDB.TZNSLS400201 ZNSLS400_P               --Pedido Produto
        ON ZNSLS400_P.T$NCIA$C = ZNSLS401_P.T$NCIA$C
       AND ZNSLS400_P.T$UNEG$C = ZNSLS401_P.T$UNEG$C
       AND ZNSLS400_P.T$PECL$C = ZNSLS401_P.T$PECL$C
       AND ZNSLS400_P.T$SQPD$C = ZNSLS401_P.T$SQPD$C

LEFT JOIN BAANDB.TTCIBD001201 TCIBD001_G                --Item Garantia       
        ON TCIBD001_G.T$ITEM = ZNSLS401.T$ITML$C
  
LEFT JOIN BAANDB.TTCMCS023201 TCMCS023
        ON TCMCS023.T$CITG  = TCIBD001_I.T$CITG

LEFT JOIN BAANDB.TZNMCS031201 ZNMCS031
        ON ZNMCS031.T$CITG$C = TCIBD001_I.T$CITG
       AND ZNMCS031.T$SETO$C = TCIBD001_I.T$SETO$C
       AND ZNMCS031.T$FAMI$C = TCIBD001_I.T$FAMI$C
  
-- LEFT JOIN ( SELECT A.T$ORNO,
--                    A.T$PONO,
--                    A.T$SQNB,
--                    SUM(A.T$FCOP$1) VALOR
--               FROM BAANDB.TTDSLS415201 A
--              WHERE A.T$CSTO = 2
--           GROUP BY A.T$ORNO,
--                    A.T$PONO,
--                    A.T$SQNB ) CUSTO
--        ON CUSTO.T$ORNO = ZNCOM005.T$ORNO$C
--       AND CUSTO.T$PONO = ZNCOM005.T$PONO$C
--       AND CUSTO.T$SQNB = ZNCOM005.T$SQNB$C
  
-- LEFT JOIN BAANDB.TCISLI940201 CISLI940
--        ON CISLI940.T$FIRE$L = ZNCOM005.T$FIRE$C

-- LEFT JOIN ( SELECT d.t$cnst CNST, 
--                    l.t$desc DSC
--               FROM baandb.tttadv401000 d, baandb.tttadv140000 l 
--              WHERE d.t$cpac = 'zn' 
--                AND d.t$cdom = 'ibd.tgar.c'
--                AND l.t$clan = 'p'
--                AND l.t$cpac = 'zn'
--                AND l.t$clab = d.t$za_clab
--                AND rpad(d.t$vers,4) ||
--                    rpad(d.t$rele,2) ||
--                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
--                                                    rpad(l1.t$rele,2) ||
--                                                    rpad(l1.t$cust,4)) 
--                                           from baandb.tttadv401000 l1 
--                                          where l1.t$cpac = d.t$cpac 
--                                            and l1.t$cdom = d.t$cdom )
--                AND rpad(l.t$vers,4) ||
--                    rpad(l.t$rele,2) ||
--                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
--                                                    rpad(l1.t$rele,2) || 
--                                                    rpad(l1.t$cust,4)) 
--                                           from baandb.tttadv140000 l1 
--                                          where l1.t$clab = l.t$clab 
--                                            and l1.t$clan = l.t$clan 
--                                            and l1.t$cpac = l.t$cpac)) TGAR
--        ON TGAR.CNST = TCIBD001_G.T$TGAR$C
        
--LEFT JOIN BAANDB.TTCMCS060201  TCMCS060 --T$DSCA  FABRICANTE
--       ON TCMCS060.T$CMNF  = TCIBD001_I.T$CMNF

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$dtoc$c
            from   baandb.tznsls410201 a
            where  a.t$poco$c = 'DNF' ) znsls410_G      --Emissão Nota Garantia
        ON ZNSLS410_G.T$NCIA$C = ZNCOM005.T$NCIA$C
       AND ZNSLS410_G.T$UNEG$C = ZNCOM005.T$UNEG$C
       AND ZNSLS410_G.T$PECL$C = ZNCOM005.T$PECL$C
       AND ZNSLS410_G.T$SQPD$C = ZNCOM005.T$SQPD$C
       AND ZNSLS410_G.T$ENTR$C = ZNCOM005.T$ENTR$C

LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$dtoc$c,
                   a.t$docn$c,
                   a.t$seri$c,
                   a.t$dtem$c
            from   baandb.tznsls410201 a
            where  a.t$poco$c = 'NFS' ) znsls410_P      --Emissão Nota Produto
        ON ZNSLS410_P.T$NCIA$C = ZNSLS401_P.T$NCIA$C
       AND ZNSLS410_P.T$UNEG$C = ZNSLS401_P.T$UNEG$C
       AND ZNSLS410_P.T$PECL$C = ZNSLS401_P.T$PECL$C
       AND ZNSLS410_P.T$SQPD$C = ZNSLS401_P.T$SQPD$C
       AND ZNSLS410_P.T$ENTR$C = ZNSLS401_P.T$ENTR$C
       
--LEFT JOIN baandb.tcisli941201 cisli941
--        ON cisli941.t$fire$l = zncom005.t$fire$c
--       AND cisli941.t$line$l = zncom005.t$line$c
--
--LEFT JOIN baandb.ttdrec941201 tdrec941                --recebimento de devolução
--        ON tdrec941.t$fire$l = zncom005.t$fire$c
--       AND tdrec941.t$line$l = zncom005.t$line$c
--
--LEFT JOIN baandb.ttdrec940201 tdrec940
--       ON tdrec940.t$fire$l = tdrec941.t$fire$l
--       
--LEFT JOIN baandb.tznsls004201 znsls004
--        ON znsls004.t$ncia$c = zncom005.t$ncia$c
--       AND znsls004.t$uneg$c = zncom005.t$uneg$c
--       AND znsls004.t$orno$c = zncom005.t$orno$c
--       AND znsls004.t$pono$c = zncom005.t$pono$c

LEFT JOIN baandb.ttccom100201 tccom100
       ON tccom100.t$bpid = znsls400.t$ofbp$c
       
LEFT JOIN baandb.ttccom130201 tccom130
       ON tccom130.t$cadr = tccom100.t$cadr
       
where exists ( select *     --ITENS TIPO GARANTIA ESTENDIDA
               from   baandb.tznisa002201 a,
                      baandb.tznisa001201 b
               where  a.t$npcl$c = TCIBD001_G.T$NPCL$C     
               and    b.t$nptp$c = a.t$nptp$c
               and    b.t$emnf$c = 2    --Emissao de Nota Fiscal = Nao
               and    b.t$bpti$c = 2    --Tipo de Interface de Aviso = Arquivo Texto
               and    b.t$nfed$c = 2  ) --Gera Nota Fiscal de Entrada = Nao
  
  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)   
      BETWEEN :DataPedidoDe AND :DataPedidoAte
  AND ( (:UNegocioTodos = 1) OR (TRIM(ZNCOM005.T$UNEG$C) IN (:UNegocio) AND (:UNegocioTodos = 0)) )
  AND ZNSLS400.T$IDCA$C IN (:CanalVendas)
  AND CASE WHEN ZNCOM005.T$CANC$C = 1 
             THEN 'CANCELAMENTO' 
           ELSE   'VENDA' 
      END IN (:Status)
