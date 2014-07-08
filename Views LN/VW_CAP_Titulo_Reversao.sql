SELECT
                znacp001.t$ttyp$c || znacp001.t$ninv$c cd_chave_primaria,
                201 cd_cia,
                CASE WHEN tfacp200.t$ttyp IN ('AGA', 'GA1') THEN 3 ELSE 2 END cd_filial,
                znacp001.t$tdoc$c cd_transacao_link,
                znacp001.t$docn$c nr_documento_link,
                znacp001.t$lino$c nr_linha_link,
                tfacp200d.t$docd dt_link,
                tfacp200.t$amnt vl_link,
                znacp001.t$ttrv$c cd_transacao_reversao,
                znacp001.t$dorv$c nr_documento_reversao,
                znacp001.t$lirv$c nr_linha_reversao,
                CAST((from_tz(CAST(to_char(znacp001.t$date$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
                  AT TIME ZONE SESSIONTIMEZONE) AS DATE) dt_reversao
FROM          tznacp001201 znacp001
INNER JOIN    ttfacp200201 tfacp200 ON  tfacp200.t$ttyp=znacp001.t$ttyp$c
                                    AND tfacp200.t$ninv=znacp001.t$ninv$c
                                    AND tfacp200.t$tdoc=znacp001.t$tdoc$c
                                    AND tfacp200.t$docn=znacp001.t$docn$c
                                    AND tfacp200.t$lino=znacp001.t$lino$c
INNER JOIN   ttfacp200201 tfacp200d ON  tfacp200d.t$ttyp=znacp001.t$ttyp$c
                                    AND tfacp200d.t$ninv=znacp001.t$ninv$c
                                    AND tfacp200d.t$docn=0
