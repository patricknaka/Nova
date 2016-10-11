SELECT
  DISTINCT      
     znsls402.t$uneg$c             UNIDADE_NEGOCIO,
    znsls402.t$maqu$c             ESTABELECIMENTO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(zncmg015.t$date$c,
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT time zone 'America/Sao_Paulo') AS DATE)
                                  DATA_OCORRENCIA,
    znsls402.t$ncam$c             CARTAO,
    znsls400.t$dtin$c             DT_VENDA1,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 'DD-MON-YYYY HH24:MI:SS'),
    'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                  DT_VENDA2,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400d.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'),
    'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                  DT_VENDA3,
    znsls402.t$valo$c             VL_MEIOPAGTO,
    zncmg015.t$slst$c             VL_VENDA,
    zncmg015.t$slct$c             VL_CANCELAR,
    znsls402.t$auto$c             AUT,
    znsls402.t$nctf$c             NSU,
    znsls402.t$nsua$c             NSU_HOST,
    zncmg015.t$pecl$c             PEDIDO,
    znsls402.t$nute$c             TERMINAL,
    znsls400.t$iclf$c             CPF,
    znsls402.t$idad$c             ADQUIRENTE,
    Adquirente.                   DSC_ADQUIRENTE,
    znsls402.t$cccd$c             BANDEIRA,
    zncmg009.t$desc$c             DSC_BANDEIRA,
    CASE WHEN znsls409.t$dved$c = 1     OR
              znsls409.t$lbrd$c = 1     OR
              Trim(znsls409.t$pecl$c) is null
           THEN 'Sim'
         ELSE   'Não'
    END                           LIBERADO,
    zncmg015.t$situ$c             SITUACAO,
    Situacao.                     DSC_SITUACAO,
    zncmg015.t$nrem$c             REMESSA,
    znsls402.t$txju$c             TAXA_JUROS,
    znsls402.t$vlju$c             VALOR_JUROS,
    znsls402.t$vlja$c             VALOR_JUROS_ADMIN,
    znsls402.t$tcar$c             NOME_TITULAR_CARTAO,
    znsls402.t$cpft$c             CPF_TITULAR_CARTAO,
    znsls402.t$nupa$c             NR_PARCELAS,
    CASE WHEN zncmg015.t$rdat$c = '01-JAN-1970'
      THEN NULL
        ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(zncmg015.t$rdat$c,
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
    END                           DT_RETORNO_REMESSA,
    zncmg015.t$rcod$c             COD_RETORNO,
    zncmg019.t$dsca$c             DESC_COD_RETORNO,
    znsls401.t$lmot$c             MOTIVO_COLETA,
    Trim(znsls401.t$nome$c)       NOME_CLIENTE_COLETA,
    zncmg015.t$ncan$c             NRO_CANCELAMENTO,
    CASE WHEN zncmg015.t$caau$c = 1
           THEN 'Automático'
         ELSE   'Manual'
    END                           AUTOMATICO

FROM       baandb.tznsls402301  znsls402

INNER JOIN baandb.tzncmg015301  zncmg015
        ON zncmg015.t$ncia$c = znsls402.t$ncia$c
       AND zncmg015.t$uneg$c = znsls402.t$uneg$c
       AND zncmg015.t$pecl$c = znsls402.t$pecl$c
       AND zncmg015.t$sqpd$c = znsls402.t$sqpd$c
       AND zncmg015.t$sequ$c = znsls402.t$sequ$c
    
INNER JOIN baandb.tznsls400301  znsls400
        ON znsls400.t$ncia$c = znsls402.t$ncia$c
       AND znsls400.t$uneg$c = znsls402.t$uneg$c
       AND znsls400.t$pecl$c = znsls402.t$pecl$c
       AND znsls400.t$sqpd$c = znsls402.t$sqpd$c

 LEFT JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$ncia$c = znsls400.t$ncia$c
       AND znsls401.t$uneg$c = znsls400.t$uneg$c
       AND znsls401.t$pecl$c = znsls400.t$pecl$c
       AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
      
 LEFT JOIN baandb.tznsls400301  znsls400d
        ON znsls400d.t$pecl$c = znsls401.t$pvdt$c
       AND znsls400d.t$sqpd$c = znsls401.t$sedt$c
       
INNER JOIN baandb.tzncmg009301  zncmg009
        ON zncmg009.t$bnds$c = znsls402.t$cccd$c

 LEFT JOIN ( select tfcmg008.t$adqs$c   COD_ADQUIRENTE, 
                    tccom100.t$nama     DSC_ADQUIRENTE
               from baandb.tzncmg008301  tfcmg008, 
                    baandb.ttccom100301  tccom100
              where tccom100.t$bpid = tfcmg008.t$adqu$c ) Adquirente
        ON Adquirente.COD_ADQUIRENTE = znsls402.t$idad$c
 
 LEFT JOIN ( SELECT d.t$cnst COD_SITUACAO,
                    l.t$desc DSC_SITUACAO
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'zn'
                AND d.t$cdom = 'mcs.situ.c'
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
                                            and l1.t$cpac = l.t$cpac ) )  Situacao
        ON Situacao.COD_SITUACAO = zncmg015.t$situ$c
        
  LEFT JOIN baandb.tzncmg019301  zncmg019
         ON zncmg019.t$idad$c = zncmg015.t$idad$c
        AND zncmg019.t$rcod$c = zncmg015.t$rcod$c

  LEFT JOIN ( select sls409.t$ncia$c,
                     sls409.t$uneg$c,
                     sls409.t$pecl$c,
                     sls409.t$sqpd$c,
                     sls409.t$dved$c, 
                     sls409.t$lbrd$c
                from baandb.tznsls409301  sls409 ) znsls409
         ON znsls409.t$ncia$c = zncmg015.t$ncia$c
        AND znsls409.t$uneg$c = zncmg015.t$uneg$c
        AND znsls409.t$pecl$c = zncmg015.t$pecl$c
        AND znsls409.t$sqpd$c = zncmg015.t$sqpd$c
 
     WHERE znsls400.T$IDPO$C = 'TD'  
       AND znsls402.t$idmp$c = 1  
       AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(zncmg015.t$date$c,  
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
             AT time zone 'America/Sao_Paulo') AS DATE))  
           Between :DataOcorrenciaDe  
               And :DataOcorrenciaAte  
 
  AND znsls402.t$idad$c IN ( + JOIN(Parameters!Adquirente.Value, , ) + ) 
  AND zncmg015.t$situ$c IN ( + JOIN(Parameters!Situacao.Value, , ) + ) 
 
  AND ( (zncmg015.t$nrem$c IN 
        (  + IIF(Trim(Parameters!Remessa.Value) = , '', ' + Replace(Replace(Parameters!Remessa.Value,  , ), ,, ',') + ')  +  ))  
           OR ( + IIF(Parameters!Remessa.Value Is Nothing, 1, 0) +  = 1) ) 
  AND ( (zncmg015.t$pecl$c IN 
        (  + IIF(Trim(Parameters!Pedido.Value) = , '', ' + Replace(Replace(Parameters!Pedido.Value,  , ), ,, ',') + ')  +  ))  
           OR ( + IIF(Parameters!Pedido.Value Is Nothing, 1, 0) +  = 1) ) 
  and znsls402.t$uneg$c in ( + JOIN(Parameters!UniNegocio.Value, , ) + ) 
 
  ORDER BY znsls400.t$dtin$c  


=

" SELECT  " &
"   DISTINCT  " &
"     znsls402.t$uneg$c             UNIDADE_NEGOCIO,  " &
"     znsls402.t$maqu$c             ESTABELECIMENTO,  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(zncmg015.t$date$c,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                   DATA_OCORRENCIA,  " &
"     znsls402.t$ncam$c             CARTAO,  " &
"     znsls400.t$dtin$c             DT_VENDA1,  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                   DT_VENDA2,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400d.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                 DT_VENDA3,  " &
"     znsls402.t$valo$c             VL_MEIOPAGTO,  " &
"     zncmg015.t$slst$c +  " &
"     ABS(znsls402.t$vlju$c)        VL_VENDA,  " &
"     zncmg015.t$slct$c             VL_CANCELAR,  " &
"     znsls402.t$auto$c             AUT,  " &
"     znsls402.t$nctf$c             NSU,  " &
"     znsls402.t$nsua$c             NSU_HOST,  " &
"     zncmg015.t$pecl$c             PEDIDO,  " &
"     znsls402.t$nute$c             TERMINAL,  " &
"     znsls400.t$iclf$c             CPF,  " &
"     znsls402.t$idad$c             ADQUIRENTE,  " &
"     Adquirente.                   DSC_ADQUIRENTE,  " &
"     znsls402.t$cccd$c             BANDEIRA,  " &
"     zncmg009.t$desc$c             DSC_BANDEIRA,  " &
"     CASE WHEN znsls409.t$dved$c = 1     OR  " &
"               znsls409.t$lbrd$c = 1     OR  " &
"               Trim(znsls409.t$pecl$c) is null  " &
"            THEN 'Sim'  " &
"          ELSE   'Não'  " &
"     END                           LIBERADO,  " &
"     zncmg015.t$situ$c             SITUACAO,  " &
"     Situacao.                     DSC_SITUACAO,  " &
"     zncmg015.t$nrem$c             REMESSA,  " &
"     znsls402.t$txju$c             TAXA_JUROS,  " &
"     znsls402.t$vlju$c             VALOR_JUROS,  " &
"     znsls402.t$vlja$c             VALOR_JUROS_ADMIN,  " &
"     znsls402.t$tcar$c             NOME_TITULAR_CARTAO,  " &
"     znsls402.t$cpft$c             CPF_TITULAR_CARTAO,  " &
"     znsls402.t$nupa$c             NR_PARCELAS,  " &
"     CASE WHEN zncmg015.t$rdat$c = '01-JAN-1970'  " &
"       THEN NULL  " &
"         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(zncmg015.t$rdat$c,  " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                           DT_RETORNO_REMESSA,  " &
"     zncmg015.t$rcod$c             COD_RETORNO,  " &
"     zncmg019.t$dsca$c             DESC_COD_RETORNO,  " &
"     znsls401.t$lmot$c             MOTIVO_COLETA,  " &
"     Trim(znsls401.t$nome$c)       NOME_CLIENTE_COLETA,  " &
"     znsls401.t$emae$c             EMAIL,  " &
"     zncmg015.t$ncan$c             NRO_CANCELAMENTO,  " &
"     CASE WHEN zncmg015.t$caau$c = 1  " &
"            THEN 'Automático'  " &
"          ELSE   'Manual'  " &
"     END                           AUTOMATICO  " &
"  " &
" FROM       baandb.tznsls402" + Parameters!Compania.Value + " znsls402  " &
"  " &
" INNER JOIN baandb.tzncmg015" + Parameters!Compania.Value + " zncmg015  " &
"         ON zncmg015.t$ncia$c = znsls402.t$ncia$c  " &
"        AND zncmg015.t$uneg$c = znsls402.t$uneg$c  " &
"        AND zncmg015.t$pecl$c = znsls402.t$pecl$c  " &
"        AND zncmg015.t$sqpd$c = znsls402.t$sqpd$c  " &
"        AND zncmg015.t$sequ$c = znsls402.t$sequ$c  " &
"  " &
" INNER JOIN baandb.tznsls400" + Parameters!Compania.Value + " znsls400  " &
"         ON znsls400.t$ncia$c = znsls402.t$ncia$c  " &
"        AND znsls400.t$uneg$c = znsls402.t$uneg$c  " &
"        AND znsls400.t$pecl$c = znsls402.t$pecl$c  " &
"        AND znsls400.t$sqpd$c = znsls402.t$sqpd$c  " &
"  " &
"  LEFT JOIN baandb.tznsls401" + Parameters!Compania.Value + " znsls401  " &
"         ON znsls401.t$ncia$c = znsls400.t$ncia$c  " &
"        AND znsls401.t$uneg$c = znsls400.t$uneg$c  " &
"        AND znsls401.t$pecl$c = znsls400.t$pecl$c  " &
"        AND znsls401.t$sqpd$c = znsls400.t$sqpd$c  " &
"  " &
"  LEFT JOIN baandb.tznsls400" + Parameters!Compania.Value + "  znsls400d  " &
"         ON znsls400d.t$pecl$c = znsls401.t$pvdt$c  " &
"        AND znsls400d.t$sqpd$c = znsls401.t$sedt$c  " &
"  " &
" INNER JOIN baandb.tzncmg009" + Parameters!Compania.Value + " zncmg009  " &
"         ON zncmg009.t$bnds$c = znsls402.t$cccd$c  " &
"  " &
"  LEFT JOIN ( select tfcmg008.t$adqs$c   COD_ADQUIRENTE,  " &
"                     tccom100.t$nama     DSC_ADQUIRENTE  " &
"                from baandb.tzncmg008" + Parameters!Compania.Value + " tfcmg008,  " &
"                     baandb.ttccom100" + Parameters!Compania.Value + " tccom100  " &
"               where tccom100.t$bpid = tfcmg008.t$adqu$c ) Adquirente  " &
"         ON Adquirente.COD_ADQUIRENTE = znsls402.t$idad$c  " &
"  " &
"  LEFT JOIN ( SELECT d.t$cnst COD_SITUACAO,  " &
"                     l.t$desc DSC_SITUACAO  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'zn'  " &
"                 AND d.t$cdom = 'mcs.situ.c'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'zn'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) )  Situacao  " &
"         ON Situacao.COD_SITUACAO = zncmg015.t$situ$c  " &
"  " &
"   LEFT JOIN baandb.tzncmg019301 zncmg019  " &
"          ON zncmg019.t$idad$c = zncmg015.t$idad$c  " &
"         AND zncmg019.t$rcod$c = zncmg015.t$rcod$c  " &
"  " &
"   LEFT JOIN ( select sls409.t$ncia$c,  " &
"                      sls409.t$uneg$c,  " &
"                      sls409.t$pecl$c,  " &
"                      sls409.t$sqpd$c,  " &
"                      sls409.t$dved$c,  " &
"                      sls409.t$lbrd$c  " &
"                 from baandb.tznsls409" + Parameters!Compania.Value + " sls409 ) znsls409  " &
"          ON znsls409.t$ncia$c = zncmg015.t$ncia$c  " &
"         AND znsls409.t$uneg$c = zncmg015.t$uneg$c  " &
"         AND znsls409.t$pecl$c = zncmg015.t$pecl$c  " &
"         AND znsls409.t$sqpd$c = zncmg015.t$sqpd$c  " &
"  " &
"      WHERE znsls400.T$IDPO$C = 'TD'  " &
"        AND znsls402.t$idmp$c = 1  " &
"        AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(zncmg015.t$date$c,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE))  " &
"            Between :DataOcorrenciaDe  " &
"                And :DataOcorrenciaAte  " &
"  " &
"   AND znsls402.t$idad$c IN (" + JOIN(Parameters!Adquirente.Value, ", ") + ") " &
"   AND zncmg015.t$situ$c IN (" + JOIN(Parameters!Situacao.Value, ", ") + ") " &
"  " &
"   AND ( (zncmg015.t$nrem$c IN " &
"         ( " + IIF(Trim(Parameters!Remessa.Value) = "", "''", "'" + Replace(Replace(Parameters!Remessa.Value, " ", ""), ",", "','") + "'")  + " ))  " &
"            OR (" + IIF(Parameters!Remessa.Value Is Nothing, "1", "0") + " = 1) ) " &
"   AND ( (zncmg015.t$pecl$c IN " &
"         ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(Parameters!Pedido.Value, " ", ""), ",", "','") + "'")  + " ))  " &
"            OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) ) " &
"   and znsls402.t$uneg$c in (" + JOIN(Parameters!UniNegocio.Value, ", ") + ") " &
"  " &
"   ORDER BY znsls400.t$dtin$c  "
