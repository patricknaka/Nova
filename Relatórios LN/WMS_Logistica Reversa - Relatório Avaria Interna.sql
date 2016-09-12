SELECT ITRN.ITRNKEY                   ID_MOVIMENTO,  --ITRN.TRANTYPE,
       ITRN.ADDDATE                   DT_MOVIMENTO,
       ITRN.WHSEID                    FILIAL,
       ITRN.SKU                       ITEM,
       ( SELECT asku.altsku    
           FROM WMWHSE5.altsku asku   
          WHERE asku.sku = ITRN.sku   
            AND ROWNUM = 1 )          EAN,
       SKU.DESCR                      DESCR_SKU,
       STORER.COMPANY                 FORNECEDOR,
       DEPARTSECTORSKU.DEPART_NAME    DEPARTAMENTO,
       NVL(maucLN.mauc, 0) * 
       ITRN.QTY                       CMV_TOTAL,
       ITRN.QTY                       QTD,
       CASE WHEN NVL(FHLD.STATUS, 'WN') = 'WN'  
              THEN 'ENTRADA'  
            ELSE 'SAIDA' 
        END                           SENTIDO,
       ITRN.ADDWHO                    USUARIO,
  
       NVL(FHLD.STATUS, 'WN')         NOME_DEPOSITO,     -- RESTRICAO_FROM,   
       NVL(FIHC.DESCRIPTION, 
           'Deposito WN')             TIPO_DEPOSITO,
       
       ITRN.ITRNKEY                   ID_MOVIMENTO_PARA, -- SERÁ O MESMO QUE O ID DO MOVIMENTO POIS NÃO EXISTE NO WMS INFOR
       TLOC.WHSEID                    FILIAL_PARA,
       NVL(TIHC.DESCRIPTION, 
           'Deposito WN')             DEPOSITO_PAR,
       ITRN.FROMLOC                   LOCAL_INICIAL,
       ITRN.TOLOC                     LOCAL_FINAL
  
FROM       WMWHSE5.ITRN    ITRN

INNER JOIN WMWHSE5.SKU     SKU
        ON SKU.SKU  = ITRN.SKU
    
INNER JOIN WMWHSE5.LOC     TLOC
        ON TLOC.LOC = ITRN.TOLOC
  
 LEFT JOIN ( select A.LOC,
                    A.status 
               from WMWHSE5.INVENTORYHOLD A 
              where hold = 1 
                and loc <> ' ' )     FHLD
        ON FHLD.LOC = ITRN.FROMLOC
    
 LEFT JOIN WMWHSE5.INVENTORYHOLDCODE FIHC
        ON FIHC.CODE = FHLD.STATUS
    
 LEFT JOIN ( select A.LOC,
                    A.status 
               from WMWHSE5.INVENTORYHOLD A 
              where hold = 1 
                and loc <> ' ' )     THLD
    ON THLD.LOC = ITRN.TOLOC

 LEFT JOIN WMWHSE5.INVENTORYHOLDCODE TIHC
        ON TIHC.CODE = THLD.STATUS

 LEFT JOIN WMWHSE5.STORER     STORER
        ON STORER.STORERKEY = sku.SUSR5 
       AND STORER.WHSEID = sku.WHSEID 
       AND STORER.TYPE = 5
    
 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU
        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)

 LEFT JOIN ENTERPRISE.BILLOFMATERIAL BOM
        ON BOM.COMPONENTSKU = ITRN.SKU
    
 LEFT JOIN ENTERPRISE.CODELKUP     cl 
        ON UPPER(cl.UDF1) = ITRN.WHSEID
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
                    whwmd217.t$cwar )  maucLN                                
        ON  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
       AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4)
                                THEN NVL(BOM.SKU, ITRN.SKU)
                              ELSE ITRN.sku 
                         END
    
WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')
  AND NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')
  AND ITRN.TRANTYPE = 'MV'
  AND NVL(FHLD.STATUS, 'WN') != NVL(THLD.STATUS, 'WN')
  
  AND NVL(FHLD.STATUS, 'WN') IN (:RestricaoDe)
  AND NVL(THLD.STATUS, 'WN') IN (:RestricaoAte)


=

"SELECT ITRN.ITRNKEY                   ID_MOVIMENTO,  " &
"       ITRN.ADDDATE                   DT_MOVIMENTO,  " &
"       ITRN.WHSEID                    FILIAL,  " &
"       FilialA.UDF2              	   NOME_FILIAL,  " &
"       ITRN.SKU                       ITEM,  " &
"       ( SELECT asku.altsku  " &
"           FROM " + Parameters!Table.Value + ".altsku asku  " &
"          WHERE asku.sku = ITRN.sku  " &
"            AND ROWNUM = 1 )          EAN,  " &
"       SKU.DESCR                      DESCR_SKU,  " &
"       STORER.COMPANY                 FORNECEDOR,  " &
"       DEPARTSECTORSKU.DEPART_NAME    DEPARTAMENTO,  " &
"       NVL(maucLN.mauc, 0) *  " &
"       ITRN.QTY                       CMV_TOTAL,  " &
"       ITRN.QTY                       QTD,  " &
"       CASE WHEN NVL(FHLD.STATUS, 'WN') = 'WN'  " &
"              THEN 'ENTRADA'  " &
"            ELSE 'SAIDA'  " &
"        END                           SENTIDO,  " &
"       ITRN.ADDWHO                    USUARIO,  " &
"       NVL(FHLD.STATUS, 'WN')         NOME_DEPOSITO,  " &
"       NVL(FIHC.DESCRIPTION,  " &
"           'Deposito WN')             TIPO_DEPOSITO,  " &
"       ITRN.ITRNKEY                   ID_MOVIMENTO_PARA,  " &
"       TLOC.WHSEID                    FILIAL_PARA,  " &
"       FilialB.UDF2              	   NOME_FILIAL_PARA,  " &
"       NVL(TIHC.DESCRIPTION,  " &
"           'Deposito WN')             DEPOSITO_PAR,  " &
"       ITRN.FROMLOC                   LOCAL_INICIAL,  " &
"       ITRN.TOLOC                     LOCAL_FINAL  " &
"FROM       " + Parameters!Table.Value + ".ITRN  ITRN  " &
"INNER JOIN " + Parameters!Table.Value + ".SKU  SKU  " &
"        ON SKU.SKU  = ITRN.SKU  " &
"INNER JOIN " + Parameters!Table.Value + ".LOC     TLOC  " &
"        ON TLOC.LOC = ITRN.TOLOC  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"              UPPER(A.UDF1) UDF1,  " &
"              A.UDF2  " &
"         from ENTERPRISE.CODELKUP A  " &
"        where A.LISTNAME = 'SCHEMA') FilialA  " &
"     ON FilialA.UDF1 = ITRN.WHSEID  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"              UPPER(A.UDF1) UDF1,  " &
"              A.UDF2  " &
"         from ENTERPRISE.CODELKUP A  " &
"        where A.LISTNAME = 'SCHEMA') FilialB  " &
"     ON FilialB.UDF1 = TLOC.WHSEID  " &
" LEFT JOIN ( select A.LOC,  " &
"                    A.status  " &
"               from " + Parameters!Table.Value + ".INVENTORYHOLD A  " &
"              where hold = 1  " &
"                and loc <> ' ' )  FHLD  " &
"        ON FHLD.LOC = ITRN.FROMLOC  " &
" LEFT JOIN " + Parameters!Table.Value + ".INVENTORYHOLDCODE  FIHC  " &
"        ON FIHC.CODE = FHLD.STATUS  " &
" LEFT JOIN ( select A.LOC,  " &
"                    A.status  " &
"               from " + Parameters!Table.Value + ".INVENTORYHOLD A  " &
"              where hold = 1  " &
"                and loc <> ' ' )  THLD  " &
"    ON THLD.LOC = ITRN.TOLOC  " &
" LEFT JOIN " + Parameters!Table.Value + ".INVENTORYHOLDCODE  TIHC  " &
"        ON TIHC.CODE = THLD.STATUS  " &
" LEFT JOIN " + Parameters!Table.Value + ".STORER  STORER  " &
"        ON STORER.STORERKEY = sku.SUSR5  " &
"       AND STORER.WHSEID = sku.WHSEID  " &
"       AND STORER.TYPE = 5  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ENTERPRISE.BILLOFMATERIAL  BOM  " &
"        ON BOM.COMPONENTSKU = ITRN.SKU  " &
" LEFT JOIN ENTERPRISE.CODELKUP  cl  " &
"        ON UPPER(cl.UDF1) = ITRN.WHSEID  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &          
"                           then sum(whwmd217.t$ftpa$1)  " &                  
"                         else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc  " &
"               from baandb.twhwmd217301@pln01 whwmd217  " &
"          left join baandb.twhinr140301@pln01 a  " &
"                 on a.t$cwar = whwmd217.t$cwar  " &
"                and a.t$item = whwmd217.t$item  " &
"           group by whwmd217.t$item,  " &
"                    whwmd217.t$cwar )  maucLN  " &
"        ON  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"       AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4)  " &
"                                THEN NVL(BOM.SKU, ITRN.SKU)  " &
"                              ELSE ITRN.sku  " &
"                         END  " &
"WHERE ITRN.TRANTYPE = 'MV'  " &
"  AND NVL(FHLD.STATUS, 'WN') != NVL(THLD.STATUS, 'WN')  " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  "&
"      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  "&
"      BETWEEN '"+ Parameters!DataDe.Value + "'  "&
"          AND '"+ Parameters!DataAte.Value + "'  "&
"  AND NVL(FHLD.STATUS, 'WN') IN (" + Replace(("'" + JOIN(Parameters!RestricaoDe.Value, "',") + "'"),",",",'") + ") " &
"  AND NVL(THLD.STATUS, 'WN') IN (" + Replace(("'" + JOIN(Parameters!RestricaoPara.Value, "',") + "'"),",",",'") + ") " &
"ORDER BY FILIAL, DT_MOVIMENTO, ITEM  "
