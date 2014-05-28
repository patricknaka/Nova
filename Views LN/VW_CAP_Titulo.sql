-- 06-jan-2014, Fabio Ferreira, Correção timezone
--	FAF.001 - 07-jan-2014, Fabio Ferreira, 	Retirada conversão de timezone para campos somente data
--											Corrigido campos Taxa Juros, Taxa Mora
--	FAF.003 - 12-jan-2014, Fabio Ferreira, 	Retirada conversão de timezone para campo DATA_LIQUIDACAO_TITULO
--											O campo taxa multa foi alterado apara ler o valor da tabela tfacp201
--	FAF.007 - 12-jan-2014, Fabio Ferreira, 	Alteração valor original do título
--****************************************************************************************************************************************************************
SELECT DISTINCT
  tfacp200.t$ttyp || tfacp200.t$ninv CD_CHAVE_PRIMARIA,
  tfacp200.t$ttyp CD_TIPO_TRANSACAO,
  tfacp200.t$ninv NR_TITULO,
  tfacp200.t$pcom CD_CIA,
  --tfacp200.t$dim2 CODIGO_FILIAL,
	CASE WHEN tfacp200.t$ttyp IN ('AGA', 'GA1')
	THEN 3
	ELSE 2
	END CD_FILIAL,
  (Select u.t$eunt From ttcemm030201 u
   where u.t$euca!=' '
   AND TO_NUMBER(u.t$euca)=CASE WHEN tfacp200.t$dim2=' ' then 999
   WHEN tfacp200.t$dim2>to_char(0) then 999 
   else TO_NUMBER(tfacp200.t$dim2) END
   and rownum = 1
   ) CD_UNIDADE_EMPRESARIAL,
  tfacp200.t$tpay CD_TIPO_DOCUMENTO,
  tfacp200.t$ifbp CD_PARCEIRO,
  tdrec947.t$rcno$l NR_NFR,
  tfacp200.t$docn$l NR_NF_RECEBIDA,
  tfacp200.t$seri$l NR_SERIE_NF_RECEBIDA,
  tfacp200.t$line$l SQ_NF_RECEBIDA,
	tfacp200.t$docd DT_EMISSAO_TITULO,															--#FAF.001.n
	tfacp200.t$dued DT_VENCIMENTO,															--#FAF.001.n
	tfacp201.t$odue$l DT_VENCIMENTO_ORIGINAL,														--#FAF.001.n
--	CAST((FROM_TZ(CAST(TO_CHAR(tfacp201.t$odue$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.001.o
--		AT time zone sessiontimezone) AS DATE) DATA_VENC_ORIG_TITULO,								--#FAF.001.o
	(select 																						--#FAF.003.sn
		max(p.t$docd) 
	from ttfacp200201 p
	where p.t$ttyp=tfacp200.t$ttyp
	and p.t$ninv=tfacp200.t$ninv
	and p.t$tpay=2) DT_LIQUIDACAO_TITULO,															--#FAF.003.en
  tfacp200.t$amnt VL_TITULO,
	nvl(tdrec940.t$tfda$l, tfacp200.t$amnt)  VL_ORIGINAL,									--#FAF.007.o	
  CASE WHEN tfacp200.t$afpy=2 THEN 1
  ELSE 2
  END IN_BLOQUEIO_TITULO,
  tfacp201.t$pyst$l CD_PREPARADO_PAGAMENTO,
  tfacp200.t$stap CD_SITUACAO_TITULO,
  CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE) DT_SITUACAO_TITULO,
  tfacp200.t$doty$l CD_TIPO_NF,
  tfacp200.t$balh$1 VL_SALDO,
  tdrec947.t$orno$l NR_PEDIDO_VENDA,
  tfcmg011f.t$baoc$l CD_BANCO_DESTINO,
  tfcmg011f.t$agcd$l NR_AGENCIA_DESTINO,
  tfcmg011f.t$agdg$l NR_DIGITO_AGENCIA_DESTINO,
  tfcmg001f.t$bano NR_CONTA_CORRENTE_DESTINO,
  tfcmg001f.t$ofdg$l NUM_DIGITO_CONTA_CORRENTE_DESTINO,
  tfacp200.t$lapa VL_TAXA_MORA,																		--#FAF.001.n
  nvl((select p.t$inra$l from ttfacp201201 p														--#FAF.003.sn 
   where p.t$ttyp=tfacp200.t$ttyp
   and p.t$ninv=tfacp200.t$ninv
   and ROWNUM=1),0) VL_TAXA_MULTA,																		--#FAF.003.en
  CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
        AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
  'CAP' CD_MODULO,
  tdrec940.t$fire$l NR_REFERENCIA_FISCAL
FROM
  ttfacp200201 tfacp200
  LEFT JOIN ttdrec940201 tdrec940
  ON tdrec940.t$docn$l=tfacp200.t$docn$l
  AND tdrec940.t$seri$l=tfacp200.t$seri$l
  AND tdrec940.t$ttyp$l=tfacp200.t$ttyp
  AND tdrec940.t$invn$l=tfacp200.t$ninv
  LEFT JOIN ttdrec947201 tdrec947
  ON tdrec947.t$fire$l=tdrec940.t$fire$l
  LEFT JOIN ttccom125201 tccom125
  ON  tccom125.t$ptbp=tfacp200.t$otbp
  AND tccom125.t$cban=tfacp200.t$bank
  LEFT JOIN ttfcmg011201 tfcmg011
  ON  tfcmg011.t$bank=tccom125.t$brch,
  (SELECT a.t$ttyp,
      a.t$ninv,
      MIN(a.t$odue$l) t$odue$l,
      MIN(a.t$liqd)   t$liqd,
      SUM(a.t$amnt)   t$amnt,
      MIN(a.t$pyst$l) t$pyst$l,
      MAX(a.t$inta$l) t$inta$l,
	  MAX(a.t$bank) t$bank
  FROM ttfacp201201 a
  GROUP BY a.t$ttyp,
       a.t$ninv) tfacp201
  LEFT JOIN ttfcmg001201 tfcmg001f
	ON tfcmg001f.t$bank=tfacp201.t$bank
  LEFT JOIN ttfcmg011201 tfcmg011f
	ON tfcmg011f.t$bank=tfcmg001f.t$brch
WHERE
  tfacp201.t$ttyp=tfacp200.t$ttyp
AND  tfacp201.t$ninv=tfacp200.t$ninv
AND tfacp200.t$docn=0