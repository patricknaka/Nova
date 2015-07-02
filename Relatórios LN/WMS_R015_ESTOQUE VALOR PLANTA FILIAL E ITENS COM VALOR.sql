SELECT
  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,
  subStr(cl.DESCRIPTION,3,6) || 
  ll.sku                               CHAVE,
  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,
  
  CASE WHEN sku.SUSR5 IS NULL
         THEN LN_IPU001.t$otbp
       ELSE   TO_CHAR(sku.SUSR5) 
   END                                 COD_FORN,
  CASE WHEN SKU.SUSR5 IS NULL 
         THEN LN_COM100.T$NAMA
       ELSE   CASE WHEN STORER.COMPANY IS NULL 
                     THEN LN_COM100_WMS.T$NAMA
                   ELSE   TO_CHAR(STORER.COMPANY) 
               END  
   END                                 FORNECEDOR,
  
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
  nvl(max(maucLN_02.mauc),0)           PRECO,
  
  CASE WHEN TO_CHAR(ll.holdreason) = ' ' 
         THEN 'OK'
       ELSE  TO_CHAR(ll.holdreason) 
   END                                 WARR,
  sum(llid.qty)                        QTD_EST,

  nvl(max(maucLN_02.mauc),0)*
      sum(llid.qty)                    VALOR,
      
  sum(sku.STDNETWGT * llid.qty)        PESO,
  sum(sku.STDCUBE * llid.qty)          M3,
  
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
   
   BOM.SKU                             ITEM_PAI,
   SKP.DESCR                           DESC_PAI,
   TIPO_ITEM.DSC_TIPO                  KIT_TIK2,
   BOM.SEQUENCE                        SEQUENCIA
    
FROM       WMWHSE5.lotxloc ll

INNER JOIN WMWHSE5.lotxlocxid llid 
        ON llid.sku = ll.sku 
       AND llid.loc = ll.loc
     
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID 

INNER JOIN ENTERPRISE.CODELKUP cl 
        ON UPPER(cl.UDF1) = llid.WHSEID
       AND cl.LISTNAME = 'SCHEMA'
     
 LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                           then sum(whwmd217.t$ftpa$1)                                              
                         else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
               from baandb.twhwmd217301@pln01 whwmd217                      
          left join baandb.twhinr140301@pln01 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) maucLN_02                                
        ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)                         
       AND maucLN_02.item = llid.sku

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
        ON SKP.SKU = BOM.SKU
        
 LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM
        ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4 
                                        THEN SKU.SKU
                                      ELSE BOM.SKU 
                                  END
        
 LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM
        ON LN_FAM.T$CITG$C = LN_ITM.T$CITG
       AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C
       AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C

  LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001
         ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)

  LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100
         ON LN_COM100.T$BPID = LN_IPU001.T$OTBP

  LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS
         ON LN_COM100_WMS.T$BPID = sku.SUSR5
         
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
       
WHERE departSector.ID_DEPART IN (:Depto)
  AND ( (Trim(ll.sku) IN (:Itens) And (:ItensTodos = 0)) OR (:ItensTodos = 1) )
  
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
         CASE WHEN SKU.BOMITEMTYPE != 0 
                THEN NVL(BOM.SKU, SKU.SKU)
              ELSE NULL END,
         CASE WHEN SKU.BOMITEMTYPE != 0 
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
         BOM.SEQUENCE,
         LN_IPU001.t$otbp,
         LN_COM100.T$NAMA,
         LN_COM100_WMS.T$NAMA

   
   
=IIF(Parameters!Table.Value <> "AAA",
   
" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from " + Parameters!Table.Value + ".altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       " + Parameters!Table.Value + ".lotxloc ll  " &
" INNER JOIN " + Parameters!Table.Value + ".lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN " + Parameters!Table.Value + ".sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN " + Parameters!Table.Value + ".STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN " + Parameters!Table.Value + ".loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN " + Parameters!Table.Value + ".PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN " + Parameters!Table.Value + ".BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN " + Parameters!Table.Value + ".SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from " + Parameters!Table.Value + ".codelkup clkp  " &
"           left join " + Parameters!Table.Value + ".translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
"ORDER BY ARMAZEM, COD_FORN, ITEM  "

,

" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from WMWHSE1.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       WMWHSE1.lotxloc ll  " &
" INNER JOIN WMWHSE1.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE1.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE1.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE1.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE1.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE1.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE1.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE1.codelkup clkp  " &
"           left join WMWHSE1.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
" Union  " &
" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from WMWHSE2.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       WMWHSE2.lotxloc ll  " &
" INNER JOIN WMWHSE2.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE2.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE2.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE2.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE2.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE2.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE2.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE2.codelkup clkp  " &
"           left join WMWHSE2.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
" Union  " &
" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from WMWHSE3.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       WMWHSE3.lotxloc ll  " &
" INNER JOIN WMWHSE3.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE3.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE3.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE3.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE3.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE3.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE3.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE3.codelkup clkp  " &
"           left join WMWHSE3.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
" Union  " &
" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from WMWHSE4.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       WMWHSE4.lotxloc ll  " &
" INNER JOIN WMWHSE4.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE4.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE4.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE4.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE4.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE4.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE4.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE4.codelkup clkp  " &
"           left join WMWHSE4.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
" Union  " &
" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from WMWHSE5.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       WMWHSE5.lotxloc ll  " &
" INNER JOIN WMWHSE5.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE5.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE5.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE5.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE5.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE5.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE5.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE5.codelkup clkp  " &
"           left join WMWHSE5.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
" Union  " &
" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from WMWHSE6.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       WMWHSE6.lotxloc ll  " &
" INNER JOIN WMWHSE6.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE6.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE6.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE6.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE6.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE6.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE6.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE6.codelkup clkp  " &
"           left join WMWHSE6.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
" Union  " &
" SELECT  " &
"   WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,  " &
"   subStr(cl.DESCRIPTION,3,6) ||  " &
"   ll.sku                               CHAVE,  " &
"   subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,  " &
"   CASE WHEN sku.SUSR5 IS NULL  " &
"          THEN LN_IPU001.t$otbp  " &
"        ELSE   TO_CHAR(sku.SUSR5)  " &
"    END                                 COD_FORN,  " &
"   CASE WHEN SKU.SUSR5 IS NULL  " &
"          THEN LN_COM100.T$NAMA  " &
"        ELSE   CASE WHEN STORER.COMPANY IS NULL  " &
"                      THEN LN_COM100_WMS.T$NAMA  " &
"                    ELSE   TO_CHAR(STORER.COMPANY)  " &
"                END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   ( select asku.altsku  " &
"       from WMWHSE7.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   departSector.depart_name             DEPTO,  " &
"   departSector.sector_name             SETOR,  " &
"   Trim(pz.DESCR)                       CLAL,  " &
"   ll.loc                               LOCA,  " &
"   nvl(max(maucLN_02.mauc),0)           PRECO,  " &
"   CASE WHEN TO_CHAR(ll.holdreason) = ' '  " &
"          THEN 'OK'  " &
"        ELSE  TO_CHAR(ll.holdreason)  " &
"    END                                 WARR,  " &
"   sum(llid.qty)                        QTD_EST,  " &
"   nvl(max(maucLN_02.mauc),0)*  " &
"       sum(llid.qty)                    VALOR,  " &
"   sum(sku.STDNETWGT * llid.qty)        PESO,  " &
"   sum(sku.STDCUBE * llid.qty)          M3,  " &
"   CASE WHEN SKU.BOMITEMTYPE = 0  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != 0  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   SKU.SKU  " &
"    END                                 ITEM_LN,  " &
"   LN_FAM.T$DSCA$C                      NOME_FAMILIA,  " &
"   CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"          THEN 'SIM'  " &
"        ELSE   'NÃO'  " &
"    END                                 COMPONENTE_MESTRE,  " &
"    BOM.SKU                             ITEM_PAI,  " &
"    SKP.DESCR                           DESC_PAI,  " &
"    TIPO_ITEM.DSC_TIPO                  KIT_TIK2,  " &
"    BOM.SEQUENCE                        SEQUENCIA  " &
" FROM       WMWHSE7.lotxloc ll  " &
" INNER JOIN WMWHSE7.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID  " &
" INNER JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = llid.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                            then sum(whwmd217.t$ftpa$1)  " &                  
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE7.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE7.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE7.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE7.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE7.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE7.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001301@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != 4  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031301@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"   LEFT JOIN BAANDB.TTDIPU001301@PLN01 LN_IPU001  " &
"          ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100  " &
"          ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"   LEFT JOIN BAANDB.ttccom100301@PLN01 LN_COM100_WMS  " &
"          ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE7.codelkup clkp  " &
"           left join WMWHSE7.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"WHERE NVL(departSector.ID_DEPART, 0) IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != 0  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE SKU.SKU END,  " &
"          LN_FAM.T$FAMI$C,  " &
"          LN_FAM.T$DSCA$C,  " &
"          CASE WHEN BOM.PRIMARYCOMPONENT = 1  " &
"                 THEN 'SIM'  " &
"               ELSE   'NÃO'  " &
"           END,  " &
"          BOM.SKU,  " &
"          SKP.DESCR,  " &
"          TIPO_ITEM.DSC_TIPO,  " &
"          BOM.SEQUENCE,  " &
"          LN_IPU001.t$otbp,  " &
"          LN_COM100.T$NAMA,  " &
"          LN_COM100_WMS.T$NAMA  " &
"ORDER BY ARMAZEM, COD_FORN, ITEM  "

)
