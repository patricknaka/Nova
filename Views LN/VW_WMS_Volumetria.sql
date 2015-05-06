select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE1.lotxloc ll,
WMWHSE1.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE1.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE1.loc
LEFT JOIN WMWHSE1.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE2.lotxloc ll,
WMWHSE2.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE2.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE2.loc
LEFT JOIN WMWHSE2.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE3.lotxloc ll,
WMWHSE3.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE3.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE3.loc
LEFT JOIN WMWHSE3.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE4.lotxloc ll,
WMWHSE4.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE4.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE4.loc
LEFT JOIN WMWHSE4.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE5.lotxloc ll,
WMWHSE5.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE5.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE5.loc
LEFT JOIN WMWHSE5.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE6.lotxloc ll,
WMWHSE6.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE6.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE6.loc
LEFT JOIN WMWHSE6.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE7.lotxloc ll,
WMWHSE7.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE7.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE7.loc
LEFT JOIN WMWHSE7.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE8.lotxloc ll,
WMWHSE8.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE8.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE8.loc
LEFT JOIN WMWHSE8.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE
--******************************************************************************************
UNION
select 
ll.sku CD_SKU,
ll.sku CD_ITEM,
CASE WHEN TO_CHAR(ll.holdreason)=' ' THEN 'WN' ELSE TO_CHAR(ll.holdreason) END CD_BLOQUEIO,
pz.PUTAWAYZONE CD_CLASSE_LOCAL,
ll.loc CD_LOCAL,
subStr(cl.DESCRIPTION,3,6) CD_ARMAZEM,
sum(llid.qty) QT_PC,
sum(llid.netwgt) QT_PESO,
sum(sku.STDCUBE*llid.qty) QT_M3,
llid.WHSEID CD_ARMAZEM_WMS
from 
WMWHSE9.lotxloc ll,
WMWHSE9.lotxlocxid llid
left join (select whseid, sku, sum(STDCUBE) stdcube from WMWHSE9.sku group by whseid, sku) sku
on sku.whseid = llid.WHSEID and sku.sku = llid.SKU,
WMWHSE9.loc
LEFT JOIN WMWHSE9.PUTAWAYZONE pz on pz.PUTAWAYZONE=loc.PUTAWAYZONE,
ENTERPRISE.CODELKUP cl
where ll.sku = llid.sku and ll.loc = llid.loc and ll.lot = llid.lot
AND ll.loc=loc.loc
AND cl.LISTNAME = 'SCHEMA'
AND UPPER(cl.UDF1)=llid.WHSEID
group by
ll.sku,
ll.holdreason,
ll.loc,
pz.PUTAWAYZONE, 
cl.DESCRIPTION,
llid.WHSEID,
sku.STDCUBE