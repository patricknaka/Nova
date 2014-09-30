SELECT
DISTINCT
    brnfe940.t$fovn$l     id_fiscal,
    brnfe940.t$fids$l	  razao_social,
    brnfe940.t$fire$l	  num_rascunho,
    znnfe007.t$orno$c	  num_pedido,
    brnfe940.t$docn$l	  num_nota_fiscal,
    brnfe940.t$fdot$l	  natureza_oper,
    brnfe940.t$idat$l     data_fiscal,                    
    brnfe940.t$slog$c	  login_usuário,
    tdpur400.t$cdec	  linha_doc_fiscal,
    tdpur400.t$cofc	  departamento,
    brnfe940.t$idat$l     data_emissao_nf,
    brnfe941.t$qnty$l     qtde_total_pecas,
    brnfe941.t$tamt$l     vlr_total_batimento,
    brnfe940.t$stat$l     status_batimento,
    CASE WHEN brnfe940.t$stpr$c = 3 THEN
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$fcdt$c, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE) end
                          data_status_altera_erro,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$sdat$c, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE) 
                          data_status_altera_agenda

FROM  baandb.tbrnfe940201 	brnfe940,
      (select sum(l.t$qnty$l) t$qnty$l, sum(l.t$tamt$l) t$tamt$l,
            l.t$fire$l
            from baandb.tbrnfe941201 l
            group by l.t$fire$l) brnfe941 
            
LEFT JOIN   baandb.tznnfe007201 znnfe007
       ON   brnfe941.t$fire$l = znnfe007.t$fire$c 
       
LEFT JOIN   baandb.ttdpur401201 tdpur401 
       ON   tdpur401.t$orno = znnfe007.t$orno$c 
      AND   tdpur401.t$pono = znnfe007.t$pono$c 
      AND   tdpur401.t$sqnb = znnfe007.t$seqn$c

LEFT JOIN   baandb.ttdpur400201 tdpur400
       ON   tdpur400.t$orno = znnfe007.t$orno$c 

LEFT JOIN   baandb.ttccom100201 tccom100
       ON   tccom100.t$bpid = tdpur400.t$otbp 

LEFT JOIN   baandb.ttccom130201 tccom130
       ON   tccom130.t$cadr = tdpur400.t$otad

WHERE
 brnfe940.t$fire$l = brnfe941.t$fire$l