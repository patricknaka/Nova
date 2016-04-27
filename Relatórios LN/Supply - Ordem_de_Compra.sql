SELECT
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur450.t$trdt, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_GERACAO,
  tdpur450.t$logn                      LOGIN,
									   
  tccom130.t$fovn$l                    CNPJ_FORNECEDOR,
  tccom130.t$nama                      NOME_FORNECEDOR,  
  tcemm030.t$euca                      NUME_FILIAL,
  tdpur400.t$orno                      NUME_ORDEM,
  tdpur400.t$cotp                      COD_TIPO_ORDEM_COMPRA,
  tdpur094.t$dsca                      DSC_TIPO_ORDEM_COMPRA,
  tcmcs041.t$dsca                      TIPO_GER,
  Trim(tdpur401.t$item)                NUME_ITEM,
  tcibd001.t$dsca                      DESC_ITEM,  
  tcibd001.t$citg                      NUME_GRUPO_ITEM,  
  tcmcs023.t$dsca                      DESC_GRUPO_ITEM,  
  
  CASE WHEN tdpur401.t$fire = 1 
         THEN tdpur401.t$qoor - tdpur401.t$qidl 
       ELSE 0 
   END                                 QTDE_CANCELADA,
   
  tdpur401.t$qibo                      QTDE_REPOSICAO,
  tdpur401.t$pric                      PRECO_UNITARIO,
  tdpur401.t$qoor                      QTDE_ORDENADA,
  tdpur401.t$oamt                      PRECO_TOTAL,
  tdpur401.t$pric * tdpur401.t$qoor    VALO_ORDEM,  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_ORDEM,   
            
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$ddta, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_PLANEJADA,     
  tdpur400.t$cdec                      CONDICAO_ENTREGA,
  tcibd001.t$csig                      SINALIZACAO_ITEM,
  tdrec940.t$docn$l                    NUME_NOTA,
  tdrec940.t$seri$l                    SERIE_NOTA,
  Trim(tdrec941.t$item$l)              ITEM_NOTA,
  whwmd400.t$abcc                      CODE_ABC, 
  tdpur400.t$sorn                      ORDEM_PN_FORNECEDOR,
  tdpur401.t$crcd                      LIN_RAZAO_ALTERAC,
  tdpur401.t$ctcd                      LIN_TIPO_ALTERAC,
  
  tdpur400.t$hdst                      COD_STATUS_PEDIDO,
  StatusPedido.DESCR                   DSC_STATUS_PEDIDO

FROM       baandb.ttdpur401301 tdpur401

INNER JOIN baandb.ttdpur400301 tdpur400
        ON tdpur400.t$orno = tdpur401.t$orno
        
INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = tdpur401.t$item

INNER JOIN ( select tdpur450.t$orno,
                    tdpur450.t$logn,
                    tdpur450.t$trdt
               from baandb.ttdpur450301 tdpur450
              where tdpur450.t$trdt  = ( select min(a.t$trdt) 
                                           from baandb.ttdpur450301 a 
                                          where a.t$orno = tdpur450.t$orno 
                                            and rownum = 1 ) ) tdpur450
        ON tdpur450.t$orno = tdpur400.t$orno

 LEFT JOIN ( select rec947.t$orno$l,
                    rec947.t$pono$l,
                    rec947.t$seqn$l,
                    rec947.t$oorg$l,
                    rec947.t$fire$l, 
                    rec947.t$line$l
               from baandb.ttdrec947301 rec947
              where rec947.t$oorg$l = 80  ) tdrec947 --Ordem de Compra 
        ON tdrec947.t$orno$l = tdpur401.t$orno
       AND tdrec947.t$pono$l = tdpur401.t$pono
       AND tdrec947.t$seqn$l = tdpur401.t$sqnb
   
 LEFT JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.t$fire$l = tdrec947.t$fire$l
    
 LEFT JOIN baandb.ttdrec941301 tdrec941
        ON tdrec941.t$fire$l = tdrec947.t$fire$l 
       AND tdrec941.t$line$l = tdrec947.t$line$l
  
 LEFT JOIN baandb.ttdpur094301 tdpur094
        ON tdpur094.t$potp = tdpur400.t$cotp
        
 LEFT JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdpur400.t$cofc 
       AND tcemm124.t$dtyp = 2

 LEFT JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid 

 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tdpur400.t$sfad
  
 LEFT JOIN baandb.ttcmcs041301 tcmcs041
        ON tcmcs041.t$cdec = tdpur400.t$cdec

 LEFT JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = tcibd001.t$item
   
 LEFT JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
		
 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,      
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'td'      
                AND d.t$cdom = 'pur.hdst'     
                AND l.t$clan = 'p'
                AND l.t$cpac = 'td'      
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
                                            and l1.t$cpac = l.t$cpac ) ) StatusPedido  
      ON StatusPedido.CODE = tdpur400.t$hdst
      
WHERE tcibd001.t$citg != '001'
  AND tdpur400.t$cotp != '200'

  AND (          (:ValData = 0) 
        OR (   ( (:ValData = 1) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur450.t$trdt, 
                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                AT time zone 'America/Sao_Paulo') AS DATE)) = :DtGeraOCDe ) ) 
            OR ( (:ValData = 2) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur450.t$trdt, 
                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                AT time zone 'America/Sao_Paulo') AS DATE)) = :DtGeraOCAte ) ) 
            OR ( (:ValData = 3) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur450.t$trdt, 
                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                AT time zone 'America/Sao_Paulo') AS DATE)) 
                                      Between :DtGeraOCDe
                                          And :DtGeraOCAte ) ) ) )

  AND NVL(Trim(tcibd001.t$csig), '000') IN (:Situacao)
  AND Trim(tcibd001.t$citg) IN (:GrupoItem)
  AND tdpur400.t$hdst IN (:StatusPedido)
  AND tcemm030.t$euca IN (:Filial)
