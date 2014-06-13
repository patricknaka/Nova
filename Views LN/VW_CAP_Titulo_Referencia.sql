select
        tfacp200.t$ninv NR_TITULO,
        tfacp200.t$ttyp CD_TRANSACAO_TITULO,
        tdrec947.t$rcno$l NR_NFR,
        sum(tdpur401.t$oamt) VL_PEDIDO_COMPRA,
        tdrec940.T$FIRE$L NR_REFERENCIA_FISCAL
FROM
        ttfacp200201 tfacp200
        INNER JOIN ttdrec940201 tdrec940
        ON tdrec940.t$docn$l=tfacp200.t$docn$l
        AND tdrec940.t$seri$l=tfacp200.t$seri$l
        AND tdrec940.t$ttyp$l=tfacp200.t$ttyp
        AND tdrec940.t$invn$l=tfacp200.t$ninv
        INNER JOIN ttdrec947201 tdrec947
        ON tdrec947.t$fire$l=tdrec940.t$fire$l
        INNER JOIN ttdpur401201 tdpur401
        ON tdpur401.t$orno=tdrec947.t$orno$l AND tdpur401.t$pono=tdrec947.t$pono$l
WHERE
      tfacp200.t$docn=0
AND   tdrec947.t$rcno$l!=' '
GROUP BY 
        tfacp200.t$ninv,
        tfacp200.t$ttyp,
        tdrec947.t$rcno$l,
        tdrec940.T$FIRE$L