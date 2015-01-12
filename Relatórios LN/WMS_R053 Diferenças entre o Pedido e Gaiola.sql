=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                       " &
"  DISTINCT                                   " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,       " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,        " &
"   OWMS.ORDERKEY            ORDEM_WMS,       " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,            " &
"   TCIBD001.T$DSCA          DESCR_ITEM,      " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,     " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO,  " &
"   CCPLACA.PLACA            CAMINHAO,        " &
"   OWMS.WHSEID              ID_FILIAL,       " &
"   CL.UDF2                  DESCR_FILIAL     " &
"                                             " &
"FROM       (select a.t$ncia$c,               " &
"                   a.t$uneg$c,               " &
"                   a.t$pecl$c,               " &
"                   a.t$sqpd$c,               " &
"                   a.t$entr$c,               " &
"                   a.t$sequ$c,               " &
"                   a.t$orno$c                " &
"              from baandb.tznsls004301 a     " &
"             where a.t$date$c = ( select max(r1.t$date$c)                    " &
"                                    from baandb.tznsls004301  r1             " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004  " &
"                                                                             " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401                                      " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C                             " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C                             " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C                             " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C                             " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C                             " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C                             " &
"                                                                             " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001                                      " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C                               " &
"                                                                             " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS@DL_LN_WMS OWMS              " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C                        " &
"                                                                             " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL                                  " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID                                      " &
"       AND CL.LISTNAME = 'SCHEMA'                                            " &
"                                                                             " &
"INNER JOIN ( select f.t$orno$c,                                              " &
"                    f.t$ncar$c,                                              " &
"                    f.t$fili$c,                                              " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c  " &
"               from baandb.tznfmd630301 f                                                " &
"         inner join baandb.tznfmd640301 o                                                " &
"                 on o.t$fili$c = f.t$fili$c                                              " &
"                and o.t$etiq$c = f.t$etiq$c                                              " &
"           group by f.t$orno$c,                                                          " &
"                    f.t$ncar$c,                                                          " &
"                    f.t$fili$c ) ULT_OCR                                                 " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C                                          " &
"                                                                                         " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030                                                  " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C                                          " &
"                                                                                         " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa,                  " &
"                    l.t$fili$c,                                                          " &
"                    l.t$ncar$c                                                           " &
"               from baandb.tznfmd170301 c                                                " &
"         inner join baandb.tznfmd171301 l                                                " &
"                 on l.t$fili$c = c.t$fili$c                                              " &
"                and l.t$nent$c = c.t$nent$c                                              " &
"                and l.t$cfrw$c = c.t$cfrw$c                                              " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),                        " &
"                    l.t$fili$c,                                                          " &
"                    l.t$ncar$c ) CCPLACA                                                 " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C                                           " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C                                           " &
"                                                                                         " &
"WHERE ((Trim(CCPLACA.PLACA) IN (" + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " )             " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                          " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) )                                                         " &
"                                                                                                                                  " &
"ORDER BY DESCR_FILIAL, ID_PEDIDO                                                                                                  " 
                                                                                                                                   
,                                                                                                                                  
                                                                                                                                   
"SELECT                                     " &
"  DISTINCT                                 " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,     " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,      " &
"   OWMS.ORDERKEY            ORDEM_WMS,     " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,          " &
"   TCIBD001.T$DSCA          DESCR_ITEM,    " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,   " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO," &
"   CCPLACA.PLACA            CAMINHAO,      " &
"   OWMS.WHSEID              ID_FILIAL,     " &
"   CL.UDF2                  DESCR_FILIAL   " &
"                                           " &
"FROM       (select a.t$ncia$c,             " &
"                   a.t$uneg$c,             " &
"                   a.t$pecl$c,             " &
"                   a.t$sqpd$c,             " &
"                   a.t$entr$c,             " &
"                   a.t$sequ$c,             " &
"                   a.t$orno$c              " &
"              from baandb.tznsls004301 a   " &
"             where a.t$date$c = ( select max(r1.t$date$c)                                                                         " &
"                                    from baandb.tznsls004301  r1                                                                  " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004                                                       " &
"                                                                                                                                  " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401                 " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C        " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C        " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C        " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C        " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C        " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C        " &
"                                                        " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001                 " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C          " &
"                                                        " &
"INNER JOIN WMWHSE1.ORDERS@DL_LN_WMS OWMS                " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C   " &
"                                               " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL    " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID        " &
"       AND CL.LISTNAME = 'SCHEMA'              " &
"                                               " &
"INNER JOIN ( select f.t$orno$c,                " &
"                    f.t$ncar$c,                " &
"                    f.t$fili$c,                " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c                                  " &
"               from baandb.tznfmd630301 f            " &
"         inner join baandb.tznfmd640301 o            " &
"                 on o.t$fili$c = f.t$fili$c          " &
"                and o.t$etiq$c = f.t$etiq$c          " &
"           group by f.t$orno$c,                      " &
"                    f.t$ncar$c,                      " &
"                    f.t$fili$c ) ULT_OCR             " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C      " &
"                                                     " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030              " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C      " &
"                                                     " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa,                                                  " &
"                    l.t$fili$c,                 " &
"                    l.t$ncar$c                  " &
"               from baandb.tznfmd170301 c       " &
"         inner join baandb.tznfmd171301 l       " &
"                 on l.t$fili$c = c.t$fili$c     " &
"                and l.t$nent$c = c.t$nent$c     " &
"                and l.t$cfrw$c = c.t$cfrw$c     " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),                                                        " &
"                    l.t$fili$c,                  " &
"                    l.t$ncar$c ) CCPLACA         " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C   " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C   " &
"                                                 " &
"WHERE  ( (Trim(CCPLACA.PLACA) IN ( " + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " ) " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                 " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) )                                                " &
"                                              " &
"UNION                                         " &
"                                              " &
"SELECT                                        " &
"  DISTINCT                                    " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,        " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,         " &
"   OWMS.ORDERKEY            ORDEM_WMS,        " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,             " &
"   TCIBD001.T$DSCA          DESCR_ITEM,       " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,      " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO,   " &
"   CCPLACA.PLACA            CAMINHAO,         " &
"   OWMS.WHSEID              ID_FILIAL,        " &
"   CL.UDF2                  DESCR_FILIAL      " &
"                                              " &
"FROM       (select a.t$ncia$c,                " &
"                   a.t$uneg$c,                " &
"                   a.t$pecl$c,                " &
"                   a.t$sqpd$c,                " &
"                   a.t$entr$c,                " &
"                   a.t$sequ$c,                " &
"                   a.t$orno$c                 " &
"              from baandb.tznsls004301 a      " &
"             where a.t$date$c = ( select max(r1.t$date$c)                                                                " &
"                                    from baandb.tznsls004301  r1                                                         " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004                                              " &
"                                                       " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401                " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C       " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C       " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C       " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C       " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C       " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C       " &
"                                                       " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001                " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C         " &
"                                                       " &
"INNER JOIN WMWHSE2.ORDERS@DL_LN_WMS OWMS               " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C  " &
"                                                       " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL            " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                      " &
"                                                       " &
"INNER JOIN ( select f.t$orno$c,                        " &
"                    f.t$ncar$c,                        " &
"                    f.t$fili$c,                        " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c                                  " &
"               from baandb.tznfmd630301 f       " &
"         inner join baandb.tznfmd640301 o       " &
"                 on o.t$fili$c = f.t$fili$c     " &
"                and o.t$etiq$c = f.t$etiq$c     " &
"           group by f.t$orno$c,                 " &
"                    f.t$ncar$c,                 " &
"                    f.t$fili$c ) ULT_OCR        " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C " &
"                                                " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030         " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C " &
"                                                " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa,                                                  " &
"                    l.t$fili$c,               " &
"                    l.t$ncar$c                " &
"               from baandb.tznfmd170301 c     " &
"         inner join baandb.tznfmd171301 l     " &
"                 on l.t$fili$c = c.t$fili$c   " &
"                and l.t$nent$c = c.t$nent$c   " &
"                and l.t$cfrw$c = c.t$cfrw$c   " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),                                                        " &
"                    l.t$fili$c,                   " &
"                    l.t$ncar$c ) CCPLACA          " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C    " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C    " &
"                                                                                                                         " &
"WHERE  ( (Trim(CCPLACA.PLACA) IN ( " + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " ) " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                 " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) )                                                " &
"                                                 " &
"UNION                                            " &
"                                                 " &
"SELECT                                           " &
"  DISTINCT                                       " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,           " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,            " &
"   OWMS.ORDERKEY            ORDEM_WMS,           " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,                " &
"   TCIBD001.T$DSCA          DESCR_ITEM,          " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,         " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO,      " &
"   CCPLACA.PLACA            CAMINHAO,            " &
"   OWMS.WHSEID              ID_FILIAL,           " &
"   CL.UDF2                  DESCR_FILIAL         " &
"                                                 " &
"FROM       (select a.t$ncia$c,                   " &
"                   a.t$uneg$c,                   " &
"                   a.t$pecl$c,                   " &
"                   a.t$sqpd$c,                   " &
"                   a.t$entr$c,                   " &
"                   a.t$sequ$c,                   " &
"                   a.t$orno$c                    " &
"              from baandb.tznsls004301 a         " &
"             where a.t$date$c = ( select max(r1.t$date$c)                                                                " &
"                                    from baandb.tznsls004301  r1                                                         " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004                                              " &
"                                                                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401              " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C     " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C     " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C     " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C     " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C     " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C     " &
"                                                     " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001              " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C       " &
"                                                     " &
"INNER JOIN WMWHSE3.ORDERS@DL_LN_WMS OWMS             " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C" &
"                                                     " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL          " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID              " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"                                                     " &
"INNER JOIN ( select f.t$orno$c,                      " &
"                    f.t$ncar$c,                      " &
"                    f.t$fili$c,                      " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c                                  " &
"               from baandb.tznfmd630301 f                                                                                " &
"         inner join baandb.tznfmd640301 o                                  " &
"                 on o.t$fili$c = f.t$fili$c                                " &
"                and o.t$etiq$c = f.t$etiq$c                                " &
"           group by f.t$orno$c,                                            " &
"                    f.t$ncar$c,                                            " &
"                    f.t$fili$c ) ULT_OCR                                   " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C                            " &
"                                                                           " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030                                    " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C                            " &
"                                                                           " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa,    " &
"                    l.t$fili$c,                                            " &
"                    l.t$ncar$c                                             " &
"               from baandb.tznfmd170301 c                                  " &
"         inner join baandb.tznfmd171301 l                                  " &
"                 on l.t$fili$c = c.t$fili$c                                " &
"                and l.t$nent$c = c.t$nent$c                                " &
"                and l.t$cfrw$c = c.t$cfrw$c                                " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),          " &
"                    l.t$fili$c,                                            " &
"                    l.t$ncar$c ) CCPLACA                                   " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C                             " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C                             " &
"                                                                           " &
"WHERE  ( (Trim(CCPLACA.PLACA) IN ( " + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " ) " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                 " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) )                                                " &
"                                            " &
"UNION                                       " &
"                                            " &
"SELECT                                      " &
"  DISTINCT                                  " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,      " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,       " &
"   OWMS.ORDERKEY            ORDEM_WMS,      " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,           " &
"   TCIBD001.T$DSCA          DESCR_ITEM,     " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,    " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO, " &
"   CCPLACA.PLACA            CAMINHAO,       " &
"   OWMS.WHSEID              ID_FILIAL,      " &
"   CL.UDF2                  DESCR_FILIAL    " &
"                                            " &
"FROM       (select a.t$ncia$c,              " &
"                   a.t$uneg$c,              " &
"                   a.t$pecl$c,              " &
"                   a.t$sqpd$c,              " &
"                   a.t$entr$c,              " &
"                   a.t$sequ$c,              " &
"                   a.t$orno$c               " &
"              from baandb.tznsls004301 a    " &
"             where a.t$date$c = ( select max(r1.t$date$c)           " &
"                                    from baandb.tznsls004301  r1    " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004  " &
"                                                                             " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401               " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C      " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C      " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C      " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C      " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C      " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C      " &
"                                                      " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001               " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C        " &
"                                                      " &
"INNER JOIN WMWHSE4.ORDERS@DL_LN_WMS OWMS              " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C " &
"                                                      " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL           " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID               " &
"       AND CL.LISTNAME = 'SCHEMA'                     " &
"                                                      " &
"INNER JOIN ( select f.t$orno$c,                       " &
"                    f.t$ncar$c,                       " &
"                    f.t$fili$c,                       " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c   " &
"               from baandb.tznfmd630301 f                                " &
"         inner join baandb.tznfmd640301 o                                " &
"                 on o.t$fili$c = f.t$fili$c                              " &
"                and o.t$etiq$c = f.t$etiq$c                              " &
"           group by f.t$orno$c,                                          " &
"                    f.t$ncar$c,                                          " &
"                    f.t$fili$c ) ULT_OCR                                 " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C                          " &
"                                                                         " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030                                  " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C                          " &
"                                                                         " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa,  " &
"                    l.t$fili$c,                                          " &
"                    l.t$ncar$c                                           " &
"               from baandb.tznfmd170301 c                                " &
"         inner join baandb.tznfmd171301 l                                " &
"                 on l.t$fili$c = c.t$fili$c                              " &
"                and l.t$nent$c = c.t$nent$c                              " &
"                and l.t$cfrw$c = c.t$cfrw$c                              " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),        " &
"                    l.t$fili$c,                                          " &
"                    l.t$ncar$c ) CCPLACA                                 " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C                           " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C                           " &
"                                                                         " &
"WHERE  ( (Trim(CCPLACA.PLACA) IN ( " + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " ) " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                 " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) )                                                " &
"                                                                                                                         " &
"UNION                                             " &
"                                                  " &
"SELECT                                            " &
"  DISTINCT                                        " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,            " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,             " &
"   OWMS.ORDERKEY            ORDEM_WMS,            " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,                 " &
"   TCIBD001.T$DSCA          DESCR_ITEM,           " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,          " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO,       " &
"   CCPLACA.PLACA            CAMINHAO,             " &
"   OWMS.WHSEID              ID_FILIAL,            " &
"   CL.UDF2                  DESCR_FILIAL          " &
"                                                  " &
"FROM       (select a.t$ncia$c,                    " &
"                   a.t$uneg$c,                    " &
"                   a.t$pecl$c,                    " &
"                   a.t$sqpd$c,                    " &
"                   a.t$entr$c,                    " &
"                   a.t$sequ$c,                    " &
"                   a.t$orno$c                     " &
"              from baandb.tznsls004301 a          " &
"             where a.t$date$c = ( select max(r1.t$date$c)                                                                " &
"                                    from baandb.tznsls004301  r1                                                         " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004 " &
"                                                      " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401               " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C      " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C      " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C      " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C      " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C      " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C      " &
"                                                      " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001               " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C        " &
"                                                      " &
"INNER JOIN WMWHSE5.ORDERS@DL_LN_WMS OWMS              " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C " &
"                                                      " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL           " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID               " &
"       AND CL.LISTNAME = 'SCHEMA'                     " &
"                                                      " &
"INNER JOIN ( select f.t$orno$c,                       " &
"                    f.t$ncar$c,                       " &
"                    f.t$fili$c,                       " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c  " &
"               from baandb.tznfmd630301 f                                 " &
"         inner join baandb.tznfmd640301 o                                 " &
"                 on o.t$fili$c = f.t$fili$c                               " &
"                and o.t$etiq$c = f.t$etiq$c                               " &
"           group by f.t$orno$c,                                           " &
"                    f.t$ncar$c,                                           " &
"                    f.t$fili$c ) ULT_OCR                                  " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C                           " &
"                                                                          " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030                                   " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C                           " &
"                                                                          " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa,   " &
"                    l.t$fili$c,                                           " &
"                    l.t$ncar$c                                            " &
"               from baandb.tznfmd170301 c                                 " &
"         inner join baandb.tznfmd171301 l                                 " &
"                 on l.t$fili$c = c.t$fili$c                               " &
"                and l.t$nent$c = c.t$nent$c                               " &
"                and l.t$cfrw$c = c.t$cfrw$c                               " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),         " &
"                    l.t$fili$c,                                           " &
"                    l.t$ncar$c ) CCPLACA                                  " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C                            " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C                            " &
"                                                                          " &
"WHERE  ( (Trim(CCPLACA.PLACA) IN ( " + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " ) " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                 " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) )                                                " &
"                                              " &
"UNION                                         " &
"                                              " &
"SELECT                                        " &
"  DISTINCT                                    " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,        " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,         " &
"   OWMS.ORDERKEY            ORDEM_WMS,        " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,             " &
"   TCIBD001.T$DSCA          DESCR_ITEM,       " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,      " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO,   " &
"   CCPLACA.PLACA            CAMINHAO,         " &
"   OWMS.WHSEID              ID_FILIAL,        " &
"   CL.UDF2                  DESCR_FILIAL      " &
"                                              " &
"FROM       (select a.t$ncia$c,                " &
"                   a.t$uneg$c,                " &
"                   a.t$pecl$c,                " &
"                   a.t$sqpd$c,                " &
"                   a.t$entr$c,                " &
"                   a.t$sequ$c,                " &
"                   a.t$orno$c                 " &
"              from baandb.tznsls004301 a      " &
"             where a.t$date$c = ( select max(r1.t$date$c)                   " &
"                                    from baandb.tznsls004301  r1            " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004 " &
"                                                     " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401              " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C     " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C     " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C     " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C     " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C     " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C     " &
"                                                     " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001              " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C       " &
"                                                     " &
"INNER JOIN WMWHSE6.ORDERS@DL_LN_WMS OWMS             " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C" &
"                                                     " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL          " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID              " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"                                                     " &
"INNER JOIN ( select f.t$orno$c,                      " &
"                    f.t$ncar$c,                      " &
"                    f.t$fili$c,                      " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c    " &
"               from baandb.tznfmd630301 f         " &
"         inner join baandb.tznfmd640301 o         " &
"                 on o.t$fili$c = f.t$fili$c       " &
"                and o.t$etiq$c = f.t$etiq$c       " &
"           group by f.t$orno$c,                   " &
"                    f.t$ncar$c,                   " &
"                    f.t$fili$c ) ULT_OCR          " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C   " &
"                                                                        " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030                                 " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C                         " &
"                                                                        " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa, " &
"                    l.t$fili$c,                                         " &
"                    l.t$ncar$c                                          " &
"               from baandb.tznfmd170301 c                               " &
"         inner join baandb.tznfmd171301 l                               " &
"                 on l.t$fili$c = c.t$fili$c                             " &
"                and l.t$nent$c = c.t$nent$c                             " &
"                and l.t$cfrw$c = c.t$cfrw$c                             " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),       " &
"                    l.t$fili$c,                                         " &
"                    l.t$ncar$c ) CCPLACA                                " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C                          " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C                          " &
"                                                                        " &
"WHERE  ( (Trim(CCPLACA.PLACA) IN ( " + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " ) " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                 " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) )                                                " &
"                                                                                                                         " &
"UNION                                             " &
"                                                  " &
"SELECT                                            " &
"  DISTINCT                                        " &
"   ZNSLS004.T$PECL$C        ID_PEDIDO,            " &
"   ZNSLS004.T$ORNO$C        ORDEM_LN,             " &
"   OWMS.ORDERKEY            ORDEM_WMS,            " &
"   TRIM(ZNSLS401.T$ITEM$C)  ITEM,                 " &
"   TCIBD001.T$DSCA          DESCR_ITEM,           " &
"   ULT_OCR.T$COCI$C         ID_SITUACAO,          " &
"   ZNFMD030.T$DSCI$C        DESCR_SITUACAO,       " &
"   CCPLACA.PLACA            CAMINHAO,             " &
"   OWMS.WHSEID              ID_FILIAL,            " &
"   CL.UDF2                  DESCR_FILIAL          " &
"                                                  " &
"FROM       (select a.t$ncia$c,                    " &
"                   a.t$uneg$c,                    " &
"                   a.t$pecl$c,                    " &
"                   a.t$sqpd$c,                    " &
"                   a.t$entr$c,                    " &
"                   a.t$sequ$c,                    " &
"                   a.t$orno$c                     " &
"              from baandb.tznsls004301 a                          " &
"             where a.t$date$c = ( select max(r1.t$date$c)         " &
"                                    from baandb.tznsls004301  r1  " &
"                                   where r1.t$orno$c=A.t$orno$c) ) ZNSLS004 " &
"                                                      " &
"INNER JOIN BAANDB.TZNSLS401301 ZNSLS401               " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C      " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C      " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C      " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C      " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C      " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C      " &
"                                                      " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001               " &
"        ON TCIBD001.T$ITEM = ZNSLS401.T$ITEM$C        " &
"                                                      " &
"INNER JOIN WMWHSE7.ORDERS@DL_LN_WMS OWMS              " &
"        ON OWMS.REFERENCEDOCUMENT = ZNSLS004.T$ORNO$C " &
"                                                      " &
"INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS CL           " &
"        ON UPPER(CL.UDF1) = OWMS.WHSEID               " &
"       AND CL.LISTNAME = 'SCHEMA'                     " &
"                                                      " &
"INNER JOIN ( select f.t$orno$c,                       " &
"                    f.t$ncar$c,                       " &
"                    f.t$fili$c,                       " &
"                    max(o.t$coci$c) keep (dense_rank last order by o.t$date$c) t$coci$c   " &
"               from baandb.tznfmd630301 f                                                 " &
"         inner join baandb.tznfmd640301 o                               " &
"                 on o.t$fili$c = f.t$fili$c                             " &
"                and o.t$etiq$c = f.t$etiq$c                             " &
"           group by f.t$orno$c,                                         " &
"                    f.t$ncar$c,                                         " &
"                    f.t$fili$c ) ULT_OCR                                " &
"        ON ULT_OCR.T$ORNO$C = ZNSLS004.T$ORNO$C                         " &
"                                                                        " &
"INNER JOIN BAANDB.TZNFMD030301 ZNFMD030                                 " &
"        ON ZNFMD030.T$OCIN$C = ULT_OCR.T$COCI$C                         " &
"                                                                        " &
" LEFT JOIN ( select nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)) placa, " &
"                    l.t$fili$c,                                         " &
"                    l.t$ncar$c                                          " &
"               from baandb.tznfmd170301 c                               " &
"         inner join baandb.tznfmd171301 l                               " &
"                 on l.t$fili$c = c.t$fili$c                             " &
"                and l.t$nent$c = c.t$nent$c                             " &
"                and l.t$cfrw$c = c.t$cfrw$c                             " &
"           group by nvl(c.t$vpla$c, nvl(c.t$vplc$c, c.t$vplt$c)),       " &
"                    l.t$fili$c,                                         " &
"                    l.t$ncar$c ) CCPLACA                                " &
"        ON CCPLACA.t$fili$c = ULT_OCR.T$FILI$C                          " &
"       AND CCPLACA.T$NCAR$C = ULT_OCR.T$NCAR$C                          " &
"                                                                        " &
"WHERE  ( (Trim(CCPLACA.PLACA) IN ( " + IIF(Parameters!Caminhao.Value Is Nothing, "''", Parameters!Caminhao.Value)  + " ) " &
"  AND (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 0))                                                 " &
"   OR (" + IIF(Parameters!Caminhao.Value Is Nothing, "1", "0") + " = 1) ) " &
"ORDER BY DESCR_FILIAL, ID_PEDIDO "
)