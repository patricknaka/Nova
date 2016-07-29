CREATE OR REPLACE VIEW VW_NK_LOJA_VENDA_PGTO_PARCELAS AS
SELECT
--***************************************************************************************************************************
--        VENDA LJ
--***************************************************************************************************************************
    ''                            TERMINAL,
    ''                            LANCAMENTO_CAIXA,
    'NIKE.COM'                        FILIAL,
    ZNSLS402.T$SEQU$C                    PARCELA,
    DECODE(ZNSLS402.T$cccd$c,
      1,  '03',                                    -- 1  Visa              03 - VISA CREDITO
      2,  '04',                                                               -- 2  Mastercard                      04 - MASTERCARD
      3,  '01',                                                               -- 3  Amex                            01- AMERICAN EXPRESS
      4,  '07',                                                               -- 4  Diners                          07 - DINERS
      5,  '10',                                                               -- 5  Hipercard                       10 - HIPERCARD
      18,  '04',                                                               -- 18  Extra Mastercard                04 - MASTERCARD
      38,  '11',                                                               -- 38  Paypal                          11 - PAYPAL
      15,  '  ',                                                               -- 15  Multicheque/Multicash
      50,  '  ',                                                               -- 50  Multicheque/Multicash
      19,  '03',                                                               -- 19  Extra Visa                      03 - VISA CREDITO
      11,  '03',                                                               -- 11  Ponto Frio Visa                 03 - VISA CREDITO
      8,  '04',                                                               -- 8  Ponto Frio Mastercard           04 - MASTERCARD
      10,  '11',                                                               -- 10  Cartão Pão de Açúcar
      7,   '  ',                                                               -- 7  Aura
      37,  '08',                                                               -- 37  Elo                             08 - ELO CREDITO
      43,  '  ',                                                               -- 43  Primeira Compra
      21, '  ',                                                               -- 21  Ponto Frio Private Label
      17, '  ',                                                               -- 17  Extra Private Label
      40, '04',                                                               -- 40  Mobile Mastercard               04 - MASTERCARD
      42,  '05',                                                               -- 42  Visa Electron                   05 - VISA ELECTRON
      49,  '04',                                                               -- 49  Minha Casa Melhor Mastercard    04 - MASTERCARD
      39,  '03',                                                               -- 39  Mobile Visa                     03 - VISA CREDITO
      22,  '  ',                                                               -- 22  Itaucard
      48,  '  ',                                                               -- 48  Minha Casa Melhor Elo
      44,  '  ',                                                               -- 44  Clube Extra
      70, '  ')                      CODIGO_ADMINISTRADORA,      -- 70  Bndes

    CASE WHEN ZNSLS400.T$IDPO$C='TD' THEN                    --  LN                    NIKE
        'T'                                  --                      T - TROCA
     ELSE DECODE(ZNSLS402.T$IDMP$C,
        1,  'A',                                                           --1  Cartão de Crédito            A - CARTAO DE CREDITO POS             /*Venda SIGE*/
        2,  'D',                                                           --2  Boleto B2C (BV)              J - DUPLICATA                         CASE WHEN b.pepa_id_meio_pagto = 'Cartão de Crédito' THEN 'A'
        3,  'D',                                                           --3  Boleto B2B Spot              J - DUPLICATA                         WHEN b.pepa_id_meio_pagto = 'Debito/transferencia' THEN '5'
        4,  '1',                                                           --4  Vale (VA)                    R - VALE PRODUTO                      WHEN b.pepa_id_meio_pagto = 'Vale' OR b.pepa_id_meio_pagto = 'Livre de Debito' THEN '1'
        5,  '5',                                                           --5  Debito/Transferência (BV)    5 - TRANSFERENCIA BANCARIA            WHEN b.pepa_id_meio_pagto = 'Boleto' OR b.pepa_id_meio_pagto = 'Boleto Globex' THEN 'D' END as
        8,  'D',                                                           --8  Boleto à Prazo B2B (PZ)          ' ' - Não existe
        9,  'D',                                                           --9  Boleto a prazo Atacado (PZ)        ' ' - Não existe
        10,  'D',                                                           --10  Boleto à vista Atacado (BV)      ' ' - Não existe
        11, '  ',                                                          --11  Pagamento Complementar        ' ' - Não existe
        12, '5',                                                           --12  Cartão de Débito (DB)        E - CARTAO DE DEBITO
        13, '  ',                                                          --13  Pagamento Antecipado        ' ' - Não existe
        15,  '  ')  END                    TIPO_PAGTO,                        --15  BNDES                ' ' - Não existe
    CASE WHEN CISLI940.T$FDTY$L = 15 THEN
      CASE WHEN PAGTO.M_PAG > 1 THEN
          CISLI940_FAT.T$AMNT$L * ZNSLS402.T$VLMR$C/PAGTO.VL_TOT
      ELSE CISLI940_FAT.T$AMNT$L END
    ELSE
      CASE WHEN PAGTO.M_PAG > 1 THEN
          CISLI940.T$AMNT$L * ZNSLS402.T$VLMR$C/PAGTO.VL_TOT
      ELSE CISLI940.T$AMNT$L END
    END                                 VALOR,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$PVEN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)               VENCIMENTO,
    ZNSLS402.T$AUTO$C                    NUMERO_TITULO,
    ''                            MOEDA,
    ''                            AGENCIA,
    ''                            BANCO,
    ''                            CONTA_CORRENTE,
    ABS(ZNSLS402.T$NSUA$C)          NUMERO_APROVACAO_CARTAO,
    ZNSLS402.T$NUPA$C                    PARCELAS_CARTAO,
    0                            VALOR_CANCELADO,
    ''                            CHEQUE_CARTAO,
    ''                            NUMERO_LOTE,
    0                            TROCO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$DTRA$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)               DATA_HORA_TEF,
    ''                        ID_DOCUMENTO_ECF,
--    ZNSLS402.T$PECL$C || ZNSLS402.T$SQPD$C                TICKET,
    TO_CHAR(ZNSLS004.T$ENTR$C)         TICKET,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)               DATA_VENDA,
    'S'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    CASE WHEN CISLI940.T$FDTY$L = 15 THEN
          CISLI940_FAT.T$FIRE$L
    ELSE cisli940.t$fire$l END                             REF_FISCAL,
    CASE WHEN CISLI940.T$FDTY$L = 15 THEN
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940_FAT.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
          AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)
    END                                                     DT_ULT_ALTERACAO

FROM (  SELECT  A.T$FIRE$L,
                A.T$SLSO
        FROM  BAANDB.TCISLI245601 A
        WHERE  A.T$SLCP=601
        AND    A.T$ORTP=1
        AND    A.T$KOOR=3
        GROUP BY A.T$FIRE$L,
                 A.T$SLSO)  CISLI245

INNER JOIN (SELECT  B.T$NCIA$C,
          B.T$UNEG$C,
          B.T$PECL$C,
          B.T$SQPD$C,
          B.T$ENTR$C,
          B.T$ORNO$C
      FROM   BAANDB.TZNSLS004601 B
      GROUP BY B.T$NCIA$C,
               B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
           B.T$ENTR$C,
                     B.T$ORNO$C) ZNSLS004  ON  ZNSLS004.T$ORNO$C  =  CISLI245.T$SLSO

INNER JOIN  BAANDB.TZNSLS400601  ZNSLS400  ON  ZNSLS400.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                            AND ZNSLS400.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =  ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =  ZNSLS004.T$SQPD$C

INNER JOIN (SELECT  C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
          SUM(C.T$VLDI$C) T$VLDI$C
      FROM  BAANDB.TZNSLS401601 C
      GROUP BY C.T$NCIA$C,
               C.T$UNEG$C,
               C.T$PECL$C,
               C.T$SQPD$C,
               C.T$ENTR$C) ZNSLS401  ON  ZNSLS401.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                  AND ZNSLS401.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                  AND ZNSLS401.T$PECL$C   =  ZNSLS004.T$PECL$C
                                  AND ZNSLS401.T$SQPD$C   =  ZNSLS004.T$SQPD$C
                      AND ZNSLS401.T$ENTR$C   =  ZNSLS004.T$ENTR$C

INNER JOIN BAANDB.TZNSLS402601 ZNSLS402    ON  ZNSLS402.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                  AND ZNSLS402.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                  AND ZNSLS402.T$PECL$C   =  ZNSLS004.T$PECL$C
                                  AND ZNSLS402.T$SQPD$C   =  ZNSLS004.T$SQPD$C
LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    sum(a.t$vlmr$c) VL_TOT,
                    count(a.t$idmp$c) M_PAG
            from    baandb.tznsls402601 a
            group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c ) PAGTO
        ON PAGTO.T$NCIA$C  =  ZNSLS004.T$NCIA$C
       AND PAGTO.T$UNEG$C =  ZNSLS004.T$UNEG$C
       AND PAGTO.T$PECL$C =  ZNSLS004.T$PECL$C
      AND  PAGTO.T$SQPD$C =  ZNSLS004.T$SQPD$C

INNER JOIN  BAANDB.TCISLI940601  CISLI940  ON  CISLI940.T$FIRE$L  =  CISLI245.T$FIRE$L

INNER JOIN (SELECT  E.T$FIRE$L,
                    E.T$REFR$L

            FROM  BAANDB.TCISLI941601 E
            GROUP BY E.T$FIRE$L,
                     E.T$REFR$L) CISLI941
       ON  CISLI941.T$FIRE$L  =  CISLI940.T$FIRE$L

LEFT JOIN  BAANDB.TCISLI940601  CISLI940_FAT ON  CISLI940_FAT.T$FIRE$L =  CISLI941.T$REFR$L
                      AND  CISLI940_FAT.T$FDTY$L =  16

    WHERE cisli940.t$stat$l IN (2,5,6,101)      --cancelada, impressa, lançada, estornada
    AND   cisli940.t$cnfe$l != ' '
    AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1   --faturamento
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5   --nota impressa
                  and   znnfe011.t$nfes$c = 5)  --nfe processada
   AND      cisli940.t$fdty$l NOT IN (2,14)     --2-venda sem pedido, 14-retorno mercadoria cliente
   AND      znsls400.t$idpo$c = 'LJ'

--***************************************************************************************************************************
--        TROCA
--***************************************************************************************************************************
UNION

SELECT
    ''                            TERMINAL,
    ''                            LANCAMENTO_CAIXA,
    'NIKE.COM'                    FILIAL,
    1                              PARCELA,
--    DECODE(ZNSLS402.T$cccd$c,
--      1,  '03',                                    -- 1  Visa              03 - VISA CREDITO
--      2,  '04',                                                               -- 2  Mastercard                      04 - MASTERCARD
--      3,  '01',                                                               -- 3  Amex                            01- AMERICAN EXPRESS
--      4,  '07',                                                               -- 4  Diners                          07 - DINERS
--      5,  '10',                                                               -- 5  Hipercard                       10 - HIPERCARD
--      18,  '04',                                                               -- 18  Extra Mastercard                04 - MASTERCARD
--      38,  '11',                                                               -- 38  Paypal                          11 - PAYPAL
--      15,  '  ',                                                               -- 15  Multicheque/Multicash
--      50,  '  ',                                                               -- 50  Multicheque/Multicash
--      19,  '03',                                                               -- 19  Extra Visa                      03 - VISA CREDITO
--      11,  '03',                                                               -- 11  Ponto Frio Visa                 03 - VISA CREDITO
--      8,  '04',                                                               -- 8  Ponto Frio Mastercard           04 - MASTERCARD
--      10,  '11',                                                               -- 10  Cartão Pão de Açúcar
--      7,   '  ',                                                               -- 7  Aura
--      37,  '08',                                                               -- 37  Elo                             08 - ELO CREDITO
--      43,  '  ',                                                               -- 43  Primeira Compra
--      21, '  ',                                                               -- 21  Ponto Frio Private Label
--      17, '  ',                                                               -- 17  Extra Private Label
--      40, '04',                                                               -- 40  Mobile Mastercard               04 - MASTERCARD
--      42,  '05',                                                               -- 42  Visa Electron                   05 - VISA ELECTRON
--      49,  '04',                                                               -- 49  Minha Casa Melhor Mastercard    04 - MASTERCARD
--      39,  '03',                                                               -- 39  Mobile Visa                     03 - VISA CREDITO
--      22,  '  ',                                                               -- 22  Itaucard
--      48,  '  ',                                                               -- 48  Minha Casa Melhor Elo
--      44,  '  ',                                                               -- 44  Clube Extra
--      70, '  ')                      CODIGO_ADMINISTRADORA,      -- 70  Bndes

    ''                            CODIGO_ADMINISTRADORA,
    'D'                            TIPO_PAGTO,
    tdrec940.t$tfda$l * (-1)        VALOR,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L+1, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)               VENCIMENTO,
    ZNSLS402.T$AUTO$C                    NUMERO_TITULO,
    ''                            MOEDA,
    ''                            AGENCIA,
    ''                            BANCO,
    ''                            CONTA_CORRENTE,
    ABS(ZNSLS402.T$NSUA$C)        NUMERO_APROVACAO_CARTAO,
    0                              PARCELAS_CARTAO,
    0                              VALOR_CANCELADO,
    ''                            CHEQUE_CARTAO,
    ''                            NUMERO_LOTE,
    0                            TROCO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)               DATA_HORA_TEF,
    ''                            ID_DOCUMENTO_ECF,
    TDREC940.T$DOCN$L || TDREC940.T$SERI$L          TICKET,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)               DATA_VENDA,
    'C'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    tdrec940.t$fire$l             REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$ADAT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)               DT_ULT_ALTERACAO
FROM
    (  SELECT  A.T$FIRE$L,
          A.T$ORNO$L
      FROM  BAANDB.TTDREC947601 A
      WHERE  A.T$NCMP$L=601
      AND    A.T$OORG$L=1
      GROUP BY A.T$FIRE$L,
                 A.T$ORNO$L)  TDREC947

INNER JOIN (SELECT  B.T$NCIA$C,
          B.T$UNEG$C,
          B.T$PECL$C,
          B.T$SQPD$C,
          B.T$ENTR$C,
          B.T$ORNO$C
      FROM   BAANDB.TZNSLS004601 B
      GROUP BY B.T$NCIA$C,
               B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
           B.T$ENTR$C,
                     B.T$ORNO$C) ZNSLS004  ON  ZNSLS004.T$ORNO$C  =  TDREC947.T$ORNO$L

LEFT JOIN (select a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  max(a.t$auto$c) t$auto$c,
                  max(a.t$nsua$c) t$nsua$c
           from BAANDB.TZNSLS402601 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c ) znsls402
       ON ZNSLS402.T$NCIA$C = ZNSLS004.T$NCIA$C
      AND ZNSLS402.T$UNEG$C = ZNSLS004.T$UNEG$C
      AND ZNSLS402.T$PECL$C = ZNSLS004.T$PECL$C
      AND ZNSLS402.T$SQPD$C = ZNSLS004.T$SQPD$C

INNER JOIN (SELECT  C.T$NCIA$C,
          C.T$UNEG$C,
          C.T$PECL$C,
          C.T$SQPD$C,
          C.T$ENTR$C,
          SUM(C.T$VLFR$C) T$VLFR$C
      FROM  BAANDB.TZNSLS401601 C
      GROUP BY C.T$NCIA$C,
               C.T$UNEG$C,
               C.T$PECL$C,
               C.T$SQPD$C,
               C.T$ENTR$C) ZNSLS401  ON  ZNSLS401.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                  AND ZNSLS401.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                  AND ZNSLS401.T$PECL$C   =  ZNSLS004.T$PECL$C
                                  AND ZNSLS401.T$SQPD$C   =  ZNSLS004.T$SQPD$C
                      AND ZNSLS401.T$ENTR$C   =  ZNSLS004.T$ENTR$C


INNER JOIN  BAANDB.TTDREC940601  TDREC940  ON  TDREC940.T$FIRE$L  =  TDREC947.T$FIRE$L


WHERE tdrec940.t$stat$l IN (4,5,6)                --4-aprovado, 5-aprovado com problemas, 6-estornado
AND    tdrec940.t$cnfe$l != ' '
AND   TDREC940.T$RFDT$L = 10                      --10-retorno de mercadoria
AND   tdrec940.t$rfdt$l NOT IN (19,20,21,22,23) --Conhecimento de Frete Aéreo-19, Ferroviário-20, Aquaviário-21, Rodoviário--22, Multimodal-23

UNION

SELECT
--***************************************************************************************************************************
--        VENDA TD
--***************************************************************************************************************************
    ''                            TERMINAL,
    ''                            LANCAMENTO_CAIXA,
    'NIKE.COM'                        FILIAL,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
        1
    ELSE SLS402_VENDA.T$SEQU$C END        PARCELA,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
        ''  --OK
    ELSE
        DECODE(SLS402_VENDA.T$cccd$c,
        1,  '03',                                    -- 1  Visa              03 - VISA CREDITO
        2,  '04',                                                               -- 2  Mastercard                      04 - MASTERCARD
        3,  '01',                                                               -- 3  Amex                            01- AMERICAN EXPRESS
        4,  '07',                                                               -- 4  Diners                          07 - DINERS
        5,  '10',                                                               -- 5  Hipercard                       10 - HIPERCARD
        18,  '04',                                                               -- 18  Extra Mastercard                04 - MASTERCARD
        38,  '11',                                                               -- 38  Paypal                          11 - PAYPAL
        15,  '  ',                                                               -- 15  Multicheque/Multicash
        50,  '  ',                                                               -- 50  Multicheque/Multicash
        19,  '03',                                                               -- 19  Extra Visa                      03 - VISA CREDITO
        11,  '03',                                                               -- 11  Ponto Frio Visa                 03 - VISA CREDITO
        8,  '04',                                                               -- 8  Ponto Frio Mastercard           04 - MASTERCARD
        10,  '11',                                                               -- 10  Cartão Pão de Açúcar
        7,   '  ',                                                               -- 7  Aura
        37,  '08',                                                               -- 37  Elo                             08 - ELO CREDITO
        43,  '  ',                                                               -- 43  Primeira Compra
        21, '  ',                                                               -- 21  Ponto Frio Private Label
        17, '  ',                                                               -- 17  Extra Private Label
        40, '04',                                                               -- 40  Mobile Mastercard               04 - MASTERCARD
        42,  '05',                                                               -- 42  Visa Electron                   05 - VISA ELECTRON
        49,  '04',                                                               -- 49  Minha Casa Melhor Mastercard    04 - MASTERCARD
        39,  '03',                                                               -- 39  Mobile Visa                     03 - VISA CREDITO
        22,  '  ',                                                               -- 22  Itaucard
        48,  '  ',                                                               -- 48  Minha Casa Melhor Elo
        44,  '  ',                                                               -- 44  Clube Extra
        70, '  ')    END                  CODIGO_ADMINISTRADORA,                  -- 70  Bndes

    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          '1'
    ELSE
        CASE WHEN CONT.NO_IDMP > 1 THEN
              '$$'
        ELSE
              DECODE(SLS402_VENDA.T$IDMP$C,
              1,  'A',                                                           --1  Cartão de Crédito            A - CARTAO DE CREDITO POS             /*Venda SIGE*/
              2,  'D',                                                           --2  Boleto B2C (BV)              J - DUPLICATA                         CASE WHEN b.pepa_id_meio_pagto = 'Cartão de Crédito' THEN 'A'
              3,  'D',                                                           --3  Boleto B2B Spot              J - DUPLICATA                         WHEN b.pepa_id_meio_pagto = 'Debito/transferencia' THEN '5'
              4,  '1',                                                           --4  Vale (VA)                    R - VALE PRODUTO                      WHEN b.pepa_id_meio_pagto = 'Vale' OR b.pepa_id_meio_pagto = 'Livre de Debito' THEN '1'
              5,  '5',                                                           --5  Debito/Transferência (BV)    5 - TRANSFERENCIA BANCARIA            WHEN b.pepa_id_meio_pagto = 'Boleto' OR b.pepa_id_meio_pagto = 'Boleto Globex' THEN 'D' END as
              8,  'D',                                                           --8  Boleto à Prazo B2B (PZ)          ' ' - Não existe
              9,  'D',                                                           --9  Boleto a prazo Atacado (PZ)        ' ' - Não existe
              10,  'D',                                                           --10  Boleto à vista Atacado (BV)      ' ' - Não existe
              11, '  ',                                                          --11  Pagamento Complementar        ' ' - Não existe
              12, '5',                                                           --12  Cartão de Débito (DB)        E - CARTAO DE DEBITO
              13, '  ',                                                          --13  Pagamento Antecipado        ' ' - Não existe
              15,  '  ')  END                                                      --15  BNDES                ' ' - Não existe
    END                                     TIPO_PAGTO,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          CASE WHEN CISLI940.T$FDTY$L = 15 THEN     --REMESSA TRIANGULAR
                CISLI940_FAT.T$AMNT$L
          ELSE CISLI940.T$AMNT$L END    --OK
    ELSE SLS402_VENDA.T$VLPG$C  END         VALOR,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        --OK
            AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS402_VENDA.T$PVEN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
            AT time zone 'America/Sao_Paulo') AS DATE)     END          VENCIMENTO,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          ''    --OK
    ELSE SLS402_VENDA.T$AUTO$C  END        NUMERO_TITULO,
    ''                            MOEDA,
    ''                            AGENCIA,
    ''                            BANCO,
    ''                            CONTA_CORRENTE,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          0
    ELSE ABS(SLS402_VENDA.T$NSUA$C) END    NUMERO_APROVACAO_CARTAO,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
        0
    ELSE SLS402_VENDA.T$NUPA$C  END        PARCELAS_CARTAO,
    0                              VALOR_CANCELADO,
    ''                            CHEQUE_CARTAO,
    ''                            NUMERO_LOTE,
    0                              TROCO,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
           AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS402_VENDA.T$DTRA$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
           AT time zone 'America/Sao_Paulo') AS DATE)   END            DATA_HORA_TEF,
    ''                        ID_DOCUMENTO_ECF,
    TO_CHAR(ZNSLS004.T$ENTR$C)         TICKET,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)               DATA_VENDA,
    'S'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    CASE WHEN CISLI940.T$FDTY$L = 15 THEN
          CISLI940_FAT.T$FIRE$L
    ELSE cisli940.t$fire$l END                             REF_FISCAL,
    CASE WHEN CISLI940.T$FDTY$L = 15 THEN
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940_FAT.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
          AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
    AT time zone 'America/Sao_Paulo') AS DATE)
    END                                                     DT_ULT_ALTERACAO

FROM (  SELECT  A.T$FIRE$L,
                A.T$SLSO
        FROM  BAANDB.TCISLI245601 A
        WHERE  A.T$SLCP=601
        AND    A.T$ORTP=1
        AND    A.T$KOOR=3
        GROUP BY A.T$FIRE$L,
                 A.T$SLSO)  CISLI245

INNER JOIN (SELECT  B.T$NCIA$C,
          B.T$UNEG$C,
          B.T$PECL$C,
          B.T$SQPD$C,
          B.T$ENTR$C,
          B.T$ORNO$C
      FROM   BAANDB.TZNSLS004601 B
      GROUP BY B.T$NCIA$C,
               B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
           B.T$ENTR$C,
                     B.T$ORNO$C) ZNSLS004  ON  ZNSLS004.T$ORNO$C  =  CISLI245.T$SLSO

INNER JOIN  BAANDB.TZNSLS400601  ZNSLS400  ON  ZNSLS400.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                            AND ZNSLS400.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =  ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =  ZNSLS004.T$SQPD$C

INNER JOIN (SELECT  C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
          SUM(C.T$VLDI$C) T$VLDI$C
      FROM  BAANDB.TZNSLS401601 C
      GROUP BY C.T$NCIA$C,
               C.T$UNEG$C,
               C.T$PECL$C,
               C.T$SQPD$C,
               C.T$ENTR$C) ZNSLS401  ON  ZNSLS401.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                  AND ZNSLS401.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                  AND ZNSLS401.T$PECL$C   =  ZNSLS004.T$PECL$C
                                  AND ZNSLS401.T$SQPD$C   =  ZNSLS004.T$SQPD$C
                      AND ZNSLS401.T$ENTR$C   =  ZNSLS004.T$ENTR$C

LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c
            from    baandb.tznsls400601 a
            where   a.t$idpo$c = 'LJ' ) PED_VENDA
       ON   PED_VENDA.T$NCIA$C = ZNSLS004.T$NCIA$C
      AND   PED_VENDA.T$NCIA$C = ZNSLS004.T$UNEG$C
      AND   PED_VENDA.T$PECL$C = ZNSLS004.T$PECL$C

LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$orno$c
            from    baandb.tznsls401601 a
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$orno$c ) ENT_VENDA
       ON   ENT_VENDA.T$NCIA$C = PED_VENDA.T$NCIA$C
      AND   ENT_VENDA.T$NCIA$C = PED_VENDA.T$UNEG$C
      AND   ENT_VENDA.T$PECL$C = PED_VENDA.T$PECL$C
      AND   ENT_VENDA.T$SQPD$C = PED_VENDA.T$SQPD$C

LEFT JOIN ( select  a.t$slso,
                    a.t$fire$l
            from    baandb.tcisli245601 a
            group by a.t$slso,
                     a.t$fire$l ) NOTA_VENDA
       ON NOTA_VENDA.T$SLSO = ENT_VENDA.T$ORNO$C

INNER JOIN (SELECT  C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
          SUM(C.T$VLDI$C) T$VLDI$C
      FROM  BAANDB.TZNSLS401601 C
      GROUP BY C.T$NCIA$C,
               C.T$UNEG$C,
               C.T$PECL$C,
               C.T$SQPD$C,
               C.T$ENTR$C) ZNSLS401  ON  ZNSLS401.T$NCIA$C  =  ZNSLS004.T$NCIA$C
                                  AND ZNSLS401.T$UNEG$C   =  ZNSLS004.T$UNEG$C
                                  AND ZNSLS401.T$PECL$C   =  ZNSLS004.T$PECL$C
                                  AND ZNSLS401.T$SQPD$C   =  ZNSLS004.T$SQPD$C
                                  AND ZNSLS401.T$ENTR$C   =  ZNSLS004.T$ENTR$C

LEFT JOIN (SELECT  D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
                    D.T$IDMP$C,
                    D.T$SEQU$C,
          MIN(D.T$DTVB$C) T$DTVB$C,
          MIN(D.T$DTVB$C) T$DTRA$C,
          SUM(D.T$VLMR$C) T$VLMR$C,
          SUM(D.T$VLPG$C) T$VLPG$C,
          MAX(D.T$NUPA$C) T$NUPA$C,
          MAX(D.T$NSUA$C) T$NSUA$C,
          MAX(D.T$AUTO$C) T$AUTO$C,
          MAX(D.T$AUTO$C) T$PVEN$C,
          MAX(D.T$AUTO$C) T$CCCD$C
      FROM BAANDB.TZNSLS402601 D
      GROUP BY D.T$NCIA$C,
               D.T$UNEG$C,
               D.T$PECL$C,
               D.T$SQPD$C,
               D.T$IDMP$C,
               D.T$SEQU$C) SLS402_VENDA
      ON SLS402_VENDA.T$NCIA$C  =  ENT_VENDA.T$NCIA$C
     AND SLS402_VENDA.T$UNEG$C  =  ENT_VENDA.T$UNEG$C
     AND SLS402_VENDA.T$PECL$C  =  ENT_VENDA.T$PECL$C
     AND SLS402_VENDA.T$SQPD$C  =  ENT_VENDA.T$SQPD$C

LEFT JOIN (SELECT  D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
          COUNT(D.T$IDMP$C) NO_IDMP
      FROM BAANDB.TZNSLS402601 D
      GROUP BY D.T$NCIA$C,
               D.T$UNEG$C,
               D.T$PECL$C,
               D.T$SQPD$C ) CONT
       ON  CONT.T$NCIA$C  =  ENT_VENDA.T$NCIA$C
      AND CONT.T$UNEG$C =  ENT_VENDA.T$UNEG$C
      AND CONT.T$PECL$C =  ENT_VENDA.T$PECL$C
      AND CONT.T$SQPD$C =  ENT_VENDA.T$SQPD$C

INNER JOIN  BAANDB.TCISLI940601  CISLI940  ON  CISLI940.T$FIRE$L  =  CISLI245.T$FIRE$L

INNER JOIN (SELECT  E.T$FIRE$L,
                    E.T$REFR$L
            FROM  BAANDB.TCISLI941601 E
            GROUP BY E.T$FIRE$L,
                     E.T$REFR$L) CISLI941
       ON  CISLI941.T$FIRE$L  =  CISLI940.T$FIRE$L

LEFT JOIN  BAANDB.TCISLI940601  CISLI940_FAT ON  CISLI940_FAT.T$FIRE$L =  CISLI941.T$REFR$L
                      AND  CISLI940_FAT.T$FDTY$L =  16


    WHERE cisli940.t$stat$l IN (2,5,6,101)      --cancelada, impressa, lançada, estornada
    AND   cisli940.t$cnfe$l != ' '
    AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1   --faturamento
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5   --nota impressa
                  and   znnfe011.t$nfes$c = 5)  --nfe processada
   AND      cisli940.t$fdty$l NOT IN (2,14)     --2-venda sem pedido, 14-retorno mercadoria cliente
   AND      znsls400.t$idpo$c = 'TD'


ORDER BY TP_MOVTO, REF_FISCAL;
