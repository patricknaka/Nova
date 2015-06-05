select DISTINCT 
-- O campo CD_CIA foi incluido para diferenciar NIKE(2) E BUNZL(3)
--**********************************************************************************************************************************************************
       bspt.t$bpid CD_PARCEIRO,
        CASE WHEN regexp_replace(addr.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(addr.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(addr.t$fovn$l, '[^0-9]', '') END NR_CNPJ_CPF,						

       bspt.t$nama NM_PARCEIRO,
       bspt.t$seak NM_APELIDO,
       addr.t$ftyp$l CD_TIPO_CLIENTE,
       CASE
         WHEN Nvl(trnp.t$cfrw,' ')!=' ' then 10
         WHEN Nvl(fabr.t$cmnf,' ')!=' ' then 11
         ELSE bspt.t$bprl
       END CD_TIPO_CADASTRO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(bspt.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE) DT_CADASTRO,											
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(bspt.t$lmdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,										
       bspt.t$okfi$c IN_IDONEO,
	   bspt.t$prst CD_STATUS,
	   (select pf.t$cpay from baandb.ttccom122201 pf 
	    where pf.t$ifbp=bspt.t$bpid and rownum=1) CD_CONDICAO_PAGAMENTO,									
    cast(2 as int) CD_CIA
FROM baandb.ttccom100201 bspt
LEFT JOIN baandb.ttccom130201 addr ON addr.t$cadr = bspt.t$cadr											
LEFT JOIN baandb.ttcmcs080201 trnp ON trnp.t$suno = bspt.t$bpid -- rel com transportadoras
LEFT JOIN baandb.ttcmcs060201 fabr ON fabr.t$otbp = bspt.t$bpid -- rel com fabricantes