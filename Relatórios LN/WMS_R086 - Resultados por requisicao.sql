SELECT 
       Q1.ITEM_WMS,
       Q1.NOME_ITEM,
       NVL(Q1.WARR, 'OK') ID_WARR,
       NVL(IH.DESCRIPTION,'OK') DESC_WARR,
       sum(Q1.QT_LOGICA) QT_LOGICA,
       sum(Q1.QT_FISICA) QT_FISICA,
       sum(Q1.VAR_QTDE) VAR_QTDE,
       Q1.SIMULACAO,  
       Q1.ID_PLANTA,
       Q1.NOME_PLANTA
       
FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,
              CD.LOC                    ID_LOCAL,
              CD.SKU                    ITEM_WMS,
              SK.DESCR                  NOME_ITEM,   
              CD.SYSQTY                 QT_LOGICA,
              CD.SYSQTY+CD.ADJQTY       QT_FISICA,
              CD.ADJQTY                 VAR_QTDE,
              ' '                       SIMULACAO,          -- PENDENTE DE CUSTOMIZAÇÃO
              CC.WHSEID                 ID_PLANTA,
              CL.UDF2                   NOME_PLANTA,
              T.STATUS                  WARR
         from WMWHSE5.CC   CC
   inner join WMWHSE5.CCDETAIL CD 
           on CD.CCKEY  = CC.CCKEY
   inner join ENTERPRISE.CODELKUP CL
           on UPPER(CL.UDF1)  =  CC.WHSEID
          and CL.LISTNAME  =  'SCHEMA'  
   inner join WMWHSE5.SKU   SK 
           on SK.SKU   = CD.SKU
  LEFT OUTER JOIN (SELECT LOC,status FROM INVENTORYHOLD where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC
        where CC.STATUS < 9
  
        UNION

       SELECT ' '                       ID_INVENTARIO,
              CD.LOC                    ID_LOCAL,
              CD.SKU                    ITEM_WMS,
              SK.DESCR                  NOME_ITEM,   
              nvl(LL.QTY,0)             QT_LOGICA,
              CD.QTY                    QT_FISICA,
              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,
              ' '                       SIMULACAO,          --PENDENTE DE CUSTOMIZAÇÃO
              CD.WHSEID                 ID_PLANTA,
              CL.UDF2                   NOME_PLANTA,
              T.STATUS                  WARR
         FROM WMWHSE5.PHYSICAL CD
   INNER JOIN ENTERPRISE.CODELKUP CL
           ON UPPER(CL.UDF1)  =  CD.WHSEID
          AND CL.LISTNAME  =  'SCHEMA'  
   INNER JOIN WMWHSE5.SKU   SK 
           ON SK.SKU   = CD.SKU
    LEFT JOIN WMWHSE5.LOTXLOCXID LL 
           ON LL.LOT = CD.LOT
          AND LL.LOC = CD.LOC
          AND LL.ID = CD.ID
          AND LL.SKU = CD.SKU
    LEFT OUTER JOIN (SELECT LOC,status FROM INVENTORYHOLD where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC
          WHERE CD.STATUS=9
          ) Q1
    LEFT JOIN INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE
     GROUP BY 
              Q1.ITEM_WMS,
              Q1.NOME_ITEM, 
              NVL(Q1.WARR, 'OK'),
              NVL(IH.DESCRIPTION,'OK'),
              Q1.SIMULACAO,  
              Q1.ID_PLANTA,
              Q1.NOME_PLANTA 