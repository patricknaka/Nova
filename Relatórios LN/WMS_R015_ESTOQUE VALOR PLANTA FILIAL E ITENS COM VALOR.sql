SELECT
  WMSADMIN_PL_DB.DB_ALIAS               ARMAZEM,
  
  subStr(cl.DESCRIPTION,3,6) || 
  ll.sku                                CHAVE,
  
  subStr(cl.DESCRIPTION,3,6)            ARMAZEM_LN,
  
  CASE WHEN sku.SUSR5 IS NULL
         THEN LN_IPU001.t$otbp
       ELSE   TO_CHAR(sku.SUSR5) 
   END                                  COD_FORN,

  LN_COM100.T$NAMA                      FORNECEDOR,
  
  ll.sku                                ITEM,
  
  sku.DESCR                             DECR_ITEM,
  
  tcibd001.t$cean                       EAN,
     
  CASE WHEN sku.ACTIVE = '2' 
         THEN 'Inativo'
       ELSE   'Ativo' 
   END                                  SITUACAO_ITEM,
   
  LN_DEPTO.t$dsca                       DEPTO,
  
  LN_SETOR.t$dsca$c                     SETOR,
        
  Trim(pz.DESCR)                        CLAL,
  
  ll.loc                                LOCA,
  
  nvl(maucLN_02.mauc,0)                 PRECO,
  
  CASE WHEN TO_CHAR(ll.holdreason) = ' ' 
         THEN 'OK'
       ELSE  TO_CHAR(ll.holdreason) 
   END                                  WARR,
   
  llid.tot_qty                          QTD_EST,

    nvl(maucLN_02.mauc,0) * 
      llid.tot_qty                      VALOR,
      
  sku.STDNETWGT * llid.tot_qty          PESO,
  
  sku.STDCUBE * llid.tot_qty             M3,
  
  CASE WHEN SKU.BOMITEMTYPE = 0 
         THEN 'NAO'
       WHEN (SKU.BOMITEMTYPE = 1 OR SKU.BOMITEMTYPE = 2)
         THEN 'KIT'
       ELSE   'TIK'
   END                                 TIK_KIT,                 --20
  
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
       ELSE   'NAO'
   END                                 COMPONENTE_MESTRE,
   
   BOM.SKU                             ITEM_PAI,
   
   SKP.DESCR                           DESC_PAI,
   
   TIPO_ITEM.DSC_TIPO                  KIT_TIK2,
   
   BOM.SEQUENCE                        SEQUENCIA              --29
    
FROM  baandb.ttcibd001301 tcibd001

INNER JOIN WMWHSE5.lotxloc@DL_LN_WMS ll
        ON TRIM(ll.sku) = TRIM(tcibd001.t$item) 

INNER JOIN ( select a.sku,
                    a.loc,
                    a.lot,
                    a.WHSEID,
                    sum(a.qty) tot_qty
             from WMWHSE5.lotxlocxid@DL_LN_WMS a 
             group by a.sku,
                      a.loc,
                      a.lot,
                      a.WHSEID ) llid 
        ON llid.sku = ll.sku 
       AND llid.loc = ll.loc
       AND llid.lot = ll.lot
     
INNER JOIN WMSADMIN.PL_DB@DL_LN_WMS WMSADMIN_PL_DB
        ON UPPER(WMSADMIN_PL_DB.DB_LOGID) = llid.WHSEID 

INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS cl 
        ON UPPER(cl.UDF1) = llid.WHSEID
       AND cl.LISTNAME = 'SCHEMA'
     
 LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                           then sum(whwmd217.t$ftpa$1)                                              
                         else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
               from baandb.twhwmd217301  whwmd217                      
          left join baandb.twhinr140301  a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) maucLN_02                                
        ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)                         
       AND maucLN_02.item = llid.sku

INNER JOIN WMWHSE5.sku@DL_LN_WMS sku 
        ON sku.SKU = ll.SKU
    
INNER JOIN WMWHSE5.loc@DL_LN_WMS loc
        ON loc.loc = ll.loc
    
 LEFT JOIN WMWHSE5.PUTAWAYZONE@DL_LN_WMS pz 
        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE
      
 LEFT JOIN WMWHSE5.BILLOFMATERIAL@DL_LN_WMS BOM
        ON BOM.COMPONENTSKU = SKU.SKU
  
 LEFT JOIN WMWHSE5.SKU@DL_LN_WMS SKP 
        ON SKP.SKU = BOM.SKU
        
 LEFT JOIN BAANDB.TZNMCS031301 LN_FAM
        ON LN_FAM.T$CITG$C = TCIBD001.T$CITG
       AND LN_FAM.T$SETO$C = TCIBD001.T$SETO$C
       AND LN_FAM.T$FAMI$C = TCIBD001.T$FAMI$C

  LEFT JOIN BAANDB.TTDIPU001301 LN_IPU001
        on LN_IPU001.T$ITEM = TCIBD001.T$ITEM

  LEFT JOIN BAANDB.ttccom100301 LN_COM100
         ON LN_COM100.T$BPID = LN_IPU001.T$OTBP
         
 LEFT JOIN ( select clkp.code          COD_TIPO, 
                    NVL(trans.description, 
                    clkp.description)  DSC_TIPO
               from WMWHSE5.codelkup@DL_LN_WMS clkp
          left join WMWHSE5.translationlist@DL_LN_WMS trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
              where clkp.listname = 'EANTYPE'
                and Trim(clkp.code) is not null  ) TIPO_ITEM
        ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE
   
  LEFT JOIN BAANDB.TTCMCS023301  LN_DEPTO
         ON LN_DEPTO.T$CITG = TCIBD001.T$CITG
         
  LEFT JOIN BAANDB.TZNMCS030301  LN_SETOR
         ON LN_SETOR.T$CITG$C = TCIBD001.T$CITG
        AND LN_SETOR.T$SETO$C = TCIBD001.T$SETO$C
        
WHERE departSector.ID_DEPART IN (:Depto)
  AND ( (Trim(ll.sku) IN (:Itens) And (:ItensTodos = 0)) OR (:ItensTodos = 1) )
		 
=IIF(Parameters!Compania.Value <> "AAA",

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
"              THEN LN_COM100_WMS.T$NAMA  " &
"            ELSE   TO_CHAR(STORER.COMPANY)  " &
"        END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   LN_ITM.T$MDFB$C                      SKU_NOVA,  " &
"   LN_ITM.T$SIZE$C                      COD_TAMANHO,  " &
"   ZNIBD005.T$DESC$C                    DSC_TAMANHO,  " &
"   ( select asku.altsku  " &
"       from " + Parameters!Compania.Value + ".altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   CASE WHEN departSector.depart_name IS NULL  " &
"          THEN LN_DEPTO.t$dsca  " &
"        ELSE   TO_CHAR(departSector.depart_name)  " &
"   END                                  DEPTO,  " &
"   CASE WHEN departSector.sector_name IS NULL  " &
"          THEN LN_SETOR.t$dsca$c  " &
"        ELSE   TO_CHAR(departSector.sector_name)  " &
"   END                                  SETOR,  " &
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
"   CASE WHEN SKU.BOMITEMTYPE = '0'  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = '1' OR SKU.BOMITEMTYPE = '2')  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != '0'  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != '0'  " &
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
" FROM       " + Parameters!Compania.Value + ".lotxloc ll  " &
" INNER JOIN " + Parameters!Compania.Value + ".lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
"        AND llid.lot = ll.lot  " &
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
"                from baandb.twhwmd217" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 whwmd217  " &
"           left join baandb.twhinr140" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN " + Parameters!Compania.Value + ".sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN " + Parameters!Compania.Value + ".loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN " + Parameters!Compania.Value + ".SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != '4'  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"  LEFT JOIN BAANDB.TTDIPU001" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 LN_IPU001  " &
"         ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"  LEFT JOIN BAANDB.ttccom100" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 LN_COM100  " &
"         ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"  LEFT JOIN BAANDB.ttccom100" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 LN_COM100_WMS  " &
"         ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from " + Parameters!Compania.Value + ".codelkup clkp  " &
"           left join " + Parameters!Compania.Value + ".translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"  LEFT JOIN BAANDB.TTCMCS023" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 LN_DEPTO  " &
"         ON LN_DEPTO.T$CITG = LN_ITM.T$CITG  " &
"  LEFT JOIN BAANDB.TZNMCS030" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 LN_SETOR  " &
"         ON LN_SETOR.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_SETOR.T$SETO$C = LN_ITM.T$SETO$C  " &
"  LEFT JOIN BAANDB.TZNIBD005" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 ZNIBD005  " &
"         ON ZNIBD005.T$SIZE$C = LN_ITM.T$SIZE$C  " &
"WHERE NVL(NVL(departSector.id_depart, LN_DEPTO.T$CITG), 0) IN (" + Replace(("'" + JOIN(Parameters!Depto.Value, "',") + "'"),",",",'") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          LN_ITM.T$MDFB$C,  " &
"          LN_ITM.T$SIZE$C,  " &
"          ZNIBD005.T$DESC$C,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != '0'  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != '0'  " &
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
"          LN_COM100_WMS.T$NAMA,  " &
"          LN_DEPTO.t$dsca,  " &
"          LN_SETOR.t$dsca$c  " &
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
"              THEN LN_COM100_WMS.T$NAMA  " &
"            ELSE   TO_CHAR(STORER.COMPANY)  " &
"        END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   LN_ITM.T$MDFB$C                      SKU_NOVA,  " &
"   LN_ITM.T$SIZE$C                      COD_TAMANHO,  " &
"   ZNIBD005.T$DESC$C                    DSC_TAMANHO,  " &
"   ( select asku.altsku  " &
"       from WMWHSE9.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   CASE WHEN departSector.depart_name IS NULL  " &
"          THEN LN_DEPTO.t$dsca  " &
"        ELSE   TO_CHAR(departSector.depart_name)  " &
"   END                                  DEPTO,  " &
"   CASE WHEN departSector.sector_name IS NULL  " &
"          THEN LN_SETOR.t$dsca$c  " &
"        ELSE   TO_CHAR(departSector.sector_name)  " &
"   END                                  SETOR,  " &
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
"   CASE WHEN SKU.BOMITEMTYPE = '0'  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = '1' OR SKU.BOMITEMTYPE = '2')  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != '0'  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != '0'  " &
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
" FROM       WMWHSE9.lotxloc ll  " &
" INNER JOIN WMWHSE9.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
"        AND llid.lot = ll.lot  " &
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
"                from baandb.twhwmd217601@PLN01 whwmd217  " &
"           left join baandb.twhinr140601@PLN01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE9.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE9.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE9.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE9.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE9.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE9.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001601@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != '4'  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031601@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"  LEFT JOIN BAANDB.TTDIPU001601@PLN01 LN_IPU001  " &
"         ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"  LEFT JOIN BAANDB.ttccom100601@PLN01 LN_COM100  " &
"         ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"  LEFT JOIN BAANDB.ttccom100601@PLN01 LN_COM100_WMS  " &
"         ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE9.codelkup clkp  " &
"           left join WMWHSE9.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"  LEFT JOIN BAANDB.TTCMCS023601@PLN01 LN_DEPTO  " &
"         ON LN_DEPTO.T$CITG = LN_ITM.T$CITG  " &
"  LEFT JOIN BAANDB.TZNMCS030601@PLN01 LN_SETOR  " &
"         ON LN_SETOR.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_SETOR.T$SETO$C = LN_ITM.T$SETO$C  " &
"  LEFT JOIN BAANDB.TZNIBD005" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 ZNIBD005  " &
"         ON ZNIBD005.T$SIZE$C = LN_ITM.T$SIZE$C  " &
"WHERE NVL(NVL(departSector.id_depart, LN_DEPTO.T$CITG), 0) IN (" + Replace(("'" + JOIN(Parameters!Depto.Value, "',") + "'"),",",",'") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          LN_ITM.T$MDFB$C,  " &
"          LN_ITM.T$SIZE$C,  " &
"          ZNIBD005.T$DESC$C,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != '0'  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != '0'  " &
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
"          LN_COM100_WMS.T$NAMA,  " &
"          LN_DEPTO.t$dsca,  " &
"          LN_SETOR.t$dsca$c  " &
"UNION "&
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
"              THEN LN_COM100_WMS.T$NAMA  " &
"            ELSE   TO_CHAR(STORER.COMPANY)  " &
"        END  " &
"    END                                 FORNECEDOR,  " &
"   ll.sku                               ITEM,  " &
"   sku.DESCR                            DECR_ITEM,  " &
"   LN_ITM.T$MDFB$C                      SKU_NOVA,  " &
"   LN_ITM.T$SIZE$C                      COD_TAMANHO,  " &
"   ZNIBD005.T$DESC$C                    DSC_TAMANHO,  " &
"   ( select asku.altsku  " &
"       from WMWHSE10.altsku asku  " &
"      where asku.sku = ll.sku  " &
"        and rownum = 1 )                EAN,  " &
"   CASE WHEN sku.ACTIVE = '2'  " &
"          THEN 'Inativo'  " &
"        ELSE   'Ativo'  " &
"    END                                 SITUACAO_ITEM,  " &
"   CASE WHEN departSector.depart_name IS NULL  " &
"          THEN LN_DEPTO.t$dsca  " &
"        ELSE   TO_CHAR(departSector.depart_name)  " &
"   END                                  DEPTO,  " &
"   CASE WHEN departSector.sector_name IS NULL  " &
"          THEN LN_SETOR.t$dsca$c  " &
"        ELSE   TO_CHAR(departSector.sector_name)  " &
"   END                                  SETOR,  " &
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
"   CASE WHEN SKU.BOMITEMTYPE = '0'  " &
"          THEN 'Não'  " &
"        WHEN (SKU.BOMITEMTYPE = '1' OR SKU.BOMITEMTYPE = '2')  " &
"          THEN 'KIT'  " &
"        ELSE   'TIK'  " &
"    END                                 TIK_KIT,  " &
"   CASE WHEN SKU.BOMITEMTYPE != '0'  " &
"          THEN NVL(BOM.SKU, SKU.SKU)  " &
"        ELSE   NULL  " &
"    END                                 AGRUPADOR,  " &
"   LN_FAM.T$FAMI$C                      ID_FAMILIA,  " &
"   CASE WHEN SKU.BOMITEMTYPE != '0'  " &
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
" FROM       WMWHSE10.lotxloc ll  " &
" INNER JOIN WMWHSE10.lotxlocxid llid  " &
"         ON llid.sku = ll.sku  " &
"        AND llid.loc = ll.loc  " &
"        AND llid.lot = ll.lot  " &
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
"                from baandb.twhwmd217602@PLN01 whwmd217  " &
"           left join baandb.twhinr140602@PLN01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN_02  " &
"         ON maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN_02.item = llid.sku  " &
" INNER JOIN WMWHSE10.sku  " &
"         ON sku.SKU = ll.SKU  " &
"  LEFT JOIN WMWHSE10.STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
" INNER JOIN WMWHSE10.loc  " &
"         ON loc.loc = ll.loc  " &
"  LEFT JOIN WMWHSE10.PUTAWAYZONE pz  " &
"         ON pz.PUTAWAYZONE = loc.PUTAWAYZONE  " &
"  LEFT JOIN enterprise.departsectorsku departSector  " &
"         ON TO_CHAR(departSector.id_depart) = sku.skugroup  " &
"        AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2  " &
"  LEFT JOIN WMWHSE10.BILLOFMATERIAL BOM  " &
"         ON BOM.COMPONENTSKU = SKU.SKU  " &
"  LEFT JOIN WMWHSE10.SKU SKP  " &
"         ON SKP.SKU = BOM.SKU  " &
"  LEFT JOIN BAANDB.TTCIBD001602@PLN01 LN_ITM  " &
"         ON TRIM(LN_ITM.T$ITEM) = CASE WHEN SKU.BOMITEMTYPE != '4'  " &
"                                         THEN SKU.SKU  " &
"                                       ELSE BOM.SKU  " &
"                                   END  " &
"  LEFT JOIN BAANDB.TZNMCS031602@PLN01 LN_FAM  " &
"         ON LN_FAM.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_FAM.T$SETO$C = LN_ITM.T$SETO$C  " &
"        AND LN_FAM.T$FAMI$C = LN_ITM.T$FAMI$C  " &
"  LEFT JOIN BAANDB.TTDIPU001602@PLN01 LN_IPU001  " &
"         ON TRIM(LN_IPU001.T$ITEM) = TRIM(SKU.SKU)  " &
"  LEFT JOIN BAANDB.ttccom100602@PLN01 LN_COM100  " &
"         ON LN_COM100.T$BPID = LN_IPU001.T$OTBP  " &
"  LEFT JOIN BAANDB.ttccom100602@PLN01 LN_COM100_WMS  " &
"         ON LN_COM100_WMS.T$BPID = sku.SUSR5  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO  " &
"                from WMWHSE10.codelkup clkp  " &
"           left join WMWHSE10.translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'EANTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_ITEM  " &
"         ON TIPO_ITEM.COD_TIPO = SKU.BOMITEMTYPE  " &
"  LEFT JOIN BAANDB.TTCMCS023602@PLN01 LN_DEPTO  " &
"         ON LN_DEPTO.T$CITG = LN_ITM.T$CITG  " &
"  LEFT JOIN BAANDB.TZNMCS030602@PLN01 LN_SETOR  " &
"         ON LN_SETOR.T$CITG$C = LN_ITM.T$CITG  " &
"        AND LN_SETOR.T$SETO$C = LN_ITM.T$SETO$C  " &
"  LEFT JOIN BAANDB.TZNIBD005" + IIF(Parameters!Compania.Value = "WMWHSE10","602", "601") + "@PLN01 ZNIBD005  " &
"         ON ZNIBD005.T$SIZE$C = LN_ITM.T$SIZE$C  " &
"WHERE NVL(NVL(departSector.id_depart, LN_DEPTO.T$CITG), 0) IN (" + Replace(("'" + JOIN(Parameters!Depto.Value, "',") + "'"),",",",'") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " ) " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) ) " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"          cl.DESCRIPTION,  " &
"          STORER.COMPANY,  " &
"          ll.sku,  " &
"          LN_ITM.T$MDFB$C,  " &
"          LN_ITM.T$SIZE$C,  " &
"          ZNIBD005.T$DESC$C,  " &
"          sku.DESCR,  " &
"          sku.ACTIVE,  " &
"          sku.SUSR5,  " &
"          pz.DESCR,  " &
"          ll.loc,  " &
"          ll.holdreason,  " &
"          departSector.depart_name,  " &
"          departSector.sector_name,  " &
"          SKU.BOMITEMTYPE,  " &
"          CASE WHEN SKU.BOMITEMTYPE != '0'  " &
"                 THEN NVL(BOM.SKU, SKU.SKU)  " &
"               ELSE NULL END,  " &
"          CASE WHEN SKU.BOMITEMTYPE != '0'  " &
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
"          LN_COM100_WMS.T$NAMA,  " &
"          LN_DEPTO.t$dsca,  " &
"          LN_SETOR.t$dsca$c  " &
"ORDER BY ARMAZEM, COD_FORN, ITEM  "

)
