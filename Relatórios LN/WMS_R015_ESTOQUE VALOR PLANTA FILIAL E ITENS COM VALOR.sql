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
         THEN 'INATIVO'
       ELSE 'ATIVO' 
   END                                 SITUACAO_ITEM,
   
  departSector.depart_name             DEPTO,
  departSector.sector_name             SETOR, 
  Trim(pz.DESCR)                       CLAL,
  ll.loc                               LOCA,
  nvl(max(maucLN.mauc),0)              PRECO,

  CASE WHEN TO_CHAR(ll.holdreason)=' ' 
  THEN 'OK'
  ELSE  TO_CHAR(ll.holdreason) END     WARR,
  
  sum(llid.qty)                        QTD_EST,
  nvl(max(maucLN.mauc),0)*
      sum(llid.qty)                    VALOR,
  sum(llid.netwgt)                     PESO,
  sum(sku.STDCUBE*ll.qty)              M3
    
FROM       WMWHSE5.lotxloc ll

INNER JOIN WMWHSE5.lotxlocxid llid 
        ON llid.sku = ll.sku 
       AND llid.loc = ll.loc
     
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID 

INNER JOIN ENTERPRISE.CODELKUP cl 
        ON UPPER(cl.UDF1) = llid.WHSEID
       AND cl.LISTNAME = 'SCHEMA'
     
 LEFT JOIN ( select trim(whina113.t$item) item,
                    whina113.t$cwar cwar,
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
         departSector.sector_name
		 
"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from " + Parameters!Table.Value + ".altsku asku     " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       " + Parameters!Table.Value + ".lotxloc ll      " &
"                                                          " &
"INNER JOIN " + Parameters!Table.Value + ".lotxlocxid llid " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &                               
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN " + Parameters!Table.Value + ".sku                 " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN " + Parameters!Table.Value + ".STORER              " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN " + Parameters!Table.Value + ".loc                 " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN " + Parameters!Table.Value + ".PUTAWAYZONE pz      " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  "

-- Query com UNION ***************************************************************************************************

"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from WMWHSE1.altsku asku                            " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       WMWHSE1.lotxloc ll                             " &
"                                                          " &
"INNER JOIN WMWHSE1.lotxlocxid llid                        " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN WMWHSE1.sku                                        " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN WMWHSE1.STORER                                     " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN WMWHSE1.loc                                        " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN WMWHSE1.PUTAWAYZONE pz                             " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  " &
"                                   " &
"Union                              " &
"                                   " &
"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from WMWHSE2.altsku asku                            " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       WMWHSE2.lotxloc ll                             " &
"                                                          " &
"INNER JOIN WMWHSE2.lotxlocxid llid                        " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN WMWHSE2.sku                                        " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN WMWHSE2.STORER                                     " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN WMWHSE2.loc                                        " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN WMWHSE2.PUTAWAYZONE pz                             " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  " &
"                                   " &
"Union                              " &
"                                   " &
"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from WMWHSE3.altsku asku                            " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       WMWHSE3.lotxloc ll                             " &
"                                                          " &
"INNER JOIN WMWHSE3.lotxlocxid llid                        " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN WMWHSE3.sku                                        " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN WMWHSE3.STORER                                     " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN WMWHSE3.loc                                        " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN WMWHSE3.PUTAWAYZONE pz                             " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  " &
"                                   " &
"Union                              " &
"                                   " &
"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from WMWHSE4.altsku asku                            " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       WMWHSE4.lotxloc ll                             " &
"                                                          " &
"INNER JOIN WMWHSE4.lotxlocxid llid                        " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN WMWHSE4.sku                                        " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN WMWHSE4.STORER                                     " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN WMWHSE4.loc                                        " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN WMWHSE4.PUTAWAYZONE pz                             " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  " &
"                                   " &
"Union                              " &
"                                   " &
"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from WMWHSE5.altsku asku                            " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       WMWHSE5.lotxloc ll                             " &
"                                                          " &
"INNER JOIN WMWHSE5.lotxlocxid llid                        " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN WMWHSE5.sku                                        " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN WMWHSE5.STORER                                     " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN WMWHSE5.loc                                        " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN WMWHSE5.PUTAWAYZONE pz                             " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  " &
"                                   " &
"Union                              " &
"                                   " &
"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from WMWHSE6.altsku asku                            " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       WMWHSE6.lotxloc ll                             " &
"                                                          " &
"INNER JOIN WMWHSE6.lotxlocxid llid                        " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN WMWHSE6.sku                                        " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN WMWHSE6.STORER                                     " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN WMWHSE6.loc                                        " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN WMWHSE6.PUTAWAYZONE pz                             " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  " &
"                                   " &
"Union                              " &
"                                   " &
"SELECT                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,           " &
"  subStr(cl.DESCRIPTION,3,6) ||                           " &
"  ll.sku                               CHAVE,             " &
"  subStr(cl.DESCRIPTION,3,6)           ARMAZEM_LN,        " &
"  sku.SUSR5                            COD_FORN,          " &
"  STORER.COMPANY                       FORNECEDOR,        " &
"  ll.sku                               ITEM,              " &
"  sku.DESCR                            DECR_ITEM,         " &
"  ( select asku.altsku                                    " &
"      from WMWHSE7.altsku asku                            " &
"     where asku.sku = ll.sku                              " &
"       and rownum = 1 )                EAN,               " &
"                                                          " &
"  CASE WHEN sku.ACTIVE = '2'                              " &
"         THEN 'INATIVO'                                   " &
"       ELSE 'ATIVO'                                       " &
"   END                                 SITUACAO_ITEM,     " &
"                                                          " &
"  departSector.depart_name             DEPTO,             " &
"  departSector.sector_name             SETOR,             " &
"  Trim(pz.DESCR)                       CLAL,              " &
"  ll.loc                               LOCA,              " &
"  nvl(max(maucLN.mauc),0)              PRECO,             " &
"  ll.holdreason                        WARR,              " &
"  sum(llid.qty)                        QTD_EST,           " &
"  nvl(max(maucLN.mauc),0)*                                " &
"      sum(llid.qty)                    VALOR,             " &
"  sum(llid.netwgt)                     PESO,              " &
"  sum(sku.STDCUBE*ll.qty)              M3                 " &
"                                                          " &
"FROM       WMWHSE7.lotxloc ll                             " &
"                                                          " &
"INNER JOIN WMWHSE7.lotxlocxid llid                        " &
"        ON llid.sku = ll.sku                              " &
"       AND llid.loc = ll.loc                              " &
"                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                 " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID   " &
"                                                          " &
"INNER JOIN ENTERPRISE.CODELKUP cl                         " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                   " &
"       AND cl.LISTNAME = 'SCHEMA'                         " &
"                                                          " &
" LEFT JOIN ( select trim(whina113.t$item) item,           " &
"                    whina113.t$cwar cwar,                 " &
"                    sum(whina113.t$mauc$1) mauc           " &
"               from BAANDB.Twhina113301@pln01 whina113                                                            " &
"              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)                    " &
"                                                             from BAANDB.Twhina113301@pln01 b                     " &
"                                                            where b.t$item = whina113.t$item                      " &
"                                                              and b.t$cwar = whina113.t$cwar                      " &
"                                                              and b.t$trdt = ( select max(c.t$trdt)               " &
"                                                                                 from BAANDB.Twhina113301@pln01 c " &
"                                                                                where c.t$item = b.t$item         " &
"                                                                                  and c.t$cwar = b.t$cwar ) )     " &
"           group by whina113.t$item,                          " &
"                    whina113.t$cwar ) maucLN                  " &
"        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)           " &
"       AND maucLN.item = llid.sku                             " &
"                                                              " &
"INNER JOIN WMWHSE7.sku                                        " &
"        ON sku.SKU = ll.SKU                                   " &
"                                                              " &
" LEFT JOIN WMWHSE7.STORER                                     " &
"        ON STORER.STORERKEY = sku.SUSR5                       " &
"       AND STORER.WHSEID = sku.WHSEID                         " &
"       AND STORER.TYPE = 5                                    " &
"                                                              " &
"INNER JOIN WMWHSE7.loc                                        " &
"        ON loc.loc = ll.loc                                   " &
"                                                              " &
" LEFT JOIN WMWHSE7.PUTAWAYZONE pz                             " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                   " &
"                                                              " &
" LEFT JOIN enterprise.departsectorsku departSector            " &
"        ON TO_CHAR(departSector.id_depart) = sku.skugroup     " &
"       AND TO_CHAR(departSector.ID_SECTOR) = sku.skugroup2    " &
"                                                              " &
"WHERE departSector.ID_DEPART IN (" + JOIN(Parameters!Depto.Value, ", ") + ") " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )     " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                        " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                       " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"         cl.DESCRIPTION,           " &
"         STORER.COMPANY,           " &
"         ll.sku,                   " &
"         sku.DESCR,                " &
"         sku.ACTIVE,               " &
"         sku.SUSR5,                " &
"         pz.DESCR,                 " &
"         ll.loc,                   " &
"         ll.holdreason,            " &
"         departSector.depart_name, " &
"         departSector.sector_name  " &
"                                   " &
"ORDER BY ARMAZEM                   "