SELECT Q1.CNPJ_FORNECEDOR                                 "CNPJ Fornecedor",
       Q1.NOME_FORNECEDOR                                 "Nome Fornecedor",  
       Q1.FILIAL                                          "Filial",
       Q1.ORDEM_DE_COMPRA                                 "Ordem de Compra",
       Q1.LINHA_ORDEM_DE_COMPRA                           "Linha da Ordem de Compra",
       Q1.TIPO_ORDEM_DE_COMPRA                            "Tipo Ordem de Compra",
       Q1.DESCRICAO_TIPO_ORDEM_DE_COMPRA                  "Descrição Tipo Ordem de Compra",
       Q1.GRUPO_DO_ITEM                                   "Grupo do Item",  
       Q1.DESCRICAO_GRUPO_DO_ITEM                         "Descrição Grupo do Item",  
       Q1.ITEM                                            "Item",
       Q1.DESCRICAO_ITEM                                  "Descrição Item",  
       Q1.CHAVE_DE_BUSCA_II                               "Chave de Busca II",
       Q1.EAN                                             "EAN",
       Q1.SITUACAO_ITEM                                   "Situação Item",
       Q1.PRECO_COMPRA_UNITARIO                           "Preço Compra Unitário",
       Q1.QTDE_ORDENADA_ITEM_TOTAL                        "Qtde Ordenada Item Total",
       Q1.QTDE_CANCELADA                                  "Qtde Cancelada",
       Q1.QTDE_RECEBIDA                                   "Qtde Recebida",
       Q1.QTDE_SALDO                                      "Qtde Saldo",
       Q1.QTDE_DEVOLVIDA                                  "Qtde Devolvida",
       Q1.PRECO_TOTAL_ITEM_S_IMPOSTOS                     "Preço Total Item S Impostos",
       Q1.PRECO_SALDO_ITEM_S_IMPOSTOS                     "Preço Saldo Item S Impostos",
       Q1.VALOR_DESCONTO                                  "Valor Desconto",
       Q1.PERCENTUAL_DE_DESCONTO                          "Percentual de Desconto",
       Q1.DATA_GERACAO_PEDIDO                             "Data Geração Pedido",
       Q1.DATA_PLANEJAMENTO_RECEBIMENTO                   "Data Planejamento Recebimento",     
       Q1.DATA_CONFIRMADA_RECEBIMENTO                     "Data Confirmada Recebimento",
       Q1.ORDEM_PN_FORNECEDOR                             "Ordem PN Fornecedor",
       Q1.CONDICAO_DE_ENTREGA                             "Código Condição de Entrega",
       Q1.DSC_CONDICAO_DE_ENTREGA                         "Condição de Entrega",
       Q1.CONDICAO_DE_PAGAMENTO                           "Código Condição de Pagamento",
       Q1.DSC_CONDICAO_DE_PAGAMENTO                       "Condição de Pagamento",
       Q1.STATUS_DO_PEDIDO                                "Status do Pedido",
       Q1.CODIGO_ABC                                      "Código ABC", 
       Q1.LOGIN_GEROU_OC                                  "Login Gerou OC",
       Q1.DSC_LOGIN_GEROU_OC                              "Descrição do Login Gerou OC",
       Q1.LINHAS_RAZAO_ALTERACAO                          "Linhas Razão Alteração",
       Q1.LINHAS_TIPO_ALTERACAO                           "Linhas Tipo Alteração",
       Q1.STATUS_CAPA_PEDIDO                              "Stauts Capa Pedido"
	   
  FROM ( SELECT tccom130.t$fovn$l                    CNPJ_FORNECEDOR, 
                tccom130.t$nama                      NOME_FORNECEDOR,
                tcemm030.t$euca                      FILIAL,
                tdpur400.t$orno                      ORDEM_DE_COMPRA,
                tdpur401.t$pono                      LINHA_ORDEM_DE_COMPRA,
                tdpur400.t$cotp                      TIPO_ORDEM_DE_COMPRA,
                tdpur094.t$dsca                      DESCRICAO_TIPO_ORDEM_DE_COMPRA,
                tcibd001.t$citg                      GRUPO_DO_ITEM,
                tcmcs023.t$dsca                      DESCRICAO_GRUPO_DO_ITEM,
                Trim(tdpur401.t$item)                ITEM,
                tcibd001.t$dsca                      DESCRICAO_ITEM,
                tcibd001.t$seab                      CHAVE_DE_BUSCA_II,
                tcibd001.t$cean                      EAN,
                CASE WHEN tcibd001.t$csig = 'REA' OR tcibd001.t$csig = ' ' THEN 'Ativo'
                     WHEN tcibd001.t$csig = 'CAN'                          THEN 'Cancelado'
                     WHEN tcibd001.t$csig = 'SUS'                          THEN 'Suspenso'
                     WHEN tcibd001.t$csig = '001'                          THEN 'Verificacao Fiscal' 
                END                                  SITUACAO_ITEM,
                tdpur401.t$pric                      PRECO_COMPRA_UNITARIO,
                tdpur401.t$qoor                      QTDE_ORDENADA_ITEM_TOTAL,
                CASE WHEN OrdemReposicao.t$clyn = 1  THEN ABS(OrdemReposicao.t$qoor)
                     WHEN tdpur401.t$clyn = 1        THEN tdpur401.t$qoor
                     ELSE 0 
                END                                  QTDE_CANCELADA,
                NVL(tdpur406.t$qidl,0)               QTDE_RECEBIDA,

                CASE WHEN NVL(ABS(OrdemReposicao.t$qibo), 0) = 0 
                       THEN CASE WHEN (tdpur401.t$clyn = 2 and 
                                       NVL(OrdemReposicao.t$clyn, 2) = 2)       --LINHA CANCELADA = NAO
                                   THEN tdpur401.t$qoor                -        --qtde ordenada
                                        NVL(tdpur406.t$qidl, 0)        -        --qtde recebida
                                        NVL(ABS(tdrec947_Dev.qtd_dev), 0) -        --qtde devolvida
                                        NVL(ABS(OrdemReposicao.t$qoor), 0)      --ordem cancelada
                                 ELSE  0 
                            END
                     ELSE   ABS(OrdemReposicao.t$qibo)
                END                                  QTDE_SALDO,

                NVL(ABS(tdrec947_Dev.qtd_dev), 0)       QTDE_DEVOLVIDA,
                tdpur401.t$oamt                      PRECO_TOTAL_ITEM_S_IMPOSTOS,
                CASE WHEN tdpur401.t$clyn = 2 --LINHA CANCELADA = NAO
                       THEN (tdpur401.t$qoor - NVL(tdpur406.t$qidl,0)) * tdpur401.t$pric
                     ELSE 0.0 
                END                                  PRECO_SALDO_ITEM_S_IMPOSTOS,
                tdpur401.t$ldam$1                    VALOR_DESCONTO,
                tdpur401.t$disc$1                    PERCENTUAL_DE_DESCONTO,
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') AS DATE)
                                                     DATA_GERACAO_PEDIDO,
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$ddta, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') AS DATE)
                                                     DATA_PLANEJAMENTO_RECEBIMENTO,     
                CASE WHEN TRUNC(tdpur406.t$ddte) < TO_DATE('01-01-1980', 'DD-MM-YYYY') 
                       THEN NULL
                     ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur406.t$ddte, 
                            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE) 
                END                                  DATA_CONFIRMADA_RECEBIMENTO,
                tdpur400.t$sorn                      ORDEM_PN_FORNECEDOR,
                tdpur400.t$cdec                      CONDICAO_DE_ENTREGA,
                tcmcs041.t$dsca                      DSC_CONDICAO_DE_ENTREGA,
                tdpur401.t$cpay                      CONDICAO_DE_PAGAMENTO,
                tcmcs013.t$dsca                      DSC_CONDICAO_DE_PAGAMENTO,
                CASE WHEN tdpur406.t$fire = 1 
                       THEN 'Receb.Total'
                     ELSE   'Receb.Parcial' 
                END                                  STATUS_DE_RECEBIMENTO,
                tdrec940.t$docn$l                    NOTA_FISCAL,
                tdrec940.t$seri$l                    SERIE_NF,
                
                CASE WHEN     NVL(OrdemReposicao.t$qibo, 0) = 0
                          AND tdpur401.t$clyn = 2                              --LINHA CANCELADA = NAO
                          AND NVL(OrdemReposicao.t$clyn, 2) = 2                --Ordem Reposicao cancelada = Nao
                          AND ( ABS(tdpur401.t$qoor)                  -        --qtde ordenada
                                NVL(ABS(tdpur406.t$qidl), 0)          -        --qtde recebida
                                NVL(ABS(tdrec947_Dev.qtd_dev),0)         -        --qtde devolvida
                                NVL(ABS(OrdemReposicao.t$qoor), 0))  != 0      --ordem cancelada
                           OR (NVL(ABS(OrdemReposicao.t$qibo),0) != 0 AND NVL(OrdemReposicao.t$clyn, 2) = 2)
                       THEN 'Aberto'
                       
                     WHEN     NVL(OrdemReposicao.t$qibo, 0) = 0 
                          AND tdpur401.t$clyn = 2                              --LINHA CANCELADA = NAO
                          AND NVL(OrdemReposicao.t$clyn,2) = 2                 --Ordem Reposicao cancelada = Nao
                          AND ( ABS(tdpur401.t$qoor)                 -         --qtde ordenada
                                NVL(ABS(tdpur406.t$qidl),0)          -         --qtde recebida
                                NVL(ABS(tdrec947_Dev.qtd_dev),0)        -         --qtde devolvida
                                NVL(ABS(OrdemReposicao.t$qoor), 0))  = 0       --ordem cancelada
                       THEN 'Atendida'                
                       
                     WHEN (tdpur401.t$clyn = 1 OR NVL(OrdemReposicao.t$clyn, 2) = 1 )  
                           AND NVL(ABS(OrdemReposicao.t$qibo), 0) = 0
                       THEN 'Cancelada'
                END                                  STATUS_DO_PEDIDO,

                whwmd400.t$abcc                      CODIGO_ABC,
                tdpur450.t$logn                      LOGIN_GEROU_OC,
                nome_login.t$name                    DSC_LOGIN_GEROU_OC,
                tdpur401.t$crcd                      LINHAS_RAZAO_ALTERACAO,
                tdpur401.t$ctcd                      LINHAS_TIPO_ALTERACAO,
                StatusPedido.DESCR                   STATUS_CAPA_PEDIDO,

                tdpur401.t$qibo                      QTDE_REPOSICAO,   --EXCLUIR
                tdpur401.t$pric * tdpur401.t$qoor    VALO_ORDEM,       --EXCLUIR
                tdrec940.t$fire$l                    REFE_FISCAL       --EXCLUIR
           
           FROM baandb.ttdpur400301 tdpur400
     
     INNER JOIN baandb.ttdpur401301 tdpur401
             ON tdpur401.t$orno = tdpur400.t$orno
             
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
     
      LEFT JOIN ( select ttaad200.t$user,
                         ttaad200.t$name
                    from baandb.tttaad200000 ttaad200 ) nome_login
             ON nome_login.t$user = tdpur450.t$logn
             
      LEFT JOIN ( select a.t$orno$l,
                         a.t$pono$l,
                         a.t$oorg$l,
                         min(a.t$fire$l) t$fire$l, 
                         min(a.t$line$l) t$line$l,
                         sum(a.t$qnty$l) t$qnty$l
                    from baandb.ttdrec947301 a
                   where a.t$oorg$l = 80 
                group by a.t$orno$l,
                         a.t$pono$l,
                         a.t$oorg$l ) tdrec947       --Rec.Fiscal x Ordem de Compra
             ON tdrec947.t$orno$l = tdpur401.t$orno
            AND tdrec947.t$pono$l = tdpur401.t$pono
      
      LEFT JOIN baandb.ttdrec940301 tdrec940
             ON tdrec940.t$fire$l = tdrec947.t$fire$l
         
      LEFT JOIN ( select a.t$orno$l,
			 a.t$pono$l,
			 a.t$oorg$l,
			 a.t$line$l,
			 sum(a.t$qnty$l) t$qnty$l,
			 sum(tdrec941.t$qnty$l) qtd_dev
		from baandb.ttdrec947301 a
  inner join baandb.ttdrec940301 b
		  on b.t$fire$l = a.t$fire$l
   LEFT JOIN baandb.ttdrec941301 tdrec941
		  ON tdrec941.t$fire$l = a.t$fire$l 
		 AND tdrec941.t$line$l = a.t$line$l
	   where a.t$oorg$l = 80
		 and b.t$rfdt$l = 14
	group by a.t$orno$l,
			 a.t$pono$l,
			 a.t$oorg$l,
			 a.t$line$l ) tdrec947_Dev       --Devolucao
 ON tdrec947_Dev.t$orno$l = tdpur401.t$orno
AND tdrec947_Dev.t$pono$l = tdpur401.t$pono

       
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
     		
      LEFT JOIN baandb.ttcmcs013301 tcmcs013
             ON tcmcs013.t$cpay = tdpur401.t$cpay
     
      LEFT JOIN ( select a.t$orno,
                         a.t$pono,
                         min(a.t$ddte) t$ddte,
                         max(a.t$fire) t$fire,
                         sum(a.t$qidl) t$qidl
                    from baandb.ttdpur406301 a
                group by a.t$orno,
                         a.t$pono ) tdpur406       --Recebimentos
             ON tdpur406.t$orno = tdpur401.t$orno
            AND tdpur406.t$pono = tdpur401.t$pono
            
      LEFT JOIN ( select tdpur401.t$orno,
                         tdpur401.t$pono,
                         tdpur401.t$item,
                         tdpur401.t$oltp, --tipo linha
                         tdpur401.t$clyn, --cancelado
                         tdpur401.t$qibo, --editada
                         tdpur401.t$qoor, --ordenada
                         tdpur401.t$sqnb  --sequencia 
                    from baandb.ttdpur401301 tdpur401
                   where tdpur401.t$oltp = 3
                     and tdpur401.t$clyn = 1
                     and tdpur401.t$sqnb = ( select max(a.t$sqnb) 
                                               from baandb.ttdpur401301 a
                                              where tdpur401.t$oltp = 3
                                                and tdpur401.t$orno = a.t$orno
                                                and tdpur401.t$item = a.t$item
                                                and tdpur401.t$pono = a.t$pono ) ) OrdemReposicao
             ON OrdemReposicao.t$orno = tdpur401.t$orno
            AND OrdemReposicao.t$pono = tdpur401.t$pono
            AND OrdemReposicao.t$item = tdpur401.t$item
			
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
            AND tdpur401.t$oltp IN (1,4) ) Q1
          
--            AND (          (:ValData = 0) 
--                  OR (   ( (:ValData = 1) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 
--                                                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--                                                          AT time zone 'America/Sao_Paulo') AS DATE)) = :DtEmissaoDe ) ) 
--                      OR ( (:ValData = 2) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 
--                                                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--                                                          AT time zone 'America/Sao_Paulo') AS DATE)) = :DtEmissaoAte ) ) 
--                      OR ( (:ValData = 3) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 
--                                                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--                                                          AT time zone 'America/Sao_Paulo') AS DATE)) 
--                                                Between :DtEmissaoDe
--                                                    And :DtEmissaoAte ) ) ) )
--          
--            AND Trim(tcibd001.t$citg) IN (:GrupoItem)
--            AND tcemm030.t$euca IN (:Filial) ) Q1

WHERE  (          (:ValData = 0) 
         OR (   ( (:ValData = 1) AND ( Trunc(Q1.DATA_GERACAO_PEDIDO) = :DtEmissaoDe ) )
             OR ( (:ValData = 2) AND ( Trunc(Q1.DATA_GERACAO_PEDIDO) = :DtEmissaoAte ) )
             OR ( (:ValData = 3) AND ( Trunc(Q1.DATA_GERACAO_PEDIDO) Between :DtEmissaoDe And :DtEmissaoAte ) ) 
            ) 
       )

  AND Q1.STATUS_DO_PEDIDO IN (:StatusPedido)
  AND Trim(Q1.GRUPO_DO_ITEM) IN (:GrupoItem)
  AND Q1.FILIAL IN (:Filial)

ORDER BY Q1.ORDEM_DE_COMPRA,
         Q1.LINHA_ORDEM_DE_COMPRA
