SELECT
  CASE WHEN tdipu001.t$ixdn$c!=3 THEN 10
  ELSE tcibd936.t$itmu$l
  END COD_CATEGORIA,
ltrim(rtrim(tcibd001.t$item)) COD_ITEM,
 CASE WHEN tdipu001.t$ixdn$c!=3 THEN 'Crossdocking'
      WHEN tcibd936.t$itmu$l=1 THEN 'Industrialização'
      WHEN tcibd936.t$itmu$l=2 THEN 'Revenda'
      WHEN tcibd936.t$itmu$l=3 THEN 'Item Consumo'
      WHEN tcibd936.t$itmu$l=4 THEN 'Ativo Fixo'
      WHEN tcibd936.t$itmu$l=5 THEN 'Ind. por Terceiros'
      WHEN tcibd936.t$itmu$l=6 THEN 'Item Retornavel'
      WHEN tcibd936.t$itmu$l=7 THEN 'Frete'
      ELSE 'Não Aplicável'
  END DESCR_CATEGORIA
FROM  ttcibd001201 tcibd001
LEFT JOIN ttdipu001201 tdipu001 ON tdipu001.t$item=tcibd001.t$item
LEFT JOIN ttcibd936201 tcibd936 ON tcibd936.t$ifgc$l=tcibd001.t$ifgc$l