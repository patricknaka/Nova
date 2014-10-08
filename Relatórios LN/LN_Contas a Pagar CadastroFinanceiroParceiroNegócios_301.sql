
SELECT 
  DISTINCT
    201                                     COMPANHIA,
    tccom130.t$fovn$l                       ENTIDADE_FISCAL,
    CONCAT(CONCAT(tccom100.t$bpid, '  '),  
             tccom100.t$nama)               PARCEIRO_NEGOCIOS,
    tccom125.t$cban                         COD_CONTA,
    tccom125.t$brch                         FILIAL_BANCARIA,
    CONCAT(CONCAT(tfcmg011.t$baoc$l, '  '),  
             tfcmg011.t$bnam)               BANCO,
    tccom125.t$bano                         COD_CONTA_BANCARIA,
    tccom125.t$dacc$d                       DIG_CONTA_BANCARIA,
    CONCAT(CONCAT(tccom125.t$toac, ' - '),  
             iTOAC.ToacDesc)                TIPO_CONTA_BANCARIA,
    CONCAT(CONCAT(tccom122.t$paym, ' - '),  
             tfcmg003.t$desc)               METODO_PAGAMENTO,
    CONCAT(CONCAT(tccom122.t$mopa$d, ' - '),  
             iMOPA.MopaDesc)                MODALIDADE_PAGAMENTO,
    CONCAT(CONCAT(tccom130.t$namc, ', '),  
             tccom130.t$hono)               ENDERECO,
    tccom130.t$dist$l                       BAIRRO,
    tccom130.t$pstc                         CEP,       
    tccom130.t$ccit                         CIDADE,
    tccom130.t$cste                         ESTADO,
    tccom130.t$ccty                         COD_PAIS,
    CONCAT(CONCAT(tcmcs010.t$tfcd, ' '),  
             tccom130.t$telp)               TELEFONE,
    CONCAT(CONCAT(tccom100.t$bprl, ' '),  
             iBPRL.BprlDesc)                FUNCAO,                          
    CONCAT(CONCAT(tccom100.t$prst, ' '),  
             iPRST.PrstDesc)                STATUS,       
    CASE WHEN tccom100.t$btbv = 1 
           THEN 'Sim' 
         ELSE 'Não' 
     END                                    A_SER_VERIFICADO,
    tccom100.t$prbp                         PARCEIRO_NEGOCIOS_PAI,  
    tccom130.t$ftyp$l                       TIPO_IDENTIFICADOR_FISCAL,
    tccom100.t$seak                         CHAVE_BUSCA,
	
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom100.t$crdt, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                            DATA_CRIACAO
          
FROM       baandb.ttccom100201  tccom100

LEFT JOIN baandb.ttccom125201  tccom125
        ON tccom100.t$bpid = tccom125.t$ptbp

 LEFT JOIN baandb.ttccom122201 tccom122
        ON tccom122.t$ifbp = tccom125.t$ptbp

 LEFT JOIN baandb.ttfcmg003201 tfcmg003
        ON tfcmg003.t$paym = tccom122.t$paym
	   
LEFT JOIN baandb.ttccom130201 tccom130
        ON tccom100.t$cadr = tccom130.t$cadr
  
 LEFT JOIN baandb.ttcmcs010201 tcmcs010
        ON tcmcs010.t$ccty = tccom130.t$ccty
	   
LEFT JOIN baandb.ttfcmg011201 tfcmg011
        ON tfcmg011.t$bank = tccom125.t$brch
  
 LEFT JOIN ( SELECT d.t$cnst  ToacCode, 
                    l.t$desc  ToacDesc
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'tc' 
                AND d.t$cdom = 'com.toac'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tc'
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
                                            and l1.t$cpac = l.t$cpac ) ) iTOAC
        ON tccom125.t$toac = iTOAC.ToacCode

 LEFT JOIN ( SELECT d.t$cnst MopaCode, 
                    l.t$desc MopaDesc
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.mopa.d'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iMOPA
        ON tccom122.t$mopa$d = iMOPA.MopaCode

 LEFT JOIN ( SELECT d.t$cnst BprlCode, 
                    l.t$desc BprlDesc
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'tc'
                AND d.t$cdom = 'bprl'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tc'
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
                                            and l1.t$cpac = l.t$cpac ) ) iBPRL
        ON tccom100.t$bprl = iBPRL.BprlCode

 LEFT JOIN ( SELECT d.t$cnst PrstCode, 
                    l.t$desc PrstDesc
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'tc'
                AND d.t$cdom = 'com.prst'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tc'
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
                                            and l1.t$cpac = l.t$cpac ) ) iPRST
        ON tccom100.t$prst = iPRST.PrstCode
			
WHERE tccom122.t$paym IN (:MetodoPagto)
  AND tccom122.t$mopa$d IN (:ModalidadePagto)			 
  AND ( (Trim(:CNPJ) is null) OR (regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') = Trim(regexp_replace(:CNPJ, '[^0-9]', ''))) )
