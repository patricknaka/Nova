SELECT  addr.t$ftyp$l tipo_cliente,
        bspt.t$nama nome,
        bspt.t$seak apelido,
        addr.t$fovn$l cnpj,
        bspt.t$prst SITUACAO_CADASTRO,
        (select min(h.t$udat$c) from tzncom013201 h
        where h.t$okfi$c=1
        and h.t$bpid$c=bspt.t$bpid) DATA_LIBERACAO,
        bspt.t$crdt DT_CADASTRO,
        (select max(h.t$udat$c) from tzncom013201 h
        where h.t$bpid$c=bspt.t$bpid) DATA_SITUACAO,
        bspt.t$lmdt DT_ATUALIZACAO,
        bspt.t$lmus USUARIO,
        tccom966.t$stin$d INSCRICAO_ESTADUAL,
        tccom139.t$dsca MUNICIPIO,
        tcmcs143.t$abbr UF
FROM ttccom100201 bspt
LEFT JOIN ttccom130201 addr ON addr.t$cadr = bspt.t$cadr
LEFT JOIN ttccom966201 tccom966 ON  tccom966.t$fovn$l = addr.t$fovn$l
LEFT JOIN ttccom139201 tccom139 ON  tccom139.t$city = addr.t$ccit AND tccom139.t$cste=addr.t$cste AND tccom139.t$ccty=addr.t$ccty
LEFT JOIN ttcmcs143201 tcmcs143 ON  tcmcs143.t$ccty = addr.t$ccty AND tcmcs143.t$cste=addr.t$cste
WHERE bspt.t$okfi$c=1
