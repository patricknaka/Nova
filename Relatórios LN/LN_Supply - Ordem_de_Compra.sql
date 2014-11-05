SELECT
  ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(tdpur450.t$trdt), 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone sessiontimezone) AS DATE) 
      from baandb.ttdpur450301 tdpur450
     where tdpur450.t$orno = tdpur400.t$orno) 
                                       DATA_GERACAO,
  tccom130.t$fovn$l                    CNPJ_FORNECEDOR,
  tccom130.t$nama                      NOME_FORNECEDOR,  
  tcemm030.t$euca                      NUME_FILIAL,
  tdpur400.t$orno                      NUME_ORDEM,
  tcmcs041.t$dsca                      TIPO_GER,
  Trim(tdpur401.t$item)                NUME_ITEM,
  tcibd001.t$dsca                      DESC_ITEM,  
  tcibd001.t$citg                      NUME_GRUPO_ITEM,  
  tcmcs023.t$dsca                      DESC_GRUPO_ITEM,  
  
  CASE WHEN tdpur401.t$fire = 1 THEN tdpur401.t$qoor - tdpur401.t$qidl 
       ELSE 0 
   END                                 QTDE_CANCELADA,
   
  tdpur401.t$qibo                      QTDE_REPOSICAO,
  tdpur401.t$pric                      PRECO_UNITARIO,
  tdpur401.t$qoor                      QTDE_ORDENADA,
  tdpur401.t$oamt                      PRECO_TOTAL,
  tdpur401.t$pric * tdpur401.t$qoor    VALO_ORDEM,  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)
                                       DATA_ORDEM,   
            
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$ddta, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)
                                       DATA_PLANEJADA,     
  tdpur400.t$cdec                      CONDICAO_ENTREGA,
  tcibd001.t$csig                      SINALIZACAO_ITEM,
  tdrec940.t$docn$l                    NUME_NOTA,
  tdrec940.t$seri$l                    SERIE_NOTA,
  Trim(tdrec941.t$item$l)              ITEM_NOTA,
  whwmd400.t$abcc                      CODE_ABC, 
  tdpur400.t$sorn                      ORDEM_PN_FORNECEDOR,
  ( SELECT tdpur450.t$LOGN 
      FROM baandb.ttdpur450301 tdpur450 
     WHERE tdpur450.t$orno = tdpur400.t$orno 
       AND tdpur450.t$trdt  = ( select min(a.t$trdt) 
                                  from baandb.ttdpur450301 a 
                                 where a.t$orno = tdpur450.t$orno) 
                                   and ROWNUM = 1 )
                                       LOGIN,

  tdpur401.t$crcd                      LIN_RAZAO_ALTERAC,
  tdpur401.t$ctcd                      LIN_TIPO_ALTERAC

FROM     baandb.ttccom130301  tccom130,
         baandb.ttcemm030301  tcemm030,
         baandb.ttcemm124301  tcemm124,
         baandb.ttdpur400301  tdpur400
  
LEFT JOIN baandb.ttcmcs041301  tcmcs041  
       ON tcmcs041.t$cdec = tdpur400.t$cdec, 
          
          baandb.ttdpur401301 tdpur401
 
LEFT JOIN baandb.ttdrec947301  tdrec947  
       ON tdrec947.t$oorg$l = 80 
      AND tdrec947.t$orno$l = tdpur401.t$orno
      AND tdrec947.t$pono$l = tdpur401.t$pono
      AND tdrec947.t$seqn$l = tdpur401.t$sqnb
  
LEFT JOIN baandb.ttdrec940301  tdrec940  
       ON tdrec940.t$fire$l = tdrec947.t$fire$l
   
LEFT JOIN baandb.ttdrec941301 tdrec941  
       ON tdrec941.t$fire$l = tdrec947.t$fire$l 
      AND tdrec941.t$line$l = tdrec947.t$line$l,  
  
          baandb.ttcibd001301 tcibd001   
		  
LEFT JOIN baandb.twhwmd400301 whwmd400  
       ON whwmd400.t$item = tcibd001.t$item
  
LEFT JOIN baandb.ttcmcs023301 tcmcs023
       ON tcmcs023.t$citg = tcibd001.t$citg
          
WHERE tdpur400.t$orno = tdpur401.t$orno
  AND tcibd001.t$item = tdpur401.t$item
  AND tccom130.t$cadr = tdpur400.t$sfad
  AND tcemm124.t$cwoc = tdpur400.t$cofc 
  AND tcemm124.t$dtyp = 2
  AND tcemm030.t$eunt = tcemm124.t$grid 
  
  AND tcemm030.t$euca = NVL(:Filial, tcemm030.t$euca)
  AND Trunc( (SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(tdpur450.t$trdt), 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE) 
                FROM baandb.ttdpur450301 tdpur450
                WHERE tdpur450.t$orno = tdpur400.t$orno)) BETWEEN :DtGeraOCDe AND :DtGeraOCAte
  AND tcibd001.t$csig = (CASE WHEN :Situacao = 'T' THEN tcibd001.t$csig ELSE :Situacao END)
  AND Trim(tcibd001.t$citg) IN (:GrupoItem)