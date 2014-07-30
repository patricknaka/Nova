SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE1.lotxloc ll,
 WMWHSE1.lotxlocxid llid,
 WMWHSE1.sku,
 WMWHSE1.loc
 LEFT JOIN WMWHSE1.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE2.lotxloc ll,
 WMWHSE2.lotxlocxid llid,
 WMWHSE2.sku,
 WMWHSE2.loc
 LEFT JOIN WMWHSE2.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE3.lotxloc ll,
 WMWHSE3.lotxlocxid llid,
 WMWHSE3.sku,
 WMWHSE3.loc
 LEFT JOIN WMWHSE3.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE4.lotxloc ll,
 WMWHSE4.lotxlocxid llid,
 WMWHSE4.sku,
 WMWHSE4.loc
 LEFT JOIN WMWHSE4.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE5.lotxloc ll,
 WMWHSE5.lotxlocxid llid,
 WMWHSE5.sku,
 WMWHSE5.loc
 LEFT JOIN WMWHSE5.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE6.lotxloc ll,
 WMWHSE6.lotxlocxid llid,
 WMWHSE6.sku,
 WMWHSE6.loc
 LEFT JOIN WMWHSE6.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE7.lotxloc ll,
 WMWHSE7.lotxlocxid llid,
 WMWHSE7.sku,
 WMWHSE7.loc
 LEFT JOIN WMWHSE7.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE8.lotxloc ll,
 WMWHSE8.lotxlocxid llid,
 WMWHSE8.sku,
 WMWHSE8.loc
 LEFT JOIN WMWHSE8.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION
--******************************************************************************************
UNION
SELECT
 ll.sku CD_SKU,
 ll.sku CD_ITEM,
 pz.PUTAWAYZONE CD_CLASSE_LOCAL,
-- pz.DESCR CLAL,
 ll.loc CD_LOCAL,
 subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
 sum(llid.qty) QT_PC,
 sum(llid.netwgt) QT_PESO,
 sum(sku.STDCUBE*ll.qty) QT_M3
FROM WMWHSE9.lotxloc ll,
 WMWHSE9.lotxlocxid llid,
 WMWHSE9.sku,
 WMWHSE9.loc
 LEFT JOIN WMWHSE9.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
 ENTERPRISE.CODELKUP cl
WHERE llid.sku=ll.sku
AND llid.loc=ll.loc
AND sku.SKU=ll.SKU
AND llid.WHSEID=sku.WHSEID
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.LONG_VALUE)=llid.WHSEID
GROUP BY
 ll.sku,
 ll.sku,
 pz.PUTAWAYZONE,
 ll.loc,
 cl.DESCRIPTION