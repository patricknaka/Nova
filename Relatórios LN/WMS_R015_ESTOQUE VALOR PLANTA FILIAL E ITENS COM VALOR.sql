SELECT
  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,
  subStr(cl.DESCRIPTION,3,6) || 
  ll.sku                               CHAVE,
  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,
  sku.SUSR5                            COD_FORN,
  STORER.COMPANY                       FORNECEDOR,
  ll.sku                               ITEM,
  sku.DESCR                            DECR_ITEM,
  ( select asku.altsku 
      from WMWHSE5.altsku asku
     where asku.sku = ll.sku
       and rownum = 1 )                EAN,
     
  CASE WHEN sku.ACTIVE = '2' 
         THEN 'Inativo'
       ELSE   'Ativo' 
   END                                 SITUACAO_ITEM,
   
  departSector.depart_name             DEPTO,
  departSector.sector_name             SETOR, 
  Trim(pz.DESCR)                       CLAL,
  ll.loc                               LOCA,
  nvl(max(maucLN.mauc),0)              PRECO,
  CASE WHEN TO_CHAR(ll.holdreason) = ' ' 
         THEN 'OK'
       ELSE  TO_CHAR(ll.holdreason) 
   END                                 WARR,
  sum(llid.qty)                        QTD_EST,
  nvl(max(maucLN.mauc),0)*
      sum(llid.qty)                    VALOR,
  sum(llid.netwgt)                     PESO,
  sum(sku.STDCUBE*ll.qty)              M3,
  
  CASE WHEN SKU.BOMITEMTYPE = 0 
         THEN 'Não'
       WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)
         THEN 'KIT'
       ELSE   'TIK'
   END                                 TIK_KIT,
  
  CASE WHEN SKU.BOMITEMTYPE != 0 
         THEN NVL(BOM.SKU, SKU.SKU)
       ELSE   NULL 
   END                                 AGRUPADOR,
  LN_FAM.T$FAMI$C                      ID_FAMILIA,
  
  CASE WHEN SKU.BOMITEMTYPE != 0 
         THEN NVL(BOM.SKU, SKU.SKU)
       ELSE   SKU.SKU 
   END                                 ITEM_LN,
  
  LN_FAM.T$DSCA$C                      NOME_FAMILIA,
  
  CASE WHEN BOM.PRIMARYCOMPONENT = 1
         THEN 'SIM'
       ELSE   'NÃO'
   END                                 COMPONENTE_MESTRE,
   
   BOM.SKU                            ITEM_PAI,
   SKP.DESCR						  DESC_PAI,
   TIPO_ITEM.DSC_TIPO                 KIT_TIK2,
   BOM.SEQUENCE                       SEQUENCIA
   
    
FROM       WMWHSE5.lotxloc ll

INNER JOIN WMWHSE5.lotxlocxid llid 
        ON llid.sku = ll.sku 
       AND llid.loc = ll.loc
     
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID 

INNER JOIN ENTERPRISE.CODELKUP cl 
        ON UPPER(cl.UDF1) = llid.WHSEID
       AND cl.LISTNAME = 'SCHEMA'
     
 LEFT JOIN ( select trim(whina113.t$item)  item,
                    whina113.t$cwar        cwar,
                    sum(whina113.t$mauc$1) mauc
               from BAANDB.Twhina113301@pln01 whina113
              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn) 
                                                             from BAANDB.Twhina113301@pln01 b
                                                            where b.t$item = whina113.t$item
                                                              and b.t$cwar = whina113.t$cwar
                                                              and b.t$trdt = ( select max(c.t$trdt) 
                                                                                 from BAANDB.Twhina113301@pln01 c
                                                                                where c.t$item = b.t$item
                                                                                  and c.t$cwar = b.t$cwar ) )                                    
           group by whina113.t$item,
                    whina113.t$cwar ) maucLN   
        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)
       AND maucLN.item = llid.sku
     
INNER JOIN WMWHSE5.sku 
        ON sku.SKU = ll.SKU
    
 LEFT JOIN WMWHSE5.STORER 
        ON STORER.STORERKEY = sku.SUSR5 
       AND STORER.WHSEID = sku.WHSEID 
       AND STORER.TYPE = 5
      
INNER JOIN WMWHSE5.loc 
        ON loc.loc = ll.loc
    
 LEFT JOIN WMWHSE5.PUTAWAYZONE pz 
        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE
      
 LEFT JOIN enterprise.departsectorsku departSector 
        ON TO_CHAR(departSector.id_depart) = sku.skugroup 
       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2
       
 LEFT JOIN WMWHSE5.BILLOFMATERIAL BOM
        ON BOM.COMPONENTSKU = SKU.SKU
		
  LEFT JOIN WMWHSE5.SKU SKP 
		 ON	SKP.SKU = BOM.SKU
        
 LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM
        ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4 
                                        THEN SKU.SKU
                                      ELSE BOM.SKU 
                                  END
        
 LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM
        ON LN_FAM.T$CITG$C = LN_ITM.T$CITG
       AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C
       AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C

 LEFT JOIN ( select clkp.code          COD_TIPO, 
                    NVL(trans.description, 
                    clkp.description)  DSC_TIPO
               from WMWHSE5.codelkup clkp
          left join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
              where clkp.listname = 'EANTYPE'
                and Trim(clkp.code) is not null  ) TIPO_ITEM
        ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE
       
--WHERE departSector.ID_DEPART IN (:Depto)
--  AND ( (Trim(ll.sku) IN (:Itens) And (:ItensTodos = 0)) OR (:ItensTodos = 1) )
--where BOM.sku='1766619'
    
GROUP BY WMSADMIN.PL_DB.DB_ALIAS, 
         cl.DESCRIPTION, 
         STORER.COMPANY, 
         ll.sku, 
         sku.DESCR, 
         sku.ACTIVE, 
         sku.SUSR5, 
         pz.DESCR, 
         ll.loc, 
         ll.holdreason, 
         departSector.depart_name, 
         departSector.sector_name,
         SKU.BOMITEMTYPE,
         CASE WHEN SKU.BOMITEMTYPE!= 0 
                THEN NVL(BOM.SKU, SKU.SKU)
              ELSE NULL END,
         CASE WHEN SKU.BOMITEMTYPE!= 0 
                THEN NVL(BOM.SKU, SKU.SKU)
              ELSE SKU.SKU END,
         LN_FAM.T$FAMI$C,
         LN_FAM.T$DSCA$C,
         CASE WHEN BOM.PRIMARYCOMPONENT = 1
                THEN 'SIM'
              ELSE   'NÃO'
          END,
   BOM.SKU,
   SKP.DESCR,
   TIPO_ITEM.DSC_TIPO,
   BOM.SEQUENCE