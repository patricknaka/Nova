-- #FAF.008 - 21-mai-2014, Fabio Ferreira,   Diversas correções e inclusão de campos
  -- #FAF.043 - 22-mai-2014, Fabio Ferreira,   Rtrim Ltrim no codigo da garantia
  -- #FAF.043.1 - 23-mai-2014, Fabio Ferreira,   Ajustes
  -- #FAF.044 - 23-mai-2014, Fabio Ferreira,   Correção VALOR_CSLL
  -- #FAF.019 - 30-mai-2014, Fabio Ferreira,   Filtro para mostrar somente pedidos que já foram enviados para o parceiro
  -- #FAF.134 - 14-jun-2014, Fabio Ferreira,   Novos campos 
  -- #FAF.161 - 26-jun-2014, Fabio Ferreira,   Campo indicando se a garantia foi cancelado
  -- #FAF.205 - 08-juL-2014, Fabio Ferreira,   ADICIONADO CAMPO COM DATA DE ATUALIZAÇÃO
  -- #FAF.043.2 - 10-jul-2014, Fabio Ferreira,   Ajustes
  -- #FAF.043.3 - 11-jul-2014, Fabio Ferreira,   Ajustes NR_GARANTIA_ESTENDIDA
  -- #MAT.001 - 24-jul-2014, Marcia Amador R. Torres,   Adicionado campo QT_PRAZO_GARANTIA
  --********************************************************************************************************************************************************
    SELECT
    zncom005.t$cdve$c NR_GARANTIA_ESTENDIDA,                              --#FAF.043.3.o
    tdsls400.t$hdst CD_STATUS_PEDIDO,                     
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_EMISSAO_GARANTIA,                      
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_PEDIDO_PRODUTO,                        
    ltrim(rtrim(tdsls401p.t$item)) CD_ITEM,              
    ltrim(rtrim(tdsls401.t$item)) CD_ITEM_GARANTIA,                                  
    sum(tdsls401.t$pric)/count(tdsls401.t$qoor) VL_CUSTO,                        --#FAF.043.2.n
  max(tdsls401.t$pric) VL_GARANTIA,                                  --#FAF.043.2.n
    sum(zncom005.t$piof$c) VL_IOF,                    
    sum(zncom005.t$ppis$c) VL_PIS,
    sum(zncom005.t$pcof$c) VL_COFINS,
    nvl((select a.t$amnt$l from baandb.tcisli943201 a
    where a.t$fire$l=zncom005.t$fire$c
    and a.t$line$l=zncom005.t$line$c
    and a.t$brty$l=13),0) VL_CSLL,                            
    sum(zncom005.t$irrf$c) VL_IRPF,
    znsls400.T$PECL$C NR_PEDIDO,                                                           
    znsls401.T$ENTR$C NR_ENTREGA,
    tdsls400.T$ORNO NR_ORDEM,                                        
    avg(tdsls401.t$qoor) QT_GARANTIA,
  znsls400.T$uneg$c CD_UNIDADE_NEGOCIO,                                --#FAF.134.n
  znsls400.T$cven$c CD_VENDEDOR,
  znsls400.T$idca$c CD_CANAL_VENDA,                                  --#FAF.134.sn
  znsls400.t$idli$c NR_LISTA_CASAMENTO,
  (select e.t$ftyp$l from baandb.ttccom130201 e where e.t$cadr=tdsls400.t$itbp) CD_TIPO_CLIENTE_FATURA,    --#FAF.134.en
  CASE WHEN znint501.t$canc$c!=1 THEN 2 ELSE 1 END ID_CANCELADO,                    --#FAF.161.n
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(zncom005.t$rcd_utc), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,                      --#FAF.205.n
    sum(zncom005.t$igva$c) VL_ITEM_GARANTIA,                                  --#FAF.043.2.n
    zncom005.t$enga$c CD_PLANO_GARANTIA,                                    --#FAF.043.2.n
    tcibd001.T$NRPE$C QT_PRAZO_GARANTIA                                 --#MAT.001.n
  FROM
    BAANDB.tzncom005201 zncom005
  LEFT JOIN BAANDB.tznint501201 znint501                                --#FAF.161.sn
    ON  znint501.t$ncia$c=zncom005.t$ncia$c
    AND  znint501.t$uneg$c=zncom005.t$uneg$c
    AND znint501.t$pecl$c=zncom005.t$pecl$c
    AND znint501.t$sqpd$c=zncom005.t$sqpd$c
    AND znint501.t$entr$c=zncom005.t$entr$c
    AND znint501.t$sequ$c=zncom005.t$sequ$c,                            --#FAF.161.en
    baandb.ttcibd001201 tcibd001,                                            
    baandb.ttdsls400201 tdsls400,
    baandb.ttdsls401201 tdsls401,
    baandb.tznsls400201 znsls400,
    baandb.tznsls401201 znsls401
    LEFT JOIN baandb.tznsls401201 znsls401p
      ON  znsls401p.t$ncia$c=znsls401.t$ncia$c
      AND  znsls401p.t$uneg$c=znsls401.t$uneg$c
      AND znsls401p.t$pecl$c=znsls401.t$pcga$c
      AND znsls401p.t$sqpd$c=znsls401.t$sqpd$c
      AND znsls401p.t$entr$c=znsls401.t$entr$c
      AND znsls401p.t$sequ$c=znsls401.t$sgar$c  
    LEFT JOIN baandb.ttdsls401201 tdsls401p
      ON tdsls401p.t$orno=znsls401p.t$orno$c
      AND tdsls401p.t$pono=znsls401p.t$pono$c
  WHERE
    tdsls400.t$orno=zncom005.t$orno$c
  AND  znsls400.t$ncia$c=zncom005.t$ncia$c
  AND  znsls400.t$uneg$c=zncom005.t$uneg$c
  AND znsls400.t$pecl$c=zncom005.t$pecl$c
  AND znsls400.t$sqpd$c=zncom005.t$sqpd$c
  AND  znsls401.t$ncia$c=zncom005.t$ncia$c
  AND  znsls401.t$uneg$c=zncom005.t$uneg$c
  AND znsls401.t$pecl$c=zncom005.t$pecl$c
  AND znsls401.t$sqpd$c=zncom005.t$sqpd$c
  AND znsls401.t$entr$c=zncom005.t$entr$c
  AND znsls401.t$sequ$c=zncom005.t$sequ$c
  AND tdsls401.T$ORNO=znsls401.T$ORNO$C                                      
  AND tdsls401.t$pono=znsls401.T$PONO$C
  AND tcibd001.T$ITEM=tdsls401.T$ITEM
  AND tcibd001.T$ITGA$C=1
  AND zncom005.T$TPAP$C=2
  AND zncom005.t$avpn$c!=0                                --#FAF.018.n
  GROUP BY  znsls400.T$uneg$c, znsls400.T$PECL$C, znsls401.T$ENTR$C, tdsls400.T$ORNO, zncom005.t$cdve$c, tdsls400.t$hdst, znsls400.t$dtem$c,
        tdsls400.t$odat, tdsls401p.t$item, tdsls401.t$item, zncom005.t$fire$c, zncom005.t$line$c, znsls400.T$idca$c,
        znsls400.T$cven$c, znsls400.t$idli$c, tdsls400.t$itbp, znint501.t$canc$c, zncom005.t$enga$c, 
        tcibd001.T$NRPE$C                     --#MAT.001.n
