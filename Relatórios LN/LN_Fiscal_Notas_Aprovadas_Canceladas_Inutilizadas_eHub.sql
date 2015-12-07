SELECT
  DISTINCT
    regexp_replace(tccom130f.t$fovn$l, '[^0-9]', '')   EMITENTE,
    CASE WHEN cisli940.t$fdty$l = 14 THEN   --Retorno de Mercadoria de Cliente
        'Entrada' ELSE  'Saída'  END                   TIPO,
    cisli940.t$docn$l                                  NOTA_FISCAL,
    cisli940.t$seri$l                                  SERIE,
    cisli940.t$ccfo$l                                  CODIGO_FISCAL_OPERACAO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)     DATA_EMISSAO,
    NFE.DSC_STATUS                                     SITUACAO,
    Case When NFE.COD_STATUS = 5
           Then Null
         Else   cisli940.t$cnfe$l
    End                                                CHAVE_ACESSO,
    CASE WHEN SUBSTR(cisli940.t$cnfe$l,35,1) = '1' THEN
        'Normal'
    WHEN SUBSTR(cisli940.t$cnfe$l,35,1) = '4' THEN 
        'Contingencia DPEC' END                        TIPO_EMISSAO_NFE,
    regexp_replace(tccom130c.t$fovn$l, '[^0-9]', '')   ID_CLIENTE,
    Trim(cisli941.t$item$l)                            SKU_NOVA,
    Trim(tcibd001.t$mdfb$c)                            SKU_FORN,
    cisli941.t$dqua$l                                  QT_ITEM, 
    cisli941.t$pric$l                                  VALOR_UNIT,
    case when cisli940.t$gamt$l = 0 then
            0.0
    else
            cast( (cisli940.t$fght$l * (cisli941.t$gamt$l/cisli940.t$gamt$l)) as numeric(9,2))
    END                                                VALOR_FRETE,
    cisli941.t$gamt$l                                  VALOR_TOTAL_MERC,
    cisli941.t$ldam$l                                  VALOR_TOTAL_DESC,
    cisli941.t$amnt$l                                  VALOR_TOTAL_ITEM,
    cast(NVL(tttxt010f.t$text,'') as varchar(100))     MENSAGEM

FROM       baandb.tcisli940601  cisli940

INNER JOIN baandb.tcisli941601  cisli941
        ON cisli941.t$fire$l = cisli940.t$fire$l
                  
INNER JOIN baandb.ttcibd001601  tcibd001
        ON tcibd001.t$item = cisli941.t$item$l

 LEFT JOIN baandb.ttccom130601 tccom130f
        ON tccom130f.t$cadr = cisli940.t$sfra$l

 LEFT JOIN baandb.ttccom100601 tccom100c
        ON tccom100c.t$bpid = cisli940.t$bpid$l

 LEFT JOIN baandb.ttccom130601 tccom130c
        ON tccom130c.t$cadr = tccom100c.t$cadr

 LEFT JOIN baandb.ttttxt010301 tttxt010f
        ON tttxt010f.t$ctxt = cisli940.t$obse$l
       AND tttxt010f.t$clan = 'p'
       AND tttxt010f.t$seqe = 1

 LEFT JOIN baandb.ttcmcs966601 tcmcs966
        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l

 LEFT JOIN ( select l.t$desc DSC_STATUS,
                    d.t$cnst COD_STATUS
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'br'
                and d.t$cdom = 'nfe.tsta.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'br'
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
                                            and l1.t$cpac = l.t$cpac ) ) NFE
        ON NFE.COD_STATUS = cisli940.t$tsta$l
        
LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
                 
WHERE cisli940.t$stat$l IN (2,5,6,101)
  AND Trim(cisli940.t$cnfe$l) is not null
  AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
  AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
  AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
  
      Between :DataEmissaoDe
          And :DataEmissaoAte  

