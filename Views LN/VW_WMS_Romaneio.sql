SELECT  
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE1.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE1.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE1.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item)   = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC 
     FROM WMWHSE1.SKUXLOC  a 
       INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE1.SKUXLOC  
                     WHERE QTY <> 0 AND LOCATIONTYPE = 'PICK'
                     GROUP BY SKU) b   
               ON b.SKU = a.SKU 
              AND b.QTY = a.QTY ) t04 
        ON t04.SKU = t01.SKU

INNER JOIN  WMWHSE1.ALTSKU    t05 
        ON t05.SKU = t04.SKU 
       AND t05.ALTSKU = tcibd001.t$cean

INNER JOIN WMWHSE1.LOC        t06 -- Localização WMS -- 
        ON t06.LOC = t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE1.WAVEDETAIL t07 -- Linha Onda --
        ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
              WHERE t$hdst  in (20)) t09   -- 20=Em processamento
        ON t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
       AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid   = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt   = t11.t$grid   

INNER JOIN WMWHSE1.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN (SELECT t$entr$c ,count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
              HAVING count(DISTINCT t$pecl$c) = 1 ) t14
        ON t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION                   

UNION ALL

SELECT
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE2.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE2.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE2.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item) = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC FROM WMWHSE2.SKUXLOC  a 
            INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE2.SKUXLOC  
                        WHERE QTY <> 0 AND LOCATIONTYPE = 'PICK'
                        GROUP BY SKU) b   
                    ON b.SKU = a.SKU 
                   AND b.QTY = a.QTY ) t04 
        ON t04.SKU = t01.SKU

INNER JOIN WMWHSE2.ALTSKU    t05 
        ON t05.SKU = t04.SKU 
       AND t05.ALTSKU = tcibd001.t$cean

INNER JOIN WMWHSE2.LOC        t06 -- Localização WMS -- 
        ON t06.LOC =  t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE2.WAVEDETAIL t07 -- Linha Onda --
        ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
              WHERE t$hdst  in (20)) t09   -- 20=Em processamento
        ON t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
       AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt = t11.t$grid   

INNER JOIN WMWHSE2.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN ( SELECT t$entr$c ,count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
              HAVING count(DISTINCT t$pecl$c) = 1 ) t14
        ON t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION                   

UNION ALL

SELECT  
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE3.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE3.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE3.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item) = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC FROM WMWHSE3.SKUXLOC  a 
            INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE3.SKUXLOC  
                        WHERE QTY <> 0 AND LOCATIONTYPE = 'PICK'
                        GROUP BY SKU   ) b   
                    ON b.SKU = a.SKU 
                    AND b.QTY = a.QTY ) t04 
        ON t04.SKU    = t01.SKU

INNER JOIN  WMWHSE3.ALTSKU    t05 
        ON t05.SKU = t04.SKU 
       AND t05.ALTSKU  = tcibd001.t$cean

INNER JOIN WMWHSE3.LOC        t06 -- Localização WMS -- 
        ON t06.LOC =  t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE3.WAVEDETAIL t07 -- Linha Onda --
        ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
              WHERE t$hdst  in (20)) t09   -- 20=Em processamento
        ON  t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
       AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid   = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt   = t11.t$grid   

INNER JOIN WMWHSE3.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN ( SELECT t$entr$c ,count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
              HAVING count(DISTINCT t$pecl$c) = 1 ) t14
        ON t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION      
          
UNION ALL

SELECT  
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE4.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE4.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE4.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item)   = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC FROM WMWHSE4.SKUXLOC  a 
            INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE4.SKUXLOC  
                        WHERE QTY <> 0 AND LOCATIONTYPE = 'PICK'
                        GROUP BY SKU) b   
                    ON b.SKU = a.SKU 
                    AND b.QTY = a.QTY ) t04 
        ON t04.SKU    = t01.SKU

INNER JOIN  WMWHSE4.ALTSKU    t05 
        ON t05.SKU    = t04.SKU 
       AND t05.ALTSKU  = tcibd001.t$cean

INNER JOIN WMWHSE4.LOC        t06 -- Localização WMS -- 
        ON t06.LOC =  t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE4.WAVEDETAIL t07 -- Linha Onda --
ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
              WHERE t$hdst  in (20)) t09   -- 20=Em processamento
        ON t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
       AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt   = t11.t$grid   

INNER JOIN WMWHSE4.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN ( SELECT t$entr$c, count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
              HAVING count(DISTINCT t$pecl$c) = 1 ) t14
        ON  t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION  
                 
UNION ALL

SELECT  
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE5.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE5.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE5.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item)   = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC FROM WMWHSE5.SKUXLOC  a 
            INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE5.SKUXLOC  
                        WHERE QTY <> 0 AND LOCATIONTYPE = 'PICK'
                        GROUP BY SKU   ) b   
                    ON b.SKU = a.SKU 
                    AND b.QTY = a.QTY ) t04 
        ON t04.SKU = t01.SKU

INNER JOIN  WMWHSE5.ALTSKU    t05 
        ON t05.SKU = t04.SKU 
       AND t05.ALTSKU  = tcibd001.t$cean

INNER JOIN WMWHSE5.LOC        t06 -- Localização WMS -- 
        ON t06.LOC =  t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE5.WAVEDETAIL t07 -- Linha Onda --
        ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
            WHERE t$hdst  in (20)) t09   -- 20=Em processamento
        ON t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
       AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid   = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt   = t11.t$grid   

INNER JOIN WMWHSE5.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN ( SELECT t$entr$c ,count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
              HAVING count(DISTINCT t$pecl$c) = 1 ) t14
        ON  t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION  
          
UNION ALL

SELECT  
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE6.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE6.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE6.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item) = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC 
              FROM WMWHSE6.SKUXLOC  a 
            INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE6.SKUXLOC  
                         WHERE QTY <> 0 AND LOCATIONTYPE = 'PICK'
                         GROUP BY SKU   ) b   
                    ON b.SKU = a.SKU 
                    AND b.QTY = a.QTY ) t04 
        ON t04.SKU = t01.SKU

INNER JOIN  WMWHSE6.ALTSKU    t05 
        ON t05.SKU    = t04.SKU 
       AND t05.ALTSKU  = tcibd001.t$cean

INNER JOIN WMWHSE6.LOC        t06 -- Localização WMS -- 
        ON t06.LOC =  t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE6.WAVEDETAIL t07 -- Linha Onda --
        ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
              WHERE t$hdst  in (20)) t09   -- 20=Em processamento
        ON t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
       AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt   = t11.t$grid   

INNER JOIN WMWHSE6.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN ( SELECT t$entr$c ,count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
              HAVING count(DISTINCT t$pecl$c) = 1 ) t14
        ON t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION  
            
UNION ALL

SELECT  
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE7.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE7.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE7.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item) = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC FROM WMWHSE7.SKUXLOC  a 
         INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE7.SKUXLOC  
                      WHERE QTY <> 0 AND LOCATIONTYPE = 'PICK'
                      GROUP BY SKU) b   
                 ON b.SKU = a.SKU 
                AND b.QTY = a.QTY ) t04 
        ON t04.SKU = t01.SKU

INNER JOIN  WMWHSE7.ALTSKU    t05 
        ON t05.SKU = t04.SKU 
       AND t05.ALTSKU = tcibd001.t$cean

INNER JOIN WMWHSE7.LOC        t06 -- Localização WMS -- 
        ON t06.LOC = t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE7.WAVEDETAIL t07 -- Linha Onda --
        ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
              WHERE t$hdst in (20)) t09   -- 20=Em processamento
        ON t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
        AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt = t11.t$grid   

INNER JOIN WMWHSE7.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN ( SELECT t$entr$c ,count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
              HAVING count(DISTINCT t$pecl$c) = 1 ) t14
      ON t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION  

UNION ALL

SELECT  
  t02.ASSIGNMENT        AS ds_Atrib,
  trim(t08.t$item)      AS nr_SKU, 
  trim(tcibd001.t$dsca) AS ds_SKU,
  t04.LOC               AS nr_local, 
  t06.putawayzone       AS nr_classe_local,
  t06.LOCBARCODE        AS nr_EAN_local,
  t02.ORDERKEY          AS nr_pedido_WMS,
  t05.ALTSKU            AS nr_Ean_SKU, 
  sum(t01.ORIGINALQTY)  AS qtde_volumes,
  t07.WAVEKEY           AS ds_onda,
  t02.CARRIERCODE       AS nr_Transp,
  t02.CARRIERNAME       AS ds_Nome_Transp,
  t10.T$PECL$C          AS nr_Pedido,
  t10.T$ENTR$C          AS nr_Entrega ,
  t12.T$EUCA            AS nr_id_filial,
  t08.t$orno            AS nr_OV_LN, 
  t01.STATUS            AS nr_Situacao,
  t13.DESCRIPTION       AS ds_Situacao

FROM WMWHSE8.ORDERDETAIL     t01 -- Linha Ordem de Vendas WMS – 

-- Filtro Ordem de Venda com onda associada --       
INNER JOIN WMWHSE8.ORDERS     t02 -- Ordem de Vendas WMS -- 
        ON t02.ORDERKEY = t01.ORDERKEY
       AND t02.ASSIGNMENT IS NOT NULL

INNER JOIN WMWHSE8.SKU        t03 -- Item WMS -- 
        ON t03.SKU = t01.SKU  

-- Filtro Item LN  X Item  Ordem de Venda --       
INNER JOIN Baandb.ttcibd001201@dln01 tcibd001  -- Itens - Gerais --
        ON trim( tcibd001.t$item) = trim( t03.SKU)

-- Filtro Ordem de Venda que existe saldo em Estoque --       
INNER JOIN ( SELECT DISTINCT a.SKU, a.LOC FROM WMWHSE8.SKUXLOC  a 
         INNER JOIN (SELECT SKU,  MAX(QTY) AS QTY FROM WMWHSE8.SKUXLOC  
                      WHERE QTY <> 0  AND LOCATIONTYPE = 'PICK'
                        GROUP BY SKU   ) b   
                 ON b.SKU = a.SKU 
                AND b.QTY = a.QTY ) t04 
        ON t04.SKU = t01.SKU

INNER JOIN  WMWHSE8.ALTSKU    t05 
        ON t05.SKU = t04.SKU 
       AND t05.ALTSKU = tcibd001.t$cean

INNER JOIN WMWHSE8.LOC        t06 -- Localização WMS -- 
        ON t06.LOC = t04.LOC 
       AND t06.LOCBARCODE IS NOT NULL   

INNER JOIN WMWHSE8.WAVEDETAIL t07 -- Linha Onda --
        ON t07.ORDERKEY = t01.ORDERKEY

-- Filtro Ordem de Venda no LN x Front --       
INNER JOIN Baandb.ttdsls401201@dln01 t08    -- Linha Ordem de Vendas -- 
        ON t08.t$orno  = t01.SALESORDERDOCUMENT    
       AND t08.t$pono  = t01.SALESORDERLINE
       AND trim(t08.t$item)  = trim(t01.SKU) 

-- Filtro Ordem de Venda no LN que estejá em processamento --       
INNER JOIN (SELECT t$orno, t$cwar FROM Baandb.ttdsls400201@dln01
              WHERE t$hdst  in (20)) t09   -- 20=Em processamento
        ON  t09.t$orno = t08.t$orno 

INNER JOIN Baandb.tznsls004201@dln01 t10  -- Origem da Ordem de Venda --
        ON t10.t$orno$c = t08.t$orno   
       AND t10.t$pono$c = t08.t$pono   

INNER JOIN Baandb.ttcemm112201@dln01 t11  -- Armazéns --
        ON t11.t$waid = t09.t$cwar   

INNER JOIN Baandb.ttcemm030201@dln01 t12  -- Unidades Empresariais --
        ON t12.t$eunt = t11.t$grid   

INNER JOIN WMWHSE8.ORDERSTATUSSETUP  t13  -- Status Ordem WMS -- 
        ON t13.CODE = t01.STATUS  

-- Filtro Ordem de Entrega por um Pedido de Venda --       
INNER JOIN ( SELECT t$entr$c ,count(DISTINCT t$pecl$c) FROM Baandb.tznsls004201@dln01 
              GROUP BY t$entr$c
               HAVING count(DISTINCT t$pecl$c) = 1 ) t14
        ON t14.t$entr$c = t10.t$entr$c 

WHERE t01.STATUS   = '55'  --  'Coleta concluída' --

GROUP BY  t14.t$entr$c,
          t02.ASSIGNMENT,    
          trim(t08.t$item),      
          tcibd001.t$dsca,  
          t04.LOC,
          t06.putawayzone,
          t06.LOCBARCODE,
          t02.ORDERKEY,
          t05.ALTSKU,
          t07.WAVEKEY,
          t02.CARRIERCODE,
          t02.CARRIERNAME,
          t10.T$PECL$C,
          t10.T$ENTR$C,
          t12.T$EUCA,
          t08.t$orno,
          t01.STATUS,
          t13.DESCRIPTION 