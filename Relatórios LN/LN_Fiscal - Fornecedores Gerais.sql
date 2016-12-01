SELECT 
      '301'                                          COMPANHIA,
      tccom100.t$bpid                       PARCEIRO_DE_NEGOCIOS,
      tccom100.t$nama                       DESCRICAO,
      tccom130.t$fovn$l                     ENTIDADE_FISCAL,
      TRIM(tccom130.t$namc) || ',' || ' ' ||
      tccom130.t$hono                       ENDERECO,
      tccom130.t$dist$l                     BAIRRO,
      tccom139.t$dscb$c                     CIDADE,
      tccom130.t$cste                       ESTADO,
      tccom130.t$ccty                       PAIS,
      tccom130.t$pstc                       CEP,
      tccom130.t$telp                       TELEFONE,
      FUNCAO.DESCR                          FUNCAO,
      STATUS.DESCR                          STATUS,
      VERIFI.DESCR                          A_SER_VERIFICADO, --ALTERAR
      tccom100.t$prbp                       PARC_NEGOCIOS_PAI,
      tcmcs029.t$dsca                       TIPO_PARC_NEGOCIOS
      
FROM  ( select SUBSTR(a.t$fovn$l,1,8) ent_pai,
               min(a.t$cadr) t$cadr
        from baandb.ttccom130301 a
        group by SUBSTR(a.t$fovn$l,1,8) ) endereco

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = endereco.t$cadr

INNER JOIN ( select a.t$cadr,
                    min(a.t$bpid) t$bpid
             from baandb.ttccom100301 a
             where a.t$prst = 2     --Ativo
             group by a.t$cadr ) PN
       ON PN.t$cadr = tccom130.t$cadr
             
LEFT JOIN baandb.ttccom100301 tccom100
       ON tccom100.t$bpid = PN.t$bpid
       
LEFT JOIN baandb.ttccom120301 tccom120
       ON tccom120.t$otbp = tccom100.t$bpid
       
LEFT JOIN baandb.ttcmcs029301 tcmcs029
       ON tcmcs029.t$cbtp = tccom120.t$cbtp

LEFT JOIN baandb.ttccom139301 tccom139
       ON tccom139.t$ccty = tccom130.t$ccty
      AND tccom139.t$cste = tccom130.t$cste
      AND tccom139.t$city = tccom130.t$ccit

	       
 LEFT JOIN ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tc'
                and d.t$cdom = 'bprl'
                and l.t$clan = 'p'
                and l.t$cpac = 'tc'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) FUNCAO
        ON FUNCAO.t$cnst = tccom100.t$bprl 

 LEFT JOIN ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tc'
                and d.t$cdom = 'com.prst'
                and l.t$clan = 'p'
                and l.t$cpac = 'tc'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) STATUS
        ON STATUS.t$cnst = tccom100.t$prst 
      
 LEFT JOIN ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tc'
                and d.t$cdom = 'yesno'
                and l.t$clan = 'p'
                and l.t$cpac = 'tc'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) VERIFI
        ON VERIFI.t$cnst = tccom100.t$btbv
                
where tccom100.t$bprl IN (3,4)				--3-Fornecedor, 4-Cliente e Fornecedor
and exists ( select tdrec940.t$fire$l
			 from baandb.ttdrec940301 tdrec940
			 where tdrec940.t$fovn$l = tccom130.t$fovn$l )
and tccom130.t$ftyp$l IN ('PJ','NA')
and tccom120.t$cbtp not in ('011','013', '904')		--11-Devolucao Clientes, 13-Parceiro Interno
and tccom100.t$bpid not in ('103422172', '103491736', '103491482', '100013270', '103288639', '100306399', '100027698',
                            '100022387', 'N00000012', 'N00000037', 'N00000038', '100012448', '101628909', '100011247',
                            '100025880', '100989426', '100326273', '100326475', '100326005', '100326524', '100046235',
                            '100299466', '100071539')
and ((:ParceiroTodos = 0) OR (TRIM(tccom100.t$bpid) IN (:Parceiro) AND (:ParceiroTodos = 1)))
and ((:EntidadeTodos = 0) OR (TRIM(tccom130.t$fovn$l) IN (:Entidade) AND (:EntidadeTodos = 1)))
and tcmcs029.t$cbtp IN (:TipoPN)
and STATUS.DESCR in (:Status)
