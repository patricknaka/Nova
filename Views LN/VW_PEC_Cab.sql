-- 05-mai-2014, Fabio Ferreira, Correção registro duplicado (problema mesma data na tabela de histórico),
--								Inclusão do campo VALOR_TOTAL_MERCADOR,
-- #FAF.005, 14-mai-2014, Fabio Ferreira, 	Alteração alias
-- #FAF.228, 15-jul-2014, Fabio Ferreira, 	Alteração origem frete e seguro
-- #FAF.236, 23-jul-2014, Fabio Ferreira, 	Campo data da criação
--*********************************************************************************************************************************************
SELECT DISTINCT
    201 CD_CIA,
    tcemm030.t$euca CD_FILIAL,      
    tdpur400.t$orno NR_PEDIDO_COMPRA,
    tdpur400.t$otbp CD_FORNECEDOR,
    qopfc.t$opfc$l CD_NATUREZA_OPERACAO,
    ' ' SQ_NATUREZA_OPERACAO,                  -- *** NÃO TEMOS ESTA INFORMAÇÃO NA ORDEM DE COMPRA ***
    tdpur400.t$cpay CD_CONDICAO_PAGAMENTO,
    (select sum((pl1.t$qoor-pl1.t$qidl)*pl1.t$pric) 
    from baandb.ttdpur401201 pl1 
    where pl1.t$orno=tdpur400.t$orno
    and pl1.t$oltp!=2) VL_SALDO_PEC,
    tdpur400.t$cdec CD_TIPO_FRETE,
    CASE WHEN  tdpur400.t$hdst=20 THEN 'PARCIAL'
	WHEN tdpur400.t$hdst=25 THEN 'FECHADO'
	ELSE 'NÃO APLICAVEL' END CD_TIPO_ATENDIMENTO,
    CASE WHEN tdpur400.t$cotp='003' THEN 1
    ELSE 2
    END IN_CONSUMO,
    tdpur400.t$odat DT_EMISSAO_PEDIDO,
    apr.t$logn DS_USUARIO_APROVACAO_PEDIDO,
    CASE WHEN tdpur400.t$hdst>=10 THEN 1
    ELSE 2
    END IN_APROVADO,
    apr.dapr DT_APROVACAO_PEDIDO,
    tdpur400.t$hdst CD_SITUACAO_PEDIDO,
    (select min(tdpur450.t$trdt) from baandb.ttdpur450201 tdpur450
    where tdpur450.t$orno=tdpur400.t$orno
    and tdpur450.t$hdst=tdpur400.t$hdst) DT_SITUACAO_PEDIDO,
    (select tdpur450.t$logn from baandb.ttdpur450201 tdpur450
    where tdpur450.t$orno=tdpur400.t$orno
    and rownum=1) DS_USUARIO_GERACAO_PEDIDO,
    (select max(tdpur401.t$rcd_utc) from baandb.ttdpur401201 tdpur401
	where tdpur401.t$orno=tdpur400.t$orno) DT_ATUALIZACAO, 
    nvl((select t.t$text from baandb.ttttxt010201 t 
	where t$clan='p'
	AND t.t$ctxt=tdpur400.t$txta
	and rownum=1),' ') DS_OBSERVACAO_PEDIDO,
    (select znpur003.t$citg$c from baandb.tznpur003201 znpur003
    where znpur003.t$cotp$c=tdpur400.t$cotp
    and rownum=1) CD_DEPARTAMENTO,
--    tdpur400.t$corg COD_TIPO_GERACAO_PEDIDO,											--#FAF.005.o
	tdpur400.t$corg CD_TIPO_CADASTRO,													--#FAF.005.n
--    (select z.t$vlft$c from tznfmd630201 z											--#FAF.228.so
--	where z.t$orno$c=tdpur400.t$orno) VL_FRETE,											--#FAF.228.eo
	FreteSeg.fght VL_FRETE,																--#FAF.228.n
    (select sum(brmcs941.t$tamt$l) 
    from baandb.tbrmcs941201 brmcs941,
         baandb.ttdpur401201 tdpur401
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l
    and tdpur401.t$orno=tdpur400.t$orno
    and tdpur401.t$oltp!=2) VL_FINANCEIRO,
--    (select z.t$vlsg$c from tznfmd630201 z											--#FAF.228.so
--	where z.t$orno$c=tdpur400.t$orno) VL_SEGURO, 										--#FAF.228.eo
	FreteSeg.insr VL_SEGURO, 															--#FAF.228.n
    tdpur400.t$sbim IN_LIQUIDACAO_AUTOMATICA,
    tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
    tdpur400.T$COTP CD_TIPO_ORDEM_COMPRA,
	tdpur400.t$cvpc$c CD_CONTRATO_VPC,
	tdpur400.t$rfdt$l CD_TIPO_NF,
	tdpur400.t$fdtc$l CD_TIPO_DOCUMENTO_FISCAL,
	tdpur400.t$oamt VL_TOTAL_MERCADORIA,
   (select min(tdpur450.t$trdt) from baandb.ttdpur450201 tdpur450
    where tdpur450.t$orno=tdpur400.t$orno) DT_CRIACAO									--#FAF.236.n
FROM
    baandb.ttdpur400201 tdpur400
    LEFT JOIN (select b.t$orno, min(b.t$trdt) dapr, b.t$logn from baandb.ttdpur450201 b
      where b.t$hdst=10
      and b.t$trdt = (select min(c.t$trdt) from baandb.ttdpur450201 c where c.t$hdst=10 and c.t$orno=b.t$orno)
      group by b.t$orno, b.t$logn) apr
    ON apr.t$orno=tdpur400.t$orno
    LEFT JOIN (SELECT br.t$opfc$l, a.t$orno 
    from baandb.ttdpur401201 a,
         baandb.tbrmcs941201 br
    where br.t$txre$l=a.t$txre$l
    and br.t$line$l=a.t$txli$l
    and a.t$txre$l!=' '
    and a.t$oltp!=2
    and to_char(a.t$pono)+to_char(a.t$sqnb)=
            (select to_char(c.t$pono)+to_char(c.t$sqnb) from baandb.ttdpur401201 c
             where c.t$orno=a.t$orno
             and rownum=1
             and c.t$oamt=(select max(b.t$oamt) from baandb.ttdpur401201 b
                          where b.t$orno=c.t$orno))) qopfc ON qopfc.t$orno=tdpur400.t$orno				  
	LEFT JOIN (	select 	a.t$orno, sum(br.t$fght$l) fght, sum(br.t$insr$l) insr								--#FAF.228.sn
				from 	baandb.ttdpur401201 a,
              baandb.tbrmcs941201 br
				where 	a.t$txre$l!=' '
				and	 	a.t$oltp!=2
				and		br.t$txre$l=a.t$txre$l
				and 	br.t$line$l=a.t$txli$l
				group by a.t$orno) FreteSeg ON FreteSeg.t$orno=tdpur400.t$orno, 							--#FAF.228.en
    ttcemm124201 tcemm124,
    ttcemm030201 tcemm030
where tcemm124.t$cwoc=tdpur400.t$cofc
and tcemm124.t$loco=201
and tcemm124.T$DTYP=2
AND tcemm030.t$eunt=tcemm124.t$grid
AND (select count(*) from baandb.ttdpur401201 l where l.t$orno=tdpur400.T$orno)>0