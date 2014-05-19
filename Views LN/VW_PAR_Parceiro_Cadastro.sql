-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclusão dos campos UF e Pais e alteração do alias COD_CIDADE
--****************************************************************************************************************************************************************
SELECT 
       bspt.t$bpid codigo,
       addr.t$fovn$l cnpj_cpf,
       bspt.t$nama nome,
       bspt.t$seak apelido,
       addr.t$ftyp$l tipo_cliente,
       CASE
         WHEN Nvl(trnp.t$cfrw,' ')!=' ' then 10
         WHEN Nvl(fabr.t$cmnf,' ')!=' ' then 11
         ELSE bspt.t$bprl
       END TIPO_CADASTRO,
       addp.t$fovn$l cnpj_cpf_grupo ,
       bspt.t$crdt DT_CADASTRO,
       bspt.t$lmdt DT_ATUALIZACAO,
       addr.t$telp TEL1,
       addr.t$telx TEL2,
       addr.t$tefx FAX,
       bspt.t$okfi$c FLAG_IDONEO,
       CASE WHEN addp.t$cadr=addr.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END MATRIZ_FILIAL,
	   bspt.t$prst status
FROM ttccom100201 bspt
LEFT JOIN ttccom130201 addp ON addp.t$cadr = bspt.t$cadr
LEFT JOIN ttccom133201 adbp ON adbp.t$bpid = bspt.t$bpid
LEFT JOIN ttccom130201 addr ON addr.t$cadr = adbp.t$cadr
LEFT JOIN ttcmcs080201 trnp ON trnp.t$suno = bspt.t$bpid -- rel com transportadoras
LEFT JOIN ttcmcs060201 fabr ON fabr.t$otbp = bspt.t$bpid -- rel com fabricantes
