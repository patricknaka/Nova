SELECT 
  DISTINCT
    301                                     COMPANHIA,
    tccom130.t$fovn$l                       ENTIDADE_FISCAL,
    tccom100.t$bpid                         COD_PARCEIRO_NEGOCIOS,  
    tccom100.t$nama                         DSC_PARCEIRO_NEGOCIOS,
    tccom125.t$cban                         COD_CONTA,
    tccom125.t$brch                         FILIAL_BANCARIA,
    tfcmg011.t$baoc$l                       CODE_BANCO,
    tfcmg011.t$bnam                         NOME_BANCO,
	CONCAT(CONCAT(tfcmg011.t$baoc$l, '  '),  
             tfcmg011.t$bnam)               BANCO,
    tccom125.t$bano                         COD_CONTA_BANCARIA,
    tccom125.t$dacc$d                       DIG_CONTA_BANCARIA,
    tccom125.t$toac                         COD_TIPO_CONTA_BANCARIA,
    iTOAC.ToacDesc                          DSC_TIPO_CONTA_BANCARIA,
    tccom122.t$paym                         COD_METODO_PAGAMENTO,
    tfcmg003.t$desc                         DSC_METODO_PAGAMENTO,
    tccom122.t$mopa$d                       COD_MODALIDADE_PAGAMENTO,
    iMOPA.MopaDesc                          DSC_MODALIDADE_PAGAMENTO,
    CONCAT(CONCAT(tccom130.t$namc, ', '),  
             tccom130.t$hono)               ENDERECO,
    tccom130.t$dist$l                       BAIRRO,
    tccom130.t$pstc                         CEP,       
    tccom130.t$ccit                         COD_CIDADE,
    tccom139.t$dsca                         CIDADE,
    tccom130.t$cste                         ESTADO,
    tccom130.t$ccty                         COD_PAIS,
    tccom130.t$telp                         TELEFONE,
    tccom100.t$bprl                         COD_FUNCAO,
    iBPRL.BprlDesc                          DSC_FUNCAO,
    tccom100.t$prst                         COD_STATUS,
    iPRST.PrstDesc                          DSC_STATUS,
    CASE WHEN tccom100.t$btbv = 1 
           THEN 'Sim' 
         ELSE   'Não' 
     END                                    A_SER_VERIFICADO,
    tccom100.t$prbp                         PARCEIRO_NEGOCIOS_PAI,  
    tccom130.t$ftyp$l                       TIPO_IDENTIFICADOR_FISCAL,
    tccom100.t$seak                         CHAVE_BUSCA,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom100.t$crdt, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                            DATA_CRIACAO
          
FROM       baandb.ttccom100301  tccom100

 LEFT JOIN baandb.ttccom125301  tccom125
        ON tccom100.t$bpid = tccom125.t$ptbp

 LEFT JOIN baandb.ttccom122301 tccom122
        ON tccom122.t$ifbp = tccom125.t$ptbp

 LEFT JOIN baandb.ttfcmg003301 tfcmg003
        ON tfcmg003.t$paym = tccom122.t$paym
    
 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom100.t$cadr = tccom130.t$cadr
  
 LEFT JOIN baandb.ttcmcs010301 tcmcs010
        ON tcmcs010.t$ccty = tccom130.t$ccty
		
 LEFT JOIN baandb.ttccom139301 tccom139
        ON tccom139.t$city = tccom130.t$ccit
    
 LEFT JOIN baandb.ttfcmg011301 tfcmg011
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
   
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom100.t$crdt, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)) 
      Between :DataEmissaoDe 
          And :DataEmissaoAte
  AND ( (:TodosPN = 0) or (tccom100.t$bpid in (:PN) and :TodosPN = 1  ) )
  AND tccom130.t$ftyp$l IN (:IdentificadorFiscal)
  AND NVL(tfcmg011.t$baoc$l, '0') IN (:Banco)
  AND ( (:CNPJTodos = 0) OR (regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IN (:CNPJ) AND (:CNPJTodos = 1)) )
  
ORDER BY DATA_CRIACAO