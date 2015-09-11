SELECT DISTINCT

  regexp_replace(tdrec940.t$fovn$l, '[^0-9]', '')   EMITENTE,
  'ENTRADA'                 TIPO,
  tdrec940.t$docn$l         NOTA_FISCAL,
  tdrec940.t$seri$l         SERIE,
  tdrec940.t$opfc$l         CODIGO_FISCAL_OPERACAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
  AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_EMISSAO,
  NULL                      SITUACAO,
  tdrec940.t$cnfe$l         CHAVE_ACESSO,
  SUBSTR(tdrec940.t$cnfe$l,35,1) TIPO_EMISSAO_NFE,
  regexp_replace(tccom130fat.t$fovn$l, '[^0-9]', '')   ID_CLIENTE,
  tdrec941.t$item$l         SKU_NOVA,
  tcibd001.t$mdfb$c         SKU_FORN,
  tdrec941.t$qnty$l         QT_ITEM,                         
  tdrec941.t$pric$l         VALOR_UNIT,
  tdrec940.t$fght$l         VALOR_FRETE,
  tdrec941.t$tamt$l         VALOR_TOTAL,
  cast(NVL(tttxt010f.t$text,'') as varchar(100))                          MENSAGEM
  
FROM  baandb.ttdrec940601  tdrec940
     
    INNER JOIN baandb.ttdrec941601  tdrec941
            ON tdrec941.t$fire$l = tdrec940.t$fire$l
            
    INNER JOIN baandb.ttcibd001601  tcibd001
            ON tcibd001.t$item = tdrec941.t$item$l
            
    LEFT JOIN baandb.ttccom100601 tccom100fat
           ON tccom100fat.t$bpid = tdrec940.t$bpid$l
           
    LEFT JOIN baandb.ttccom130601 tccom130fat           
           ON tccom130fat.t$cadr = tccom100fat.t$cadr
           
    LEFT JOIN ( select  MIN(brnfe020.t$date$l)  AUTORIZADA,
                        brnfe020.t$ncmp$l,
                        brnfe020.t$refi$l
                from    baandb.tbrnfe020601 brnfe020
                where   brnfe020.t$stat$l = 1 
                group by brnfe020.t$ncmp$l, brnfe020.t$refi$l) DT_NFE_REC
           ON DT_NFE_REC.t$ncmp$l = 601
          AND DT_NFE_REC.t$refi$l = tdrec940.t$fire$l
          
     LEFT JOIN baandb.ttttxt010601 tttxt010r 
       ON tttxt010r.t$ctxt = tdrec940.t$obse$l
      AND tttxt010r.t$clan = 'p'
	    AND tttxt010r.t$seqe = 1
    
    LEFT JOIN baandb.ttcmcs966601 tcmcs966
           ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l
    
    LEFT JOIN baandb.ttttxt010601 tttxt010f 
           ON tttxt010f.t$ctxt = tdrec940.t$obse$l
          AND tttxt010f.t$clan = 'p'
          AND tttxt010f.t$seqe = 1
          
    WHERE tdrec940.t$stat$l IN (4,5,6)
    AND	  tdrec940.t$cnfe$l != ' '
    
UNION

SELECT DISTINCT

  regexp_replace(tccom130f.t$fovn$l, '[^0-9]', '')   EMITENTE,  
  'SAIDA'                   TIPO,
  cisli940.t$docn$l         NOTA_FISCAL,
  cisli940.t$seri$l         SERIE,
  cisli940.t$ccfo$l         CODIGO_FISCAL_OPERACAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
  AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_EMISSAO,
  NFE.STATUS                SITUACAO,
  cisli940.t$cnfe$l         CHAVE_ACESSO,
  SUBSTR(cisli940.t$cnfe$l,35,1) TIPO_EMISSAO_NFE,
  regexp_replace(tccom130c.t$fovn$l, '[^0-9]', '')   ID_CLIENTE,  
  cisli941.t$item$l         SKU_NOVA,
  tcibd001.t$mdfb$c         SKU_FORN,
  cisli941.t$dqua$l         QT_ITEM,                         
  cisli941.t$pric$l         VALOR_UNIT,
  cisli940.t$fght$l         VALOR_FRETE,
  cisli941.t$iprt$l         VALOR_TOTAL,
  cast(NVL(tttxt010f.t$text,'') as varchar(100))                          MENSAGEM
  
FROM  baandb.tcisli940601  cisli940

    INNER JOIN baandb.tcisli941601  cisli941
            ON cisli941.t$fire$l = cisli940.t$fire$l
            
    INNER JOIN baandb.ttcibd001601  tcibd001
            ON tcibd001.t$item = cisli941.t$item$l
            
    LEFT JOIN baandb.ttccom130601 tccom130f           --filial emitente
           ON tccom130f.t$cadr=cisli940.t$sfra$l

    LEFT JOIN baandb.ttccom100601 tccom100c           --cliente
           ON tccom100c.t$bpid = cisli940.t$bpid$l
           
    LEFT JOIN baandb.ttccom130601 tccom130c
           ON tccom130c.t$cadr = tccom100c.t$cadr
           
    LEFT JOIN baandb.ttttxt010601 tttxt010f 
           ON tttxt010f.t$ctxt = cisli940.t$obse$l
          AND tttxt010f.t$clan = 'p'
          AND tttxt010f.t$seqe = 1
      
    LEFT JOIN baandb.ttcmcs966601 tcmcs966
           ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l
     
      LEFT JOIN ( select  l.t$desc STATUS,
                          d.t$cnst
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
        ON NFE.t$cnst = cisli940.t$tsta$l
        
    WHERE   cisli940.t$stat$l IN (2,5,6,101)      --cancelada, impressa, lançada, estornada
    AND     cisli940.t$cnfe$l != ' '
    AND     cisli940.t$fdty$l != 2     --venda sem pedido

