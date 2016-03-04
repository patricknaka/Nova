SELECT DISTINCT
--CODELKUP.CODE,
--CODELKUP.LISTNAME,
--RECEIPTDETAIL.RECEIPTKEY,
--RECEIPTDETAIL.RECEIPTLINENUMBER,

       ENT.UDF2                   ID_PLANTA,                               
       RECEIPTDETAIL.RECEIPTKEY   ID_RECDOC,                               
       RECEIPTDETAIL.TOID         ID_OM,                                   
       RECEIPT.SUPPLIERCODE       ID_FORNEC_ITEM,                          
       RECEIPT.SUPPLIERNAME       DESC_FORNEC_ITEM,                        
       RECEIPTDETAIL.SKU          ID_ITEM,                                 
       SKU.DESCR                  DESC_ITEM,                               
       SKU.SKUGROUP               ID_DEPTO,                                
       DEPART.DEPART_NAME         DEPTO_NOME,                              
       SKU.SKUGROUP2              ID_SETOR,                                
       DEPART.SECTOR_NAME         SETOR_NOME,                              
       CODELKUP.description       TIPO_ITEM,                               
       TASKDETAIL.TOLOC           LOCAL,                                   
       LOC.LOGICALLOCATION        DESCRICAO,                               
       RECEIPTDETAIL.QTYRECEIVED  QT_REC,                                  
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      
           AT time zone 'America/Sao_Paulo') AS DATE)                          
                                  DT_ENT_RT,                               
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,              
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      
           AT time zone 'America/Sao_Paulo') AS DATE)                          
                                  DT_SAID_RT                               
                                                                          
FROM       WMWHSE4.TASKDETAIL                                              
                                                                           
INNER JOIN WMWHSE4.RECEIPTDETAIL                                           
        ON RECEIPTDETAIL.RECEIPTKEY ||                                     
           RECEIPTDETAIL.RECEIPTLINENUMBER = TASKDETAIL.SOURCEKEY          
                                                                       
INNER JOIN WMWHSE4.RECEIPT                                                 
        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                   
                                                                       
INNER JOIN WMWHSE4.SKU                                                     
        ON SKU.SKU = RECEIPTDETAIL.SKU                                     
                                                                           
 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART                              
        ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)               
       AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)              
                                                                          
INNER JOIN WMWHSE4.LOC                                                     
        ON LOC.LOC = TASKDETAIL.TOLOC                                      
                                                                       
 LEFT JOIN ENTERPRISE.CODELKUP ENT                                         
        ON UPPER(ENT.UDF1) = UPPER(RECEIPT.WHSEID)                         
                                                                           
 LEFT JOIN WMWHSE4.CODELKUP                                                
        ON CODELKUP.CODE = SKU.BOMITEMTYPE
       AND CODELKUP.LISTNAME = 'EANTYPE'
       AND (CODELKUP.CODE = 1 OR CODELKUP.CODE = 4)   -- 1 - KIT PRIMARY EAN, 4 - TIK Component EAN
                                                                          
WHERE TASKDETAIL.STATUS = 9 
  AND TASKDETAIL.TASKTYPE = 'PA'
  AND ENT.LISTNAME = 'SCHEMA'
  
--AND RECEIPTDETAIL.RECEIPTKEY = '0000005685'
--AND RECEIPTDETAIL.RECEIPTKEY = '0000005698'
--AND RECEIPTDETAIL.RECEIPTKEY = '0000005700'

  
--ORDER BY
--          CODELKUP.CODE,
--          CODELKUP.LISTNAME,
--          RECEIPTDETAIL.RECEIPTKEY,
--          RECEIPTDETAIL.RECEIPTLINENUMBER
