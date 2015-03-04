select Q1.* 
  from  ( SELECT DISTINCT
                 tdrec940.t$docn$l          NF,
                 tdrec940.t$seri$l          SERIE,
                 tdrec941.t$fire$l          REF_FIS,
                 tdrec941.t$line$l          LINHA_REF,
                 tcemm030.t$euca            FILIAL,
                 tcemm030.T$EUNT ||
                 ' - '           ||
                 tcemm030.t$dsca            CHAVE_NM_FILIAL,
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)  
                                            DATA,
                 tdrec940.t$fovn$l          CNPJ,                                            
                 tdrec940.t$bpid$l          COD_FORNECEDOR,
                 tdrec940.t$fids$l          NOME_FORNECEDOR,
                 tdrec941.t$opfc$l          COD_CFOP,
                 tcmcs940.t$dsca$l          DESC_CFOP,
                 ' '                        SEQ_CFOP,       --SIGE
                 STATUS.DESCR               SITUACAO_NF,
                 Trim(tdrec941.t$item$l)    ID_ITEM,
                 trim(tcibd001.t$dscb$c)    DESC_ITEM,
                 tdrec941.t$qnty$l          QTD,
                 tdrec941.t$pric$l          PRECO_UNIT,
                 tdrec941.t$tamt$l          VL_TOTAL,
                 TIPO.DESCR                 TIPO
                 
      FROM baandb.ttdrec940301  tdrec940  
           
       LEFT JOIN ( SELECT d.t$cnst CNST, 
                          l.t$desc DESCR
                     FROM baandb.tttadv401000 d, 
                          baandb.tttadv140000 l 
                    WHERE d.t$cpac = 'ci' 
                      AND d.t$cdom = 'sli.tdff.l'
                      AND l.t$clan = 'p'
                      AND l.t$cpac = 'ci'
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
                                                  and l1.t$cpac = l.t$cpac ) ) TIPO
              ON tdrec940.t$rfdt$l = TIPO.CNST

       LEFT JOIN ( SELECT d.t$cnst CNST, 
                          l.t$desc DESCR
                     FROM baandb.tttadv401000 d, 
                          baandb.tttadv140000 l 
                    WHERE d.t$cpac = 'ci' 
                      AND d.t$cdom = 'sli.stat'
                      AND l.t$clan = 'p'
                      AND l.t$cpac = 'ci'
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
                                                  and l1.t$cpac = l.t$cpac ) ) STATUS
              ON tdrec940.t$stat$l = STATUS.CNST
              
      INNER JOIN baandb.ttdrec941301 tdrec941
              ON tdrec940.t$fire$l = tdrec941.t$fire$l
  
       LEFT JOIN baandb.ttccom130301  tccom130
              ON tccom130.t$cadr=tdrec940.t$itoa$l
         
       LEFT JOIN baandb.ttcmcs940301 tcmcs940
              ON tcmcs940.T$OFSO$L = tdrec941.t$opfc$l

      INNER JOIN baandb.ttcibd001301 tcibd001
              ON tcibd001.t$item = tdrec941.t$item$l  

      INNER JOIN baandb.ttcemm124301 tcemm124
              ON tcemm124.t$cwoc  = tdrec940.t$cofc$l 

      INNER JOIN baandb.ttcemm030301 tcemm030
              ON tcemm030.t$eunt = tcemm124.t$grid

      WHERE tdrec940.t$rfdt$l = 10
        AND tcemm124.t$dtyp = 1 
    
        ORDER BY tdrec940.t$docn$l, tdrec940.t$seri$l ) Q1