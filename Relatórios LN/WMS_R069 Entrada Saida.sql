SELECT
  Q1.WHSEID ID_FILIAL,
  CL.UDF2 NOME_FILIAL,
  Q1.DATA,
  Q1.ID_DEPTO,
  Q1.DEPA_NOME,
  SUM(CASE WHEN Q1.TIPO='REC' THEN Q1.QTD ELSE 0 END) QTD_REC,
  SUM(CASE WHEN Q1.TIPO='REC' THEN Q1.M3 ELSE 0 END) M3_REC,
  SUM(CASE WHEN Q1.TIPO='SHIP' THEN Q1.QTD ELSE 0 END) QTD_EXPE,
  SUM(CASE WHEN Q1.TIPO='SHIP' THEN Q1.M3 ELSE 0 END) M3_EXPE,
  SUM(CASE WHEN Q1.TIPO='REC' THEN Q1.QTD*NVL(maucLN.mauc,0) ELSE 0 END) VALOR_REC,
  SUM(CASE WHEN Q1.TIPO='SHIP' THEN Q1.QTD*NVL(maucLN.mauc,0) ELSE 0 END) VALOR_REC
FROM
(SELECT RD.WHSEID,
        TRUNC(RD.DATERECEIVED, 'DD')        DATA,
        SK.SKUGROUP                         ID_DEPTO,
        DEPART.DEPART_NAME                  DEPA_NOME,
        RD.QTYRECEIVED                      QTD,
        RD.QTYRECEIVED * SK.STDCUBE         M3,
        RD.SKU,
        'REC'                               TIPO
FROM
      WMWHSE5.RECEIPTDETAIL RD
INNER JOIN WMWHSE5.SKU SK ON  SK.SKU=RD.SKU
LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART 
        ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SK.SKUGROUP)  
       AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SK.SKUGROUP2)  
       
UNION
SELECT  OD.WHSEID,
        TRUNC(OC.ACTUALSHIPDATE, 'DD')    DATA,
        SK.SKUGROUP                       ID_DEPTO,
        DEPART.DEPART_NAME                DEPA_NOME,
        OD.SHIPPEDQTY                QTD,
        OD.SHIPPEDQTY * SK.STDCUBE   M3,
        OD.SKU,
        'SHIP'                            TIPO
FROM
      WMWHSE5.ORDERDETAIL OD
INNER JOIN WMWHSE5.ORDERS OC ON  OC.ORDERKEY=OD.ORDERKEY
INNER JOIN WMWHSE5.SKU SK ON  SK.SKU=OD.SKU
LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART 
        ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SK.SKUGROUP)  
       AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SK.SKUGROUP2) 
WHERE OC.STATUS=95) Q1
LEFT JOIN ENTERPRISE.CODELKUP CL ON UPPER(CL.UDF1) = Q1.WHSEID
                                 AND CL.LISTNAME = 'SCHEMA'
LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(a.t$qhnd) = 0                             
                     then 0                                                 
                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)    
                    end mauc                                                
               from baandb.twhwmd217301@pln01 whwmd217                      
         inner join baandb.twhinr140301@pln01 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
              where whwmd217.t$mauc$1 != 0                                  
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) maucLN                                 
        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
        AND maucLN.item = Q1.SKU
GROUP BY
  Q1.WHSEID,
  CL.UDF2,
  Q1.DATA,
  Q1.ID_DEPTO,
  Q1.DEPA_NOME