SELECT DISTINCT

  GREATEST( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400dev.t$dtin$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE),
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$adat$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) )  DT_ULT_ATUALIZACAO,
  13                                                        CD_CIA,
  CAST(znsls401dev.t$uneg$c AS VARCHAR(6))                  CD_FILIAL,
  tdrec940rec.t$docn$l                                      NR_NF,        -- Nota fiscal receb. devolução
  tdrec940rec.t$seri$l                                      NR_SERIE_NF,  -- Serie NF receb. devolucção
  tdrec940rec.t$opfc$l                                      CD_NATUREZA_OPERACAO,
  tdrec940rec.t$opor$l                                      SQ_NATUREZA_OPERACAO,

    GREATEST( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400dev.t$dtin$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE),
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$adat$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) )  DT_FATURA,
  cisli940org.t$itbp$l                                      CD_CLIENTE_FATURA,
  cisli940org.t$stbp$l                                      CD_CLIENTE_ENTREGA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN NULL
  ELSE znsls401org.t$sequ$c END                             SQ_ENTREGA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN 'Sim'
  ELSE 'Nao' END                                            PEDIDO_SIGE,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN ' '
  ELSE znsls401org.t$pecl$c END                             NR_PEDIDO,

  znsls410.PT_CONTR                                         CD_STATUS,
  znsls410.DATA_OCORR                                       DT_STATUS,
  tdrec940rec.t$rfdt$l                                      CD_TIPO_NF,
  tdrec940rec.t$fire$l NR_NFR_DEVOLUCAO,
  tdrec940rec.t$fire$l                                      NR_REFERENCIA_FISCAL_DEVOLUCAO,  -- Ref. Fiscal receb. devolução
  ltrim(rtrim(znsls401dev.t$item$c))                        CD_ITEM,
  znsls401dev.t$qtve$c                                      QT_DEVOLUCAO,
  cisli943_icms.t$amnt$l                                    VL_ICMS,
  cisli941dev.t$gamt$l                                      VL_PRODUTO,
  cisli941dev.t$fght$l                                      VL_FRETE,
  cisli941dev.t$gexp$l                                      VL_DESPESA,
  cisli941dev.t$tldm$l                                      VL_DESCONTO_INCONDICIONAL,
  cisli941dev.t$amnt$l                                      VL_TOTAL_ITEM,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
      THEN CAST(znmcs095.t$sige$c AS VARCHAR(12))
  ELSE znsls401org.t$orno$c END                             NR_PEDIDO_ORIGINAL,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN NULL
  ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400dev.t$dtin$c,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) END        DT_PEDIDO,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN ' '
  ELSE znsls400org.t$idca$c END                             CD_CANAL_VENDAS,

  tccom130.t$ftyp$l                                         CD_TIPO_CLIENTE,
  tccom130.t$ccit                                           CD_CIDADE,
  tccom130.t$ccty                                           CD_PAIS,
  tccom130.t$cste                                           CD_ESTADO,
  q1.mauc                                                   VL_CMV,

  CASE WHEN cisli940org.t$fdty$l = 15      --Remessa para presente
    THEN cisli940rem_fat.t$fire$l
  ELSE cisli940org.t$fire$l END                             NR_REF_FISCAL_FATURA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN CASE WHEN znmcs095.t$tdff$c in (2,3,5) then znmcs095.t$docn$c else null end
  ELSE
    CASE WHEN cisli940org.t$fdty$l = 15    --Remessa para presente
      THEN cisli940rem_fat.t$docn$l
    ELSE cisli940org.t$docn$l END
  END                                                      NR_NF_FATURA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN CASE WHEN znmcs095.t$tdff$c in (2,3,5) then znmcs095.t$seri$c else null end
  ELSE
    CASE WHEN cisli940org.t$fdty$l = 15    --Remessa para presente
      THEN cisli940rem_fat.t$seri$l
    ELSE cisli940org.t$seri$l END
  END                                                      NR_SERIE_NF_FATURA,

  CASE WHEN cisli940org.t$fdty$l = 15     --Remessa para Presente
    THEN cisli940org.t$fire$l
  ELSE
    CASE WHEN cisli940org.t$fdty$l = 16
      THEN cisli940rem_fat.t$fire$l
    ELSE NULL END
  END                                                       NR_REF_FISCAL_REMESSA,

  CASE WHEN cisli940org.t$fdty$l = 15     --Remessa para Presente
    THEN  SLI940_ORG.STATUS
  ELSE
    CASE WHEN cisli940org.t$fdty$l = 16
      THEN SLI940_REM_FAT.STATUS
    ELSE NULL END
  END                                                       STATUS_REMESSA,


  CASE WHEN cisli940org.t$fdty$l = 15     --Remessa para Presente
    THEN CASE WHEN znmcs095.t$tdff$c in (1,4) then znmcs095.t$docn$c else null end
  ELSE
    CASE WHEN cisli940org.t$fdty$l = 16
      THEN cisli940rem_fat.t$docn$l
    ELSE NULL END
  END                                                       NR_NF_REMESSA,


  CASE WHEN cisli940org.t$fdty$l = 15     --Remessa para Presente
    THEN CASE WHEN znmcs095.t$tdff$c in (1,4) then znmcs095.t$seri$c else null end
  ELSE
    CASE WHEN cisli940org.t$fdty$l = 16
      THEN cisli940rem_fat.t$seri$l
    ELSE NULL END
  END                                                       NR_SERIE_NF_REMESSA,

  cisli943_pis.t$amnt$l                                     VL_PIS,
  cisli943_cofins.t$amnt$l                                  VL_COFINS,
  znsls401dev.t$uneg$c                                      CD_UNIDADE_NEGOCIO,

  CASE WHEN
  nvl((select  znsls401nr.t$pecl$c
        FROM  baandb.tznsls401601 znsls401nr
        WHERE  znsls401nr.t$ncia$c=znsls401dev.t$ncia$c
        AND    znsls401nr.t$uneg$c=znsls401dev.t$uneg$c
        AND    znsls401nr.t$pecl$c=znsls401dev.t$pecl$c
        AND    znsls401nr.t$sqpd$c=znsls401dev.t$sqpd$c
        AND    znsls401nr.t$entr$c>znsls401dev.t$entr$c
        AND   rownum=1),1)=1
  then 2 ELSE 1  END                                         IN_REPOSICAO,

  (SELECT tcemm124.t$grid
    FROM baandb.ttcemm124601 tcemm124
      WHERE tcemm124.t$cwoc=cisli940dev.t$cofc$l
      AND tcemm124.t$loco=201
      AND rownum=1)                                         CD_UNIDADE_EMPRESARIAL,

  tdsls406rec.t$rcid                                        NR_REC_DEVOLUCAO,
  znsls401dev.t$lcat$c                                      NM_MOTIVO_CATEGORIA,
  znsls401dev.t$lass$c                                      NM_MOTIVO_ASSUNTO,
  znsls401dev.t$lmot$c                                      NM_MOTIVO_ETIQUETA,

  CASE WHEN
  nvl((  select max(a.t$list$c)
        from baandb.tznsls405601 a
          where a.t$ncia$c=znsls401dev.t$ncia$c
          and a.t$uneg$c=znsls401dev.t$uneg$c
          and a.t$pecl$c=znsls401dev.t$pecl$c
          and a.t$sqpd$c=znsls401dev.t$sqpd$c
          and a.t$entr$c=znsls401dev.t$entr$c
          and a.t$sequ$c=znsls401dev.t$sequ$c),1)=0
  THEN 1 ELSE 2 END                                         ID_FORCADO,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN  ' '
  ELSE to_char(znsls401org.t$entr$c) END                    NR_ENTREGA_ORIGINAL,

  to_char(znsls401dev.t$entr$c)                             NR_ENTREGA_DEVOLUCAO,
  cisli941dev.t$cwar$l                                      CD_ARMAZEM,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN ' '
  ELSE
    CASE WHEN cisli940org.t$fdty$l = 15     --Remessa para presente
      THEN cisli940rem_fat.t$fire$l
    ELSE cisli941dev.t$refr$l END
  END                                                       NR_REFERENCIA_FISCAL_FATURA,

  to_char(znsls401dev.t$ccat$c)                             CD_MOTIVO_CATEGORIA,
  to_char(znsls401dev.t$cass$c)                             CD_MOTIVO_ASSUNTO,
  to_char(znsls401dev.t$cmot$c)                             CD_MOTIVO_ETIQUETA,
  tdsls400.t$orno                                           NR_ORDEM_VENDA_DEVOLUCAO,
  tdsls400.t$hdst                                           CD_STATUS_ORDEM_VDA_DEV,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)            DT_ORDEM_VENDA_DEVOLUCAO,

  tcmcs080.t$suno                                           CD_PARCEIRO_TRANSPORTADORA_FAT,
  cisli941dev.t$fire$l                                      NR_REFERENCIA_FISCAL,
  cisli941dev.t$line$l                                      NR_ITEM_NF,
  SLI940DEV.STATUS                                          STATUS_REF_FISCAL_DEV

FROM baandb.tznsls401601 znsls401dev                -- Pedido de devolução

  INNER JOIN  baandb.ttdsls400601 tdsls400
          ON tdsls400.t$orno = znsls401dev.t$orno$c

  INNER JOIN  baandb.tznsls400601 znsls400dev 
          ON  znsls400dev.t$ncia$c=znsls401dev.t$ncia$c
         AND  znsls400dev.t$uneg$c=znsls401dev.t$uneg$c
         AND  znsls400dev.t$pecl$c=znsls401dev.t$pecl$c
         AND  znsls400dev.t$sqpd$c=znsls401dev.t$sqpd$c

  LEFT JOIN (
        select  znsls410int.t$ncia$c,
                znsls410int.t$uneg$c,
                znsls410int.t$pecl$c,
                znsls410int.t$entr$c,
                znsls410int.t$sqpd$c,
                max(znsls410int.t$dtoc$c) DATA_OCORR,
                MAX(znsls410int.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410int.T$DTOC$C,  znsls410int.T$SEQN$C) PT_CONTR
        from    baandb.tznsls410601 znsls410int
        group by  znsls410int.t$ncia$c,
                  znsls410int.t$uneg$c,
                  znsls410int.t$pecl$c,
                  znsls410int.t$entr$c,
                  znsls410int.t$sqpd$c ) znsls410
    ON   znsls410.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls410.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls410.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401dev.t$sqpd$c
       AND znsls410.t$entr$c = znsls401dev.t$entr$c

  LEFT JOIN  baandb.tznsls401601 znsls401org                -- Pedido de venda original
      ON  znsls401org.t$pecl$c=znsls401dev.t$pvdt$c
      AND  znsls401org.t$ncia$c=znsls401dev.t$ncia$c
      AND  znsls401org.t$uneg$c=znsls401dev.t$uneg$c
      AND  znsls401org.t$entr$c=znsls401dev.t$endt$c
      AND  znsls401org.t$sqpd$c = znsls401dev.t$sedt$c
      AND znsls401org.t$sequ$c = znsls401dev.t$sidt$c
--      AND  znsls401org.t$sequ$c=znsls401dev.t$sedt$c

  LEFT JOIN baandb.tznsls400601 znsls400org
      ON  znsls400org.t$ncia$c=znsls401org.t$ncia$c
      AND  znsls400org.t$uneg$c=znsls401org.t$uneg$c
      AND  znsls400org.t$pecl$c=znsls401org.t$pecl$c
      AND  znsls400org.t$sqpd$c=znsls401org.t$sqpd$c

  INNER JOIN baandb.tcisli245601 cisli245dev                -- Rel Devolução
         ON  cisli245dev.t$ortp = 1
        AND  cisli245dev.t$koor = 3
        AND  cisli245dev.t$slso = znsls401dev.t$orno$c
        AND  cisli245dev.t$pono = znsls401dev.t$pono$c

  INNER JOIN  baandb.tcisli940601 cisli940dev
          ON  cisli940dev.t$fire$l=cisli245dev.t$fire$l

  INNER JOIN  baandb.tcisli941601 cisli941dev
          ON  cisli941dev.t$fire$l=cisli245dev.t$fire$l
         AND  cisli941dev.t$line$l=cisli245dev.t$line$l

  LEFT JOIN   baandb.tcisli943601 cisli943_icms
         ON   cisli943_icms.t$fire$l=cisli941dev.t$fire$l
        AND   cisli943_icms.t$line$l=cisli941dev.t$line$l
        AND   cisli943_icms.t$brty$l=1

  LEFT JOIN   baandb.tcisli943601 cisli943_pis
         ON   cisli943_pis.t$fire$l=cisli941dev.t$fire$l
        AND   cisli943_pis.t$line$l=cisli941dev.t$line$l
        AND   cisli943_pis.t$brty$l=5

  LEFT JOIN   baandb.tcisli943601 cisli943_cofins
         ON   cisli943_cofins.t$fire$l=cisli941dev.t$fire$l
        AND   cisli943_cofins.t$line$l=cisli941dev.t$line$l
        AND   cisli943_cofins.t$brty$l=6

  LEFT JOIN   baandb.tcisli245601 cisli245org
         ON   cisli245dev.t$ortp=1
        AND   cisli245dev.t$koor=3
        AND   cisli245org.t$slso=znsls401org.t$orno$c
        AND   cisli245org.t$pono=znsls401org.t$pono$c

  LEFT JOIN  baandb.tcisli940601 cisli940org
         ON  cisli940org.t$fire$l=cisli245org.t$fire$l

  LEFT JOIN  baandb.tcisli941601 cisli941org
         ON  cisli941org.t$fire$l=cisli245org.t$fire$l
        AND  cisli941org.t$line$l=cisli245org.t$line$l

  LEFT JOIN  baandb.ttccom130601 tccom130
         ON  tccom130.t$cadr=cisli940org.t$stoa$l

  LEFT JOIN  baandb.ttcmcs080601 tcmcs080
         ON  tcmcs080.t$cfrw = cisli940org.t$cfrw$L

  LEFT JOIN  baandb.ttdsls406601 tdsls406rec                -- Rec da devolução
         ON  tdsls406rec.t$orno=znsls401dev.t$orno$c
        AND  tdsls406rec.t$pono=znsls401dev.t$pono$c
        AND  tdsls406rec.t$sqnb=1

  LEFT JOIN  baandb.ttdrec947601 tdrec947rec
         ON  tdrec947rec.t$oorg$l=1
        AND  tdrec947rec.t$orno$l=znsls401dev.t$orno$c
        AND  tdrec947rec.t$pono$l=znsls401dev.t$pono$c

  LEFT JOIN  baandb.ttdrec940601 tdrec940rec
         ON  tdrec940rec.t$fire$l=tdrec947rec.t$fire$l

  LEFT JOIN  baandb.ttdrec941601 tdrec941rec
         ON  tdrec941rec.t$fire$l=tdrec947rec.t$fire$l
        AND  tdrec941rec.t$line$l=tdrec947rec.t$line$l

  LEFT JOIN ( SELECT
         whwmd217.t$item,
         whwmd217.t$cwar,
         case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
         else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4)
         end mauc
         FROM baandb.twhwmd217601 whwmd217, baandb.twhwmd215601 whwmd215
         WHERE whwmd215.t$cwar=whwmd217.t$cwar
         AND whwmd215.t$item=whwmd217.t$item
         group by  whwmd217.t$item, whwmd217.t$cwar) q1
  ON q1.t$item = cisli941dev.t$item$l AND q1.t$cwar = cisli941dev.t$cwar$l

  /*
  LEFT JOIN baandb.tznmcs095601 znmcs095    --Pedidos Sige
  ON znmcs095.t$orno$c = znsls401dev.t$orno$c
  */
  LEFT JOIN (SELECT znmcs095_i.t$orno$c, znmcs095_i.t$docn$c, znmcs095_i.t$seri$c, znmcs095_i.t$cfoc$c, znmcs095_i.t$sige$c,
                    znmcs092.t$tdff$c
            FROM baandb.tznmcs095601 znmcs095_i
            INNER JOIN baandb.tznmcs092601 znmcs092 on  znmcs095_i.t$docn$c = znmcs092.t$docn$c and
                                                       znmcs095_i.t$seri$c = znmcs092.t$seri$c and
                                                       znmcs095_i.t$cfoc$c = znmcs092.t$cfoc$c
          )znmcs095 on znmcs095.t$orno$c = znsls401dev.t$orno$c

  LEFT JOIN ( select l.t$desc STATUS,
                    d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'ci'
              and d.t$cdom = 'sli.stat'
              and l.t$clan = 'p'
              and l.t$cpac = 'ci'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4))
                                         from baandb.tttadv401000 l1
                                        where l1.t$cpac = d.t$cpac
                                          and l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4))
                                         from baandb.tttadv140000 l1
                                        where l1.t$clab = l.t$clab
                                          and l1.t$clan = l.t$clan
                                          and l1.t$cpac = l.t$cpac ) ) SLI940DEV  --Status Nota Devolução
  ON SLI940DEV.t$cnst = cisli940dev.t$stat$l

  LEFT JOIN ( select l.t$desc STATUS,
                  d.t$cnst
           from baandb.tttadv401000 d,
                baandb.tttadv140000 l
          where d.t$cpac = 'ci'
            and d.t$cdom = 'sli.stat'
            and l.t$clan = 'p'
            and l.t$cpac = 'ci'
            and l.t$clab = d.t$za_clab
            and rpad(d.t$vers,4) ||
                rpad(d.t$rele,2) ||
                rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                rpad(l1.t$rele,2) ||
                                                rpad(l1.t$cust,4))
                                       from baandb.tttadv401000 l1
                                      where l1.t$cpac = d.t$cpac
                                        and l1.t$cdom = d.t$cdom )
            and rpad(l.t$vers,4) ||
                rpad(l.t$rele,2) ||
                rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                rpad(l1.t$rele,2) ||
                                                rpad(l1.t$cust,4))
                                       from baandb.tttadv140000 l1
                                      where l1.t$clab = l.t$clab
                                        and l1.t$clan = l.t$clan
                                        and l1.t$cpac = l.t$cpac ) ) SLI940_ORG   --Status Nota Venda
  ON SLI940_ORG.t$cnst = cisli940org.t$stat$l

  LEFT JOIN ( select  a.t$fire$l  REF_FIS,
                      a.t$refr$l,
                      b.t$fire$l,
                      b.t$docn$l,
                      b.t$seri$l,
                      b.t$stat$l
              from    baandb.tcisli941601 a

              inner join baandb.tcisli940601  b
                      on b.t$fire$l = a.t$refr$l

              group by a.t$fire$l,
                       a.t$refr$l,
                       b.t$fire$l,
                       b.t$docn$l,
                       b.t$seri$l,
                       b.t$stat$l
                                      ) cisli940rem_fat
  ON cisli940rem_fat.REF_FIS = cisli940org.t$fire$l

  LEFT JOIN ( select l.t$desc STATUS,
                      d.t$cnst
               from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.stat'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv401000 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) SLI940_REM_FAT   --Status Remessa/Fatura
  ON SLI940_REM_FAT.t$cnst = cisli940rem_fat.t$stat$l

where znsls401dev.t$qtve$c < 0
and   znsls401dev.t$idor$c = 'TD'
and tdrec940rec.t$stat$l IN (4,5)

UNION 

SELECT

  GREATEST( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE),
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$adat$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) )  DT_ULT_ATUALIZACAO,
  13                                                        CD_CIA,
  CAST(znsls401.t$uneg$c AS VARCHAR(6))                     CD_FILIAL,
  tdrec940rec.t$docn$l                                      NR_NF,        -- Nota fiscal receb. devolução
  tdrec940rec.t$seri$l                                      NR_SERIE_NF,  -- Serie NF receb. devolucção
  tdrec940rec.t$opfc$l                                      CD_NATUREZA_OPERACAO,
  tdrec940rec.t$opor$l                                      SQ_NATUREZA_OPERACAO,

    GREATEST( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE),
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$adat$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) )  DT_FATURA,
  cisli940.t$itbp$l                                         CD_CLIENTE_FATURA,
  cisli940.t$stbp$l                                         CD_CLIENTE_ENTREGA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN NULL
  ELSE znsls401.t$sequ$c END                             SQ_ENTREGA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN 'Sim'
  ELSE 'Nao' END                                         PEDIDO_SIGE,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN ' '
  ELSE znsls401.t$pecl$c END                             NR_PEDIDO,

  znsls410.PT_CONTR                                      CD_STATUS,
  znsls410.DATA_OCORR                                    DT_STATUS,
  tdrec940rec.t$rfdt$l                                   CD_TIPO_NF,
  tdrec940rec.t$fire$l                                   NR_NFR_DEVOLUCAO,
  tdrec940rec.t$fire$l                                   NR_REFERENCIA_FISCAL_DEVOLUCAO,  -- Ref. Fiscal receb. devolução
  ltrim(rtrim(znsls401.t$item$c))                        CD_ITEM,
  znsls401.t$qtve$c                                      QT_DEVOLUCAO,
  cisli943_icms.t$amnt$l                                 VL_ICMS,
  cisli941dev.t$gamt$l                                   VL_PRODUTO,
  cisli941dev.t$fght$l                                   VL_FRETE,
  cisli941dev.t$gexp$l                                   VL_DESPESA,
  cisli941dev.t$tldm$l                                   VL_DESCONTO_INCONDICIONAL,
  cisli941dev.t$amnt$l                                   VL_TOTAL_ITEM,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
      THEN CAST(znmcs095.t$sige$c AS VARCHAR(12))
  ELSE znsls401.t$orno$c END                             NR_PEDIDO_ORIGINAL,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN NULL
  ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) END    DT_PEDIDO,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN ' '
  ELSE znsls400.t$idca$c END                            CD_CANAL_VENDAS,

  tccom130.t$ftyp$l                                     CD_TIPO_CLIENTE,
  tccom130.t$ccit                                       CD_CIDADE,
  tccom130.t$ccty                                       CD_PAIS,
  tccom130.t$cste                                       CD_ESTADO,
  q1.mauc                                               VL_CMV,

  CASE WHEN cisli940.t$fdty$l = 15      --Remessa para presente
    THEN cisli940rem_fat.t$fire$l
  ELSE cisli940.t$fire$l END                            NR_REF_FISCAL_FATURA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN CASE WHEN znmcs095.t$tdff$c in (2,3,5) then znmcs095.t$docn$c else null end
  ELSE
    CASE WHEN cisli940.t$fdty$l = 15    --Remessa para presente
      THEN cisli940rem_fat.t$docn$l
    ELSE cisli940.t$docn$l END
  END                                                   NR_NF_FATURA,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN CASE WHEN znmcs095.t$tdff$c in (2,3,5) then znmcs095.t$seri$c else null end
  ELSE
    CASE WHEN cisli940.t$fdty$l = 15    --Remessa para presente
      THEN cisli940rem_fat.t$seri$l
    ELSE cisli940.t$seri$l END
  END                                                   NR_SERIE_NF_FATURA,

  CASE WHEN cisli940.t$fdty$l = 15     --Remessa para Presente
    THEN cisli940.t$fire$l
  ELSE
    CASE WHEN cisli940.t$fdty$l = 16
      THEN cisli940rem_fat.t$fire$l
    ELSE NULL END
  END                                                    NR_REF_FISCAL_REMESSA,

  CASE WHEN cisli940.t$fdty$l = 15     --Remessa para Presente
    THEN  SLI940_ORG.STATUS
  ELSE
    CASE WHEN cisli940.t$fdty$l = 16
      THEN SLI940_REM_FAT.STATUS
    ELSE NULL END
  END                                                    STATUS_REMESSA,


  CASE WHEN cisli940.t$fdty$l = 15     --Remessa para Presente
    THEN CASE WHEN znmcs095.t$tdff$c in (1,4) then znmcs095.t$docn$c else null end
  ELSE
    CASE WHEN cisli940.t$fdty$l = 16
      THEN cisli940rem_fat.t$docn$l
    ELSE NULL END
  END                                                    NR_NF_REMESSA,


  CASE WHEN cisli940.t$fdty$l = 15     --Remessa para Presente
    THEN CASE WHEN znmcs095.t$tdff$c in (1,4) then znmcs095.t$seri$c else null end
  ELSE
    CASE WHEN cisli940.t$fdty$l = 16
      THEN cisli940rem_fat.t$seri$l
    ELSE NULL END
  END                                                    NR_SERIE_NF_REMESSA,

  cisli943_pis.t$amnt$l                                  VL_PIS,
  cisli943_cofins.t$amnt$l                               VL_COFINS,
  znsls401.t$uneg$c                                      CD_UNIDADE_NEGOCIO,

  CASE WHEN
  nvl((select  znsls401nr.t$pecl$c
        FROM  baandb.tznsls401601 znsls401nr
        WHERE  znsls401nr.t$ncia$c=znsls401.t$ncia$c
        AND    znsls401nr.t$uneg$c=znsls401.t$uneg$c
        AND    znsls401nr.t$pecl$c=znsls401.t$pecl$c
        AND    znsls401nr.t$sqpd$c=znsls401.t$sqpd$c
        AND    znsls401nr.t$entr$c>znsls401.t$entr$c
        AND   rownum=1),1)=1
  then 2 ELSE 1  END                                     IN_REPOSICAO,

  (SELECT tcemm124.t$grid
    FROM baandb.ttcemm124601 tcemm124
      WHERE tcemm124.t$cwoc=cisli940dev.t$cofc$l
      AND tcemm124.t$loco=201
      AND rownum=1)                                      CD_UNIDADE_EMPRESARIAL,

  tdsls406rec.t$rcid                                     NR_REC_DEVOLUCAO,
  znsls401.t$lcat$c                                      NM_MOTIVO_CATEGORIA,
  znsls401.t$lass$c                                      NM_MOTIVO_ASSUNTO,
  znsls401.t$lmot$c                                      NM_MOTIVO_ETIQUETA,

  CASE WHEN
  nvl((  select max(a.t$list$c)
        from baandb.tznsls405601 a
          where a.t$ncia$c=znsls401.t$ncia$c
          and a.t$uneg$c=znsls401.t$uneg$c
          and a.t$pecl$c=znsls401.t$pecl$c
          and a.t$sqpd$c=znsls401.t$sqpd$c
          and a.t$entr$c=znsls401.t$entr$c
          and a.t$sequ$c=znsls401.t$sequ$c),1)=0
  THEN 1 ELSE 2 END                                      ID_FORCADO,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN  ' '
  ELSE to_char(znsls401.t$entr$c) END                    NR_ENTREGA_ORIGINAL,

  to_char(znsls401.t$entr$c)                             NR_ENTREGA_DEVOLUCAO,
  cisli941dev.t$cwar$l                                   CD_ARMAZEM,

  CASE WHEN znmcs095.t$sige$c IS NOT NULL
    THEN ' '
  ELSE
    CASE WHEN cisli940.t$fdty$l = 15     --Remessa para presente
      THEN cisli940rem_fat.t$fire$l
    ELSE cisli941dev.t$refr$l END
  END                                                    NR_REFERENCIA_FISCAL_FATURA,

  to_char(znsls401.t$ccat$c)                             CD_MOTIVO_CATEGORIA,
  to_char(znsls401.t$cass$c)                             CD_MOTIVO_ASSUNTO,
  to_char(znsls401.t$cmot$c)                             CD_MOTIVO_ETIQUETA,
  tdsls400dev.t$orno                                     NR_ORDEM_VENDA_DEVOLUCAO,
  tdsls400dev.t$hdst                                     CD_STATUS_ORDEM_VDA_DEV,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400dev.t$odat,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)          DT_ORDEM_VENDA_DEVOLUCAO,

  tcmcs080.t$suno                                         CD_PARCEIRO_TRANSPORTADORA_FAT,
  cisli941dev.t$fire$l                                    NR_REFERENCIA_FISCAL,
  cisli941dev.t$line$l                                    NR_ITEM_NF,
  SLI940DEV.STATUS                                        STATUS_REF_FISCAL_DEV

FROM  ( select  a.t$ncia$c,
                a.t$uneg$c,
                a.t$pecl$c,
                a.t$sqpd$c,
                a.t$entr$c,
                a.t$sequ$c,
                max(a.t$orno$c) t$orno$c,
                a.t$pono$c
        from  baandb.tznsls004601 a
        where a.t$orig$c = 3  --insucesso de entrega
        group by  a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  a.t$entr$c,
                  a.t$sequ$c,
                  a.t$pono$c ) znsls004

  INNER JOIN baandb.tznsls401601 znsls401
          ON znsls401.t$ncia$c = znsls004.t$ncia$c
         AND znsls401.t$uneg$c = znsls004.t$uneg$c
         AND znsls401.t$pecl$c = znsls004.t$pecl$c
         AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
         AND znsls401.t$entr$c = znsls004.t$entr$c
         AND znsls401.t$sequ$c = znsls004.t$sequ$c
       
  INNER JOIN baandb.ttdsls400601 tdsls400dev
          ON tdsls400dev.t$orno = znsls004.t$orno$c

  INNER JOIN  baandb.tznsls400601 znsls400 
          ON  znsls400.t$ncia$c = znsls401.t$ncia$c
         AND  znsls400.t$uneg$c = znsls401.t$uneg$c
         AND  znsls400.t$pecl$c = znsls401.t$pecl$c
         AND  znsls400.t$sqpd$c = znsls401.t$sqpd$c

  LEFT JOIN (
              select  znsls410int.t$ncia$c,
                      znsls410int.t$uneg$c,
                      znsls410int.t$pecl$c,
                      znsls410int.t$entr$c,
                      znsls410int.t$sqpd$c,
                      max(znsls410int.t$dtoc$c) DATA_OCORR,
                      MAX(znsls410int.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410int.T$DTOC$C,  znsls410int.T$SEQN$C) PT_CONTR
              from    baandb.tznsls410601 znsls410int
              group by  znsls410int.t$ncia$c,
                        znsls410int.t$uneg$c,
                        znsls410int.t$pecl$c,
                        znsls410int.t$entr$c,
                        znsls410int.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls410.t$entr$c = znsls401.t$entr$c

  INNER JOIN baandb.tcisli245601 cisli245dev
          ON  cisli245dev.t$ortp = 1
         AND  cisli245dev.t$koor = 3
         AND  cisli245dev.t$slso = znsls004.t$orno$c
         AND  cisli245dev.t$pono = znsls004.t$pono$c

  INNER JOIN  baandb.tcisli940601 cisli940dev
          ON  cisli940dev.t$fire$l = cisli245dev.t$fire$l

  INNER JOIN  baandb.tcisli941601 cisli941dev
          ON  cisli941dev.t$fire$l = cisli245dev.t$fire$l
         AND  cisli941dev.t$line$l = cisli245dev.t$line$l

  LEFT JOIN   baandb.tcisli943601 cisli943_icms
         ON   cisli943_icms.t$fire$l = cisli941dev.t$fire$l
        AND   cisli943_icms.t$line$l = cisli941dev.t$line$l
        AND   cisli943_icms.t$brty$l = 1

  LEFT JOIN   baandb.tcisli943601 cisli943_pis
         ON   cisli943_pis.t$fire$l = cisli941dev.t$fire$l
        AND   cisli943_pis.t$line$l = cisli941dev.t$line$l
        AND   cisli943_pis.t$brty$l = 5

  LEFT JOIN   baandb.tcisli943601 cisli943_cofins
         ON   cisli943_cofins.t$fire$l = cisli941dev.t$fire$l
        AND   cisli943_cofins.t$line$l = cisli941dev.t$line$l
        AND   cisli943_cofins.t$brty$l = 6

  LEFT JOIN   baandb.tcisli245601 cisli245
         ON   cisli245.t$ortp = 1
        AND   cisli245.t$koor = 3
        AND   cisli245.t$slso = znsls401.t$orno$c
        AND   cisli245.t$pono = znsls401.t$pono$c

  LEFT JOIN  baandb.tcisli940601 cisli940
         ON  cisli940.t$fire$l = cisli245.t$fire$l

  LEFT JOIN  baandb.tcisli941601 cisli941
         ON  cisli941.t$fire$l = cisli245.t$fire$l
        AND  cisli941.t$line$l = cisli245.t$line$l

  LEFT JOIN  baandb.ttccom130601 tccom130
         ON  tccom130.t$cadr = cisli940.t$stoa$l

  LEFT JOIN  baandb.ttcmcs080601 tcmcs080
         ON  tcmcs080.t$cfrw = cisli940.t$cfrw$L

  LEFT JOIN  baandb.ttdsls406601 tdsls406rec
         ON  tdsls406rec.t$orno = znsls004.t$orno$c
        AND  tdsls406rec.t$pono = znsls004.t$pono$c
        AND  tdsls406rec.t$sqnb = 1

  LEFT JOIN  baandb.ttdrec947601 tdrec947rec
         ON  tdrec947rec.t$oorg$l = 1
        AND  tdrec947rec.t$orno$l = znsls004.t$orno$c
        AND  tdrec947rec.t$pono$l = znsls004.t$pono$c

  LEFT JOIN  baandb.ttdrec940601 tdrec940rec
         ON  tdrec940rec.t$fire$l = tdrec947rec.t$fire$l

  LEFT JOIN  baandb.ttdrec941601 tdrec941rec
         ON  tdrec941rec.t$fire$l = tdrec947rec.t$fire$l
        AND  tdrec941rec.t$line$l = tdrec947rec.t$line$l

  LEFT JOIN ( SELECT
                   whwmd217.t$item,
                   whwmd217.t$cwar,
                   case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
                   else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4)
                   end mauc
                   FROM baandb.twhwmd217601 whwmd217, baandb.twhwmd215601 whwmd215
                   WHERE whwmd215.t$cwar=whwmd217.t$cwar
                   AND whwmd215.t$item=whwmd217.t$item
                   group by  whwmd217.t$item, whwmd217.t$cwar) q1
          ON q1.t$item = cisli941dev.t$item$l 
         AND q1.t$cwar = cisli941dev.t$cwar$l


  LEFT JOIN (SELECT znmcs095_i.t$orno$c, znmcs095_i.t$docn$c, znmcs095_i.t$seri$c, znmcs095_i.t$cfoc$c, znmcs095_i.t$sige$c,
                    znmcs092.t$tdff$c
              FROM baandb.tznmcs095601 znmcs095_i
              INNER JOIN baandb.tznmcs092601 znmcs092 
                      ON  znmcs095_i.t$docn$c = znmcs092.t$docn$c 
                     AND  znmcs095_i.t$seri$c = znmcs092.t$seri$c 
                     AND  znmcs095_i.t$cfoc$c = znmcs092.t$cfoc$c )  znmcs095 
          ON znmcs095.t$orno$c = znsls004.t$orno$c

  LEFT JOIN ( select l.t$desc STATUS,
                    d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'ci'
              and d.t$cdom = 'sli.stat'
              and l.t$clan = 'p'
              and l.t$cpac = 'ci'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4))
                                         from baandb.tttadv401000 l1
                                        where l1.t$cpac = d.t$cpac
                                          and l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4))
                                         from baandb.tttadv140000 l1
                                        where l1.t$clab = l.t$clab
                                          and l1.t$clan = l.t$clan
                                          and l1.t$cpac = l.t$cpac ) ) SLI940DEV  --Status Nota Devolução
  ON SLI940DEV.t$cnst = cisli940dev.t$stat$l

  LEFT JOIN ( select l.t$desc STATUS,
                  d.t$cnst
           from baandb.tttadv401000 d,
                baandb.tttadv140000 l
          where d.t$cpac = 'ci'
            and d.t$cdom = 'sli.stat'
            and l.t$clan = 'p'
            and l.t$cpac = 'ci'
            and l.t$clab = d.t$za_clab
            and rpad(d.t$vers,4) ||
                rpad(d.t$rele,2) ||
                rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                rpad(l1.t$rele,2) ||
                                                rpad(l1.t$cust,4))
                                       from baandb.tttadv401000 l1
                                      where l1.t$cpac = d.t$cpac
                                        and l1.t$cdom = d.t$cdom )
            and rpad(l.t$vers,4) ||
                rpad(l.t$rele,2) ||
                rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                rpad(l1.t$rele,2) ||
                                                rpad(l1.t$cust,4))
                                       from baandb.tttadv140000 l1
                                      where l1.t$clab = l.t$clab
                                        and l1.t$clan = l.t$clan
                                        and l1.t$cpac = l.t$cpac ) ) SLI940_ORG   --Status Nota Venda
  ON SLI940_ORG.t$cnst = cisli940.t$stat$l

  LEFT JOIN ( select  a.t$fire$l  REF_FIS,
                      a.t$refr$l,
                      b.t$fire$l,
                      b.t$docn$l,
                      b.t$seri$l,
                      b.t$stat$l
              from    baandb.tcisli941601 a

              inner join baandb.tcisli940601  b
                      on b.t$fire$l = a.t$refr$l

              group by a.t$fire$l,
                       a.t$refr$l,
                       b.t$fire$l,
                       b.t$docn$l,
                       b.t$seri$l,
                       b.t$stat$l ) cisli940rem_fat
        ON cisli940rem_fat.REF_FIS = cisli940.t$fire$l

  LEFT JOIN ( select l.t$desc STATUS,
                      d.t$cnst
               from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.stat'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv401000 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) SLI940_REM_FAT   --Status Remessa/Fatura
  ON SLI940_REM_FAT.t$cnst = cisli940rem_fat.t$stat$l

INNER JOIN baandb.tznsls000601 znsls000
        ON znsls000.t$indt$c = TO_DATE('01-01-1970', 'DD-MM-YYYY')

where tdrec940rec.t$stat$l IN (4,5)
  and cisli941dev.t$item$l NOT IN (znsls000.t$itmd$c, znsls000.t$itmf$c, znsls000.t$itjl$c) --Despesa, Frete, Juros 
  and cisli941.t$item$l NOT IN (znsls000.t$itmd$c, znsls000.t$itmf$c, znsls000.t$itjl$c)    --Despesa, Frete, Juros 

;
