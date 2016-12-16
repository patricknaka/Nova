select  
        cl.UDF2                               PLANTA,
        LN_COM100.T$NAMA                      FORNECEDOR,
        ll.sku                                ITEM,
        tcibd001.t$cean                       EAN,
        sku.DESCR                             DECR_ITEM,
        LN_DEPTO.t$dsca                       DEPTO,
        LN_SETOR.t$dsca$c                     SETOR,
        pz.PUTAWAYZONE                        ZONA,
        ll.loc                                LOCA,
        case when ih.status in null   
              then 'OK'   
            else TO_CHAR(ih.status) 
        end                                   RESTRICAO,
        llid.tot_qty                          QTD_EST,
        nvl(maucLN_02.mauc,0) * llid.tot_qty  VALOR,
        sku.STDCUBE * llid.tot_qty            M3
    
from  baandb.ttcibd001301 tcibd001

inner join WMWHSE5.lotxloc@DL_LN_WMS ll
        on TRIM(ll.sku) = TRIM(tcibd001.t$item) 
  
inner join ( select a.sku,
                    a.loc,
                    a.lot,
                    a.WHSEID,
                    sum(a.qty) tot_qty
             from WMWHSE5.lotxlocxid@DL_LN_WMS a 
             group by a.sku,
                      a.loc,
                      a.lot,
                      a.WHSEID ) llid 
        on llid.sku = ll.sku 
       and llid.loc = ll.loc
       and llid.lot = ll.lot
     
inner join WMSADMIN.PL_DB@DL_LN_WMS WMSADMIN_PL_DB
        on UPPER(WMSADMIN_PL_DB.DB_LOGID) = llid.WHSEID 

inner join ENTERPRISE.CODELKUP@DL_LN_WMS cl 
        on UPPER(cl.UDF1) = llid.WHSEID
       and cl.LISTNAME = 'SCHEMA'
     
left join ( select trim(whwmd217.t$item) item,                             
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
        on maucLN_02.cwar = subStr(CL.DESCRIPTION,3,6)                         
       and maucLN_02.item = llid.sku

inner join WMWHSE5.sku@DL_LN_WMS sku 
        on sku.SKU = ll.SKU
    
inner join WMWHSE5.loc@DL_LN_WMS loc
        ON loc.loc = ll.loc
    
left join WMWHSE5.PUTAWAYZONE@DL_LN_WMS pz 
       on pz.PUTAWAYZONE = loc.PUTAWAYZONE

left join ( select  loc, 
                    status 
               from WMWHSE5.INVENTORYHOLD@DL_LN_WMS 
              where hold = 1 
                and loc <> ' ') ih
      on ih.loc = llid.loc

left join BAANDB.TTDIPU001301 LN_IPU001
       on LN_IPU001.T$ITEM = TCIBD001.T$ITEM

left join BAANDB.ttccom100301 LN_COM100
       on LN_COM100.T$BPID = LN_IPU001.T$OTBP

left join BAANDB.TTCMCS023301  LN_DEPTO
       on LN_DEPTO.T$CITG = TCIBD001.T$CITG
         
left join BAANDB.TZNMCS030301  LN_SETOR
       on LN_SETOR.T$CITG$C = TCIBD001.T$CITG
      and LN_SETOR.T$SETO$C = TCIBD001.T$SETO$C

where
        tcibd001.t$kitm = 1   -- Comprado
and     cl.UDF2 in :PLANTA
and     ih.status in :RESTRICAO
