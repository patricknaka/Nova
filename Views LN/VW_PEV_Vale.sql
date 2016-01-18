SELECT          
    znacr200.t$ncia$c                   CD_CIA,
    znacr200.t$uneg$c                   CD_UNIDADE_NEGOCIO,
    tfacr200.t$docd                     DT_EMISSAO_VALE,
    ABS(tfacr200.t$amnt)                VL_VALOR_VALE,
    ABS(tfacr200.t$balc)                VL_SALDO_VALE,
    tfacr201.t$liqd                     DT_VALIDADE,
    znacr200.t$bpi1$c                   CD_CLIENTE,
    CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
      THEN cast('000000000000000' as varchar(15))
		WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
      THEN cast('000000000000000' as varchar(15))
		ELSE cast(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') as varchar(15)) 
      END                               NR_CNPJ_CPF,	
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                        DT_ULT_ATUALIZACAO,
    znacr200.t$pecl$c                   NR_PEDIDO_CLIENTE,
    SUBSTR(znsls401.t$entr$c, 
    LENGTH(znsls401.t$entr$c)-1, 2)     NR_SQ_ENTREGA,
    TIPO_VALE.DESCR                     DS_TIPO_VALE,
    zngld006.t$desc$c                   DS_VALE,
    CONCAT(tfacr200.t$ttyp, 
    TO_CHAR(tfacr200.t$ninv))           CD_CHAVE_PRIMARIA
--    ,TIPO_VALE.CODE_STAT                COD_VALE   --USEI PARA CONFERIR DADOS
--    ,znsls401.t$entr$c                  NR_ENTREGA --USEI PARA CONFERIR DADOS
--    ,znsls401.t$orno$c                  NR_ORDEM   --USEI PARA CONFERIR DADOS
 
FROM    baandb.tznacr200201 znacr200
 
 LEFT JOIN ( select a.t$ttyp,
                    a.t$ninv,
                    a.t$amnt,
                    a.t$balc,
                    a.t$docd,
                    a.t$itbp,
                    a.t$rcd_utc 
               from baandb.ttfacr200201 a
              where a.t$docn = 0 ) tfacr200
        ON tfacr200.t$ttyp = znacr200.t$ttyp$c
       AND tfacr200.t$ninv = znacr200.t$ninv$c
            
 LEFT JOIN ( select a.t$ncia$c ncia,
                    a.t$uneg$c uneg,
                    a.t$pecl$c pecl
               from baandb.tznsls410201 a
              where a.t$poco$c = 'CAN'
           group by a.t$ncia$c,
                     a.t$uneg$c,
                      a.t$pecl$c ) pt_cancel
        ON pt_cancel.ncia = znacr200.t$ncia$c
       AND pt_cancel.uneg = znacr200.t$uneg$c
       AND pt_cancel.pecl = znacr200.t$pecl$c
       
 LEFT JOIN baandb.ttfacr201201 tfacr201
        ON tfacr201.t$ttyp = znacr200.t$ttyp$c
       AND tfacr201.t$ninv = znacr200.t$ninv$c

 inner join baandb.ttccom100201 tccom100
       on tccom100.t$bpid = znacr200.t$bpi1$c

 inner join baandb.ttccom130201 tccom130
       on tccom130.t$cadr = tccom100.t$cadr
       
 LEFT JOIN baandb.tzngld006201 zngld006
        ON zngld006.t$code$c = znacr200.t$code$c
 
LEFT JOIN ( SELECT d.t$cnst CODE_STAT,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'zn'
                AND d.t$cdom = 'gld.vale.c'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv401000 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) TIPO_VALE
        ON TIPO_VALE.CODE_STAT = zngld006.t$type$c
 
LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$orno$c,
                    min(a.t$entr$c) t$entr$c
              from baandb.tznsls401201 a
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c, a.t$orno$c ) znsls401
        ON znsls401.t$ncia$c = znacr200.t$ncia$c
       AND znsls401.t$uneg$c = znacr200.t$uneg$c
       AND znsls401.t$pecl$c = znacr200.t$pecl$c
       AND znsls401.t$sqpd$c = znacr200.t$sgpd$c
       
WHERE pt_cancel.pecl IS NULL      --Pedidos não cancelados
  AND tfacr200.t$balc != 0        --Vales com saldo
--  AND TO_DATE(tfacr200.t$rcd_utc) >= TO_DATE('01/11/2015')