-- 05-mai-2014, Fabio Ferreira, Correção registro duplicado (problema mesma data na tabela de histórico),
--								Inclusão do campo VALOR_TOTAL_MERCADOR,
-- #FAF.005, 14-mai-2014, Fabio Ferreira, 	Alteração alias
--*********************************************************************************************************************************************
SELECT DISTINCT
    201 COMPANHIA,
    tcemm030.t$euca FILIAL,      
	tcemm124.t$grid UNID_EMPRESARIAL,
    tdpur400.t$orno NUM_PEDIDO_COMPRA,
    tdpur400.t$otbp COD_FORNECEDOR,
    qopfc.t$opfc$l COD_NATUREZA_OPERACAO,
    ' ' SEQUENCIA_NATUREZA_OPERAÇÃO,                  -- *** NÃO TEMOS ESTA INFORMAÇÃO NA ORDEM DE COMPRA ***
    tdpur400.t$cpay COD_CONDICAO_PAGAMENTO,
    (select sum((pl1.t$qoor-pl1.t$qidl)*pl1.t$pric) 
    from ttdpur401201 pl1 
    where pl1.t$orno=tdpur400.t$orno
    and pl1.t$oltp!=2) VALOR_SALDO_PEDIDO_COMPRA,
    tdpur400.t$cdec TIPO_FRETE,
    CASE WHEN  tdpur400.t$hdst=20 THEN 'PARCIAL'
	WHEN tdpur400.t$hdst=25 THEN 'FECHADO'
	ELSE 'NÃO APLICAVEL' END COD_TIPO_ATENDIMENTO,
    CASE WHEN tdpur400.t$cotp='003' THEN 1
    ELSE 2
    END FLAGCONSUMO,
    tdpur400.t$odat DT_EMISSAO_PEDIDO,
    apr.t$logn USUARIO_APROVOU_PEDIDO,
    CASE WHEN tdpur400.t$hdst>=10 THEN 1
    ELSE 2
    END FLAG_PEDIDO_APROVADO,
    apr.dapr DT_APROVACAO_PEDIDO,
    tdpur400.t$hdst SITUACAO_PEDIDO,
    (select min(tdpur450.t$trdt) from ttdpur450201 tdpur450
    where tdpur450.t$orno=tdpur400.t$orno
    and tdpur450.t$hdst=tdpur400.t$hdst) DATA_SITUACAO_PEDIDO,
    (select tdpur450.t$logn from ttdpur450201 tdpur450
    where tdpur450.t$orno=tdpur400.t$orno
    and rownum=1) USUARIO_CRIOU_PEDIDO,
    (select max(tdpur401.t$rcd_utc) from ttdpur401201 tdpur401
	where tdpur401.t$orno=tdpur400.t$orno) DT_HR_ATUALIZACAO, 
    nvl((select t.t$text from ttttxt010201 t 
	where t$clan='p'
	AND t.t$ctxt=tdpur400.t$txta
	and rownum=1),' ') OBS_PEDIDO,
    (select znpur003.t$citg$c from tznpur003201 znpur003
    where znpur003.t$cotp$c=tdpur400.t$cotp
    and rownum=1) COD_DEPARTAMENTO,
--    tdpur400.t$corg COD_TIPO_GERACAO_PEDIDO,											--#FAF.005.o
	tdpur400.t$corg COD_TIPO_CADASTRO,													--#FAF.005.n
    (select z.t$vlft$c from tznfmd630201 z
	where z.t$orno$c=tdpur400.t$orno) VALOR_FRETE,
    (select sum(brmcs941.t$tamt$l) 
    from tbrmcs941201 brmcs941,
    ttdpur401201 tdpur401
    where brmcs941.t$txre$l=tdpur401.t$txre$l
    and brmcs941.t$line$l=tdpur401.t$txli$l
    and tdpur401.t$orno=tdpur400.t$orno
    and tdpur401.t$oltp!=2) VALOR_FINANCEIRO,
    (select z.t$vlsg$c from tznfmd630201 z
	where z.t$orno$c=tdpur400.t$orno) VALOR_SEGURO, 
    tdpur400.t$sbim FLAG_LIQUIDACAO_AUTOMATICA,
    tdpur400.T$COTP TIPO_ORD_COMPRA,
	tdpur400.t$cvpc$c VPC,
	tdpur400.t$rfdt$l COD_TIPO_NOTA,
	tdpur400.t$fdtc$l COD_TIPO_DOC_FISCAL,
	tdpur400.t$oamt VALOR_TOTAL_MERCADOR
FROM
    ttdpur400201 tdpur400
    LEFT JOIN (select b.t$orno, min(b.t$trdt) dapr, b.t$logn from ttdpur450201 b
      where b.t$hdst=10
      and b.t$trdt = (select min(c.t$trdt) from ttdpur450201 c where c.t$hdst=10 and c.t$orno=b.t$orno)
      group by b.t$orno, b.t$logn) apr
    ON apr.t$orno=tdpur400.t$orno
    LEFT JOIN (SELECT br.t$opfc$l, a.t$orno 
    from ttdpur401201 a,
         tbrmcs941201 br
    where br.t$txre$l=a.t$txre$l
    and br.t$line$l=a.t$txli$l
    and a.t$txre$l!=' '
    and a.t$oltp!=2
    and to_char(a.t$pono)+to_char(a.t$sqnb)=
            (select to_char(c.t$pono)+to_char(c.t$sqnb) from ttdpur401201 c
             where c.t$orno=a.t$orno
             and rownum=1
             and c.t$oamt=(select max(b.t$oamt) from ttdpur401201 b
                          where b.t$orno=c.t$orno))) qopfc
    ON qopfc.t$orno=tdpur400.t$orno,
    ttcemm124201 tcemm124,
    ttcemm030201 tcemm030
where tcemm124.t$cwoc=tdpur400.t$cofc
and tcemm124.t$loco=201
and tcemm124.T$DTYP=2
AND tcemm030.t$eunt=tcemm124.t$grid
AND (select count(*) from ttdpur401201 l where l.t$orno=tdpur400.T$orno)>0